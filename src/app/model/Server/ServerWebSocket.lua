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
		self.url = "ws://101.201.79.146:5001"--外服侧服

    self.url = "ws://101.201.117.64:5001"--外服侧服
		self.delaytip=true
		self.msg_id=nil
		self.timediff = 0
		self:fun_pb()
    self.showdiscon = false
	end
  self.showdiscon = false
	return self.instance
end


function ServerWS:fun_pb()
   local pb_item = _G["message_pb"]
--将所有的proto里的字段都拼接到一起 通过messageid获取
	for field_key,pb_item_field in pairs(pb_item) do
	    print("当前的信息  =  ",field_key,pb_item_field)
		  self.protoPb_list[field_key] = pb_item_field
	end

end


function ServerWS:setUrl(url)
   self.url = url
end

function ServerWS:connect(sconed_url)
	self.show_close_tip = true
	if sconed_url then
		 self.socket = cc.WebSocket:create(sconed_url)
	else
	   self.socket = cc.WebSocket:create(self.url)
	end

	local function onOpen(strData)
        self:onOpen()
        print("Socket网络链接已经打开")
  end
  local function onMessage(strData)
        self:onMessage(strData)
  end

  local function onClose(strData)
        self:onClose(strData)
        -- if not hasInternet() then
        --    self:fun_Offlinepopwindow( "网络连接断开，请检查网络后再试!" ) 
        -- end
        printError("Socket网络链接已经关闭")
  end

  local function onError(strData)
        self._zy_socket=1
 		    print("发送错误")
        -- self:fun_Offlinepopwindow( "网络连接断开，，请检查网络后再试!" ) 
  end
    
	self.socket:registerScriptHandler(onOpen,cc.WEBSOCKET_OPEN)
	self.socket:registerScriptHandler(onMessage,cc.WEBSOCKET_MESSAGE)
	self.socket:registerScriptHandler(onClose,cc.WEBSOCKET_CLOSE)
	self.socket:registerScriptHandler(onError,cc.WEBSOCKET_ERROR)


end

 
function ServerWS:close()
   if self.socket then
  	  self.show_close_tip = false
  	  self.socket:close()
   end
end

function ServerWS:onOpen()
   if self.check_tip then --服务器登陆返回 -启动登陆验证
   		self.check_tip=false
   		self:ClientLoginMsgReq()
   end
end

function ServerWS:onMessage(strData)
      	--标注前四个为消息号，截取读取
      	self.delaytip = true

      	cc.Director:getInstance():getRunningScene():stopAllActions()
      	self:removeloadBar()

      	local messageId = string.sub(strData,1,4)  
      	if tonumber(messageId)  ==  1001 then
      	   self.sconde_time = 0
      	   return
      	end

      	if tonumber(messageId)  ==  1020 then
           local command = Message_config.NAMES[tonumber(messageId)]
           local msg_data = string.sub(strData,13,string.len(strData))
           self.msg = json.decode(msg_data)
           local callback = loadstring("ServerWS:Instance():" .. command .. "_callback()")
           callback()
           return             
      	end

        local msg_data = string.sub(strData,5,string.len(strData))
       	local command = Message_config.NAMES[tonumber(messageId)]
      	self.msg_id = tonumber(messageId)--记录消息号
        local msg = self.protoPb_list[Message_config.NAMES[tonumber(messageId)]]()
      	msg:ParseFromString(msg_data)
        
        self.msg = msg
        
        print("消息号 = "..messageId.."__________________________________ 返回的数据信息 = __________________________________ ",json.encode(decodeMsgData(self.msg)))
        -- 调用方法
        local callback = loadstring("ServerWS:Instance():" .. command .. "_callback()")
        callback()
end


function ServerWS:onClose(event)
  	self.websocket = nil
    self:removeloadBar()
    if self.msg_id==Message_config.TYPES.MSG_L_2_C_LOGIN_RES then --服务器登陆返回 -启动登陆验证
  	 	 self.msg_id=nil
  		 local msg=LocalData:Instance():get_loading()
       self.check_tip = true
     	 local sconed_url="ws://"..msg.m_gateIp..":"..tostring(msg.m_gatePort)
       self:connect(sconed_url)--连接服务器
       self.show_close_tip=false
       return
    end
    self.delaytip= true
    if self.show_close_tip and self._zy_socket==1  then
     	 self.show_close_tip=false
    end
   
end

function ServerWS:onError(event)
	dump(event)
	print("&&&&&&&&&&&&& ··· onError")
end

function ServerWS:backOnLine()
	 self:fun_Offlinepopwindow( "网络不稳定,已与游戏服务器断开,请重新连接。")
   	LocalData:Instance():close_sched()
