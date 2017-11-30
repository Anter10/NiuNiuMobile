--
-- Author: admin
-- Date: 2017-08-03 11:25:07
--
function LocalData:set_loading(load_info)
   	self.load_info=load_info
end

function LocalData:get_loading()
   	return self.load_info or nil
end





function LocalData:set_CreateRoom(CreateRoom)
   	self.CreateRoom=CreateRoom
end

function LocalData:get_CreateRoom()
   	return self.CreateRoom or nil
end



function LocalData:set_UserJoinRoomMsgRes(user_join_info)
   	self.user_join_info=user_join_info
end

function LocalData:get_UserJoinRoomMsgRes()
   	return self.user_join_info or nil
end


function LocalData:set_NotifyRoomUserMsg(Notify)
   	self.Notify=Notify
end

function LocalData:get_NotifyRoomUserMsg()
   	return self.Notify or nil
end

function LocalData:set_NotifyRoomUserActionMsg(ActionMsg)
   	self.ActionMsg=ActionMsg
end

function LocalData:get_NotifyRoomUserActionMsg()
   	return self.ActionMsg or nil
end


function LocalData:set_NotifyRoomUserCardMsg(CardMsg)
      self.CardMsg=CardMsg
end

function LocalData:get_NotifyRoomUserCardMsg()
      return self.CardMsg or nil
end

function LocalData:set_UserActionMsgRes(UserActionMsgRes)
      self.UserActionMsgRes=UserActionMsgRes
end

function LocalData:get_UserActionMsgRes()
      return self.UserActionMsgRes or nil
end


function LocalData:set_NotifyRoomResultMsg(NotifyRoomResultMsg)
      self.NotifyRoomResultMsg=NotifyRoomResultMsg
end

function LocalData:get_NotifyRoomResultMsg()
      return self.NotifyRoomResultMsg or nil
end

function LocalData:set_NotifyRoomDisbandMsg(NotifyRoomDisbandMsg)
      self.NotifyRoomDisbandMsg=NotifyRoomDisbandMsg
end

function LocalData:get_NotifyRoomDisbandMsg()
      return self.NotifyRoomDisbandMsg or nil
end


function LocalData:set_RoomInfo(RoomInfo)
      self.RoomInfo=RoomInfo
end

function LocalData:get_RoomInfo()
      return self.RoomInfo or nil
end

--记录房主解散房间是否已经开始

function LocalData:set_Room_Start(Room_Start)
      self.Room_Start=Room_Start
end

function LocalData:get_Room_Start()
      return self.Room_Start or nil
end


function LocalData:set_Room_round(Room_round)
      self.Room_round=Room_round
end

function LocalData:get_Room_round()
      return self.Room_round or  nil
end

function LocalData:set_is_myhouse(is_myhouse)
      dump(is_myhouse)
      self.is_myhouse=is_myhouse
end

function LocalData:get_is_myhouse()
         dump(self.is_myhouse)
      return self.is_myhouse 
end

function LocalData:set_is_myzhang(myzhang)
      self.myzhang=myzhang
end

function LocalData:get_is_myzhang()
      return self.myzhang or false
end



--  音效
function LocalData:set_sound(_music)

   cc.UserDefault:getInstance():setBoolForKey("music" ,_music)
end

function LocalData:get_sound()
   local _music=cc.UserDefault:getInstance():getBoolForKey("music",true)
   return _music 
end

--  音乐
function LocalData:set_music_hit(music_hit)
   cc.UserDefault:getInstance():setBoolForKey("music_hit" ,music_hit)
end

function LocalData:get_music_hit()
   local _music_hit=cc.UserDefault:getInstance():getBoolForKey("music_hit",true)
   return _music_hit 
end


--  大结算数据保存
function LocalData:set_NotifyRoomAllScoreMsg(NotifyRoomAllScoreMsg)
   self.NotifyRoomAllScoreMsg=NotifyRoomAllScoreMsg
end

function LocalData:get_NotifyRoomAllScoreMsg()
   return self.NotifyRoomAllScoreMsg or nil
end

--  战绩
function LocalData:set_HistoryResultMsgRes(_HistoryResultMsgRes)
   self._HistoryResultMsgRes=_HistoryResultMsgRes
end

function LocalData:get_HistoryResultMsgRes()
   return self._HistoryResultMsgRes or nil
end


function LocalData:set_UserTalkMsg(UserTalkMsg)
   self.UserTalkMsg=UserTalkMsg
end

function LocalData:get_UserTalkMsg()
   return self.UserTalkMsg or nil
end

--分享内容
function LocalData:set_ShareInfoMsgRes(ShareInfoMsgRes)
   self.ShareInfoMsgRes=ShareInfoMsgRes
end

function LocalData:get_ShareInfoMsgRes()
   return self.ShareInfoMsgRes or nil
end


--跑马灯----
function LocalData:set_Marquee(Marquee)
   self.Marquee=Marquee
end

function LocalData:get_Marquee()
   return self.Marquee or nil
end

function LocalData:set_Marquee_new(Marqueenew)
   self.Marqueenew=Marqueenew
end

function LocalData:get_Marquee_new()
   return self.Marqueenew or nil
end

--活动
function LocalData:set_Active(Active)
   self.Active=Active
end
function LocalData:get_Active()
   return self.Active or nil
end
--公告----
function LocalData:set_messagetell(messagetell)
   self.messagetell=messagetell
end

function LocalData:get_messagetell()
   return self.messagetell or nil
end
--消息----
function LocalData:set_messagemess(messagemess)
   self.messagemess=messagemess
end

function LocalData:get_messagemess()
   return self.messagemess or nil
end
--  开关
function LocalData:set_Gameswitch(_witch)
      self._witch=_witch
end

function LocalData:get_Gameswitch()
       if device.platform=="android" then
          self._witch=1
       end
      return self._witch or 1
end
--  钻石
function LocalData:set_NotifyMoneyMsg(diamond)
      self.diamond=diamond
end

function LocalData:get_NotifyMoneyMsg()
      return self.diamond or nil
end


--  钻石
function LocalData:set_Share_RoomID()
   cc.UserDefault:getInstance():setStringForKey("Share_RoomID","-1")
end

function LocalData:get_Share_RoomID()
      local share_id=cc.UserDefault:getInstance():getStringForKey("Share_RoomID","-1")
      dump(share_id)
      if share_id=="-1" then
         return nil
      end
      
      return string.sub(share_id,-6,-1)
end






