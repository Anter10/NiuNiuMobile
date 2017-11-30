--
-- Author: peter
-- Date: 2017-05-17 09:45:23
--
--参数
---params.target--需要改变的控件对象大小
--params.object--绑定的父节点
--params.callback--回调方法实现
local UIScalButton = class("UIScalButton", function()
            return display.newLayer("UIScalButton")
end)
local scal=20
function UIScalButton:ctor(params)--cc.size(size.width+scal,size.height+scal)--bigwheelshuye-1
		self:setNodeEventEnabled(true)--layer添加监听
		self:setTouchSwallowEnabled(false)
	  local size=params.target:getContentSize()
      local button=display.newSprite("png/bigwheelshuye-1.png", 0, 0, cc.size(size.width+scal,size.height+scal))
      	button:setTouchEnabled(true)
	 	button:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)                                       
                                        -- if "began" == event.name and not cc.rectContainsPoint(boundingBox, cc.p(event.x, event.y)) then
                                        --         return false
                                        -- end
                                        dump(event)
                                        -- if "began" == event.name then
                                        --         return true
                                        -- elseif "moved" == event.name then
                                        -- elseif "ended" == event.name then
                                        -- 		print("event")
                                        --         params.callback(event)

                                        -- end
                            end)
	  button:setColor(cc.c3b(255, 255, 0))
	  button:setPosition(display.cx,display.cy)--params.target:getPosition()
	  params.object:addChild(button,900) 
end

return UIScalButton