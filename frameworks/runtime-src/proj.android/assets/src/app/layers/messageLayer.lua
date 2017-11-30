--
-- Author: Your Name
-- Date: 2017-08-09 11:17:29
--
--消息通知
local messageLayer = class("messageLayer",function()
      return cc.Layer:create()
end)

function messageLayer:ctor()--
	  self._message_tell_text=LocalData:Instance():get_messagetell()
	  self._message_mess_text=LocalData:Instance():get_messagemess()
	  self:fun_init()
    
end
function messageLayer:fun_init( ... )
		self.Message = cc.CSLoader:createNode("csb/Message.csb")
        self:addChild(self.Message)
        self.message_BG=self.Message:getChildByName("message_BG")

        self.message_txt=self.message_BG:getChildByName("message_txt")
        self.message_txt:setVisible(true)
        self.message_mess_text=self.message_BG:getChildByName("message_mess_text")
    		self.message_tell_text=self.message_BG:getChildByName("message_tell_text")
    		self.message_mess_text:setVisible(false)
    		self.message_tell_text:setVisible(true)
        self.message_tell_text:setString(self._message_tell_text)
        --  对齐方式
        self.message_mess_text:setTextHorizontalAlignment(0)
        self.message_mess_text:setTextVerticalAlignment(0)
        self.message_mess_text:ignoreContentAdaptWithSize(false); 
        self.message_mess_text:setSize(cc.size(1349.99, 650))

        self.message_tell_text:setTextHorizontalAlignment(0)
        self.message_tell_text:setTextVerticalAlignment(0)
        self.message_tell_text:ignoreContentAdaptWithSize(false); 
        self.message_tell_text:setSize(cc.size(1349.99, 650))


		    self:fun_touch()

end
function messageLayer:fun_touch( ... )
	--  messageLayer
        local message_back=self.message_BG:getChildByName("message_back")
        message_back:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  Util:all_layer_Sound("Audio_Button_Click")
                   self:removeFromParent()
        end)
        --  公告
        local message_tell=self.message_BG:getChildByName("message_tell")
        message_tell:setBright(false)
       self.curr_bright=message_tell

        message_tell:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  self:touch_btCallback(sender, eventType)
                   
        end)
        --  消息
        local message_mess=self.message_BG:getChildByName("message_mess")
        message_mess:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  self:touch_btCallback(sender, eventType)
                   
        end)
end

function messageLayer:touch_btCallback( sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                return
            end
            Util:all_layer_Sound("Audio_Button_Click")
            touch_name=sender:getName()
            if self.curr_bright:getName()==touch_name then
                  return
            end
            self.curr_bright:setBright(true)
            sender:setBright(false)

            if touch_name=="message_tell" then
              self.message_txt:setString("健康游戏公告")
              self.message_txt:setVisible(true)
              self.message_mess_text:setVisible(false)
              self.message_tell_text:setVisible(true)
              self.message_tell_text:setString(self._message_tell_text)
 
            elseif touch_name=="message_mess" then
              self.message_txt:setString("健康游戏消息")
              self.message_txt:setVisible(false)
              self.message_mess_text:setVisible(true)
              self.message_tell_text:setVisible(false)
              self.message_mess_text:setString(self._message_mess_text)

            end
            self.curr_bright=sender
 end

return messageLayer