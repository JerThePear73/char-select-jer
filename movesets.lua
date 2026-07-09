if not _G.charSelectExists then return end

local ACT_JERNADO = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR)
local ACT_SPRINGFLIP = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
local ACT_DASH = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
local ACT_BOOST = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
local ACT_BREAK_DOWN = allocate_mario_action(ACT_GROUP_MOVING | ACT_FLAG_MOVING | ACT_FLAG_ATTACKING)

local function convert_s16(a)
    return (a + 0x8000) % 0x10000 - 0x8000
end

local opacityMax = 200
local stepFrame = 5
local ANGLE_QUEUE_SIZE = 9
local SPIN_TIMER_SUCCESSFUL_INPUT = 4

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
        boostSpeed = 0,
        combo = 0,
        score = 0,
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

--local E_MODEL_JER_AFTERIMAGE = smlua_model_util_get_id("jer_afterimage_geo")
--local AfterImageDuration = 15

function afterimage_init(o)
  local index = network_local_index_from_global(o.globalPlayerIndex) or 255
  if index == 255 then
    obj_mark_for_deletion(o)
    return
  end
  local m = gMarioStates[index]
  o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
  o.oOpacity = 0

  o.oPosX = m.marioObj.header.gfx.pos.x
  o.oPosY = m.marioObj.header.gfx.pos.y
  o.oPosZ = m.marioObj.header.gfx.pos.z
  o.oFaceAnglePitch = m.marioObj.header.gfx.angle.x
  o.oFaceAngleYaw = m.marioObj.header.gfx.angle.y
  o.oFaceAngleRoll = m.marioObj.header.gfx.angle.z
  o.header.gfx.animInfo.animID = m.marioObj.header.gfx.animInfo.animID
  o.header.gfx.animInfo.curAnim = m.marioObj.header.gfx.animInfo.curAnim
  o.header.gfx.animInfo.animYTrans = m.unkB0
  o.header.gfx.animInfo.animAccel = 0            --m.marioObj.header.gfx.animInfo.animAccel
  o.header.gfx.animInfo.animFrame = m.marioObj.header.gfx.animInfo.animFrame
  o.header.gfx.animInfo.animTimer = m.marioObj.header.gfx.animInfo.animTimer
  o.header.gfx.animInfo.animFrameAccelAssist = 0 --m.marioObj.header.gfx.animInfo.animFrameAccelAssist
  o.header.gfx.scale.x = m.marioObj.header.gfx.scale.x
  o.header.gfx.scale.y = m.marioObj.header.gfx.scale.y
  o.header.gfx.scale.z = m.marioObj.header.gfx.scale.z
end
function afterimage_loop(o)
  o.oOpacity = opacityMax - (o.oTimer * (opacityMax/AfterImageDuration))
  o.header.gfx.animInfo.animAccel = -1
  o.header.gfx.scale.x = o.header.gfx.scale.x * 1.02
  o.header.gfx.scale.y = o.header.gfx.scale.y * 1.02
  o.header.gfx.scale.z = o.header.gfx.scale.z * 1.02
  if o.oTimer >= AfterImageDuration then
    obj_mark_for_deletion(o)
  end
end
id_bhvAfterImage = hook_behavior(nil, OBJ_LIST_UNIMPORTANT, true, afterimage_init, afterimage_loop, "bhvAfterImage")

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

------------------
-- CUSTOM MOVES --
------------------

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

