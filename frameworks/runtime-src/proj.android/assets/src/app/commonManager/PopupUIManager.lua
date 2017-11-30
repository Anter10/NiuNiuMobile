PopupUIManager = class("PopupUIManager")
local popupLayerList = {}
local netTip_Tag = 999999

PopupUIManager.PopupTypes = {
    Popup_tip = 0,
    Popup_setting = 1,    --设置
    Popup_roleInfo = 2,   --个人信息
    Popup_normalDesk = 3, --常规场
    Popup_selectRole = 4, --角色选择
    Popup_shop = 5,       --商城
    Popup_moreThan = 6, --大厅更多
    Popup_chat = 7,       --聊天
    Popup_bag = 8,        --bag
    Popup_matchList = 9,  --赛事
    Popup_friend = 10,  --好友error
    Popup_task = 11,  --任务
    Popup_mail = 12,      --mail
    Popup_mail_pop = 13,      --mail_pop
    Popup_chat_alert = 14, --小弹框
    Popup_board_supply = 15, --牌局补充
    Popup_small_shop = 16, --小弹窗shop
    Popup_error = 17,      --error 弹窗 
    Popup_match_info_tip = 18,      --mtt报名弹窗 
    Popup_match_result = 19, --比赛结果
    Popup_match_nochip = 20, --比赛没筹码提示
    Popup_match_singsuccess = 21, --mtt报名成功
    Popup_board_notchip = 22, --牌局筹码不足提示
    Popup_match_signup_success_pop = 23,      --比赛报名成功弹窗
    Popup_rank = 24,--排行榜
    Popup_sign = 25,--签到
    Popup_register = 26,--注册
    Popup_activity = 27,--活动
    Popup_account_login = 28, -- 账号登录
    Popup_reset_password = 29, -- 重置密码
    Popup_help = 30,--活动
    Popup_bind_phone_number = 31, -- 绑定手机号
    Popup_month_card_award = 32, -- 月卡奖励
    Popup_first_pay_gift = 33, --首冲
    Popup_settings_alert = 34, -- 设置弹框
    Popup_vip = 35,           --vip
    Popup_settings_other_alert = 36, -- 设置其他弹框
    Popup_mtt_cutdown = 37, --mtt倒计时
    Popup_match_addon =38,--加购
    Popup_desk_chat=39, --桌内聊天
    Popup_award=40, -- 奖励
    Popup_diamond_shop = 41, -- 钻石商城
    Popup_update_nick_name = 42, -- 修改昵称
    Popup_signature = 43, --个性签名
    Popup_notice = 44,--公告
    Popup_report=45,--举报
    Popup_match_buy_item = 46,--比赛列表门票不足购买 MatchBuyGoodsItemPop
    Popup_match_from_bag = 47, --背包进比赛
    Popup_dragon_tiger_fight = 48, --龙虎斗
    Popup_mttunfish_pop = 49, --mtt进行中的小弹窗
    Popup_dragon_tiger_fight_rank = 50, --龙虎斗排行结果
    Popup_dragon_tiger_show_card = 51, --龙虎斗显示牌
    Popup_dragon_tiger_data = 52, --龙虎斗数据
    Popup_buy_goods_item = 53,--改名卡购买 
    Popup_username_register = 54,--username注册
    Popup_username_login = 55, --username登录
    Popup_net_error = 56,
    Popup_turn_table = 57,
    Popup_privateDesk = 58, --私桌
    Popup_privateBrinInto = 59, --私桌带入ui
    Popup_sign_week=60,--七日签到
    Popup_slot=61,--老虎机

    Popup_race_result = 62,     --赛车结果
    Popup_race_record = 63,     --赛车记录
    Popup_physical_award = 64,     --实物奖励界面 PhysicalAwardLayer
    Popup_slot_help = 65,     --小丑帮助

    Popup_fishingSceneList = 66,
    Popup_fishingWeaponLock = 67,
    Popup_fishingHelp = 68,
    Popup_fishingBackTips = 69,
    Popup_fishingPopShop = 70,
    Popup_smallgameslayer = 71,
    Popup_new_help = 72,
}

local popupTypes = PopupUIManager.PopupTypes

