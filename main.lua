-- name: [CS] \\#00aa00\\Jer: \\#0088ff\\Boosted
-- description: [CS]\\#00aa00\\Jer: \\#0088ff\\Boosted\n\\#ffffff\\By \\#008800\\JerThePear\n\n\\#ffffff\\The helmet man learned some new moves, and also found a jetpack. Now with 20% more Evilswag!\n\n\\#ff7777\\This Pack requires Character Select\nto use as a Library!

local TEXT_MOD_NAME = "Jer: Boosted"

-- Stops mod from loading if Character Select isn't on
if not _G.charSelectExists then
    djui_popup_create("\\#ffffdc\\\n"..TEXT_MOD_NAME.."\nRequires the Character Select Mod\nto use as a Library!\n\nPlease turn on the Character Select Mod\nand Restart the Room!", 6)
    return 0
end

-- Models --
local E_MODEL_JB_JER = smlua_model_util_get_id('jb_jer_geo')

-- Credits --
_G.charSelect.credit_add(TEXT_MOD_NAME, "Squishy6094", "Coding")
_G.charSelect.credit_add(TEXT_MOD_NAME, "JerThePear", "Creator")

-- Textures --
local TEX_JB_JER = get_texture_info('jb_icon_jer')
local TEX_ART_JB_JER = get_texture_info('jb_graffiti_jer')

-- Sound --
local SOUND_MENU_THEME_JB_JER = audio_stream_load('jb_menu_theme.ogg')

CHAR_SOUND_TRICK_1  = CHAR_SOUND_MAX + 1
CHAR_SOUND_TRICK_2  = CHAR_SOUND_MAX + 2
CHAR_SOUND_YEEHAW   = CHAR_SOUND_MAX + 3
CHAR_SOUND_SPINJUMP = CHAR_SOUND_MAX + 4
CHAR_SOUND_GIDDY    = CHAR_SOUND_MAX + 5

VOICETABLE_JB_JER = { -- Voices from Scooter and other male characters from Lego Racers (1999)
    [CHAR_SOUND_ATTACKED] = {'jb_jer_no.ogg', 'jb_jer_ouch.ogg'},
    [CHAR_SOUND_COUGHING1] = nil,
    [CHAR_SOUND_COUGHING2] = nil,
    [CHAR_SOUND_COUGHING3] = nil,
    [CHAR_SOUND_DOH] = 'jb_jer_woah.ogg', -- long jump bump
    [CHAR_SOUND_DROWNING] = nil,
    [CHAR_SOUND_DYING] = 'jb_jer_aww.ogg',
    [CHAR_SOUND_EEUH] = 'jb_jer_mmf.ogg', -- climbing ledge
    [CHAR_SOUND_GROUND_POUND_WAH] = 'jb_jer_hiya.ogg',
    [CHAR_SOUND_HAHA] = 'jb_jer_yeah_jazzy.ogg',
    [CHAR_SOUND_HAHA_2] = 'jb_jer_yeah_jazzy.ogg',
    [CHAR_SOUND_HERE_WE_GO] = 'jb_jer_yeah.ogg', -- getting star/power up
    [CHAR_SOUND_HOOHOO] = 'jb_jer_heyhey.ogg', -- double jump/slide kick
    [CHAR_SOUND_HRMM] = 'jb_jer_mmf.ogg', -- lifting
    [CHAR_SOUND_IMA_TIRED] = nil,
    [CHAR_SOUND_MAMA_MIA] = 'jb_jer_ohno.ogg',
    [CHAR_SOUND_LETS_A_GO] = 'jb_jer_yeah_jazzy.ogg', -- starting level
    [CHAR_SOUND_ON_FIRE] = {'jb_jer_yeow.ogg', 'jb_jer_wooaahh.ogg', 'jb_jer_ouchh.ogg'},
    [CHAR_SOUND_OOOF] = 'jb_jer_mmf.ogg',
    [CHAR_SOUND_OOOF2] = 'jb_jer_oh.ogg', -- thrown out of painting
    [CHAR_SOUND_PANTING] = nil,
    [CHAR_SOUND_PANTING_COLD] = nil,
    [CHAR_SOUND_PUNCH_HOO] = 'jb_jer_yeah.ogg', -- kick
    [CHAR_SOUND_PUNCH_WAH] = 'jb_jer_ha.ogg', -- punch 2
    [CHAR_SOUND_PUNCH_YAH] = 'jb_jer_ya.ogg', -- punch 1
    [CHAR_SOUND_SO_LONGA_BOWSER] = {'jb_jer_heeyaw.ogg', 'jb_jer_yeehaw.ogg'},
    [CHAR_SOUND_SNORING1] = 'jb_jer_snore1.ogg',
    [CHAR_SOUND_SNORING2] = 'jb_jer_snore2.ogg',
    [CHAR_SOUND_SNORING3] = nil,
    [CHAR_SOUND_TWIRL_BOUNCE] = {'jb_jer_yeehaw.ogg', 'jb_jer_eeah.ogg'},
    [CHAR_SOUND_UH] = 'jb_jer_oh.ogg', -- wall bonk
    [CHAR_SOUND_UH2] = 'jb_jer_mmf.ogg', -- landing long jump
    [CHAR_SOUND_UH2_2] = 'jb_jer_mmf.ogg', -- same as uh2 maybe??
    [CHAR_SOUND_WAAAOOOW] = 'jb_jer_wooaahh.ogg',
    [CHAR_SOUND_WAH2] = 'jb_jer_ha.ogg', -- throw
    [CHAR_SOUND_WHOA] = 'jb_jer_woah.ogg',
    [CHAR_SOUND_YAHOO] = {'jb_jer_woohoo.ogg', 'jb_jer_yippee.ogg'},
    [CHAR_SOUND_YAWNING] = nil,
    [CHAR_SOUND_YAHOO_WAHA_YIPPEE] = {'jb_jer_woohoo.ogg', 'jb_jer_yippee.ogg', 'jb_jer_heeyaw.ogg'},
    [CHAR_SOUND_YAH_WAH_HOO] = {'jb_jer_ha.ogg', 'jb_jer_hoh.ogg'},
    [CHAR_SOUND_OKEY_DOKEY] = 'jb_jer_yeah_jazzy.ogg',
    --CHAR_SOUND_MAX
    [CHAR_SOUND_TRICK_1] = {'jb_jer_yeah.ogg', 'jb_jer_hiya.ogg', 'jb_jer_yeah_jazzy.ogg'},
    [CHAR_SOUND_TRICK_2] = {'jb_jer_woohoo.ogg', 'jb_jer_yippee.ogg'},
    [CHAR_SOUND_YEEHAW] = {'jb_jer_heeyaw.ogg', 'jb_jer_yeehaw.ogg'},
    [CHAR_SOUND_SPINJUMP] = {'jb_jer_eeah.ogg', 'jb_jer_woohoo.ogg', 'jb_jer_yippee.ogg'},
    [CHAR_SOUND_GIDDY] = 'jb_jer_giddyup.ogg',
}

