--
-- Author: Your Name
-- Date: 2017-08-11 18:43:44 
--
--规则  和  用户需知
local rulesUsers = class("rulesUsers",function()
      return cc.Layer:create()
end)

function rulesUsers:ctor(_type)--  1   规则   2   用户条款
	  self.ru_type=_type
	  self:fun_init()
end
function rulesUsers:fun_init( ... )
	   if self.ru_type==1 then
	   	  self.card_layer = cc.CSLoader:createNode("csb/card_layer.csb")
          self:addChild(self.card_layer)
          self.game_mod=self.card_layer:getChildByName("game_mod")
       else
       	   self.FLuser_Layer = cc.CSLoader:createNode("csb/FLuser_Layer.csb")
           self:addChild(self.FLuser_Layer)
           self.bg=self.FLuser_Layer:getChildByName("bg")
	   end
	   self:fun_touch(self.ru_type)
        

        
end
function rulesUsers:fun_touch(_tp )
		if _tp==1 then
			local bt_back=self.game_mod:getChildByName("bt_back")
	        bt_back:addTouchEventListener(function(sender, eventType  )
	                   if eventType ~= ccui.TouchEventType.ended then
	                       return
	                  end
	                  Util:all_layer_Sound("Audio_Button_Click")
	                   self:removeFromParent()
	        end)
	    else
	    	local back=self.bg:getChildByName("back")
	        back:addTouchEventListener(function(sender, eventType  )
	                   if eventType ~= ccui.TouchEventType.ended then
	                       return
	                  end
	                  Util:all_layer_Sound("Audio_Button_Click")
	                   self:removeFromParent()
	        end)
		end
        
        
end
return rulesUsers