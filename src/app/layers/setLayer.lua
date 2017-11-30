--
-- Author: Your Name
-- Date: 2017-08-09 18:14:22
--  设置
local setLayer = class("setLayer",function()
      return cc.Layer:create()--cc.Scene:create()--
end)

setLayer.setLayer = nil
function setLayer:ctor()
    setLayer.setLayer = self
	  self:fun_init()
end

function setLayer:fun_init(  )
		    self.setLayer = cc.CSLoader:createNode("csb/setLayer.csb")
        self:addChild(self.setLayer)
        self.bg = self.setLayer:getChildByName("bg") 

        -- 设置版本号

        self.setLayer:getChildByName("bg"):getChildByName("Text_3"):setString("版本  v"..AllRequire.logic.Parameter.version)
        self:fun_checkbox_innings()
        --  返回
        local back=self.bg:getChildByName("back")
        back:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  print("返回")
                  Util:all_layer_Sound("Audio_Button_Click")
                  self:removeFromParent()
        end)
        --  返回
        local switchaccount=self.bg:getChildByName("switchaccount")
        switchaccount:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                   end
                   ServerWS:Instance():close()
                   ServerWS:Instance():connect()
                   Util:deleWeixinLoginDate()

                   if cc.Director:getInstance():getRunningScene() then
                      cc.Director:getInstance():replaceScene(require("src.app.views.loadScene").new())
                   end 
                   -- self:getParent():getParent():addChild(require("app.views.loadScene").new())
                   -- self:getParent():removeFromParent()
        end)  


end

--局数选择
function setLayer:fun_checkbox_innings( ... )
	self.music_bx=self.bg:getChildByName("music_bx")
	self.effect_bx=self.bg:getChildByName("effect_bx")
	self.newversion_bx=self.bg:getChildByName("newversion_bx")
  if LocalData:Instance():get_music_hit() then
     self.music_bx:setSelected(true) 
  else
     self.music_bx:setSelected(false)
  end
  if LocalData:Instance():get_sound() then
     self.effect_bx:setSelected(true)
  else
     self.effect_bx:setSelected(false)
  end
	self.music_bx:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            
                            LocalData:Instance():set_music_hit(true)
                            Util:player_music_hit("hall_bg_voice",true )
                      elseif eventType == ccui.CheckBoxEventType.unselected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            
                            audio.pauseMusic()
                            LocalData:Instance():set_music_hit(false)
                     end
            end)
	self.effect_bx:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            audio.pauseAllSounds()
                            LocalData:Instance():set_sound(true)
                      elseif eventType == ccui.CheckBoxEventType.unselected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            audio.resumeAllSounds()
                            LocalData:Instance():set_sound(false)
                     end
            end)
	self.newversion_bx:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            print("新版本")
                      elseif eventType == ccui.CheckBoxEventType.unselected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            print("旧版本")
                     end
            end)
end


function setLayer:onEnter()
 
end

function setLayer:onExit()
     
end


return setLayer