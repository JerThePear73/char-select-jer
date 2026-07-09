if not _G.charSelectExists then return end

if not _G.physBoneInit then
    -- working variables for physbones
    _G.physBoneMem = _G.physBoneMem or {}
    if not _G.physBoneMem[0] then
        for i = 0, MAX_PLAYERS - 1 do
            _G.physBoneMem[i] = {}
        end
    end
    -- configurable data for physbones, indexed by model ID & physbone index
    _G.physBoneData = _G.physBoneData or {}

    _G.physBoneEnabled = true
    hook_chat_command('physbone', " - Enable/Disable physbones", function(msg)
        _G.physBoneEnabled = not _G.physBoneEnabled
        djui_chat_message_create("Physbones " .. (_G.physBoneEnabled and "Enabled" or "Disabled"))
        return true
    end)

    _G.physBoneInit = true
end

-- initialize a physbone entry for a character model. fields left `nil` will use their default value.
---@param modelId ModelExtendedId|integer
---@param index integer
---@param pull number|nil (0.0 - 1.0, default 0.25) amount of force used to return the physbone chain to rest position.
---@param spring number|nil (0.0 - 1.0, default 0.5) how much physbones will wobble while reaching rest position.
---@param yawLimit number|nil (0 - 90, default 45) the maximum yaw angle that physbones can be from rest rotation.
---@param pitchLimit number|nil (0 - 90) the maximum pitch angle for physbones. matches yaw when `nil`.
function init_physbone(modelId, index, pull, spring, yawLimit, pitchLimit)
    _G.physBoneData[modelId] = _G.physBoneData[modelId] or {}
    _G.physBoneData[modelId][index] = {}
    local data = _G.physBoneData[modelId][index]

    data.pull = math.clamp(pull or 0.25, 0.0, 1.0)
    data.spring = math.clamp(spring or 0.5, 0.0, 1.0)
    data.yawLimit = math.clamp(degrees_to_sm64(math.abs(yawLimit or 45)), 0x0000, 0x3FFF)
    data.pitchLimit = math.clamp(degrees_to_sm64(math.abs(pitchLimit or yawLimit or 45)), 0x0000, 0x3FFF)
end

-- UTILS

local gCS = _G.charSelect.gCSPlayers

function wrap(n, min, max)
    local range = max - min
    while n < min do
        n = n + range
    end
    while n > max do
        n = n - range
    end
    return n
end

local function convert_s16(n)
    return wrap(n, -0x8000, 0x8000)
end

---@param dir Vec3f
---@return integer yaw
---@return integer pitch
local function yaw_pitch(dir)
    return radians_to_sm64(math.atan(dir.x, dir.z)), radians_to_sm64(math.atan(dir.y, math.sqrt(dir.x ^ 2 + dir.z ^ 2)))
end

-- GEO FUNCTION

---@param node GraphNode
---@param matStackIndex integer
function geo_physbone_chain(node, matStackIndex)
    local m = geo_get_mario_state()
    local i = cast_graph_node(node).parameter

    -- mirror room fix
    if m.marioBodyState.mirrorMario then return end

    if not _G.physBoneEnabled then
        local child = node.next
        while child do
            if child.type == GRAPH_NODE_TYPE_DISPLAY_LIST then
                child = child.next
            end
            if child.type == GRAPH_NODE_TYPE_TRANSLATION_ROTATION then
                local rotNode = cast_graph_node(child)
                vec3s_copy(rotNode.rotation, gVec3sZero())
            end
            child = child.children
        end
        return
    end

    local mem = _G.physBoneMem[m.playerIndex][i]
    if not mem then
        _G.physBoneMem[m.playerIndex][i] = { prevPos = gVec3fZero(), prevYaw = 0, prevPitch = 0, yaw = 0, pitch = 0 }
        mem = _G.physBoneMem[m.playerIndex][i]
    end

    local data = _G.physBoneData[gCS[m.playerIndex].modelId]
    if not data then return end
    data = data[i]
    if not data then return end

    local camInv = gMat4Zero()
    mtxf_inverse(camInv, geo_get_current_camera().matrixPtr)
    ---@type Mat4
    local mtx = gMat4Zero()
    mtxf_mul(mtx, gMatStack[matStackIndex], camInv)           -- convert root matrix into world space
    mtxf_scale_vec3f(mtx, mtx, { x = 4.0, y = 4.0, z = 4.0 }) -- rescale from 0.25 -> 1.0
    local pos = { x = mtx.m30, y = mtx.m31, z = mtx.m32 }
    local posDiff = { x = mem.prevPos.x, y = mem.prevPos.y, z = mem.prevPos.z }
    vec3f_sub(posDiff, pos)

    local curYaw, curPitch = yaw_pitch({ x = mtx.m10, y = mtx.m11, z = mtx.m12 })

    local yawDiff = convert_s16(curYaw - mem.prevYaw)
        - (vec3f_dot(posDiff, { x = mtx.m20, y = mtx.m21, z = mtx.m22 }) * 0x40) --+ (posDiff.y * 0x08)
    local pitchDiff = convert_s16(curPitch - mem.prevPitch)
        + (vec3f_dot(posDiff, { x = mtx.m00, y = mtx.m01, z = mtx.m02 }) * 0x40) + (posDiff.y * 0x10)

    local rotX = mem.yaw - yawDiff
    local rotZ = mem.pitch - pitchDiff
    rotX = clamp(approach_s16_symmetric(rotX, 0, math.abs(rotX) * data.pull), -data.yawLimit,
        data.yawLimit)
    rotZ = clamp(approach_s16_symmetric(rotZ, 0, math.abs(rotZ) * data.pull), -data.pitchLimit,
        data.pitchLimit)

    mem.yaw = rotX
    mem.pitch = rotZ

    local j = 1
    local child = node.next

    while child do
        -- skip ahead for connected DL vertices
        if child.type == GRAPH_NODE_TYPE_DISPLAY_LIST then
            child = child.next
        end
        if child.type == GRAPH_NODE_TYPE_TRANSLATION_ROTATION then
            local rotNode = cast_graph_node(child)
            local rot = rotNode.rotation

            local fac = 0.8 + (j * 0.2)
            rot.x = rotX * fac
            rot.z = rotZ * fac

            j = j + 1
        end
        child = child.children
    end

    mem.prevYaw = curYaw
    mem.prevPitch = curPitch
    vec3f_copy(mem.prevPos, pos)
end


local E_MODEL_JB_JER = smlua_model_util_get_id('jb_jer_geo')
init_physbone(E_MODEL_JB_JER, 0, nil, 1, 30, 30)
init_physbone(E_MODEL_JB_JER, 1, nil, 1, 30, 30)