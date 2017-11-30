

-- 二维码绑定界面

local WeChatLink = class("WeChatLink", require("src.app.layers.touchlayer"))

WeChatLink.weChatLink = nil

function WeChatLink:ctor()
	self.super.ctor(self)
	self:addChild(require("src.app.layers.touchlayer").create(), -1)
	WeChatLink.weChatLink = self
    self.layer = cc.CSLoader:createNode("csb/WXBDChatView.csb")
    ccui.Helper:doLayout(self.layer)
    self:addChild(self.layer)
    self.bottom = self.layer:getChildByName("bottom")

    if device.model == "ipad retina" or device.model == "ipad" then
       self.layer:setAnchorPoint(cc.p(0.5,0.5))
       self.layer:setPositionX(display.cx)
       self.layer:setPositionY(display.cy)
       self.bottom:setScale(0.85)
    end
    -- 关闭
    local function closeCallBack()
       WeChatLink.weChatLink:removeFromParent()
       WeChatLink.weChatLink = nil
    end
    qq.tools.button(self.bottom, "close", closeCallBack, true) 
    self:request_pic()
end


--下载图片

function WeChatLink:request_pic()
    -- self.pic_url=url
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    local msg = LocalData:Instance():get_loading()
    local tdata = {}
    tdata.account_id = msg.openID
    xhr:open("GET", Tools.Channel().sharecodeurl..tdata.account_id)
    xhr:registerScriptHandler(function()
        if WeChatLink.weChatLink then
           WeChatLink.weChatLink:on_request_finished_pic(xhr) 
        end
    end)
    xhr:send()
end


function WeChatLink:on_request_finished_pic(xhr)
     local response = xhr.response
     local file_path = cc.FileUtils:getInstance():getWritablePath().."player_ewmcode.png"
     -- dump(file_path)
     local file = io.open(file_path, "w+b")
     if file then
        if file:write(response) == nil then
        -- self:show_error("can not save file : " .. file_path)
            print("can not save file")
            return false
        end

        io.close(file)

        local sprite = cc.Sprite:create(cc.FileUtils:getInstance():getWritablePath().."player_ewmcode.png")
        local size = 387 / 123
        sprite:setScale(size)
        self.ex, self.ey = self.bottom:getChildByName("ewm"):getPosition()
        sprite:setPosition(cc.p(self.ex, self.ey))
        self.bottom:addChild(sprite)
        
        qq.tools.button(self.bottom, "share", function()
	        self:shareEWM()
	    end, true) 
     end
end
 

function WeChatLink:shareEWM()
	 local function afterCaptured(succeed, outputFile)
         if succeed then
            print("outputFile == ",outputFile)
            self.bottom:getChildByName("close"):setVisible(true)
            self.bottom:getChildByName("share"):setVisible(true)
            local function callBack()
		   	   print("分享成功")
		    end
            local function call()
                Util:share(nil, nil, outputFile)
            end
            local call1 = cc.CallFunc:create(call)
            local seq  = cc.Sequence:create(cc.DelayTime:create(1),call1 )
            cc.Director:getInstance():getRunningScene():runAction(seq)
            
         end
     end
     
     local function call()
         self.bottom:getChildByName("close"):setVisible(true)
         self.bottom:getChildByName("share"):setVisible(true)
         Util:share(nil)
     end
     -- self:stopActionByTag(30001)
     local call1 = cc.CallFunc:create(call)
     local seq  = cc.Sequence:create(cc.DelayTime:create(1.5),call1 )
     seq:setTag(30001)

     self:runAction(seq)
     self.bottom:getChildByName("close"):setVisible(false)
     self.bottom:getChildByName("share"):setVisible(false)
     Util:captureScreen()
     -- fileName = "shareewm_code.png"
     -- cc.Director:getInstance():getTextureCache():removeTextureForKey(fileName)
     -- cc.utils:captureScreen(afterCaptured, fileName)

    
end





return WeChatLink


