--
-- Author: Your Name
-- Date: 2017-08-09 10:18:23
--
--加入房间
local layerInjon = class("layerInjon",function()
      return cc.Layer:create()
end)

function layerInjon:ctor()--
	  self:fun_init()
end
function layerInjon:fun_init( ... )
		self.layerInjon = cc.CSLoader:createNode("csb/layerInjon.csb")
        self:addChild(self.layerInjon)
        self.n_bg=self.layerInjon:getChildByName("n_bg")
        self.room_num=self.n_bg:getChildByName("room_num") --  房间号码
        self:fun_number_touch()
        self:fun_move_add_touch()
        --  返回
        local jion_back=self.n_bg:getChildByName("jion_back")
        jion_back:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  Util:all_layer_Sound("Audio_Button_Click")
                   self:removeFromParent()
        end)
end
--  点击号码
function layerInjon:fun_number_touch( ... )
	local number_table={}
	for i=0,9 do
		local n_bg=self.n_bg:getChildByName("j_Button_"  ..   tostring(i))
		number_table[i+1]=n_bg
	end
	for j=1,#number_table do
		number_table[j]:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  Util:all_layer_Sound("Audio_Button_Click")
                  self.room_num:setString(self.room_num:getString()  .. sender:getTag()-500 )
        end)
	end
end
--  加入删除
function layerInjon:fun_move_add_touch(  )
	    --  删除
	    local j_Button_10=self.n_bg:getChildByName("j_Button_10")
        j_Button_10:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  Util:all_layer_Sound("Audio_Button_Click")
                   self.room_num:setString(string.sub(self.room_num:getString(), 1, -2))
        end)
        --  加入
	    local j_Button_11=self.n_bg:getChildByName("j_Button_11")
        j_Button_11:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  Util:all_layer_Sound("Audio_Button_Click")
                   print("加入")
        end)
end

return layerInjon