local PALETTES_JB_JER = {
    {
        name = "Last Lap Legend",
        [PANTS]  = "303030",
        [SHIRT]  = "85642c",
        [GLOVES] = "305e3d",
        [SHOES]  = "ffffff",
        [HAIR]   = "FFBC00",
        [SKIN]   = "ffc2ab",
        [CAP]    = "4c4c4c",
        [EMBLEM] = "00ff00",
    },{
        name = "Left Lane",
        [PANTS]  = "b4a66c",
        [SHIRT]  = "4d642c",
        [GLOVES] = "888888",
        [SHOES]  = "4c4c4c",
        [HAIR]   = "79ff00",
        [SKIN]   = "ffc2ab",
        [CAP]    = "4c4c4c",
        [EMBLEM] = "79ff00",
    },{
        name = "Cobalt Camber",
        [PANTS]  = "ffffff",
        [SHIRT]  = "822f27",
        [GLOVES] = "33363e",
        [SHOES]  = "822f27",
        [HAIR]   = "ffffff",
        [SKIN]   = "ffc2ab",
        [CAP]    = "2d5674",
        [EMBLEM] = "ffffff",
    },{
        name = "Carbon Cruiser",
        [PANTS]  = "ff5014",
        [SHIRT]  = "555050",
        [GLOVES] = "ff6e32",
        [SHOES]  = "282832",
        [HAIR]   = "282832",
        [SKIN]   = "ffc2ab",
        [CAP]    = "282828",
        [EMBLEM] = "ff5014",
    },{
        name = "Course Clover",
        [PANTS]  = "888888",
        [SHIRT]  = "2e353c",
        [GLOVES] = "ffffff",
        [SHOES]  = "ffffff",
        [HAIR]   = "2b9a35",
        [SKIN]   = "ffc2ab",
        [CAP]    = "2b9a35",
        [EMBLEM] = "ffffff",
    },{
        name = "Hotline Hitman",
        [PANTS]  = "003264",
        [SHIRT]  = "be0064",
        [GLOVES] = "ffffff",
        [SHOES]  = "00b694",
        [HAIR]   = "ff6e32",
        [SKIN]   = "ffc2ab",
        [CAP]    = "00b694",
        [EMBLEM] = "00b694",
    },{
        name = "Gearhead Gator",
        [PANTS]  = "222222",
        [SHIRT]  = "42521e",
        [GLOVES] = "ff7600",
        [SHOES]  = "ff7600",
        [HAIR]   = "ab1b27",
        [SKIN]   = "cb8966",
        [CAP]    = "ab1b27",
        [EMBLEM] = "ab1b27",
    },{
        name = "Sprint Sister",
        [PANTS]  = "7195ac",
        [SHIRT]  = "c2ffff",
        [GLOVES] = "c2ffff",
        [SHOES]  = "ff2e41",
        [HAIR]   = "c2ffff",
        [SKIN]   = "ffba90",
        [CAP]    = "ff2e41",
        [EMBLEM] = "c2ffff",
    },{
        name = "Citrus Circuit",
        [PANTS]  = "3c5521",
        [SHIRT]  = "ff701f",
        [GLOVES] = "8bae27",
        [SHOES]  = "8bae27",
        [HAIR]   = "ff701f",
        [SKIN]   = "ffc2ab",
        [CAP]    = "3c5521",
        [EMBLEM] = "8bae27",
    },{
        name = "Desert Dweller",
        [PANTS]  = "302d44",
        [SHIRT]  = "771f81",
        [GLOVES] = "36b94b",
        [SHOES]  = "ae6d34",
        [HAIR]   = "36b94b",
        [SKIN]   = "fec179",
        [CAP]    = "302d44",
        [EMBLEM] = "36b94b",
    },
}

