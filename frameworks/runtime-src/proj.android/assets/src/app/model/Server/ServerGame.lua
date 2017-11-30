--
-- Author: admin
-- Date: 2017-08-01 15:58:24
--


--创建房间
function ServerWS:UserCreateRoomMsgReq(RoomInfo_table)
    local openid = cc.UserDefault:getInstance():getStringForKey("openid")
	local mas=Message_config.TYPES.MSG_C_2_S_CREATE_ROOM_REQ
	local phen =self.protoPb_list[Message_config.NAMES[tonumber(mas)]]()
	phen.msg_ID=mas
	-- phen.gametype=1
	dump(RoomInfo_table)
	phen.rule.roomID=1
	phen.rule.gameType=1
	phen.rule.param_a=tonumber(RoomInfo_table.CB_innings_type)
	phen.rule.param_b=tonumber(RoomInfo_table.CB_rules_type)
	phen.rule.param_c=tonumber(RoomInfo_table.CB_bottnote_type)
	phen.rule.param_d=tonumber(RoomInfo_table.CB_score_type)
	phen.rule.param_e=tonumber(RoomInfo_table.CB_special_type)
	phen.rule.param_f=tonumber(RoomInfo_table.CB_tuoguan_type)
	


	local data = phen:SerializeToString()
	local data_=tostring(mas)..data  
    self:sendChatMsg(data_)--,"UserCreateRoomMsgReq"
end
--创建返回
function ServerWS:UserCreateRoomMsgRes_callback()
	   	dump(self.m_errorCode)
	   	if  self.msg.m_errorCode ~= 0 then

	   		if self.msg.m_errorCode == 2 then
	   			Util:fun_Offlinepopwindow("玩家已经有房间",cc.Director:getInstance():getRunningScene())
	   		elseif self.msg.m_errorCode == 1 then
	   			Util:fun_Offlinepopwindow("消息解析失败",cc.Director:getInstance():getRunningScene())
	   		elseif self.msg.m_errorCode == 3 then
	   			Util:fun_Offlinepopwindow("钻石不足，请联系群主购买！",cc.Director:getInstance():getRunningScene())
	   		end


			return
		end
		
		-- LocalData:Instance():set_Room_Rule(self.msg.roomInfo.param_b)
		LocalData:Instance():set_CreateRoom(self.msg)

		LocalData:Instance():set_RoomInfo(self.msg.roomInfo)
		NotificationCenter:Instance():PostNotification("UserCreateRoomMsgRes")
    
	   	-- dump(self.msg.m_errorCode)
	   	-- dump(self.msg.m_pos)
	   	-- dump(self.msg.roomInfo.roomID)
	   	-- dump(self.msg.roomInfo.gameType)
	   	-- dump(self.msg.roomInfo.state)
	   	-- dump(self.msg.roomInfo.round)
end


--进入房间
function ServerWS:UserJoinRoomMsgReq(roomId)
	local mas=Message_config.TYPES.MSG_C_2_S_JOIN_ROOM_REQ
	dump(mas)
	local phen =self.protoPb_list[Message_config.NAMES[tonumber(mas)]]()
	dump(roomId)
	phen.msg_ID=mas
	-- phen.gametype=1
	phen.roomId=roomId
	-- phen.rule.gameType=1

	dump(roomId)
	local data = phen:SerializeToString()
	local data_=tostring(mas)..data  
	-- dump(data_)
    self:sendChatMsg(data_)--,"UserJoinRoomMsgReq"
end
--返回玩家信息
function ServerWS:UserJoinRoomMsgRes_callback()
	--ServerWS:Instance():open_update()
		-- dump(self.msg.m_errorCode)  
		if  self.msg.m_errorCode ~= 0 then
			NotificationCenter:Instance():PostNotification("UserJoinRoomMsgResfalse",self.msg.m_errorCode)
			return
		end
		LocalData:Instance():set_UserJoinRoomMsgRes(self.msg)
		LocalData:Instance():set_RoomInfo(self.msg.roomInfo)
		NotificationCenter:Instance():PostNotification("UserJoinRoomMsgRes")

		
	   	-- dump(self.msg)
	   	-- dump(self.msg.m_errorCode)
	   	-- dump(self.msg.roomInfo)
	   	-- dump(self.msg.roomInfo.roomID)
	   	-- dump(self.msg.roomInfo.gameType)
	   	-- dump(self.msg.roomInfo.state)
	   	-- dump(self.msg.roomInfo.round)