local popupMap = {
    [popupTypes.Popup_chat] = require("src/modules/chat/ChatLayer"),
    [popupTypes.Popup_matchList] = require("src/modules/match/MatchListLayer"),
    [popupTypes.Popup_normalDesk] = require("src/modules/mainHall/NormalDeskListLayer"),
    [popupTypes.Popup_tip] = require("src/modules/commonUI/CommonTipLayer"),
    [popupTypes.Popup_setting] = require("src/modules/settings/SettingsLayer"),
    [popupTypes.Popup_roleInfo] = require("src/modules/role/RoleInfoDetailLayer"),
    [popupTypes.Popup_selectRole] = require("src/modules/role/SelectRoleLayer"),
    [popupTypes.Popup_moreThan] = require("src/modules/mainHall/MoreThanLayer"),
    [popupTypes.Popup_shop] = require("src/modules/shop/ShopLayer"),
    [popupTypes.Popup_small_shop] = require("src/modules/shop/PopShopLayer"),
    [popupTypes.Popup_diamond_shop] = require("src/modules/shop/DiamondShopLayer"),
    [popupTypes.Popup_bag] = require("src/modules/bag/BagLayer"),
    [popupTypes.Popup_friend] = require("src/modules/friend/FriendLayer"),
    [popupTypes.Popup_mail] = require("src/modules/mail/MailLayer"),
    [popupTypes.Popup_mail_pop] = require("src/modules/mail/MailPopLayer"),
    [popupTypes.Popup_task] = require("src/modules/task/TaskLayer"),
    [popupTypes.Popup_chat_alert] = require("src/modules/chat/ChatAlertLayer"),
    [popupTypes.Popup_board_supply] = require("src/modules/gameBoard/BoardSupplyLayer"),
    [popupTypes.Popup_error] = require("src/modules/error/ErrorLayer"),
    [popupTypes.Popup_match_info_tip] = require("src/modules/gameBoard/match/MatchDetail"),
    [popupTypes.Popup_match_signup_success_pop] = require("src/modules/match/MatchSignUpSuccessPop"),
    [popupTypes.Popup_match_result] = require("src/modules/gameBoard/match/MatchResultLayer"),
    [popupTypes.Popup_match_nochip] = require("src/modules/gameBoard/match/MatchNoChipLayer"),
    [popupTypes.Popup_match_singsuccess] = require("src/modules/gameBoard/match/MatchSingUpSuccess"),
    [popupTypes.Popup_board_notchip] = require("src/modules/gameBoard/BoardNotChipTip"),
    [popupTypes.Popup_rank] = require("src/modules/rank/RankLayer"),
    [popupTypes.Popup_sign] = require("src/modules/sign/SignLayer"),
    [popupTypes.Popup_sign_week] = require("src/modules/sign/SignWeekLayer"),
    [popupTypes.Popup_register] = require("src/modules/login/RegisterLayer"),
    [popupTypes.Popup_activity] = require("src/modules/activity/ActivityLayer"),
    [popupTypes.Popup_help] = require("src/modules/commonUI/HelpLayer"),
    [popupTypes.Popup_new_help] = require("src/modules/commonUI/NewHelpLayer"),
    [popupTypes.Popup_account_login] = require("src/modules/login/AccountLoginLayer"),
    [popupTypes.Popup_reset_password] = require("src/modules/login/ResetPasswordLayer"),
    [popupTypes.Popup_bind_phone_number] = require("src/modules/role/BindPhoneNumberLayer"),
    [popupTypes.Popup_month_card_award] = require("src/modules/vip/MonthCardAwardLayer"),
    [popupTypes.Popup_settings_alert] = require("src/modules/settings/SettingsAlertLayer"),
    [popupTypes.Popup_first_pay_gift] = require("src/modules/vip/FirstPayGiftLayer"),
    [popupTypes.Popup_mtt_cutdown] = require("src/modules/gameBoard/match/MttCountDown"),
    [popupTypes.Popup_vip] = require("src/modules/vip/VipLayer"),
    [popupTypes.Popup_settings_other_alert] = require("src/modules/settings/SettingsOtherAlertLayer"),
    [popupTypes.Popup_match_addon] = require("src/modules/gameBoard/match/MatchAddonLayer"),
    [popupTypes.Popup_award] = require("src/modules/commonUI/AwardLayer"),
    [popupTypes.Popup_update_nick_name] = require("src/modules/role/UpdateNickNameLayer"),
    [popupTypes.Popup_signature] = require("src/modules/role/SignatureLayer"),
    [popupTypes.Popup_notice] = require("src/modules/notice/NoticeLayer"),
    [popupTypes.Popup_report] = require("src/modules/role/ReportLayer"),
    [popupTypes.Popup_match_buy_item] = require("src/modules/match/MatchBuyGoodsItemPop"),
    [popupTypes.Popup_match_from_bag] = require("src/modules/match/MatchFromBagLayer"),
    [popupTypes.Popup_dragon_tiger_fight] = require("src/gameCenter/dragonTigerFight/DragonTigerFightLayer"),
    [popupTypes.Popup_mttunfish_pop] = require("src/modules/match/MttUnFinshTip"),
    [popupTypes.Popup_dragon_tiger_fight_rank] = require("src/gameCenter/dragonTigerFight/DragonTigerFightRankLayer"),
    [popupTypes.Popup_dragon_tiger_show_card] = require("src/gameCenter/dragonTigerFight/DragonTigerShowCardLayer"),
    [popupTypes.Popup_dragon_tiger_data] = require("src/gameCenter/dragonTigerFight/DragonTigerDataLayer"),
    [popupTypes.Popup_buy_goods_item] = require("src/modules/shop/BuyGoodsItemPop"),
    [popupTypes.Popup_net_error] = require("src/modules/commonUI/NetErrorLayer"),
    [popupTypes.Popup_username_register] = require("src/modules/login/CustomAccountRegisterLayer"),
    [popupTypes.Popup_username_login] = require("src/modules/login/CustomAccountLoginLayer"),
    [popupTypes.Popup_turn_table] = require("src/modules/activity/TurnTableLayer"),
    [popupTypes.Popup_privateDesk] = require("src/modules/privatedesk/PrivateDeskLayer"),
    [popupTypes.Popup_privateBrinInto] = require("src/modules/privatedesk/privateBrinIntoLayer"),
    [popupTypes.Popup_slot] = require("src/gameCenter/slot/SlotLayer"),
    [popupTypes.Popup_race_result] = require("src/gameCenter/race/RaceResultLayer"),
    [popupTypes.Popup_race_record] = require("src/gameCenter/race/RaceRecordLayer"),
    [popupTypes.Popup_physical_award] = require("src/modules/activity/PhysicalAwardLayer"),
    [popupTypes.Popup_slot_help] = require("src/gameCenter/slot/SlotHelpLayer"),
    [popupTypes.Popup_fishingSceneList] = require("src/fishing/common/FishSceneListLayer"),
    [popupTypes.Popup_fishingWeaponLock] = require("src/fishing/main/FishingWeaponLockLayer"),
    [popupTypes.Popup_fishingHelp] = require("src/fishing/main/FishHelpLayer"),
    [popupTypes.Popup_fishingBackTips] = require("src/fishing/main/FishingBackTipsLayer"),
    [popupTypes.Popup_fishingPopShop] = require("src/fishing/main/FishPopShopLayer"),  
    [popupTypes.Popup_smallgameslayer] = require("src/modules/mainHall/SmallGamesLayer"),  
   
}