local function act_springflip(m)

    set_mario_animation(m, MARIO_ANIM_TRIPLE_JUMP_GROUND_POUND)
    m.marioObj.header.gfx.pos.y = m.pos.y - 10

    if m.actionTimer == 4 then
        m.particleFlags = m.particleFlags | PARTICLE_MIST_CIRCLE
        m.vel.y = 48
        m.forwardVel = m.forwardVel + 4
        play_character_sound(m, CHAR_SOUND_YAHOO)
    end
    if m.actionTimer > 4 then
        local stepResult = common_air_action_step(m, ACT_TRIPLE_JUMP_LAND, MARIO_ANIM_TRIPLE_JUMP_GROUND_POUND, AIR_STEP_NONE)
        if m.vel.y < 1 then
            m.vel.y = m.vel.y + 2
        end
        if m.actionTimer > 20 then
            m.marioBodyState.handState = MARIO_HAND_OPEN
        elseif m.forwardVel > 50 then
            m.particleFlags = m.particleFlags | PARTICLE_DUST
        end
    end

    if m.actionTimer == 6 or m.actionTimer == 15 then -- spin sound
        play_sound(SOUND_ACTION_TWIRL, m.marioObj.header.gfx.cameraToObject)
    end
    
    if stepResult == AIR_STEP_LANDED then
        play_sound(SOUND_ACTION_TERRAIN_LANDING, m.marioObj.header.gfx.cameraToObject)
    end
    
    m.actionTimer = m.actionTimer + 1
    return smlua_anim_util_set_animation(m.marioObj, "jb_anim_springflip")
end
hook_mario_action(ACT_SPRINGFLIP, act_springflip)

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
    elseif m.actionTimer > 10 then
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
    e.boostSpeed = math.clamp((e.boostSpeed + 1), 30, 73)
    m.faceAngle.y = m.intendedYaw - approach_s32(convert_s16(m.intendedYaw - m.faceAngle.y), 0, 0x200, 0x200)
    m.marioObj.header.gfx.pos.y = m.pos.y - 50
    m.peakHeight = m.pos.y

    if m.pos.y < (m.waterLevel + 50) then
        m.pos.y = m.waterLevel + 50
        m.vel.y = 0
        set_mario_particle_flags(m, PARTICLE_SHALLOW_WATER_SPLASH, 0)
    elseif m.pos.y < (m.floorHeight + 50) then
        m.pos.y = m.floorHeight + 50
        m.vel.y = 0
    end

    if m.controller.buttonDown & L_TRIG == 0 then
        m.pos.y = m.pos.y - 50
        set_mario_action(m, ACT_FREEFALL, 0)
    end

    m.actionTimer = m.actionTimer + 1
    return 0
end
hook_mario_action(ACT_BOOST, act_boost)

-------------
-- UPDATES --
-------------

local commonDashActions = {
    [ACT_JUMP] = true,
    [ACT_FREEFALL] = true,
    [ACT_WALL_KICK_AIR] = true,
    [ACT_SPRINGFLIP] = true,
    [ACT_SIDE_FLIP] = true,
    [ACT_BACKFLIP] = true,
    [ACT_FORWARD_ROLLOUT] = true,
    [ACT_SLIDE_KICK] = false,
    [ACT_JERNADO] = true,
    [ACT_DASH] = true,
}

local boostActions = {
    [ACT_JUMP] = true,
    [ACT_FREEFALL] = true,
    [ACT_WALL_KICK_AIR] = true,
    [ACT_SPRINGFLIP] = true,
    [ACT_SIDE_FLIP] = true,
    [ACT_BACKFLIP] = true,
    [ACT_FORWARD_ROLLOUT] = true,
    [ACT_SLIDE_KICK] = false,
    [ACT_JERNADO] = true,
    [ACT_DASH] = true,
    [ACT_WALKING] = true,
    [ACT_IDLE] = true,
    [ACT_GROUND_POUND] = true,
}