end

--玩家操作请求
--actionType 			= 2;//房间内玩家操作类型 1准备 2 开始  3 抢庄  4下注  5配牛 6 解散 7 响应解散（同意或拒绝）
--betValue  actionType 3(1 抢 2 不抢) 4（1 2 3 4 5 ） 5（1 有牛 2 无牛 3 自动配牛） 7（1 同意 2 拒绝）
function ServerWS:UserActionMsgReq(actionType,betValue)
   -- local openid = cc.UserDefault:getInstance():getStringForKey("openid")
	local mas=Message_config.TYPES.MSG_C_2_S_ROOM_USER_ACTION_REQ
	local phen =self.protoPb_list[Message_config.NAMES[tonumber(mas)]]()
	phen.msg_ID=mas
	phen.actionType=actionType
	if betValue then
		phen.betValue=betValue
	end
	
	-- phen.rule.gameType=1


	local data = phen:SerializeToString()
	local data_=tostring(mas)..data  
	-- dump(data_)
    self:sendChatMsg(data_)
end
--玩家操作请求返回
--actionType 房间内玩家操作类型 1准备 2 开始  3 抢庄  4下注  5配牛 6 解散 7 响应解散（同意或拒绝
function ServerWS:UserActionMsgRes_callback()
	   	-- dump(self.msg)
	   	dump(self.msg.m_errorCode)
	   	if self.msg.m_errorCode~=0 then
	   		if self.msg.actionType==2 then
	   			Util:fun_Offlinepopwindow("请等待其他玩家准备游戏!",cc.Director:getInstance():getRunningScene())
	   			NotificationCenter:Instance():PostNotification("ZHANGYU")
	   		end

	   		if self.msg.actionType==8 then
	   			-- Util:fun_Offlinepopwindow("退出房间 ",cc.Director:getInstance():getRunningScene())
	   			NotificationCenter:Instance():PostNotification("CALLBACK_LOSE")
	   		end

	   		if self.msg.actionType==6 then
	   			NotificationCenter:Instance():PostNotification("GAMEOVERLOSE")
	   		end

	   		print("错误提示")
	   		return
	   	end
	   	dump(self.msg.actionType)
	   	dump(self.msg.zhuangPos)
	   	-- dump(self.msg.zhuangPos)
	   	-- if self.msg.actionType and self.msg.actionType==1 then
	   	-- 	NotificationCenter:Instance():PostNotification("Userzhunbei")
	   	-- 	return
	   	-- end
	   	-- dump(self.msg.m_errorCode)
	   	-- dump(self.msg.zhuangPos)
	   	LocalData:Instance():set_UserActionMsgRes(self.msg)
	   NotificationCenter:Instance():PostNotification("UserActionMsgRes")
end


--广播其他用户单条操作行为
function ServerWS:NotifyRoomUserActionMsg_callback()
   -- local openid = cc.UserDefault:getInstance():getStringForKey("openid")
	-- dump(self.msg)
	-- dump(self.msg.actionPos)
	-- dump(self.msg.zhuangPos)
	-- dump(self.msg.actionType)
	-- dump(self.msg.betValue)

	LocalData:Instance():set_NotifyRoomUserActionMsg(self.msg)
	NotificationCenter:Instance():PostNotification("NotifyRoomUserActionMsg")


