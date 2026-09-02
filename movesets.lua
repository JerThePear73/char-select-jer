if not _G.charSelectExists then return end

local ACT_JERNADO = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR)
local ACT_DASH = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
local ACT_BOOST = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
local ACT_TRICK = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
local ACT_BREAK_DOWN = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING | ACT_FLAG_ATTACKING)
local ACT_RAIL_GRIND = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING | ACT_FLAG_INTANGIBLE)
local ACT_RAIL_TRICK = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING | ACT_FLAG_INTANGIBLE)
local ACT_FORCE_STOMP = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_INTANGIBLE)
local ACT_SCREW_SPIN = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING | ACT_FLAG_INTANGIBLE)

local function convert_s16(a)
    return (a + 0x8000) % 0x10000 - 0x8000
end

local ANGLE_QUEUE_SIZE = 9
local SPIN_TIMER_SUCCESSFUL_INPUT = 4

local TEX_JB_IMPACT_FRAME = get_texture_info('jb-impact-frame')

local SOUND_JB_TRICK = audio_sample_load("jb_sound_trick.ogg")
local SOUND_JB_PARRY = audio_sample_load("jb_sound_parry.ogg")
local SOUND_JB_BAP = audio_stream_load("jb_sound_bap.ogg")
local SOUND_JB_CROWD = audio_stream_load("jb_sound_crowd.ogg")

local opacityMax = 200
local stepFrame = 5
local fuelMax = 0
local fuelMaxInc = 100
local fuelCost = 25
local comboTimerMax = 35
local comboOpacityMax = 10
local railGrindRange = 0x2800
local turn90 = degrees_to_sm64(90)
local loaded = false
local id_bhvMasterCapBox = get_id_from_behavior_name("bhvMasterCapBox")

local gJerStates = {}
--local function jer_jess_reset_extra_states(index)
for i = 0, MAX_PLAYERS - 1 do
    gJerStates[i] = {
        --index = network_global_index_from_local(0),
        canJernado = true,
        canDash = true,
        canBoost = true,
        perfectTimer = 0,
        fuel = 0,
        fuelLerp = 0,
        boostSpeed = 0,
        prevPosY = 0,
        combo = 0,
        comboTimer = 0,
        comboOpacity = 0,
        comboPhrase = "",
        comboPhraseScale = 0,
        score = 0,
        trickName = "",
        railDir = 0,
        railTrick = -1,
        screwSpeed = 0,
        gfxX = 0,
        gfxY = 0,
        gfxZ = 0,
        -- spin
        stickLastAngle = 0,
        spinDirection = 0,
        spinBufferTimer = 0,
        spinInput = 0,
        lastStickMag = 0,
        angleDeltaQueue = {}
    }
    for j=0,(ANGLE_QUEUE_SIZE-1) do gJerStates[i].angleDeltaQueue[j] = 0 end
end

function mario_update_spin_input(m)
    local e = gJerStates[m.playerIndex]
    local rawAngle = atan2s(-m.controller.stickY, m.controller.stickX)
    e.spinInput = 0

    -- prevent issues due to the frame going out of the dead zone registering the last angle as 0
    if e.lastStickMag > 60 and m.controller.stickMag > 60 then
        local angleOverFrames = 0
        local thisFrameDelta = 0
        local i = 0

        local newDirection = e.spinDirection
        local signedOverflow = 0

        if rawAngle < e.stickLastAngle then
            if e.stickLastAngle - rawAngle > 0x8000 then
                signedOverflow = 1
            end
            if signedOverflow ~= 0 then
                newDirection = 1
            else
                newDirection = -1
            end
        elseif rawAngle > e.stickLastAngle then
            if rawAngle - e.stickLastAngle > 0x8000 then
                signedOverflow = 1
            end
            if signedOverflow ~= 0 then
                newDirection = -1
            else
                newDirection = 1
            end
        end

        if e.spinDirection ~= newDirection then
            for i=0,(ANGLE_QUEUE_SIZE-1) do
                e.angleDeltaQueue[i] = 0
            end
            e.spinDirection = newDirection
        else
            for i=(ANGLE_QUEUE_SIZE-1),1,-1 do
                e.angleDeltaQueue[i] = e.angleDeltaQueue[i-1]
                angleOverFrames = angleOverFrames + e.angleDeltaQueue[i]
            end
        end

        if e.spinDirection < 0 then
            if signedOverflow ~= 0 then
                thisFrameDelta = math.floor((1.0*e.stickLastAngle + 0x10000) - rawAngle)
            else
                thisFrameDelta = e.stickLastAngle - rawAngle
            end
        elseif e.spinDirection > 0 then
            if signedOverflow ~= 0 then
                thisFrameDelta = math.floor(1.0*rawAngle + 0x10000 - e.stickLastAngle)
            else
                thisFrameDelta = rawAngle - e.stickLastAngle
            end
        end

        e.angleDeltaQueue[0] = thisFrameDelta
        angleOverFrames = angleOverFrames + thisFrameDelta

        if angleOverFrames >= 0xA000 then
            e.spinBufferTimer = SPIN_TIMER_SUCCESSFUL_INPUT
        end


        -- allow a buffer after a successful input so that you can switch directions
        if e.spinBufferTimer > 0 then
            e.spinInput = 1
            e.spinBufferTimer = e.spinBufferTimer - 1
        end
    else
        e.spinDirection = 0
        e.spinBufferTimer = 0
    end

    e.stickLastAngle = rawAngle
    e.lastStickMag = m.controller.stickMag
end

local trickPoints = {
    ["trick"]       = 1,
    ["firstie"]     = 5,
    ["speedkick"]   = 10,
    ["sledgekick"]  = 15,
    ["breakdown"]   = 2,
    ["grind"]       = 1,
    ["forcestomp"]  = 10,
    ["screw"]       = 1,
}

local comboPhrases = {
    [0]  = "",
    [1]  = "",
    [2]  = "",
    [3]  = "",
    [4]  = "Not bad...",
    [5]  = "Not bad...",
    [6]  = "Gormful",
    [7]  = "Gormful",
    [8]  = "Gnarly!",
    [9]  = "Gnarly!",
    [10] = "Pimpin'",
    [11] = "Pimpin'",
    [12] = "Tubular!",
    [13] = "Tubular!",
    [14] = "SWEET!",
    [15] = "SWEET!",
    [16] = "WICKED!",
    [17] = "WICKED!",
    [18] = "DAYUMN!!",
    [19] = "DAYUMN!!",
    [20] = "Keep it up Baby!",
}

