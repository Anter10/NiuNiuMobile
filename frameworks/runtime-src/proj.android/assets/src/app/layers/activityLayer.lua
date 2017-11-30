--
-- Author: Your Name
-- Date: 2017-08-21 17:09:55
--  活动
local activityLayer = class("activityLayer",function()
      return cc.Layer:create()
end)

function activityLayer:ctor()--
     --  消息
	 self:registerScriptHandler(function (event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        end
    end)

   
	  self:fun_init()
end
function activityLayer:fun_init( ... )
		    local activityLayer = cc.CSLoader:createNode("csb/activityLayer.csb")
        self:addChild(activityLayer)
        xiang_BG=activityLayer:getChildByName("bg")

        --  返回
        local back=xiang_BG:getChildByName("back")
        back:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                   print("返回")
                   Util:all_layer_Sound("Audio_Button_Click")
                   self:removeFromParent()
        end)
        local _url=LocalData:Instance():get_Active()
        dump(_url)
        self.bg_url=xiang_BG:getChildByName("bg_url")
        if _url then
          self.bg_url:loadTexture(Util:sub_str(_url))
        end
        
        self:fun_ref_all_head(_url,1)
        --dump(Util:sub_str("http://texas-cdn.oss-cn-beijing.aliyuncs.com/web/niuniu.png"))
        
end
--刷新活动
function activityLayer:fun_ref_all_head(head,dex)
      
  if not head then
    return
  end
  
   Server:Instance():request_pic(head,"messageactivity",dex)
     
end
function activityLayer:onEnter()
       NotificationCenter:Instance():AddObserver("messageactivity", self, function(target, data) --下载图片
                           
                            local _url=LocalData:Instance():get_Active()
                            if _url then
                              self.bg_url:loadTexture(Util:sub_str(_url))
                            end
                            
                      end)

      
end

function activityLayer:onExit()
    
    NotificationCenter:Instance():RemoveObserver("messageactivity", self)
end



     return activityLayer