PopupUIManager.tip_type = {
    one_btn_tip = 1, --常规诸如是否退出提示这样只有确定按钮的
    two_btn_tip = 2, --确定和取消都有的
}

--冒泡提示的样式
PopupUIManager.bubbleStyle = {
    down = 1,
    top = 2
}

function PopupUIManager:onExitScene()
    popupLayerList = {}
end

function PopupUIManager:hasOpen(popupType)
    return popupLayerList[popupType]       
end

function PopupUIManager:openPopup(popupType,params)
    local layer = self:getPopup(popupType,params);
      
    if layer:getParent() then
        return layer
    end
    
    cc.Director:getInstance():getRunningScene():addChild(layer)
    layer:openPopup()
    return layer   
end

    
function PopupUIManager:closePopup(popupType)
    local layer = popupLayerList[popupType]
    if not layer then
        return 
    end
    local _isActivity = layer:getIsActivity()
    if not _isActivity then
        popupLayerList[popupType] = nil  
        layer:closePopup()
    end
    --内存释放
    --vt.collectMemory()
end
   

function PopupUIManager:getPopup(popupType,params)
    local layer = popupLayerList[popupType]
    if not layer then
        layer = self:createPopup(popupType,params);
        popupLayerList[popupType] = layer;
    end
     
    return layer
end

--是否有此popup
function PopupUIManager:getPopupByType(popupType)
    local layer = popupLayerList[popupType]
    return layer
end