---@class m gMarioStates
---@class e gJerStates
---@param addcombo integer (0 or 1) whether the trick increases your combo or not.
---@param addscore integer amount of fuel to add from the trick. Multiplied by 10 for score.
---@param name string the name of the trick that will be displayed.
---@param dosound integer whether to play a sound for the trick. 0 none, 1 short, 2 BRC trick.
local function jerComboAdd(m, e, addcombo, addscore, name, dosound)
    e.combo = e.combo + addcombo
    if addcombo == 0 and e.combo == 0 then
        e.combo = 1
    elseif addcombo == 1 and (e.combo <= #comboPhrases or e.combo == 100) then
        e.comboPhraseScale = 0
    end
    e.comboTimer = comboTimerMax
    e.fuel = e.fuel + (addscore * e.combo)
    e.score = e.score + (addscore * e.combo)*10
    e.trickName = name
    if dosound == 1 then
        audio_stream_play(SOUND_JB_BAP, true, 1)
        audio_stream_set_frequency(SOUND_JB_BAP, (math.random(8, 12)/10))
    elseif dosound == 2 then
        audio_sample_play(SOUND_JB_TRICK, m.pos, 1)
    end
end

------------------
-- CUSTOM MOVES --
------------------

local trickTable = {
    [0] = {name = "Ankle Grab",     anim = "jb_anim_trick_1",   hand = MARIO_HAND_FISTS,        start = 0,  fin = 20},
    [1] = {name = "Helicopter",     anim = "jb_anim_trick_2",   hand = MARIO_HAND_OPEN,         start = 12, fin = 20},
    [2] = {name = "Skate Pro",      anim = "jb_anim_trick_3",   hand = 5,                       start = 0,  fin = 20},
    [3] = {name = "Shoot 4 The Sky",anim = "jb_anim_trick_4",   hand = MARIO_HAND_PEACE_SIGN,   start = 5,  fin = 12},
}
local trickTableGrind = {
    [0] = {name = "Cartwheel",      anim = "jb_anim_trick_rail_1", hand = MARIO_HAND_FISTS,     start = 0,  fin = 20},
    [1] = {name = "ReversO",        anim = "jb_anim_trick_rail_2", hand = MARIO_HAND_OPEN,      start = 0,  fin = 20},
    [2] = {name = "Roundhouse",     anim = "jb_anim_trick_rail_3", hand = MARIO_HAND_FISTS,     start = 0,  fin = 20},
}

local function act_jernado(m)

    m.marioBodyState.eyeState = MARIO_EYES_CLOSED
    m.marioBodyState.handState = MARIO_HAND_OPEN
    smlua_anim_util_set_animation(m.marioObj, "jb_anim_jernado")

    if m.actionTimer == 1 then
        play_character_sound(m, CHAR_SOUND_YEEHAW)
    end

    local stepResult = common_air_action_step(m, ACT_FREEFALL_LAND, MARIO_ANIM_TRIPLE_JUMP, AIR_STEP_CHECK_LEDGE_GRAB)
    if stepResult == AIR_STEP_HIT_WALL then
        set_mario_action(m, ACT_AIR_HIT_WALL, 0)
    elseif stepResult == AIR_STEP_GRABBED_LEDGE then
        m.marioObj.header.gfx.animInfo.animID = -1
    end
    if m.actionTimer > 40 then
        set_mario_action(m, ACT_FREEFALL, 0)
    end
    if m.actionTimer > 0 then
        if m.actionTimer % 5 == 0 and m.actionTimer < 26 then
            play_sound(SOUND_ACTION_TWIRL, m.marioObj.header.gfx.cameraToObject)
        end
    end

    
    if m.actionTimer < 30 and m.action ~= ACT_FREEFALL then
        local target = 18 - (m.actionTimer * (math.abs(m.forwardVel/25)))

        m.vel.y = math.clamp(approach_s32(m.vel.y, target, 20, 0), 0, 30)
        set_mario_particle_flags(m, PARTICLE_DUST, 0)
    else
        m.vel.y = m.vel.y + 1
    end

    m.actionTimer = m.actionTimer + 1
    return 0
end
hook_mario_action(ACT_JERNADO, act_jernado)

local function act_dash(m)

    m.marioBodyState.handState = MARIO_HAND_OPEN

    if m.actionTimer == 1 then
        m.faceAngle.y = m.intendedYaw
        --m.forwardVel = m.forwardVel - 5
        m.vel.y = 20
        if m.forwardVel < 0 and m.input & INPUT_NONZERO_ANALOG == 0 then
            m.forwardVel = 60
            set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
        elseif m.forwardVel < 40 then
            m.forwardVel = 40
        end
    end

    local stepResult = common_air_action_step(m, ACT_FREEFALL_LAND, MARIO_ANIM_RUNNING_UNUSED, AIR_STEP_CHECK_LEDGE_GRAB)
    if stepResult == AIR_STEP_HIT_WALL then
        return set_mario_action(m, ACT_AIR_HIT_WALL, 0)
    elseif stepResult == AIR_STEP_GRABBED_LEDGE then
        m.marioObj.header.gfx.animInfo.animID = -1
    end

    if m.actionTimer > 0 and m.actionTimer < 4 then
        set_anim_to_frame(m, 0)
        m.vel.y = m.vel.y + 2
    else
        if m.input & INPUT_B_PRESSED ~= 0 then
            set_mario_action(m, ACT_DIVE, 0)
        elseif m.input & INPUT_Z_PRESSED ~= 0 then
            set_mario_action(m, ACT_GROUND_POUND, 0)
        end
    end
    if m.actionTimer > 0 and m.actionTimer < 15 then
        play_sound(SOUND_AIR_BOWSER_SPIT_FIRE, m.marioObj.header.gfx.cameraToObject)
        set_mario_particle_flags(m, PARTICLE_FIRE, 0)
    end

    m.actionTimer = m.actionTimer + 1
    return smlua_anim_util_set_animation(m.marioObj, "jb_anim_boost")
end
hook_mario_action(ACT_DASH, act_dash)

local function act_boost(m)
    local e = gJerStates[m.playerIndex]
    local metalCheck = m.flags & MARIO_METAL_CAP ~= 0

    play_sound(SOUND_AIR_BOWSER_SPIT_FIRE, m.marioObj.header.gfx.cameraToObject)
    set_mario_particle_flags(m, PARTICLE_FIRE, 0)
    m.marioBodyState.handState = MARIO_HAND_OPEN

    if m.actionTimer <= 7 then
        smlua_anim_util_set_animation(m.marioObj, "jb_anim_boost_start")
        if m.actionTimer == 7 then
            set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
        end
    else
        smlua_anim_util_set_animation(m.marioObj, "jb_anim_boost_steer")
        mario_set_forward_vel(m, e.boostSpeed)

        local dYaw = convert_s16(m.faceAngle.y - m.intendedYaw)
        local val04 = (dYaw * m.forwardVel / 12)
        local max = 30

        if val04 > max then
            val04 = max;
        end
        if val04 < -max then
            val04 = -max;
        end
        e.gfxY = approach_s32(e.gfxY, val04, 3, 3)

        set_anim_to_frame(m, (30 + e.gfxY))
    end

    local stepResult = common_air_action_step(m, ACT_BRAKING, MARIO_ANIM_DOUBLE_JUMP_FALL, AIR_STEP_CHECK_LEDGE_GRAB)
    if stepResult == AIR_STEP_HIT_WALL then
        return set_mario_action(m, ACT_AIR_HIT_WALL, 0)
    elseif stepResult == AIR_STEP_GRABBED_LEDGE then
        m.marioObj.header.gfx.animInfo.animID = -1
    end

    m.vel.y = math.clamp((m.vel.y + 3), -20, 0)
    e.boostSpeed = math.clamp((e.boostSpeed + 1), 30, metalCheck and 100 or 73)
    m.faceAngle.y = m.intendedYaw - approach_s32(convert_s16(m.intendedYaw - m.faceAngle.y), 0, 0x200, 0x200)
    m.marioObj.header.gfx.pos.y = m.pos.y - 50
    m.peakHeight = m.pos.y
    e.fuel = e.fuel - 1

    if m.pos.y < (m.waterLevel + 50) then
        m.pos.y = m.waterLevel + 50
        m.vel.y = 0
        spawn_non_sync_object(id_bhvWaterSplash, E_MODEL_WATER_SPLASH, m.pos.x, m.waterLevel, m.pos.z, function(oSplash)
        
        end)
        spawn_non_sync_object(id_bhvWaterSplash, E_MODEL_WATER_SPLASH, m.pos.x - m.vel.x*0.5, m.waterLevel, m.pos.z - m.vel.z*0.5, function(oSplash)
        
        end)
    elseif m.pos.y < (m.floorHeight + 50) then
        m.pos.y = m.floorHeight + 50
        m.vel.y = 0
    end

    if m.controller.buttonDown & L_TRIG == 0 or e.fuel == 0 then
        m.pos.y = m.pos.y - 50
        set_mario_action(m, ACT_FREEFALL, 0)
    end

    m.actionTimer = m.actionTimer + 1
    return 0
end
hook_mario_action(ACT_BOOST, act_boost)

local function act_trick(m)
    local e = gJerStates[m.playerIndex]

    m.peakHeight = m.pos.y

    if m.actionTimer == 1 then
        play_character_sound(m, CHAR_SOUND_TRICK)
        set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
        m.marioObj.header.gfx.animInfo.animID = -1
        local name = trickTable[m.actionArg].name
        if m.prevAction & ACT_FLAG_AIR == 0 then
            name = "Pop "..name
        end
        jerComboAdd(m, e, 1, trickPoints["trick"], name, 1)
    end

    local stepResult = common_air_action_step(m, ACT_FREEFALL_LAND, CHAR_ANIM_BREAKDANCE, AIR_STEP_NONE)
    if stepResult == AIR_STEP_LANDED then
        m.actionArg = 0
    end
    if m.actionTimer == 20 then
        m.action = ACT_FREEFALL
        m.actionArg = 0
    end

    if m.vel.y < 0 then m.vel.y = m.vel.y + 1 end
    smlua_anim_util_set_animation(m.marioObj, trickTable[m.actionArg].anim)
    if m.marioObj.header.gfx.animInfo.animFrame >= trickTable[m.actionArg].start and m.marioObj.header.gfx.animInfo.animFrame <= trickTable[m.actionArg].fin then
        m.marioBodyState.handState = trickTable[m.actionArg].hand
    end

    m.actionTimer = m.actionTimer + 1
    return 0
end
hook_mario_action(ACT_TRICK, act_trick, INT_KICK)

local function act_break_down(m)
    local e = gJerStates[m.playerIndex]
    local frame = m.marioObj.header.gfx.animInfo.animFrame
    local metalCheck = m.flags & MARIO_METAL_CAP ~= 0

    e.prevPosY = m.pos.y

    set_mario_animation(m, MARIO_ANIM_RUNNING_UNUSED)
    smlua_anim_util_set_animation(m.marioObj, "jb_anim_break_down")

    if m.actionTimer == 0 then
        e.boostSpeed = m.forwardVel + 10
        set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
        play_character_sound(m, CHAR_SOUND_YAHOO)
        m.vel.y = 0
    elseif m.actionTimer == 20 then
        audio_sample_play(SOUND_JB_TRICK, m.pos, 1)
    end
    if frame < 30 then
        if frame == 5 or frame == 10 then
            play_sound(SOUND_GENERAL_SWISH_WATER, m.marioObj.header.gfx.cameraToObject)
        end
    end

    m.faceAngle.y = m.intendedYaw - approach_s32(convert_s16(m.intendedYaw - m.faceAngle.y), 0, 500, 500)

    if e.boostSpeed > 30 then
        set_mario_particle_flags(m, PARTICLE_DUST, 0)
    end

    mario_set_forward_vel(m, e.boostSpeed)
    local stepResult = perform_ground_step(m)
    if stepResult == GROUND_STEP_HIT_WALL then
        m.particleFlags = m.particleFlags | PARTICLE_VERTICAL_STAR
        m.action = ACT_BACKWARD_GROUND_KB
    elseif stepResult == GROUND_STEP_LEFT_GROUND then
        set_mario_action(m, ACT_FREEFALL, 0)
        m.vel.y = 5
    end

    e.boostSpeed = math.clamp((e.boostSpeed - 0.2 + (e.prevPosY - m.pos.y)/(metalCheck and 5 or 10)), 15, metalCheck and 150 or 110)
    if e.boostSpeed == 15 then
        set_mario_action(m, ACT_BUTT_SLIDE_STOP, 0)
    end

    if m.input & INPUT_A_PRESSED ~= 0 then
        m.pos.y = m.pos.y + 5
        m.vel.y = 30
        return set_mario_action(m, ACT_TRICK, math.random(0, #trickTable))
    elseif m.input & INPUT_B_PRESSED ~= 0 then
        m.pos.y = m.pos.y + 5
        return set_mario_action(m, ACT_DIVE, 0)
    end

    if m.actionTimer > 29 then
        e.gfxY = e.gfxY + math.round(e.boostSpeed * 0x55)
    end
    if e.gfxY > 0x10000 then
        if m.forwardVel > 35 then
            play_sound(SOUND_GENERAL_SWISH_WATER, m.marioObj.header.gfx.cameraToObject)
            jerComboAdd(m, e, 0, trickPoints["breakdown"], "Break it Down", 0)
        end
        e.gfxY = e.gfxY - 0x10000
    end
    m.marioObj.header.gfx.angle.y = e.gfxY

    m.actionTimer = m.actionTimer + 1
    return 0
end
hook_mario_action(ACT_BREAK_DOWN, act_break_down)

local function act_rail_grind(m)
    local e = gJerStates[m.playerIndex]
    local intendedDYaw = convert_s16(m.intendedYaw - m.faceAngle.y)

    --center_free_camera()
    --center_rom_hack_camera()

    play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject)
    spawn_mist_particles_variable(1, 0, 5)
    set_mario_animation(m, MARIO_ANIM_START_RIDING_SHELL)
    m.marioBodyState.handState = MARIO_HAND_OPEN

    if m.actionState == 0 then 
        if m.prevAction ~= ACT_RAIL_TRICK then
            if intendedDYaw > 0 then
                e.railDir = 1
            elseif intendedDYaw < 0 then
                e.railDir = -1
            end
            m.faceAngle.y = m.faceAngle.y + (turn90 * e.railDir)
            set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
            e.boostSpeed = 45
            m.vel.x = 0
            m.vel.y = 0
            m.vel.z = 0
            if m.actionArg == 0 then
                play_character_sound(m, CHAR_SOUND_HOOHOO)
            end
        end
        m.actionState = 1
    end

    if e.railTrick ~= 1 then
        if (m.actionTimer % 5) == 0 then
            jerComboAdd(m, e, 0, trickPoints["grind"], "Soap Shoes", 0)
        end
    elseif (m.actionTimer % 4) == 0 then
        jerComboAdd(m, e, 0, trickPoints["grind"], "Reverse Soaps", 0)
    end

    if m.input & INPUT_A_PRESSED ~= 0 and m.actionTimer > 1 then
        m.pos.y = m.pos.y + 10
        m.forwardVel = 50
        return set_mario_action(m, ACT_JUMP, 0)
    end

    if m.controller.buttonPressed & B_BUTTON ~= 0 and m.actionTimer > 1 then
        return set_mario_action(m, ACT_RAIL_TRICK, math.random(0, #trickTableGrind))
    --elseif m.controller.buttonDown & L_TRIG ~= 0 then
        --e.boostSpeed = math.lerp(e.boostSpeed, 80, 0.1)
        --play_sound(SOUND_AIR_BOWSER_SPIT_FIRE, m.marioObj.header.gfx.cameraToObject)
        --set_mario_particle_flags(m, PARTICLE_FIRE, 0)
        --e.fuel = e.fuel - 1
    else
        e.boostSpeed = math.lerp(e.boostSpeed, 45, 0.2)
    end
    if m.actionArg == 1 then
        if e.railTrick ~= -1 then
            set_mario_animation(m, MARIO_ANIM_RUNNING_UNUSED)
            set_anim_to_frame(m, 40)
            smlua_anim_util_set_animation(m.marioObj, trickTableGrind[e.railTrick].anim)
        else
            set_anim_to_frame(m, 20)
        end
    else
        e.railTrick = -1
    end

    m.forwardVel = e.boostSpeed
    m.pos.y = m.floorHeight
    --m.pos.x = m.pos.x + (e.boostSpeed * sins(m.faceAngle.y))
    --m.pos.z = m.pos.z + (e.boostSpeed * coss(m.faceAngle.y))

    local ray1 = collision_find_surface_on_ray( m.pos.x + (e.boostSpeed * sins(m.faceAngle.y)) + (50 * sins(m.faceAngle.y + (turn90 * e.railDir))),
                                                m.pos.y - 15,
                                                m.pos.z + (e.boostSpeed * coss(m.faceAngle.y)) + (50 * coss(m.faceAngle.y + (turn90 * e.railDir))),
                                                (200 * sins(m.faceAngle.y - (turn90 * e.railDir))),
                                                0,
                                                (200 * coss(m.faceAngle.y - (turn90 * e.railDir)))
                                            )

    if ray1.surface ~= nil then
        local gotWallAngle = math.s16(atan2s(ray1.surface.normal.z, ray1.surface.normal.x) - 0x8000)
        if m.actionState == 1 then
            m.faceAngle.y = gotWallAngle + (turn90 * e.railDir)
            m.pos.x = ray1.hitPos.x + (2 * sins(gotWallAngle))
            m.pos.z = ray1.hitPos.z + (2 * coss(gotWallAngle))
        end
    else
        m.vel.y = 10
        m.forwardVel = 40
        return set_mario_action(m, ACT_FREEFALL, 0)
    end

    local stepResult = perform_ground_step(m)
    if stepResult == GROUND_STEP_LEFT_GROUND then
        m.vel.y = 10
        m.forwardVel = 40
        return set_mario_action(m, ACT_FREEFALL, 0)
    elseif stepResult == GROUND_STEP_HIT_WALL then
        return set_mario_action(m, ACT_BACKWARD_GROUND_KB, 0)
    end

    local checkA = m.pos.y - find_floor_height_relative_polar(m, turn90, 30)
    local checkB = m.pos.y - find_floor_height_relative_polar(m, 0 - turn90, 30)
    local height = 10

    if (checkA < height and checkB < height) then
        return set_mario_action(m, ACT_BRAKING, 0)
    end

    local checkFront = m.pos.y - find_floor_height_relative_polar(m, 0, 10)
    local tilt = math.tan(checkFront/10)*2000
    m.marioObj.header.gfx.angle.x = tilt

    m.actionTimer = m.actionTimer + 1
    return 0
end
hook_mario_action(ACT_RAIL_GRIND, act_rail_grind)

local function act_rail_trick(m)
    local e = gJerStates[m.playerIndex]

    play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject)
    set_mario_animation(m, MARIO_ANIM_RUNNING_UNUSED)
    if m.prevAction == ACT_RAIL_GRIND then
        spawn_mist_particles_variable(5, 0, 5)
        m.pos.y = m.floorHeight
        m.pos.x = m.pos.x + (e.boostSpeed * sins(m.faceAngle.y))
        m.pos.z = m.pos.z + (e.boostSpeed * coss(m.faceAngle.y))
    else
        if m.actionTimer == 0 then
            e.boostSpeed = m.forwardVel
        end
        set_mario_particle_flags(m, PARTICLE_DUST, 0)
        mario_set_forward_vel(m, e.boostSpeed)
    end

    if m.actionTimer == 0 then
        set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
        set_anim_to_frame(m, 0)
        play_character_sound(m, CHAR_SOUND_TRICK)
        jerComboAdd(m, e, 1, trickPoints["trick"], trickTableGrind[m.actionArg].name, 1)
        e.railTrick = m.actionArg
    end

    smlua_anim_util_set_animation(m.marioObj, trickTableGrind[m.actionArg].anim)
    if m.marioObj.header.gfx.animInfo.animFrame == 19 then
        return set_mario_action(m, m.prevAction, 1)
    end

    local stepResult = perform_ground_step(m)
    if stepResult == GROUND_STEP_LEFT_GROUND then
        e.railTrick = -1
        m.vel.y = 10
        m.forwardVel = 40
        return set_mario_action(m, ACT_FREEFALL, 0)
    elseif stepResult == GROUND_STEP_HIT_WALL then
        return set_mario_action(m, ACT_BACKWARD_GROUND_KB, 0)
    end

    local checkA = m.pos.y - find_floor_height_relative_polar(m, turn90, 30)
    local checkB = m.pos.y - find_floor_height_relative_polar(m, 0 - turn90, 30)
    local height = 10

    if (checkA < height and checkB < height) and m.prevAction == ACT_RAIL_GRIND then
        e.railTrick = -1
        return set_mario_action(m, ACT_BRAKING, 0)
    end

    local checkFront = m.pos.y - find_floor_height_relative_polar(m, 0, 10)
    local tilt = math.tan(checkFront/10)*2000
    m.marioObj.header.gfx.angle.x = tilt

    m.actionTimer = m.actionTimer + 1
    return 0
end
hook_mario_action(ACT_RAIL_TRICK, act_rail_trick)

local function act_screw_spin(m)
    local e = gJerStates[m.playerIndex]
    local o = m.interactObj
    if not o then return end
    set_mario_animation(m, MARIO_ANIM_RUNNING_UNUSED)
    smlua_anim_util_set_animation(m.marioObj, "jb_anim_stomp")
    set_anim_to_frame(m, 0)
    perform_ground_step(m)

    if m.actionState == 0 then
        e.canJernado = true
        e.canBoost = true
        e.canDash = true
        e.screwSpeed = 1500 * (1 - m.actionArg)
        m.vel.x = 0
        m.vel.y = 0
        m.vel.z = 0
        m.actionState = 1
        if m.actionArg == 1 then
            audio_stream_stop(SOUND_JB_BAP)
            audio_sample_stop(SOUND_JB_TRICK)
            audio_sample_play(SOUND_JB_PARRY, m.pos, 1)
        end
    end

    m.pos.x = o.oPosX
    m.pos.z = o.oPosZ
    m.pos.y = o.oPosY + 191

    e.gfxY = e.gfxY + e.screwSpeed
    if e.screwSpeed > 1600 then
        o.oWoodenPostOffsetY = o.oWoodenPostOffsetY - e.screwSpeed/2000
    end
    if m.actionArg == 1 and m.actionTimer == 6 then
        e.screwSpeed = 10000
    end

    m.marioObj.header.gfx.pos.x = m.pos.x
    m.marioObj.header.gfx.pos.y = m.pos.y - 4
    m.marioObj.header.gfx.pos.z = m.pos.z

    if o.oWoodenPostOffsetY < -190 then
        o.oWoodenPostOffsetY = -190
        set_mario_particle_flags(m, PARTICLE_MIST_CIRCLE, 0)
        play_sound(SOUND_GENERAL_POUND_WOOD_POST, m.marioObj.header.gfx.cameraToObject) -- SOUND_GENERAL_BIG_POUND
        if m.actionArg == 1 then
            m.vel.y = 120
            m.faceAngle.y = e.gfxY
            set_mario_action(m, ACT_FORCE_STOMP, 1)
        elseif m.actionArg == 0 then
            m.faceAngle.y = e.gfxY
            set_mario_action(m, ACT_BACKFLIP, 0)
        end
    end

    if m.actionArg == 0 then
        if m.input & INPUT_A_PRESSED ~= 0 then
            m.pos.y = m.pos.y + 10
            m.faceAngle.y = m.intendedYaw
            m.forwardVel = 0
            set_mario_action(m, ACT_JUMP, 0)
        elseif m.input & INPUT_B_PRESSED ~= 0 then
            play_sound(SOUND_ACTION_TWIRL, m.marioObj.header.gfx.cameraToObject)
            set_mario_particle_flags(m, PARTICLE_HORIZONTAL_STAR, 0)
            e.screwSpeed = e.screwSpeed + 3000
            jerComboAdd(m, e, 0, trickPoints["screw"], "Around The World", 0)
        else
            e.screwSpeed = math.lerp(e.screwSpeed, 1500, 0.1)
        end
    elseif m.actionArg == 1 then
        play_sound(SOUND_AIR_HEAVEHO_MOVE, m.marioObj.header.gfx.cameraToObject)
        if (m.actionTimer % 4) == 0 then
            set_mario_particle_flags(m, PARTICLE_HORIZONTAL_STAR, 0)
            jerComboAdd(m, e, 0, trickPoints["screw"], "CYCLONE", 0)
        end
    end

    m.marioObj.header.gfx.angle.y = e.gfxY
    m.actionTimer = m.actionTimer + 1
    return 0
end
hook_mario_action(ACT_SCREW_SPIN, act_screw_spin)

local FORCE_STOMP_STATE_INIT = 0
local FORCE_STOMP_STATE_STALL = 1
local FORCE_STOMP_STATE_BOUNCE = 2

local function bhv_force_stomp_genaric(m, e, o, state)
    if state == FORCE_STOMP_STATE_INIT then

    elseif state == FORCE_STOMP_STATE_STALL then
        m.pos.x = o.oPosX
        m.pos.z = o.oPosZ
        if obj_has_behavior_id(o, id_bhvWoodenPost) == 0 then
            m.pos.y = o.oPosY + o.hitboxHeight
        end
    elseif state == FORCE_STOMP_STATE_BOUNCE then
        -- Emulate Ground Pound
        o.oInteractStatus = ATTACK_GROUND_POUND_OR_TWIRL + (INT_STATUS_INTERACTED | INT_STATUS_WAS_ATTACKED)
        -- Calculate spring off velocity
        local vel = math.sqrt(m.vel.x^2 + m.vel.y^2 + m.vel.z^2) + 0 -- the humble plus 10
        m.vel.y = vel * (1 - m.intendedMag/32*0.5)
        m.forwardVel = vel * (m.intendedMag/32)
        m.faceAngle.y = m.intendedYaw
    end
end

local function bhv_force_stomp_bully(m, e, o, state)
    if state == FORCE_STOMP_STATE_INIT then
        o.oForwardVel = 0
    elseif state == FORCE_STOMP_STATE_STALL then
        m.pos.x = o.oPosX - sins(m.faceAngle.y)*o.hitboxRadius*0.5
        m.pos.y = o.oPosY + o.hitboxHeight*0.75
        m.pos.z = o.oPosZ - coss(m.faceAngle.y)*o.hitboxRadius*0.5
        m.marioObj.header.gfx.angle.x = -0x2000
    elseif state == FORCE_STOMP_STATE_BOUNCE then
        -- Calculate spring off velocity
        local vel = math.sqrt(m.vel.x^2 + m.vel.y^2 + m.vel.z^2)
        o.oAction = BULLY_ACT_KNOCKBACK
        o.oBullyMarioCollisionAngle = m.intendedYaw + 0x8000
        o.oMoveAngleYaw = m.intendedYaw + 0x8000
        o.oVelY = 10
        o.oForwardVel = vel * (m.actionArg == 1 and 2 or 1) * -1

        m.vel.y = 30
        m.forwardVel = -30
        m.faceAngle.y = m.intendedYaw
        if m.actionArg == 1 then
            return "EVICTION NOTICE"
        end
    end
end

local forceStompBhvs = {
    [id_bhvBobomb] = function (m, e, o, state)
        if state == FORCE_STOMP_STATE_INIT then
            o.oBobombFuseLit = 1
            o.oBobombFuseTimer = 141
        end
        bhv_force_stomp_genaric(m, e, o, state)
    end,
    [id_bhvToadMessage] = function (m, e, o, state)

        if state == FORCE_STOMP_STATE_STALL then
            m.pos.x = o.oPosX
            m.pos.y = o.oPosY + o.hitboxHeight
            m.pos.z = o.oPosZ
        elseif state == FORCE_STOMP_STATE_BOUNCE then
            -- Calculate spring off velocity
            local vel = math.sqrt(m.vel.x^2 + m.vel.y^2 + m.vel.z^2) + 0 -- the humble plus 10
            m.vel.y = vel * (1 - m.intendedMag/32*0.5)
            m.forwardVel = vel * (m.intendedMag/32)
            m.faceAngle.y = m.intendedYaw
            if m.actionArg ~= 1 then
                o.oPosY = o.oPosY - o.hitboxHeight*0.75
                play_sound(gCharacters[CT_TOAD].soundAttacked, {x = o.oPosX, y = o.oPosY, z = o.oPosZ})
            else
                spawn_non_sync_object(id_bhvExplosion, E_MODEL_EXPLOSION, o.oPosX, o.oPosY, o.oPosZ, function(o)
                
                end)
                play_sound(gCharacters[CT_TOAD].soundWaaaooow, {x = o.oPosX, y = o.oPosY, z = o.oPosZ})
                obj_mark_for_deletion(o)
            end

            -- debug for fun
            return "Friendly Fire"
        end
    end,
    [id_bhvJumpingBox] = function(m, e, o, state)
        if state == FORCE_STOMP_STATE_INIT then
            o.oVelY = 50
        elseif state == FORCE_STOMP_STATE_STALL then
            m.pos.x = o.oPosX
            m.pos.y = o.oPosY + o.hitboxHeight
            m.pos.z = o.oPosZ
        elseif state == FORCE_STOMP_STATE_BOUNCE then
            -- Emulate Ground Pound
            for i=0, 4 do
                spawn_sync_object(id_bhvSingleCoinGetsSpawned, E_MODEL_YELLOW_COIN, o.oPosX, o.oPosY, o.oPosZ, nil)
            end
            obj_mark_for_deletion(o)
            set_mario_particle_flags(m, PARTICLE_MIST_CIRCLE, 0)
            -- Calculate spring off velocity
            local vel = math.sqrt(m.vel.x^2 + m.vel.y^2 + m.vel.z^2) + 0 -- the humble plus 10
            m.vel.y = vel * 2
            m.forwardVel = 0
            m.faceAngle.y = m.intendedYaw
        end
    end,
    [id_bhvBowserBodyAnchor] = function(m, e, o, state)
        local oBoswer = o.parentObj
        if state == FORCE_STOMP_STATE_INIT then
        elseif state == FORCE_STOMP_STATE_STALL then
            m.pos.x = o.oPosX
            m.pos.y = o.oPosY + o.hitboxHeight
            m.pos.z = o.oPosZ
            oBoswer.oVelY = 0
        elseif state == FORCE_STOMP_STATE_BOUNCE then
            if oBoswer.oAction ~= 19 and oBoswer.oAction ~= 4 and oBoswer.oAction ~= 12 then
                oBoswer.oMoveFlags = 0
                oBoswer.oSubAction = 0
                oBoswer.oFaceAngleYaw = m.intendedYaw + 0x8000
                oBoswer.oMoveAngleYaw = m.intendedYaw + 0x8000
                if oBoswer.oAction == 1 and o.oPosY > find_floor(o.oPosX, o.oPosY, o.oPosZ) + 150 then
                    -- Spike Bowser after pop
                    m.vel.y = 30
                    m.forwardVel = -30
                    m.faceAngle.y = m.intendedYaw

                    oBoswer.oVelY = -80
                    oBoswer.oForwardVel = -80
                else
                    -- Pop bowser into the air
                    m.vel.y = 100
                    m.forwardVel = -30
                    m.faceAngle.y = m.intendedYaw
                    
                    oBoswer.oAction = 1
                    oBoswer.oVelY = 125
                    oBoswer.oForwardVel = -30
                end
            else
                m.vel.y = 30
                m.forwardVel = -50
            end
        end
    end,
    [id_bhvWoodenPost] = function (m, e, o, state)
        bhv_force_stomp_genaric(m, e, o, state)
    end,
    [id_bhvMasterCapBox] = function (m, e, o, state)
        if state == FORCE_STOMP_STATE_INIT then
            o.oForwardVel = 0
        elseif state == FORCE_STOMP_STATE_STALL then
            m.faceAngle.y = o.oFaceAngleYaw + 0x8000
            m.pos.x = o.oPosX - sins(m.faceAngle.y)*o.hitboxRadius*0.6
            m.pos.y = o.oPosY + o.hitboxHeight*0.75
            m.pos.z = o.oPosZ - coss(m.faceAngle.y)*o.hitboxRadius*0.6
            m.marioObj.header.gfx.angle.x = -0x4000
            m.marioObj.header.gfx.angle.y = m.faceAngle.y
        elseif state == FORCE_STOMP_STATE_BOUNCE then
            -- Calculate spring off velocity
            o.oAction = 3
            audio_stream_play(SOUND_JB_CROWD, false, 0.7)
            jerComboAdd(m, e, 0, 300, "Start Your Engines!", 0)
            m.vel.y = 30
            m.forwardVel = -15
            m.faceAngle.y = m.intendedYaw
        end

        return "Start Your Engines!"
    end,
}

local forceStompInteracts = {
    [INTERACT_KOOPA] = bhv_force_stomp_genaric,
    [INTERACT_BOUNCE_TOP] = bhv_force_stomp_genaric,
    [INTERACT_BOUNCE_TOP2] = bhv_force_stomp_genaric,
    [INTERACT_HIT_FROM_BELOW] = bhv_force_stomp_genaric,

    [INTERACT_BULLY] = bhv_force_stomp_bully,
}

---@param o Object
---@return function?
-- Gets extra logic ran 
local function obj_get_force_stomp_func(o)
    --if not o then return end
    if forceStompBhvs[get_id_from_behavior(o.behavior)] then
        return forceStompBhvs[get_id_from_behavior(o.behavior)]
    end
    for int, func in pairs(forceStompInteracts) do
        if o.oInteractType & int ~= 0 then
            return func
        end
    end
end

local function act_force_stomp(m)
    local e = gJerStates[m.playerIndex]
    local o = m.interactObj
    if not o then return end
    local forceStompFunc = obj_get_force_stomp_func(o) or bhv_force_stomp_genaric

    set_mario_animation(m, MARIO_ANIM_GROUND_POUND_LANDING)
    smlua_anim_util_set_animation(m.marioObj, "jb_anim_stomp")
    m.marioBodyState.handState = MARIO_HAND_OPEN
    if not o then return end
    if m.actionState == 0 then
        set_anim_to_frame(m, 0)
        if m.actionArg == 1 then
            audio_stream_stop(SOUND_JB_BAP)
            audio_sample_stop(SOUND_JB_TRICK)
            audio_sample_play(SOUND_JB_PARRY, m.pos, 1)
        end
        forceStompFunc(m, e, o, FORCE_STOMP_STATE_INIT)
        m.actionState = 1
    elseif m.actionTimer < 10 then
        forceStompFunc(m, e, o, FORCE_STOMP_STATE_STALL)
    elseif m.actionTimer == 10 then
        set_mario_particle_flags(m, PARTICLE_MIST_CIRCLE, 0)
        local trickName = forceStompFunc(m, e, o, FORCE_STOMP_STATE_BOUNCE)
        if m.actionArg == 1 then
            jerComboAdd(m, e, 0, trickPoints["forcestomp"] * 2, trickName and string.upper(trickName) or "LIMIT BREAK", 2)
        elseif m.actionArg == 0 then
            jerComboAdd(m, e, 0, trickPoints["forcestomp"], trickName or "Boot Fuel", 2)
        end
        -- Reset Air Vars
        e.canJernado = true
        e.canDash = true
        e.canBoost = true
        m.actionState = 2
    else
        local stepResult = common_air_action_step(m, ACT_FREEFALL_LAND, MARIO_ANIM_GROUND_POUND_LANDING, AIR_STEP_CHECK_LEDGE_GRAB)
        if stepResult == AIR_STEP_GRABBED_LEDGE then
            m.marioObj.header.gfx.animInfo.animID = -1
        end
        if m.input & INPUT_B_PRESSED ~= 0 then
            set_mario_action(m, ACT_TRICK, math.random(0, #trickTable))
        end
    end

    if m.actionState < 2 then
        m.marioObj.header.gfx.pos.x = m.pos.x
        m.marioObj.header.gfx.pos.y = m.pos.y
        m.marioObj.header.gfx.pos.z = m.pos.z
    end

    m.actionTimer = m.actionTimer + 1
    return 0
end
hook_mario_action(ACT_FORCE_STOMP, act_force_stomp)

-------------
-- UPDATES --
-------------

local commonAirActions = {
    [ACT_JUMP] = true,
    [ACT_FREEFALL] = true,
    [ACT_WALL_KICK_AIR] = true,
    [ACT_SIDE_FLIP] = true,
    [ACT_BACKFLIP] = true,
    [ACT_FORWARD_ROLLOUT] = true,
    [ACT_TWIRLING] = true,
    [ACT_TOP_OF_POLE_JUMP] = true,
    [ACT_JERNADO] = true,
    [ACT_DASH] = true,
}
local boostActions = {
    [ACT_JUMP] = true,
    [ACT_FREEFALL] = true,
    [ACT_WALL_KICK_AIR] = true,
    [ACT_SIDE_FLIP] = true,
    [ACT_BACKFLIP] = true,
    [ACT_FORWARD_ROLLOUT] = true,
    [ACT_TWIRLING] = true,
    [ACT_TOP_OF_POLE_JUMP] = true,
    [ACT_JERNADO] = true,
    [ACT_DASH] = true,
    [ACT_WALKING] = true,
    [ACT_IDLE] = true,
    [ACT_GROUND_POUND] = true,
}

local function jb_update(m)
    local e = gJerStates[m.playerIndex]
    local capCheck = m.flags & MARIO_CAP_ON_HEAD ~= 0

    e.fuel = math.clamp(e.fuel, 0, fuelMax)
    e.fuelLerp = math.lerp(e.fuelLerp, e.fuel, 0.2)
    mario_update_spin_input(m)
    if m.action == ACT_GROUND_POUND then
        m.marioObj.header.gfx.angle.y = m.faceAngle.y
    end
    if m.numStars >= 30 then
        fuelMax = fuelMaxInc * 3
    elseif m.numStars >= 15 then
        fuelMax = fuelMaxInc * 2
    else
        fuelMax = fuelMaxInc
    end
    if loaded == false then
        if m.numStars >= 30 then
            e.fuel = 300
        end
        loaded = true
    end

    -- alt jump
    if m.action == ACT_JUMP and m.actionArg == 73 then
        smlua_anim_util_set_animation(m.marioObj, "jb_anim_single_jump_big")
    end
    -- running tilt
    if m.action == ACT_WALKING then
        if get_global_timer() % stepFrame == 0 and m.forwardVel > 29 and m.pos.y > m.waterLevel then
            m.particleFlags = m.particleFlags | PARTICLE_DUST
        end

        if m.marioObj.header.gfx.animInfo.animID == MARIO_ANIM_RUNNING then
            e.gfxZ = approach_s32(e.gfxZ, m.marioBodyState.torsoAngle.z, 0x200, 0x200)
            m.marioObj.header.gfx.angle.z = e.gfxZ
        end
    end
    --slide kick
    if m.action == ACT_SLIDE_KICK then
        --m.slideVelX = m.slideVelX * 3
        --m.slideVelZ = m.slideVelZ * 3

        if m.input & INPUT_Z_DOWN ~= 0 and m.pos.y == m.floorHeight then
            e.railTrick = -1
            m.action = ACT_SLIDE_KICK_SLIDE
            set_mario_particle_flags(m, PARTICLE_MIST_CIRCLE, 0)
        end
    end
    if (m.action == ACT_JUMP_LAND or m.action == ACT_FREEFALL_LAND) then
        if m.input & INPUT_Z_PRESSED ~= 0 then
            set_mario_action(m, ACT_SLIDE_KICK, 0)
        elseif m.input & INPUT_Z_DOWN ~= 0 then
            set_mario_action(m, ACT_SLIDE_KICK_SLIDE, 0)
        end
    end
    -- break down
    if m.action == ACT_SLIDE_KICK_SLIDE then
                m.slideVelZ = m.slideVelZ * 1.05
                m.slideVelX = m.slideVelX * 1.05
        if m.controller.buttonDown & L_TRIG ~= 0 and e.fuel > 0 and m.forwardVel > 0 and capCheck then
            play_sound(SOUND_AIR_BOWSER_SPIT_FIRE, m.marioObj.header.gfx.cameraToObject)
            set_mario_particle_flags(m, PARTICLE_FIRE, 0)
            if m.forwardVel < 73 then
                m.slideVelZ = m.vel.z * 1.1
                m.slideVelX = m.vel.x * 1.1
            end
            e.fuel = e.fuel - 1
            if m.controller.buttonPressed & B_BUTTON ~= 0 and e.fuel > fuelCost then
                set_mario_action(m, ACT_BREAK_DOWN, 0)
                e.gfxY = 0
                e.fuel = e.fuel - fuelCost
            end
        elseif m.controller.buttonPressed & B_BUTTON ~= 0 and m.forwardVel >= 30 then
            set_mario_action(m, ACT_RAIL_TRICK, math.random(0, #trickTableGrind))
        end

        if e.railTrick ~= -1 then
            smlua_anim_util_set_animation(m.marioObj, trickTableGrind[e.railTrick].anim)
            set_anim_to_frame(m, 20)
        end
    end
    -- firsties
    if m.action == ACT_WALL_KICK_AIR and (m.prevAction == ACT_AIR_HIT_WALL or m.prevAction == ACT_WALL_KICK_AIR) then
        smlua_anim_util_set_animation(m.marioObj, "jb_anim_wallkick_firstie")
        if m.marioObj.header.gfx.animInfo.animFrame < 10 then
            set_mario_particle_flags(m, PARTICLE_SPARKLES, 0)
            if m.marioObj.header.gfx.animInfo.animFrame == 1 then
                jerComboAdd(m, e, 1, trickPoints["firstie"], "Firstie", 2)
            end
        end
    end
    -- ledge kick
    if m.action == ACT_LEDGE_GRAB then
        if e.perfectTimer < 3 and m.input & INPUT_B_PRESSED ~= 0 then
            set_mario_action(m, ACT_JUMP_KICK, 1)
            m.particleFlags = m.particleFlags | PARTICLE_VERTICAL_STAR
            m.vel.y = 25
            m.forwardVel = 45
            jerComboAdd(m, e, 1, trickPoints["sledgekick"], "Sledge-Kick", 2)
        end
        e.perfectTimer = e.perfectTimer + 1
    end
    -- air dash
    if (commonAirActions[m.action] or (m.action == ACT_FORCE_STOMP and m.actionState == 2)) and m.vel.y < 20 and m.input & INPUT_A_PRESSED ~= 0 and e.canDash and m.pos.y > m.floorHeight and capCheck then
        set_mario_action(m, ACT_DASH, 0)
        e.canDash = false
    end
    -- jernado
    if ((commonAirActions[m.action] or (m.action == ACT_FORCE_STOMP and m.actionState == 2)) or m.action == ACT_GROUND_POUND) and e.spinInput ~= 0 and e.canJernado and m.pos.y > m.floorHeight then
        if m.action ~= ACT_SIDE_FLIP or m.marioObj.header.gfx.animInfo.animFrame >= 10 then
            set_mario_action(m, ACT_JERNADO, 0)
            e.canJernado = false
        end
    end
    -- boost
    if (boostActions[m.action] or (m.action == ACT_FORCE_STOMP and m.actionState == 2)) and m.controller.buttonPressed & L_TRIG ~= 0 and e.canBoost and e.fuel > 0 and capCheck then
        set_mario_action(m, ACT_BOOST, 0)
        m.marioObj.header.gfx.animInfo.animID = -1
        set_anim_to_frame(m, 0)
        m.vel.y = 5
        m.pos.y = m.pos.y + 50
        m.actionTimer = 0
        e.boostSpeed = m.forwardVel
        e.gfxY = 0
        e.canBoost = false
    end
    -- speedkick anim
    if m.action == ACT_JUMP_KICK and m.actionArg == 1 then
        smlua_anim_util_set_animation(m.marioObj, "jb_anim_speedkick")
        m.marioBodyState.handState = MARIO_HAND_OPEN
    end
    --wing cap
    if m.action == ACT_BOOST and m.flags & MARIO_WING_CAP ~= 0 and m.input & INPUT_B_PRESSED ~= 0 then
        m.action = ACT_FLYING
        e.gfxZ = 0x10000
    end
    if m.action == ACT_FLYING then
        e.gfxZ = math.lerp(e.gfxZ, 0, 0.1)
        m.marioObj.header.gfx.angle.z = m.marioObj.header.gfx.angle.z + e.gfxZ
    end
    -- tricks
    if (commonAirActions[m.action] or m.action == ACT_BUTT_SLIDE_AIR or (m.action == ACT_FORCE_STOMP and m.actionState == 2)) and m.controller.buttonPressed & B_BUTTON ~= 0 and m.pos.y > (m.floorHeight + 250) then
        set_mario_action(m, ACT_TRICK, math.random(0, #trickTable))
    end
    -- butt slide
    if m.action == ACT_BUTT_SLIDE and m.input & INPUT_Z_PRESSED ~= 0 then
        set_mario_action(m, ACT_SLIDE_KICK_SLIDE, 0)
    end
    -- special swimming
    if m.action == ACT_FLUTTER_KICK and m.marioObj.header.gfx.animInfo.animID == MARIO_ANIM_FLUTTERKICK then
        set_mario_particle_flags(m, PARTICLE_PLUNGE_BUBBLE, 0)
    end
    -- wooden posts
    local nearestWoodPost = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvWoodenPost)
    if cur_obj_dist_to_nearest_object_with_behavior(get_behavior_from_id(id_bhvWoodenPost)) < 300 and m.action == ACT_TRICK and nearestWoodPost.oWoodenPostOffsetY > -190 then
        local crack = m.prevAction == ACT_BREAK_DOWN and m.forwardVel > 35
        m.interactObj = nearestWoodPost
        set_mario_action(m, ACT_SCREW_SPIN, crack and 1 or 0)
    end
    -- master cap
    if cur_obj_dist_to_nearest_object_with_behavior(get_behavior_from_id(id_bhvMasterCapBox)) < 400 and m.action == ACT_TRICK then
        local crack = m.prevAction == ACT_BREAK_DOWN and m.forwardVel > 35
        m.interactObj = obj_get_nearest_object_with_behavior_id(m.marioObj, id_bhvMasterCapBox)
        set_mario_action(m, ACT_FORCE_STOMP, crack and 1 or 0)
    end


    -- hud calcs
    local comboPreserveActions = {
        [ACT_BUTT_SLIDE]        = true,
        [ACT_DIVE_SLIDE]        = true,
        [ACT_SLIDE_KICK]        = true,
        [ACT_SLIDE_KICK_SLIDE]  = true,
        [ACT_BREAK_DOWN]        = true,
        [ACT_RAIL_GRIND]        = true,
        [ACT_RAIL_TRICK]        = true,
        [ACT_LEDGE_GRAB]        = true,
        [ACT_STOMACH_SLIDE]     = true,
    }
    if e.comboTimer > 0 then
        e.comboOpacity = comboOpacityMax
        if m.pos.y == m.floorHeight and not comboPreserveActions[m.action] then
            e.comboTimer = e.comboTimer - 1
        end
        if m.action == ACT_WATER_PLUNGE or m.action == ACT_WATER_IDLE then
            e.comboTimer = 0
        end
    else
        if e.comboOpacity > 0 then
            e.comboOpacity = e.comboOpacity - 1
        elseif e.comboOpacity == 0 then
            e.combo = 0
            e.score = 0
        end
    end
    e.comboPhraseScale = math.lerp(e.comboPhraseScale, 2, 0.2)
end
_G.charSelect.character_hook_moveset(CT_JB_JER, HOOK_MARIO_UPDATE, jb_update)

local function jb_set_action(m)
    local e = gJerStates[m.playerIndex]

    e.perfectTimer = 0
    e.gfxX = 0
    e.gfxY = 0
    e.gfxZ = 0
    if m.pos.y == m.floorHeight then
        e.canJernado = true
        e.canDash = true
        e.canBoost = true
    end

    -- jump height
    if m.action == ACT_JUMP then
        m.vel.y = m.vel.y + 10
    end
    -- slide kick
    if m.action == ACT_SLIDE_KICK then
        play_sound(SOUND_GENERAL_SWISH_WATER, m.marioObj.header.gfx.cameraToObject)
        if m.forwardVel > 45 then
            m.vel.y = m.vel.y + 20
        end
    end
    -- fix repeated firsties
    if m.action == ACT_WALL_KICK_AIR then
        m.marioObj.header.gfx.animInfo.animID = -1
    end
    -- speedkick
    if m.action == ACT_JUMP_KICK then
        if m.forwardVel > 45 then
            set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
            m.actionArg = 1
            jerComboAdd(m, e, 1, trickPoints["speedkick"], "Speed-Kick", 2)
        end
    end
    -- jump anim
    if m.action == ACT_JUMP and m.forwardVel > 45 then
        m.actionArg = 73
    end
    -- slide kick tricks reset
    if m.prevAction == ACT_SLIDE_KICK_SLIDE and e.railTrick ~= -1 then
        e.railTrick = -1
        if m.action == ACT_FORWARD_ROLLOUT then
            set_mario_action(m, ACT_JUMP, 0)
        end
    end

    -- rail grind
    if m.action == ACT_LEDGE_GRAB and m.prevAction ~= ACT_LEDGE_CLIMB_DOWN and m.floor.normal.y > 0.6 and (math.abs(convert_s16(m.intendedYaw - m.faceAngle.y)) > railGrindRange or m.floor.normal.y < 0.9063078) and m.input & INPUT_NONZERO_ANALOG ~= 0 then
        return set_mario_action(m, ACT_RAIL_GRIND, 0)
    end
end
_G.charSelect.character_hook_moveset(CT_JB_JER, HOOK_ON_SET_MARIO_ACTION, jb_set_action)

local function jb_before_set_action(m, act)
    local e = gJerStates[m.playerIndex]

    if act == ACT_DOUBLE_JUMP or act == ACT_TRIPLE_JUMP then
        return ACT_JUMP
    elseif act == ACT_CROUCH_SLIDE then
        return ACT_SLIDE_KICK
    -- flying fix; idk if this is necessary cuz of custom twirling
    elseif act == ACT_FLYING then
        m.marioObj.header.gfx.angle.y = m.faceAngle.y
    elseif act == ACT_SLIDE_KICK_SLIDE_STOP then
        if e.railTrick ~= -1 then
            return ACT_BRAKING_STOP
        end
    -- Set vanilla attacks to tricks
    elseif act == ACT_DIVE or (act == ACT_JUMP_KICK and (m.input & INPUT_NONZERO_ANALOG ~= 0 and m.action ~= ACT_LEDGE_GRAB)) then
        if m.action & ACT_FLAG_AIR == 0 then   
            local velTrade = math.max(m.forwardVel - 30, 0)*0.75
            m.forwardVel = m.forwardVel - velTrade
            m.vel.y = 50 + velTrade  
        end
        m.actionTimer = 0
        return set_mario_action(m, ACT_TRICK, math.random(0, #trickTable))
    end
end
_G.charSelect.character_hook_moveset(CT_JB_JER, HOOK_BEFORE_SET_MARIO_ACTION, jb_before_set_action)

local function jb_before_phys_step(m)
    -- faster swimming
    if m.action == ACT_FLUTTER_KICK and m.marioObj.header.gfx.animInfo.animID == MARIO_ANIM_FLUTTERKICK then
        mult = 3
        m.vel.x = m.vel.x * mult
        m.vel.y = m.vel.y * mult
        m.vel.z = m.vel.z * mult
    end
end
_G.charSelect.character_hook_moveset(CT_JB_JER, HOOK_BEFORE_PHYS_STEP, jb_before_phys_step)

local function jb_hud()
    local m = gMarioStates[0]
    local e = gJerStates[0]
    if gNetworkPlayers[0].currActNum == 99 or gMarioStates[0].action == ACT_INTRO_CUTSCENE or obj_get_first_with_behavior_id(id_bhvActSelector) then return end

    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_set_resolution(RESOLUTION_DJUI)
    djui_hud_set_font(FONT_ALIASED)
    local width = djui_hud_get_screen_width()
    local height = djui_hud_get_screen_height()
    local halfW = width/2
    local halfH = height/2
    local eCol = network_player_get_override_palette_color(gNetworkPlayers[0], EMBLEM)

    -- DEBUG HUD
    --djui_hud_print_text(("e.screwSpeed = "..tostring(e.screwSpeed)), 75, 175, 1)
    --djui_hud_print_text(("e.fuel = "..tostring(e.fuel)), 75, 200, 1)
    --djui_hud_print_text(("e.combo = "..tostring(e.combo)), 75, 225, 1)
    --djui_hud_print_text(("m.floor.normal.x = "..tostring(m.floor.normal.x)), 75, 250, 1)
    --djui_hud_print_text(("m.floor.normal.y = "..tostring(m.floor.normal.y)), 75, 275, 1)
    --djui_hud_print_text(("m.floor.normal.z = "..tostring(m.floor.normal.z)), 75, 300, 1)
    --djui_hud_print_text(("intendedDYaw = "..tostring(convert_s16(m.intendedYaw - m.faceAngle.y))), 75, 325, 1)
    --djui_hud_print_text(("m.actionTimer = "..tostring(m.actionTimer)), 75, 350, 1)
    --djui_hud_print_text(("m.actionArg = "..tostring(m.actionArg)), 75, 375, 1)
    --djui_hud_print_text(("animFrame = "..tostring(m.marioObj.header.gfx.animInfo.animFrame)), 75, 400, 1)

    --if m.wall ~= nil then
    --djui_hud_print_text(("m.wall.lowerY = "..tostring(m.wall.lowerY)), 75, 175, 1)
    --djui_hud_print_text(("m.wall.upperY = "..tostring(m.wall.upperY)), 75, 200, 1)
    --djui_hud_print_text(("m.wall.vertex1.x = "..tostring(m.wall.vertex1.x)), 700, 100, 1)
    --djui_hud_print_text(("m.wall.vertex1.y = "..tostring(m.wall.vertex1.y)), 700, 125, 1)
    --djui_hud_print_text(("m.wall.vertex1.z = "..tostring(m.wall.vertex1.z)), 700, 150, 1)
    --djui_hud_print_text(("m.wall.vertex3.x = "..tostring(m.wall.vertex3.x)), 1000, 100, 1)
    --djui_hud_print_text(("m.wall.vertex3.y = "..tostring(m.wall.vertex3.y)), 1000, 125, 1)
    --djui_hud_print_text(("m.wall.vertex3.z = "..tostring(m.wall.vertex3.z)), 1000, 150, 1)
    --end


    if m.flags & MARIO_CAP_ON_HEAD ~= 0 then
        local yOff = 40
        local xOff = 20
        djui_hud_set_color(0, 0, 0, 255)
        djui_hud_render_rect(width - xOff - fuelMax*2, height - yOff, fuelMax*2, 30)
        djui_hud_set_color(eCol.r, eCol.g, eCol.b, 128)
        djui_hud_render_rect(width - xOff - fuelMax*2 + 4, height - yOff + 4, e.fuel*2 - 8, 30 - 8)
        djui_hud_set_color(eCol.r, eCol.g, eCol.b, 255)
        djui_hud_render_rect(width - xOff - fuelMax*2 + 4, height - yOff + 4, e.fuelLerp*2 - 8, 30 - 8)
    end

    djui_hud_set_color(eCol.r, eCol.g, eCol.b, 255)
    djui_hud_set_font(FONT_RECOLOR_HUD)
    local kph = ""..string.format("%.0f", m.forwardVel).." KPH"
    djui_hud_print_text(kph, width - 40 - (#kph * 3 * 12), height - 240, 3, 3)

    local randomOffsetX = math.round(math.random(0-e.score, e.score)/10000)
    local randomOffsetY = math.round(math.random(0-e.score, e.score)/10000)

    if e.comboOpacity > 0 then
        local opacity = ((e.comboOpacity/comboOpacityMax) * 255)
        --local opacity = 255
        local nameLength = #e.trickName
        local scoreLength = #tostring(e.score)
        djui_hud_set_font(FONT_RECOLOR_HUD)
        djui_hud_set_color(0, 0, 0, opacity)
        djui_hud_render_rect(halfW - 200 + randomOffsetX, height - 110 + randomOffsetY, 400, 10)
        djui_hud_set_color(255, 255, 255, opacity)
        djui_hud_render_rect(halfW - 200 + randomOffsetX, height - 110 + randomOffsetY, (e.comboTimer/comboTimerMax)*400, 10)
        djui_hud_print_text(e.trickName, halfW - nameLength*12 + randomOffsetX, height - 90 + randomOffsetY, 2)

        local comboLimit = math.clamp(e.combo, 0, 20)
        local comboCol = math.clamp((comboLimit)*12.75, 0, 255)

        --djui_hud_set_font(FONT_HUD)
        djui_hud_set_color(eCol.r, eCol.g, eCol.b, opacity)
        djui_hud_print_text(""..tostring(e.score), halfW - (scoreLength)*25 + randomOffsetX, height - 185 + randomOffsetY, 4)
        --djui_hud_set_font(FONT_RECOLOR_HUD)
        if e.combo >= 100 then
            djui_hud_set_color(255, 0, 0, opacity)
        else
            djui_hud_set_color(comboCol, 255-comboCol, 255-(comboCol/2)+50, opacity)
        end
        djui_hud_print_text("x"..tostring(e.combo), halfW + 210 + randomOffsetX, height - 135 + randomOffsetY, 3)
        if comboPhrases[e.combo] ~= "" then
            local comboPhraseUse = ""
            if e.combo <= #comboPhrases then
                comboPhraseUse = comboPhrases[e.combo]
            elseif e.combo >= 100 then
                comboPhraseUse = "1000 YEARS OF BLOOD!!!"
            else
                comboPhraseUse = comboPhrases[#comboPhrases]
            end
            djui_hud_print_text(comboPhraseUse, halfW + 210 + randomOffsetX, height - 180 - (e.comboPhraseScale - 2)*32 + randomOffsetY, e.comboPhraseScale)
        end
    end

    local posOut = gVec3fZero()

    if (m.action == ACT_FORCE_STOMP or m.action == ACT_SCREW_SPIN) and m.actionArg == 1 then
        if m.actionTimer <= 5 then
            djui_hud_world_pos_to_screen_pos({x = m.pos.x, y = m.pos.y - 50, z = m.pos.z}, posOut)
            --djui_hud_set_color(0, 0, 0, 255)
            --djui_hud_render_rect(0, 0, width, height)
            set_shader_flag_value(SHADER_FLAG_SATURATION, 0)
            set_shader_flag_value(SHADER_FLAG_EXPOSURE, 0.25)
            set_shader_flag_value(SHADER_FLAG_CONTRAST, 10)
            set_shader_flag_enabled(SHADER_FLAG_SATURATION, true)
            set_shader_flag_enabled(SHADER_FLAG_EXPOSURE, true)
            set_shader_flag_enabled(SHADER_FLAG_CONTRAST, true)
            djui_hud_set_color(eCol.r, eCol.g, eCol.b, 255)
            djui_hud_render_texture(TEX_JB_IMPACT_FRAME, posOut.x - 384, posOut.y - 384, 1.5, 1.5)
        else
            set_shader_flag_enabled(SHADER_FLAG_SATURATION, false)
            set_shader_flag_enabled(SHADER_FLAG_EXPOSURE, false)
            set_shader_flag_enabled(SHADER_FLAG_CONTRAST, false)
        end
    end
end
_G.charSelect.character_hook_moveset(CT_JB_JER, HOOK_ON_HUD_RENDER_BEHIND, jb_hud)

local function jb_interact(m, o, int)
    if m.action == ACT_TRICK and obj_get_force_stomp_func(o) then
        local crack = m.prevAction == ACT_BREAK_DOWN and m.forwardVel > 35
        m.interactObj = o
        set_mario_action(m, ACT_FORCE_STOMP, crack and 1 or 0)
        return false
    end
    if m.action == ACT_FORCE_STOMP then return false end
end
_G.charSelect.character_hook_moveset(CT_JB_JER, HOOK_ALLOW_INTERACT, jb_interact)