end


function ServerWS:removeloadBar()
     if self.loadbar then
        print("当前的自动引用计数是多少 = ",self.loadbar:getReferenceCount())
        self.loadbar:removeFromParent(true)
        self.loadbar = nil
     end
end

function ServerWS:fun_loadbar(_obj,_tag )
     -- printError("当前的那儿转圈的")
     -- self.loadbar = cc.CSLoader:createNode("csb/loadbar.csb")
     -- cc.Director:getInstance():getRunningScene():addChild(self.loadbar,_tag,_tag)
     -- -- self.loadbar:addChild(require("src.app.layers.touchlayer").create(), -1)
     -- self.loadbar_act = cc.CSLoader:createTimeline("csb/loadbar.csb")
     -- self.loadbar:runAction(self.loadbar_act)
     -- self.loadbar_act:gotoFrameAndPlay(0,46, true)   
end


function ServerWS:Destory()
   self.socket = nil
end

function ServerWS:isReady()
   return self.socket ~= nil and self.socket:isReady()
end


function ServerWS:sendChatMsg(package,status, noprint)
  if not noprint then
     printError("那儿发送的数据")
  end
   
  if not status or status~="ClientTickMsg"  then
     if not self.loadbar then
        self:fun_loadbar(cc.Director:getInstance():getRunningScene(),999999) 
     end
  end 
  
  print(hasInternet(), "当前的状态= ",self.socket:getReadyState())
  if (not hasInternet() or self.socket:getReadyState() == 0) and not noprint then
     self:fun_Offlinepopwindow( "网络连接异常，请检查网络后再试!" )
  elseif (not hasInternet() or self.socket:getReadyState() == 3 or self.socket:getReadyState() == 2) and not noprint then
     self:fun_Offlinepopwindow( "网络连接断开，请检查网络后再试!" ) 
  else
     if self.socket:getReadyState() == 1 then
        self:removeBoomFrame()
     end
     self.socket:sendString(package)
  end
  
  return self.socket:getReadyState()
end

function ServerWS:removeBoomFrame()
   -- if self.Offlinepopwindow then
   
   --    self.Offlinepopwindow:removeFromParent(true)
   --    self.Offlinepopwindow = nil
   -- end
   self:setShows(false)
end

function ServerWS:setShows(ff)
    Tools.hasnet = ff
    print(ff)
    printError("什么意思啊啊 啊啊啊啊dddds  ")
end

function ServerWS:fun_Offlinepopwindow( popup_text )
         print("self.showdiscon = ",self.showdiscon)
         if not Tools.hasnet then
    	      self._zy_socket=0
            cc.Director:getInstance():getRunningScene():removeChildByTag(300)
            Tools.hasnet = true

            local Offlinepopwindow = cc.CSLoader:createNode("csb/Offlinepopwindow.csb")
            Offlinepopwindow:addChild(require("src.app.layers.touchlayer").create(), -1)
            cc.Director:getInstance():getRunningScene():addChild(Offlinepopwindow,999999300,999300)
            
            local Offlpop_bt = Offlinepopwindow:getChildByName("bg"):getChildByName("Offlpop_bt")
            local Offlpop_text = Offlinepopwindow:getChildByName("bg"):getChildByName("Offlpop_text")
            Offlpop_text:setString(popup_text)
            Offlpop_text:setTextHorizontalAlignment(1)
            Offlpop_text:setTextVerticalAlignment(0)
            Offlpop_text:ignoreContentAdaptWithSize(false); 
            Offlpop_text:setSize(cc.size(700, 200))

            Offlpop_bt:addTouchEventListener(function(sender, eventType  )
                Tools.hasnet = false
                 if eventType == ccui.TouchEventType.ended then  
                    
                    print("当前的网络异常错误eee",self.showdiscon)
                    if self.socket:getReadyState() ~= 1 then
                       ServerWS:Instance():connect()
                    end
                    if cc.Director:getInstance():getRunningScene() then
                       cc.Director:getInstance():replaceScene(require("src.app.views.loadScene").new())
                    end 
                end 
            end)
        end

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
      -- self.sconde_time=self.sconde_time+1
      -- if self.sconde_time > 5 then
      -- 	 Util:fun_loadbar(cc.Director:getInstance():getRunningScene(),999999)
      -- end
      -- if self.sconde_time < 10 then 
      --    return 
      -- end
      -- cc.Director:getInstance():getRunningScene():removeChildByTag(999999, true)
      -- self.sconde_time=0 
      -- self:close_update()
      -- dump("心跳返回")
      -- self:backOnLine()  
end





require("app.model.Server.ServerLogin")
require("app.model.Server.ServerGame")