function PopupUIManager:createPopup(popupType,params)
    print("----popupType----",popupType)
    local layer = nil
	local c = popupMap[popupType]
	local specialList = {
		[popupTypes.Popup_chat] = function()
			local _data = DataManager:getChatList()
			return _data
		end,
		[popupTypes.Popup_matchList] = function()
			local _data = DataManager:getMttRoomData()
			return _data
		end,
		[popupTypes.Popup_normalDesk] = function()
			local _data = DataManager:getNormalDeskData()
			return _data
		end,
	}
	if  c ~=nil then

		if specialList[popupType] ~= nil then

			local func = specialList[popupType]
			local data = func()
			layer = c:create(data)
        else

			layer = c:create(params)
		end
	end


    if params then
        if type(params) == "table" then
            layer:setTouchClose(params.is_touchClose)
        end
    end
    --layer:openPopup()
    layer:setPopupType(popupType)
    return layer
end


--常规冒泡提示 显示几秒消失
function PopupUIManager:bubbleTips(str,dt,type)
    dt = (dt == nil) and 1.5 or dt
    
    local layer = cc.CSLoader:createNode(g_ui_res.buddle_tip_csb)
    if type==PopupUIManager.PopupTypes.Popup_chat then
        layer:setPosition(-300,0)
    elseif type==PopupUIManager.PopupTypes.Popup_desk_chat then
        layer:setPosition(-250,0)
    else
        layer:setPosition(0,0)
    end
    layer:setVisible(true)
    local root_panel = layer:getChildByName("root_panel")
    local bg = root_panel:getChildByName("bg")
    local text = root_panel:getChildByName("text_label")
    
    
    text:setText(str)
    bg:stopAllActions()
    text:stopAllActions()
    bg:setOpacity(255)
    text:setOpacity(255)
    bg:setVisible(true);
    text:setVisible(true)
    local _size = text:getContentSize()
    bg:setContentSize(_size)
    
    bg:runAction(cc.Sequence:create(cc.DelayTime:create(dt/2), cc.FadeOut:create(dt)))
    text:runAction(cc.Sequence:create(cc.DelayTime:create(dt/2), cc.FadeOut:create(dt)))
    layer:runAction(cc.Sequence:create(cc.DelayTime:create(dt*3/2), cc.RemoveSelf:create()))

    layer:setCameraMask(cc.CameraFlag.USER2)
    layer:setLocalZOrder(ConstantConfig.UI_ORDER.GAME_TIP)
    cc.Director:getInstance():getRunningScene():addChild(layer)
end

function PopupUIManager:bubbleNetTips()
    local current_scene = cc.Director:getInstance():getRunningScene()
    local layer = current_scene:getChildByTag(netTip_Tag)
    if layer == nil then
        layer = cc.CSLoader:createNode(g_ui_res.buddle_tip_csb)    
        layer:setTag(netTip_Tag)
        layer:setPosition(0,0)
        layer:setVisible(true)
        local root_panel = layer:getChildByName("root_panel")
        local text = root_panel:getChildByName("text_label")

        text:setText("网络异常,请检查")
        current_scene:addChild(layer)
    end
    
end

--移动展现的冒泡 诸如屏幕最下 和最上出现
function PopupUIManager:bubbleMoveTips(str,dt,type)
    local layer = cc.CSLoader:createNode(g_ui_res.buddle_tip_csb)    
    layer:setPosition(0,0)
    layer:setVisible(true)

    local root_panel = layer:getChildByName("root_panel")
    local text = root_panel:getChildByName("text_label")
    
    local call_back = cc.CallFunc:create(function(sender,tb)
        layer:removeFromParent()
    end)
    
    local end_y = 0
    if type == PopupUIManager.bubbleStyle.down then
        local x,y = root_panel:getPosition()
        local offest_y = root_panel:getContentSize().height
        root_panel:setPosition(cc.p(x,-offest_y/2))
        end_y = offest_y
    else
        local x,y = root_panel:getPosition()
        local offest_y = root_panel:getContentSize().height
        root_panel:setPosition(cc.p(x,layer:getContentSize().height + offest_y/2))
        end_y = -offest_y
      
    end
    
    print("xxx--xxx-----"..tostring(end_y))
    text:setText(str)
    cc.Director:getInstance():getRunningScene():addChild(layer)
    
    local move_by = cc.MoveBy:create(0.5,cc.p(0, end_y))
    local dealy = cc.DelayTime:create(dt)
    local action = cc.Sequence:create(move_by,dealy,call_back)
    root_panel:runAction(action)
end


function PopupUIManager:removeBubbleNetTips()
    local node = cc.Director:getInstance():getRunningScene()
    node:removeChildByTag(netTip_Tag)
end