--local CAP_JB_JER = {
--    normal = smlua_model_util_get_id("jb_cap_helmet_geo"),
--    wing = smlua_model_util_get_id("jb_cap_nos_geo"),
--    metal = smlua_model_util_get_id("jb_cap_metal_geo"),
--    metalWing = smlua_model_util_get_id("jb_cap_metalnos_geo"),
--}

local ANIMTABLE_JB_JER = {
--    [_G.charSelect.CS_ANIM_MENU] = "jb_anim_menu", -- wip
--    [CHAR_ANIM_RUNNING] = "jb_anim_running", -- wip
--    [CHAR_ANIM_RIDING_SHELL] = "jb_anim_shell_ride", -- wip
--    [CHAR_ANIM_START_RIDING_SHELL] = "jb_anim_shell_start", -- wip
--    [CHAR_ANIM_JUMP_RIDING_SHELL] = "jb_anim_shell_fall", -- wip
--    [CHAR_ANIM_SINGLE_JUMP] = "jb_anim_single_jump", -- wip
    [MARIO_ANIM_SLIDEFLIP]              = "jb_anim_slideflip",
    [MARIO_ANIM_SLIDEJUMP]              = "jb_anim_wallkick",
    [MARIO_ANIM_WALKING]                = "jb_anim_nephew_stride",
    [MARIO_ANIM_IDLE_HEAD_LEFT]         = "jb_anim_idle",
    [MARIO_ANIM_IDLE_HEAD_RIGHT]        = "jb_anim_idle",
    [MARIO_ANIM_IDLE_HEAD_CENTER]       = "jb_anim_idle_turn",
    [MARIO_ANIM_FIRST_PERSON]           = "jb_anim_idle",
    [MARIO_ANIM_TRIPLE_JUMP_LAND]       = "jb_anim_tada",
    [MARIO_ANIM_GENERAL_FALL]           = "jb_anim_fall",
    [MARIO_ANIM_GENERAL_LAND]           = "jb_anim_land",
    [MARIO_ANIM_LAND_FROM_SINGLE_JUMP]  = "jb_anim_land_single_jump",
    [MARIO_ANIM_LAND_FROM_DOUBLE_JUMP]  = "jb_anim_land_double_jump",
    [MARIO_ANIM_SLIDE_KICK]             = "jb_anim_slide_kick",
    [MARIO_ANIM_START_RIDING_SHELL]     = "jb_anim_shell_ride_start",
    [MARIO_ANIM_RIDING_SHELL]           = "jb_anim_shell_ride_land",
    [MARIO_ANIM_JUMP_RIDING_SHELL]      = "jb_anim_shell_ride_jump",
    [MARIO_ANIM_HANDSTAND_JUMP]         = "jb_anim_single_jump_big",
    [MARIO_ANIM_SINGLE_JUMP]            = function(m, frame)
                                            if m.actionArg == 73 then
                                                return "jb_anim_single_jump_big"
                                            else
                                                return "jb_anim_single_jump"
                                            end
                                        end,
    [MARIO_ANIM_RUNNING]                = function(m, frame)
                                            if get_global_timer() % 5 == 0 and m.forwardVel > 29 and m.pos.y > m.waterLevel then
                                                m.particleFlags = m.particleFlags | PARTICLE_DUST
                                            end
                                            return "jb_anim_run"
                                        end,
}

