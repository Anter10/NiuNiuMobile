ServerWS = {}
--{}

require 'src/app/protobuf/message_pb'
-- require 'app.views.person_pb'




local sconde_time_tag=0
local sconde_time_tag_num=0
function ServerWS:new(o)
	o = o or {}
	setmetatable(o,self)
	self.__index = self
	return o
end

function ServerWS:Instance()
	if self.instance == nil then
		self.instance = self:new()
		self.sconde_time=0
		self._zy_socket=1
		self.protoPb_list = {}
		self.schedulerID=nil
		
		-- self.url = "ws://192.168.1.145:8003"
		-- self.url = "ws://127.0.0.1:8282"
		--self.instance.url = "ws://192.168.170.98:8282"
		--self.instance.url= "ws://192.168.170.23:8282"
		self.show_close_tip = false
		self.check_tip=false
	    --self.url = "ws://192.168.1.145:5001"---内侧服
		self.url = "ws://101.201.117.64:5001"--外服侧服
		self.delaytip=true
		self.msg_id=nil
		self.timediff = 0
		self:fun_pb()
	end
	return self.instance
end


function ServerWS:fun_pb()
   local pb_item = _G["message_pb"]
--将所有的proto里的字段都拼接到一起 通过messageid获取
	for field_key,pb_item_field in pairs(pb_item) do
		-- print("----",field_key,pb_item_field)
		self.protoPb_list[field_key] = pb_item_field
	end

end


function ServerWS:setUrl(url)
   self.url = url
end

function ServerWS:connect(sconed_url)
	
	dump(self.url)
	self.show_close_tip = true
	if sconed_url then
		self.socket = cc.WebSocket:create(sconed_url)
	else
			self.socket = cc.WebSocket:create(self.url)
	end
	

	local function wsSendBinaryOpen(strData)
            print("Binary  wsSendBinaryOpen.")
            self:onOpen()
    end

    local function wsSendBinaryMessage(strData)
		self:onMessage(strData)
    end

    local function wsSendBinaryClose(strData)
        print("_wsiSendBinary websocket instance closed.")
        self:onClose(strData)
    end

    local function wsSendBinaryError(strData)
        self._zy_socket=1
 		print("&&&&&&&&&&&&& 网络错误 wsSendBinaryError")
    end
    
	self.socket:registerScriptHandler(wsSendBinaryOpen,cc.WEBSOCKET_OPEN)
	self.socket:registerScriptHandler(wsSendBinaryMessage,cc.WEBSOCKET_MESSAGE)
	self.socket:registerScriptHandler(wsSendBinaryClose,cc.WEBSOCKET_CLOSE)
	self.socket:registerScriptHandler(wsSendBinaryError,cc.WEBSOCKET_ERROR)


end




function ServerWS:close()
   if (self.socket) then
	  self.show_close_tip = false
	  self.socket:close()
	  -- self.socket:closeAllConnections()
   end
end

function ServerWS:onOpen()
   print("&&&&&&&&&&&&& ··提示连接成功· onOpen",self.check_tip)
   dump(self.check_tip)
   if self.check_tip then --服务器登陆返回 -启动登陆验证
   		self.check_tip=false
   		self:ClientLoginMsgReq()
   end
   -- 提示连接成功
   -- NotificationCenter:Instance():PostNotification("SOCKET_LINKED", nil)
end

function ServerWS:onMessage(strData)
	--标注前四个为消息号，截取读取
	-- dump(strData)
	--self.sconde_time=0 
	self.delaytip=true
	--self:close_update()

	cc.Director:getInstance():getRunningScene():stopAllActions()
	cc.Director:getInstance():getRunningScene():removeChildByTag(999999, true)
	local msg_n=string.sub(strData,1,4)  
	if tonumber(msg_n)  ==  1001 then
		self.sconde_time=0
		dump("1001-------")
		return
	end
	if tonumber(msg_n)  ==  1020 then
        print("章鱼互动")
        local command=Message_config.NAMES[tonumber(msg_n)]
        --dump(strData)
        local msg_data= string.sub(strData,13,string.len(strData))
        dump(msg_data)
         --local msg_data=json.decode(msg_data)
        self.msg=json.decode(msg_data)
        local callback = loadstring("ServerWS:Instance():" .. command .. "_callback()")
		callback()
		return
	end
	dump(msg_n)
	--print("章鱼互动3")
    local msg_data= string.sub(strData,5,string.len(strData))
    dump(msg_data)
    -- print("章鱼互动1")
 	local command=Message_config.NAMES[tonumber(msg_n)]
		
	self.msg_id=tonumber(msg_n)--记录消息号
	local msg =self.protoPb_list[Message_config.NAMES[tonumber(msg_n)]]()
	
    msg:ParseFromString(msg_data)
    dump(command)
    -- print("章鱼互动2")
   
	self.msg=msg
	-- dump(self.msg)
	dump(self.msg.m_errorCode)
	local callback = loadstring("ServerWS:Instance():" .. command .. "_callback()")
	callback()
end


