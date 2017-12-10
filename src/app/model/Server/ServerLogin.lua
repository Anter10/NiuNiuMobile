


--------心跳--------
local firsthasnotinternet = false

function ServerWS:ClientTickMsg()

    local mas=Message_config.TYPES.MSG_C_CLIENT_TICK
    local phen =message_pb.ClientTickMsg()
    phen.msg_ID=mas
    local data = phen:SerializeToString()
    local data_=tostring(mas)..data
    if not hasInternet() then
       self:fun_Offlinepopwindow( "网络连接断开，请检查网络后再试!" ) 
    else
       Tools.hasnet = false
    end
    ServerWS:Instance():sendChatMsg(data_,"ClientTickMsg", true)
end

--登陆请求
function ServerWS:UserLoginMsgReq(logintype)
    local mas=Message_config.TYPES.MSG_C_2_L_LOGIN_REQ
    local phen =message_pb.UserLoginMsgReq()
    phen.msg_ID=mas
        --cc.UserDefault:getInstance():setIntegerForKey("openID_y",0)
    local y_openid=cc.UserDefault:getInstance():getIntegerForKey("openID_y",0)
 
    local openid=cc.UserDefault:getInstance():getStringForKey("openid","-1")
    local wechattoken=cc.UserDefault:getInstance():getStringForKey("accessToken","-1")
    local nick=cc.UserDefault:getInstance():getStringForKey("name","-1")
    local head=cc.UserDefault:getInstance():getStringForKey("iconurl","-1")
    local sex=1 
    if cc.UserDefault:getInstance():getStringForKey("gender","男")=="女" then
        sex=2
    end
    print("我也打印一下·",nick,sex,y_openid,head)
    phen.openID=y_openid
    phen.wechatID= openid
    phen.wechattoken=wechattoken
    phen.logintype=logintype
    phen.nick=nick
    phen.head=head
    phen.sex=sex
    phen.gameID=1
    -- print("data = UserLoginMsgReqUserLoginMsgReqUserLoginMsgReq ",type(phen),json.encode)
    local data = phen:SerializeToString()
    local data_=tostring(mas)..data  
    return ServerWS:Instance():sendChatMsg(data_)
end


function ServerWS:UserLoginMsgRes_callback()
        dump(self.msg.m_errorCode)
        if  self.msg.m_errorCode ~= 0 then
            return
        end
        if cc.UserDefault:getInstance():getIntegerForKey("openID_y",0)==0 then
            cc.UserDefault:getInstance():setIntegerForKey("openID_y",self.msg.openID)
        end
        dump(self.msg.head)
        dump(self.msg.nick)
        dump(self.msg.openID)

        print("登陆返回的数据  ",json.encode(decodeMsgData(self.msg)))
        LocalData:Instance():set_NotifyMoneyMsg(nil)
        LocalData:Instance():set_loading(self.msg)
end


--登录验证返回
function ServerWS:ClientLoginMsgReq()
   -- local openid = cc.UserDefault:getInstance():getStringForKey("openid")
    local mas=Message_config.TYPES.MSG_C_2_S_LOGIN_REQ
    local phen =message_pb.ClientLoginMsgReq()
    phen.msg_ID=Message_config.TYPES.MSG_C_2_S_LOGIN_REQ

    local msg_data=LocalData:Instance():get_loading()

    phen.openID=msg_data.openID
    phen.m_seed=msg_data.token

    local data = phen:SerializeToString()
    local data_=tostring(mas)..data  
    dump(data_)
    self:sendChatMsg(data_)
end

function ServerWS:ClientLoginMsgRes_callback()
        print("连接ClientLoginMsgRes登陆服务器错误------",self.msg.m_errorCode)
        self.show_close_tip=true
        if  self.msg.m_errorCode ~= 0 then
            
            self:fun_Offlinepopwindow( "服务器断开链接，请重新链接！")
            return
        end

        local msg_data=LocalData:Instance():get_loading()
        dump(msg_data.m_gatePort)
        

        NotificationCenter:Instance():PostNotification("loading")

        
end


