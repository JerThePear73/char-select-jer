if not _G.wpets then return end

if _G.wpets then return end -- remove this when model done

local E_MODEL_JBOT = smlua_model_util_get_id('jb_pet_jbot')

local ID_JBOT = _G.wpets.add_pet({
	name = "J-Bot", credit = "JerThePear",
	description = "A lil clanker that follows you around.",
	modelID = E_MODEL_JBOT,
	scale = 1, yOffset = 0, flying = false
})

_G.wpets.set_pet_anims_head(ID_JBOT)

_G.wpets.set_pet_sounds(ID_JBOT, {
	spawn = 'jb_jbot_yeah.ogg',
	happy = 'jb_jbot_yeah.ogg',
	vanish = nil,
	step = SOUND_ACTION_METAL_LANDING
})