local function jb_update(m)
    local e = gJerStates[m.playerIndex]

    mario_update_spin_input(m)
    if m.action == ACT_GROUND_POUND then
        m.marioObj.header.gfx.angle.y = m.faceAngle.y
    end
    if m.pos.y == m.floorHeight then
        e.canJernado = true
        e.canDash = true
        e.canBoost = true
    end

    -- running tilt
    if m.action == ACT_WALKING and m.pos.y > m.waterLevel then
        if get_global_timer() % stepFrame == 0 and m.forwardVel > 29 then
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
            m.action = ACT_SLIDE_KICK_SLIDE
            set_mario_particle_flags(m, PARTICLE_MIST_CIRCLE, 0)
        end
    end
    if (m.action == ACT_JUMP_LAND or m.action == ACT_FREEFALL_LAND) and m.input & INPUT_Z_DOWN ~= 0 then
        set_mario_action(m, ACT_SLIDE_KICK, 0)
    end
    -- firsties
    if m.action == ACT_WALL_KICK_AIR and (m.prevAction == ACT_AIR_HIT_WALL or m.prevAction == ACT_WALL_KICK_AIR) then
        smlua_anim_util_set_animation(m.marioObj, "jb_anim_wallkick_firstie")
        if m.marioObj.header.gfx.animInfo.animFrame < 10 then
            m.particleFlags = m.particleFlags | PARTICLE_SPARKLES
        end
    end
    -- ledge kick
    if m.action == ACT_LEDGE_GRAB then
        if e.perfectTimer < 3 and m.input & INPUT_B_PRESSED ~= 0 then
            set_mario_action(m, ACT_JUMP_KICK, 1)
            m.particleFlags = m.particleFlags | PARTICLE_VERTICAL_STAR
            m.vel.y = 25
            m.forwardVel = 45
        end
        e.perfectTimer = e.perfectTimer + 1
    end
    -- springflip
    if m.action == ACT_DIVE_SLIDE and m.forwardVel > 10 and m.input & INPUT_Z_PRESSED ~= 0 then
        set_mario_action(m, ACT_SPRINGFLIP, 0)
    end
    -- air dash
    if commonDashActions[m.action] and m.vel.y < 20 and m.input & INPUT_A_PRESSED ~= 0 and e.canDash and m.pos.y > m.floorHeight then
        set_mario_action(m, ACT_DASH, 0)
        e.canDash = false
    end
    -- jernado
    if (commonDashActions[m.action] or m.action == ACT_GROUND_POUND) and e.spinInput ~= 0 and e.canJernado and m.pos.y > m.floorHeight then
        set_mario_action(m, ACT_JERNADO, 0)
        e.canJernado = false
    end
    -- boost
    if boostActions[m.action] and m.controller.buttonPressed & L_TRIG ~= 0 and e.canBoost then
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
    if m.action == ACT_DIVE and m.prevAction ~= ACT_GROUND_POUND and m.flags & MARIO_WING_CAP ~= 0 and m.vel.y < 0 and m.pos.y > (m.floorHeight + 100) then
        m.action = ACT_FLYING
        e.gfxZ = 0x10000
    end
    if m.action == ACT_FLYING then
        e.gfxZ = math.lerp(e.gfxZ, 0, 0.1)
        m.marioObj.header.gfx.angle.z = m.marioObj.header.gfx.angle.z + e.gfxZ
    end
end
_G.charSelect.character_hook_moveset(CT_JB_JER, HOOK_MARIO_UPDATE, jb_update)

local function jb_set_action(m)
    local e = gJerStates[m.playerIndex]

    e.perfectTimer = 0
    e.gfxX = 0
    e.gfxY = 0
    e.gfxZ = 0

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
        if m.forwardVel > 40 then
            set_mario_particle_flags(m, PARTICLE_VERTICAL_STAR, 0)
            m.actionArg = 1
        end
    end
end
_G.charSelect.character_hook_moveset(CT_JB_JER, HOOK_ON_SET_MARIO_ACTION, jb_set_action)

local function jb_before_set_action(m, act)
    if act == ACT_DOUBLE_JUMP or act == ACT_TRIPLE_JUMP then
        return ACT_JUMP
    elseif act == ACT_CROUCH_SLIDE then
        return ACT_SLIDE_KICK
    -- flying fix; idk if this is necessary cuz of custom twirling
    elseif act == ACT_FLYING then
        m.marioObj.header.gfx.angle.y = m.faceAngle.y
    end
end
_G.charSelect.character_hook_moveset(CT_JB_JER, HOOK_BEFORE_SET_MARIO_ACTION, jb_before_set_action)