end
--广播发牌信息比牌信息--所有人
function ServerWS:NotifyRoomUserCardMsg_callback()
	   	dump(self.msg.msg_ID)
	   	-- dump(self.msg.roomstate)
	   	-- dump(self.msg.userCard[1].type)--用户的牌型 牛1 牛2 ...
	   	-- dump(self.msg.userCard[1].score)--玩家倍数
	   	-- dump(self.msg.userCard[1].betValue)--下注的值
	   	-- dump(self.msg.userCard[1].result)
	   	-- dump(self.msg.usercount)
	   	-- dump(self.msg.userCard[1].pos)--房间座位位置
	   	print("------打印牛几")
	   	-- dump(self.msg.userCard[1].cards[1].coler)--用户的手牌信息
	   	-- dump(self.msg.userCard[1].type)--用户的手牌信息
	 local room=LocalData:Instance():get_RoomInfo()  
	 room.state=self.msg.roomstate	
	 LocalData:Instance():set_RoomInfo(room) 
	 
	LocalData:Instance():set_NotifyRoomUserCardMsg(self.msg)
	NotificationCenter:Instance():PostNotification("NotifyRoomUserCardMsg")
end


--广播比赛结果所有人
function ServerWS:NotifyRoomResultMsg_callback()
	   -- 	dump(self.msg.msg_ID)
	   -- 	dump(self.msg.result[1].pos)--房间座位位置
	   -- 	dump(self.msg.result[1].result)--赢1  输2
	   -- 	dump(self.msg.result[1].type)--用户的牌型 牛1 牛2 ...
	   -- 	dump(self.msg.result[1].score)--玩家倍数
	   -- 	dump(self.msg.result[1].betValue)--下注的值
	   -- dump(self.msg.round)--
	   	-- dump(self.msg.userCardInfo.)
	   	
	LocalData:Instance():set_NotifyRoomResultMsg(self.msg)
	NotificationCenter:Instance():PostNotification("NotifyRoomResultMsg")
	   
end

--返回单条玩家加入信息刷新信息
function ServerWS:NotifyRoomUserMsg_callback()
		-- dump(self.msg.m_errorCode)
		-- if  self.msg.m_errorCode ~= 0 then
		-- 	return
		-- end
		LocalData:Instance():set_NotifyRoomUserMsg(self.msg)
		NotificationCenter:Instance():PostNotification("NotifyRoomUserMsg")
	   	dump(self.msg.users[1].pos)--房间座位位置
	   	-- dump(self.msg.users[1].nike)--昵称
	   	-- dump(self.msg.users[1].head)--头像
	   	-- dump(self.msg.users[1].userIp)--用户IP
	   	-- dump(self.msg.users[1].userPort)--用户的port
	   	-- dump(self.msg.users[1].userstate)--用户的状态
end



--解散
function ServerWS:NotifyRoomDisbandMsg_callback()
		dump("章鱼 解散房间")
		LocalData:Instance():set_NotifyRoomDisbandMsg(self.msg)
		      --dump(self.msg.result)
		NotificationCenter:Instance():PostNotification("NotifyRoomDisbandMsg")

end


--大结算消息
function ServerWS:NotifyRoomAllScoreMsg_callback()
		print("大结算消息接收",self.msg.allscore[1].name)
		LocalData:Instance():set_NotifyRoomAllScoreMsg(self.msg)
		NotificationCenter:Instance():PostNotification("NotifyRoomAllScoreMsg")

end

--传入table 格式
--table={
-- 	pos=
-- 	infotype=
-- 	talkinfo=
-- 	talkurl=
--infoindex
-- }
function ServerWS:UserTalkMsg(talkinfo)
	   local mas=Message_config.TYPES.MSG_S_2_C_ROOM_USER_TALK_MSG
	local phen =self.protoPb_list[Message_config.NAMES[tonumber(mas)]]()
	phen.msg_ID=mas--消息号  1017
	phen.pos=talkinfo.pos --玩家位置
	phen.infotype=talkinfo.infotype-- 内容类型 1 打字，2 预设聊天内容 3语音
	if talkinfo.talkurl then
		phen.talkurl=talkinfo.talkurl
	end
	-- phen.talkinfo=talkinfo.talkinfo --说话内容详细信息
	--phen.talkurl=talkinfo.talkurl --语音url
	phen.infoindex=talkinfo.infoindex --预设内容index

	local data = phen:SerializeToString()
	local data_=tostring(mas)..data  
	-- dump(data_)
    self:sendChatMsg(data_,"UserTalkMsg")
