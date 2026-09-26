if not _G.wpets then return end

local E_MODEL_JB_PUDDLES = smlua_model_util_get_id('jb_pet_puddles_geo')

local ID_JB_PUDDLES = _G.wpets.add_pet({
	name = "Puddles", credit = "JerThePear",
	description = "I'll never forget you.",
	modelID = E_MODEL_JB_PUDDLES,
	scale = 1, yOffset = 0, flying = false
})

_G.wpets.set_pet_anims_4leg(ID_JB_PUDDLES)

_G.wpets.set_pet_sounds(ID_JB_PUDDLES, {
	spawn = nil,
	happy = nil,
	vanish = nil,
	step = nil,
})