function ServerWS:onClose(event)
	
	dump(self.msg_id)
	self.websocket = nil

	if self.msg_id==Message_config.TYPES.MSG_L_2_C_LOGIN_RES then --服务器登陆返回 -启动登陆验证
		self.msg_id=nil
		 print("·网络请求错误呢··")
		local msg=LocalData:Instance():get_loading()

   		-- self:setUrl("ws://"..msg.m_gateIp..":"..tostring(msg.m_gatePort))
   		self.check_tip = true
   		local sconed_url="ws://"..msg.m_gateIp..":"..tostring(msg.m_gatePort)
    	self:connect(sconed_url)--连接服务器
    	self.show_close_tip=false
    	return
   end
   --self:close_update()
   self.delaytip=true
   dump(self.show_close_tip)
   dump(self._zy_socket)
   if self.show_close_tip and self._zy_socket==1  then

   	  dump("游戏章鱼000")
   	  --self:close_update()
   	  --self:backOnLine()
   	  self.show_close_tip=false
   end
  	cc.Director:getInstance():getRunningScene():removeChildByTag(999999, true)

	
	-- print("&&&&&&&&&&&&& ··· onClose", event)
	-- self.socket = nil
	-- if (self.show_close_tip) then
	--    display.getRunningScene():socket_off_line_dia({text = "服务器断开链接，请重新链接！", type = true})
	-- end
end

function ServerWS:onError(event)
	dump(event)
	print("&&&&&&&&&&&&& ··· onError")
end

function ServerWS:backOnLine()
	self:fun_Offlinepopwindow( "网络不稳定,已与游戏服务器断开,请重新连接。")
   	LocalData:Instance():close_sched()
end


function ServerWS:Destory()
   self.socket = nil
end

function ServerWS:isReady()
   return self.socket ~= nil and self.socket:isReady()
end


function ServerWS:sendChatMsg(package,status)

	self.socket:sendString(package)
    
	print("走了没-----")
	-- if status and (status=="UserCreateRoomMsgReq" or status=="UserJoinRoomMsgReq" or status=="UserLoginMsgReq") then
	-- 	Util:fun_loadbar(cc.Director:getInstance():getRunningScene(),999999) 
	-- end
	-- dump(status)
	if not status or status~="ClientTickMsg"  then
		print("走了没----rrr-")
		cc.Director:getInstance():getRunningScene():runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(function()
                      
                                        Util:fun_loadbar(cc.Director:getInstance():getRunningScene(),999999) 

                            end)))
		if 1 then
			return
		end
		self.delaytip=false
		self:open_update()
		cc.Director:getInstance():getRunningScene():stopAllActions()
		cc.Director:getInstance():getRunningScene():runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(function()
											
                                    		Util:fun_loadbar(cc.Director:getInstance():getRunningScene(),999999) 

                            end)))

	end	   
end



function ServerWS:fun_Offlinepopwindow( popup_text )
	    self._zy_socket=0
        cc.Director:getInstance():getRunningScene():removeChildByTag(300)
        local Offlinepopwindow = cc.CSLoader:createNode("csb/Offlinepopwindow.csb")
        cc.Director:getInstance():getRunningScene():addChild(Offlinepopwindow,300,300)

        local Offlpop_bt=Offlinepopwindow:getChildByName("bg"):getChildByName("Offlpop_bt")
        local Offlpop_text=Offlinepopwindow:getChildByName("bg"):getChildByName("Offlpop_text")
        Offlpop_text:setString(popup_text)
        Offlpop_text:setTextHorizontalAlignment(1)
        Offlpop_text:setTextVerticalAlignment(0)
        Offlpop_text:ignoreContentAdaptWithSize(false); 
        Offlpop_text:setSize(cc.size(700, 200))
        dump("游戏章鱼1")
        Offlpop_bt:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                          return
                   end
                   --self._zy_socket=1
                   dump("游戏章鱼")
                 Offlinepopwindow:setVisible(false)
                 --self:open_update()
                 
                  --cc.Director:getInstance():getRunningScene():removeChildByTag(300)
                 --cc.Director:getInstance():getRunningScene():removeAllChildren()
                 -- ServerWS:Instance():setUrl("ws://101.201.117.64:5001")
                 local lo=require("app.views.loadScene").new()
                 dump(lo._lo)
                 -- if lo._lo==0 then
                 -- 	return
                 -- end
                 cc.Director:getInstance():getRunningScene():addChild(lo)
                 
        end)

end





function ServerWS:open_update()
  if self.schedulerID then
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    self.schedulerID=nil
  end
  local scheduler = cc.Director:getInstance():getScheduler()  
 
    self.schedulerID = scheduler:scheduleScriptFunc(function()  
       self:update() 
    end,1,false)   

end

function ServerWS:close_update()
  if self.schedulerID then
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    self.schedulerID=nil
  end
   
  
end



function ServerWS:update()
       self.sconde_time=self.sconde_time+1
      if self.sconde_time > 5 then
      	Util:fun_loadbar(cc.Director:getInstance():getRunningScene(),999999)
      end
      if self.sconde_time < 10 then return end
      cc.Director:getInstance():getRunningScene():removeChildByTag(999999, true)
       self.sconde_time=0 
       self:close_update()
         dump("心跳返回")
     	 self:backOnLine()  
end





require("app.model.Server.ServerLogin")
require("app.model.Server.ServerGame")


