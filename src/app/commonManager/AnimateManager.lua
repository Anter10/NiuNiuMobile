require("src/gameConfig/genConfig/AnimationConfig")
AnimateManager = class("AnimateManager")

local person3dInfo_list = {}

local reload_list = {
    g_3dModel_res.ditan_c3b,
    g_3dModel_res.table_9_c3b,
    g_3dModel_res.chouma_c3b,
    g_3dModel_res.dealer_c3b,
    g_3dModel_res.dealer_tb_c3b,
    g_3dModel_res.pai_c3b,
    g_3dModel_res.table_9_c3b
}
function AnimateManager:reload3dModel()
    for _,value in pairs(reload_list) do
        local sprite3d = cc.Sprite3D:create(value)
        sprite3d:retain()
    end
end

function AnimateManager:load3dPersonInfo()
    local person_action =  StaticDataManager:getTable(g_table_name.person_action)
    for _,person_item in pairs(person_action) do
        local person_id = person_item.peopleid
        local offest_position = string.split(person_item.offestpoint,",")
        for key,value in pairs(offest_position) do
            offest_position[key] =tonumber(value)
        end
        local base_info = {}
        base_info.bet_chip_duration = (person_item.betchipframe - person_item.bet_start)*(1/ConstantConfig.frameRate)
        base_info.name = person_item.name
        base_info.modelname = person_item.modelname
        if person3dInfo_list[person_id] == nil then
            person3dInfo_list[person_id] = {}
        end
        person3dInfo_list[person_id].base_info = base_info
        person3dInfo_list[person_id].offest_position = offest_position
        
        local animate_list = {}
        for key,value in pairs(g_animation_name) do
            local frame_item = {}
            frame_item["start"] = person_item[value.."_start"]
            frame_item["end"]= person_item[value.."_end"]
            animate_list[value] = frame_item
        end
        
        person3dInfo_list[person_id].animate_list = animate_list 
    end
    
end

function AnimateManager:createPersonAnimate(avatar_id,action_type)
    local avatar_id = GameUtil:checkAvatarId(avatar_id)
    
    local model_name = GameUtil:getModel3DName(avatar_id)
    print("----model_name-----"..tostring(model_name))
    local animation = cc.Animation3D:create(g_3dModel_res[model_name],"Take 001")

    local animate_list = person3dInfo_list[avatar_id].animate_list
    local animate_item = animate_list[action_type]
    local start_frame = animate_item["start"]
    local end_frame = animate_item["end"]
    local animate = cc.Animate3D:createWithFrames(animation, start_frame, end_frame)
    return animate
end

function AnimateManager:get3DPresonPosition(avatar_id)
    local avatar_id = GameUtil:checkAvatarId(avatar_id)
    local position = person3dInfo_list[avatar_id].offest_position
    return position
end

function AnimateManager:getbetChipDuration(avatar_id)
    local avatar_id = GameUtil:checkAvatarId(avatar_id)
    local base_info = person3dInfo_list[avatar_id].base_info
    local bet_chip_duration = base_info.bet_chip_duration
    return bet_chip_duration
end

function AnimateManager:getPersonInfoList()
    return person3dInfo_list
end