end


--广播其他用户单条操作行为
function ServerWS:UserTalkMsg_callback()

	LocalData:Instance():set_UserTalkMsg(self.msg)
	NotificationCenter:Instance():PostNotification("UserTalkMsg")

end

--微信分享内容问题
function ServerWS:ShareInfoMsgRes_callback()

	---infotype  ---1 分享 2 跑马灯--活动
	
	local _table={}
	for i=1,#self.msg.m_info do
		if self.msg.m_info[i].infotype==2 then	
			_table[i]=self.msg.m_info[i].content
			-- dump(self.msg.m_info[i].content)
			LocalData:Instance():set_Marquee(self.msg.m_info[i].content)
		end

		if self.msg.m_info[i].infotype==5 then	
			_table[i]=self.msg.m_info[i].content

			radio_table_max=  radio_table_max  ..  "  "  ..    self.msg.m_info[i].content
			
			LocalData:Instance():set_Marquee_new(radio_table_max)--(self.msg.m_info[i].content)
			NotificationCenter:Instance():PostNotification("MarqueeJS")
		end

	end
	-- if self.msg.m_info[1].infotype==2 then
	-- 	LocalData:Instance():set_Marquee(self.msg.m_info[2].content)--跑马灯
	-- end
	for i=1,#self.msg.m_info do
		if self.msg.m_info[i].infotype==2 then	
			LocalData:Instance():set_Active(self.msg.m_info[i].pictureurl)--活动
		end
		if self.msg.m_info[i].infotype==2 then	
			LocalData:Instance():set_Active(self.msg.m_info[i].pictureurl)--活动
			if self.msg.m_info[i].pictureurl then
				Server:Instance():request_pic(self.msg.m_info[i].pictureurl,"zy",1)
			end
		end
		if self.msg.m_info[i].infotype==3 then	
			LocalData:Instance():set_messagetell(self.msg.m_info[i].content)--公告
		end
		if self.msg.m_info[i].infotype==4 then	
			LocalData:Instance():set_messagemess(self.msg.m_info[i].content)--消息
		end
		if self.msg.m_info[i].infotype==1 then
			LocalData:Instance():set_ShareInfoMsgRes(self.msg.m_info[i])
		end
	end

	
	
	

	NotificationCenter:Instance():PostNotification("Marquee")
	
	
	-- NotificationCenter:Instance():PostNotification("UserTalkMsg")


end
--微信分享内容问题
function ServerWS:NotifyMoneyMsg_callback()
     dump("钻石王国")
	LocalData:Instance():set_NotifyMoneyMsg(self.msg,"NotifyMoneyMsg")
	 NotificationCenter:Instance():PostNotification("NotifyMoneyMsg")


end

--  战绩
function ServerWS:HistoryResultMsgReq(_startime,_endtime)
	local mas=Message_config.TYPES.MSG_S_2_C_ZHANJI
	local phen =self.protoPb_list[Message_config.NAMES[tonumber(mas)]]()
	phen.msg_ID=mas
	phen.gameid=1
	if _startime then
		phen.startime=_startime
	end
	if _endtime then
		phen.endtime=_endtime
	end

	local data = phen:SerializeToString()
	dump(data)
	local data_=tostring(mas)..data  
	dump(data_)
    self:sendChatMsg(data_)
end
--玩家操作请求返回
--actionType 房间内玩家操作类型 1准备 2 开始  3 抢庄  4下注  5配牛 6 解散 7 响应解散（同意或拒绝
function ServerWS:HistoryResultMsgRes_callback()
	   	 -- dump(self.msg)
	   	 -- dump(json.decode(self.msg))
	   	 -- dump(self.msg[1])
	   	 --dump(self.msg)
	   	 print("哈哈哈哈哈   ")
         -- json.decode(self.msg)
	   	 --dump()
	   	 --dump(#self.msg)
	   	 dump(self.msg)
	   	-- dump(self.msg["all"])

	   	
	   	LocalData:Instance():set_HistoryResultMsgRes(self.msg)
	   NotificationCenter:Instance():PostNotification("HistoryResultMsgRes")
end



