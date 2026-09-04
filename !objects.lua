local afterImageDurr = 0
local afterImageStartOpacity = 0
local E_MODEL_JB_JER_AFTER_IMAGE = smlua_model_util_get_id('jb_jer_after_image_geo')

function after_image_init(o)
	local m = gMarioStates[0]
	o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
	o.oOpacity = 0

	vec3f_copy(o.header.gfx.pos, m.marioObj.header.gfx.pos)
	vec3f_copy(o.header.gfx.scale, m.marioObj.header.gfx.scale)
	vec3s_copy(o.header.gfx.angle, m.marioObj.header.gfx.angle)
	o.header.gfx.animInfo.animID = m.marioObj.header.gfx.animInfo.animID
	o.header.gfx.animInfo.curAnim = m.marioObj.header.gfx.animInfo.curAnim
	o.header.gfx.animInfo.animYTrans = m.marioObj.header.gfx.animInfo.animYTrans
	o.header.gfx.animInfo.animAccel = 0
	o.header.gfx.animInfo.animFrame = m.marioObj.header.gfx.animInfo.animFrame
	o.header.gfx.animInfo.animTimer = m.marioObj.header.gfx.animInfo.animTimer
	o.header.gfx.animInfo.animFrameAccelAssist = 0
end

function after_image_loop(o)
  	o.oOpacity = afterImageStartOpacity - (o.oTimer * (afterImageStartOpacity/afterImageDurr))
  	o.header.gfx.animInfo.animAccel = -1
  	if o.oTimer >= afterImageDurr then
  		obj_mark_for_deletion(o)
  	end
end

local id_bhvAfterImage = hook_behavior(nil, OBJ_LIST_UNIMPORTANT, false, after_image_init, after_image_loop, "id_bhvAfterImage")

function spawn_after_images(frame, durr, opacity)
	local m = gMarioStates[0]
	if get_global_timer() % frame == 0 then
		spawn_non_sync_object(
			id_bhvAfterImage,
			E_MODEL_JB_JER_AFTER_IMAGE,
			m.marioObj.header.gfx.pos.x,
			m.marioObj.header.gfx.pos.y,
			m.marioObj.header.gfx.pos.z,
			function(o)
				afterImageDurr = durr
				afterImageStartOpacity = opacity
			end
		)
	end
end