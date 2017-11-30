--
-- Author: Your Name
-- Date: 2017-08-21 17:09:55
--  活动
local activityLayer = class("activityLayer",function()
      return cc.Layer:create()
end)

activityLayer.activityLayer = nil
function activityLayer:ctor()--
     --  消息
	 self:registerScriptHandler(function (event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        end
    end)

    activityLayer.activityLayer = self
	  self:fun_init()
end

function activityLayer:fun_init( ... )
		    local activityLayer = cc.CSLoader:createNode("csb/activityLayer.csb")
        self:addChild(activityLayer)
        
        local xiang_BG = activityLayer:getChildByName("bg")

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
        self.bg_url = xiang_BG:getChildByName("bg_url")
        self:request_pic()
end


--下载图片
function activityLayer:request_pic()
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    local url = ServerWS:Instance():getLoadpicture()
    print("url ddddd ",url)
    xhr:open("GET", url)
    xhr:registerScriptHandler(function()
        if activityLayer.activityLayer then
           activityLayer.activityLayer:on_request_finished_pic(xhr) 
        end
    end)
    xhr:send()
end

function activityLayer:on_request_finished_pic(xhr)
     local response = xhr.response
     local file_path = cc.FileUtils:getInstance():getWritablePath().."activity_ewmcode.png"
     cc.Director:getInstance():getTextureCache():removeTextureForKey(file_path)  
     local remove = os.remove(file_path)
     print("rm_filerm_filerm_filerm_file ",remove)
     local file = io.open(file_path, "w+")
     if file then
        if file:write(response) == nil then
            print("can not save file")
            return false
        end
        io.flush()
        file:flush()
        io.close(file)
        self.bg_url:loadTexture(cc.FileUtils:getInstance():getWritablePath().."activity_ewmcode.png")
        self.bg_url:setContentSize(cc.size(1300, 750))
     end
end


--刷新活动
function activityLayer:fun_ref_all_head(head,dex)
      if not head then
        return
      end
      -- Server:Instance():request_pic(head,"messageactivity",dex)
end
function activityLayer:onEnter()
       NotificationCenter:Instance():AddObserver("messageactivity", self, function(target, data) --下载图片
           local _url=LocalData:Instance():get_Active()
            if _url then
              -- self.bg_url:loadTexture(Util:sub_str(_url))
              -- self.bg_url:setContentSize(cc.size(1300, 750))
            end           
       end)
end

function activityLayer:onExit()
    
    NotificationCenter:Instance():RemoveObserver("messageactivity", self)
end



     return activityLayer