local EYETABLE_JB_JER = {
    [MARIO_ANIM_BACKWARD_KB]        = MARIO_EYES_DEAD,
    [MARIO_ANIM_FORWARD_KB]         = MARIO_EYES_DEAD,
    [MARIO_ANIM_BACKWARD_AIR_KB]    = MARIO_EYES_DEAD,
    [MARIO_ANIM_AIR_FORWARD_KB]     = MARIO_EYES_DEAD,
    [MARIO_ANIM_BACKWARDS_WATER_KB] = MARIO_EYES_DEAD,
    [MARIO_ANIM_WATER_FORWARD_KB]   = MARIO_EYES_DEAD,
    [MARIO_ANIM_IDLE_HEAD_CENTER]   = MARIO_EYES_LOOK_RIGHT,
}

local HANDTABLE_JB_JER = {
    [MARIO_ANIM_TRIPLE_JUMP_LAND]   = MARIO_HAND_OPEN,
    [MARIO_ANIM_SLIDEFLIP]          = MARIO_HAND_OPEN,
    [MARIO_ANIM_GENERAL_FALL]       = MARIO_HAND_OPEN,
    [MARIO_ANIM_BACKFLIP]           = MARIO_HAND_OPEN,
    [MARIO_ANIM_SLIDE_KICK]         = 5,
    [MARIO_ANIM_SINGLE_JUMP]        = function(m, frame) if frame > 8 then return MARIO_HAND_OPEN end end,
}

--local HEALTH_METER_JB_JER = {
--    label = {
--        left = get_texture_info("jj-pie-jer-left"),
--        right = get_texture_info("jj-pie-jer-right"),
--    },
--    pie = {
--        [1] = get_texture_info("jj-pie-1"),
--        [2] = get_texture_info("jj-pie-2"),
--        [3] = get_texture_info("jj-pie-3"),
--        [4] = get_texture_info("jj-pie-4"),
--        [5] = get_texture_info("jj-pie-5"),
--        [6] = get_texture_info("jj-pie-6"),
--        [7] = get_texture_info("jj-pie-7"),
--        [8] = get_texture_info("jj-pie-8"),
--    }
--}

if _G.charSelectExists then
    CT_JB_JER = _G.charSelect.character_add("Jer", { "A helmet man with that need for speed. Press L to boost!"},
        "JerThePear",
        {r = 000, g = 255, b = 000},
        E_MODEL_JB_JER,
        CT_MARIO,
        TEX_JB_JER,
        1.25
    )
end

local CSloaded = false
local function on_character_select_load()
    for i = 1, #PALETTES_JB_JER do
        _G.charSelect.character_add_palette_preset(E_MODEL_JB_JER, PALETTES_JB_JER[i], PALETTES_JB_JER[i].name)
    end

    -- Model dependant
    _G.charSelect.character_add_animations(E_MODEL_JB_JER, ANIMTABLE_JB_JER, EYETABLE_JB_JER, HANDTABLE_JB_JER)
    --_G.charSelect.character_add_caps(E_MODEL_JB_JER, CAP_JB_JER)
    _G.charSelect.character_add_voice(E_MODEL_JB_JER, VOICETABLE_JB_JER)

    -- Char dependant
    --_G.charSelect.character_add_health_meter(CT_JB_JER, HEALTH_METER_JB_JER)
    _G.charSelect.character_add_graffiti(CT_JB_JER, TEX_ART_JB_JER)
    _G.charSelect.character_add_menu_instrumental(CT_JB_JER, SOUND_MENU_THEME_JB_JER)

    -- Categories
    _G.charSelect.character_set_category(CT_JB_JER, "Squishy Workshop")

    CSloaded = true
end

local function on_character_sound(m, sound)
    if not CSloaded then return end
    if _G.charSelect.character_get_voice(m) == VOICETABLE_JB_JER then return _G.charSelect.voice.sound(m, sound) end
end

local function on_character_snore(m)
    if not CSloaded then return end
    if _G.charSelect.character_get_voice(m) == VOICETABLE_JB_JER then return _G.charSelect.voice.snore(m) end
end

hook_event(HOOK_ON_MODS_LOADED, on_character_select_load)
hook_event(HOOK_CHARACTER_SOUND, on_character_sound)
hook_event(HOOK_MARIO_UPDATE, on_character_snore)