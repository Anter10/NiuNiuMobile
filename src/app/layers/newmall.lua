--
-- Author: admin
-- Date: 2017-10-20 10:46:45
--   支付商城
local newmall = class("newmall",function()
      return cc.Layer:create()--cc.Scene:create()--
end)


function newmall:ctor()--
	  self:fun_init()
end

function newmall:fun_init(  )
	    dump("新的商城")
		self.newmall = cc.CSLoader:createNode("csb/newmall.csb")
        self:addChild(self.newmall)
        --  返回
        local back=self.newmall:getChildByName("Button_5")
        back:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                   print("返回")
                   Util:all_layer_Sound("Audio_Button_Click")
                   self:removeFromParent()
        end)
        --  返回
        local Button_1=self.newmall:getChildByName("Button_1")
        Button_1:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  dump("1111")

                      --local function notifymenuCallbackTest()
					    local luaoc = require"cocos.cocos2d.luaoc"
					    local ok, ret = luaoc.callStaticMethod("iospay", "buy", {type1 = 1})
					 dump(ok)
					 dump(ret)
					  -- end
        end)  

        local Button_2=self.newmall:getChildByName("Button_2")
        Button_2:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  local luaoc = require"cocos.cocos2d.luaoc"
				  local ok, ret = luaoc.callStaticMethod("iospay", "buy", {type1 = 2})
					 dump(ok)
					 dump(ret)
        end)    

        local Button_3=self.newmall:getChildByName("Button_3")
        Button_3:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  local luaoc = require"cocos.cocos2d.luaoc"
				  local ok, ret = luaoc.callStaticMethod("iospay", "buy", {type1 = 3})
					 dump(ok)
					 dump(ret)
        end)    

        local Button_4=self.newmall:getChildByName("Button_4")
        Button_4:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  local luaoc = require"cocos.cocos2d.luaoc"
				  local ok, ret = luaoc.callStaticMethod("iospay", "buy", {type1 = 4})
					 dump(ok)
					 dump(ret)
        end)            
end

function newmall:callStaticMethod(className, methodName, args)
    local callStaticMethod = LuaObjcBridge.callStaticMethod
    local ok, ret = callStaticMethod(className, methodName, args)
	    if not ok then
	        local msg = string.format("luaoc.callStaticMethod(\"%s\", \"%s\", \"%s\") - error: [%s] ",
	                className, methodName, tostring(args), tostring(ret))
	        if ret == -1 then
	            print(msg .. "INVALID PARAMETERS")
	        elseif ret == -2 then
	            print(msg .. "CLASS NOT FOUND")
	        elseif ret == -3 then
	            print(msg .. "METHOD NOT FOUND")
	        elseif ret == -4 then
	            print(msg .. "EXCEPTION OCCURRED")
	        elseif ret == -5 then
	            print(msg .. "INVALID METHOD SIGNATURE")
	        else
	            print(msg .. "UNKNOWN")
	        end
	    end
	    return ok, ret
end


function newmall:onEnter()
      -- NotificationCenter:Instance():AddObserver("CreateRoom", self,
      --                  function()
                       	  
      --                 end)--
	 

      
end

function newmall:onExit()
    --NotificationCenter:Instance():RemoveObserver("CreateRoom", self)
end


return newmall