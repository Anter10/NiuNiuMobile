-- 公共的场景用于管理某些通用的节点类
local CommonNode = class("CommonNode",function()
   return cc.Node:create()
end)

function CommonNode:ctor()
    self:enableNodeEvents()
    self.enableTouch = false
    --判断点击的范围形状，1为矩形，2为弧形
    self.touchshape=1
    --圆弧半径
    self.radius=0
    --圆弧夹角
    self.angle=0
    self:setContentSize(cc.size(120, 80))
end

--打开触摸
function CommonNode:OpenTouch()
    if self.listener~=nil then
        return
    end
    self.listener = cc.EventListenerTouchOneByOne:create()

    -- 开始触摸
    local function onTouchBegan(touch, event)

        if not self:containsTouchLocation(touch:getLocation().x,touch:getLocation().y) then
           return false
        end
        if not self.enableTouch then
            return false
        end
        local c=self
        while c~=nil do 
            if c:isVisible()==false then
                return false
            end
            c=c:getParent()
        end
        
        return self:onTouchBegan(touch,event)
    end

    -- 移动触摸
    local function onTouchMoved(touch, event)
        if self.enableTouch then
           self:onTouchMoved(touch,event)
        end
    end

    -- 结束触摸
    local function onTouchEnded(touch, event)
        if self.enableTouch then
           self:onTouchEnded(touch, event)
        end
    end

    local function onTouchCancelled(touch, event)
        if self.enableTouch then
           self:onTouchCancelled(touch, event)
        end
    end
    self.listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    self.listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    self.listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    self.listener:registerScriptHandler(onTouchCancelled,cc.Handler.EVENT_TOUCH_CANCELLED) 
    local eventDispatcher = self:getEventDispatcher()
    -- self.listener:setSwallowTouches(true)
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener, self)
    self.enableTouch = true
end
--设置是否吞吃触摸
function CommonNode:setSwallowTouches(needSwallow)
    self.listener:setSwallowTouches(needSwallow)
end
-- 设置是否可以触摸
function CommonNode:setTouchEnabled(enable)
    self.enableTouch = enable
end
function CommonNode:setButtonTouchShape(shape,radius,angle)
    self.touchshape=shape
    self.radius=radius
    self.angle=angle
end
-- 点击的范围是否在当前触摸节点上
function CommonNode:containsTouchLocation(x,y)
    if self.touchshape==1 then
        local position = self:getParent():convertToWorldSpace(cc.p(self:getPosition()))
        local nodeSize = self:getContentSize()
        local ap = self:getAnchorPoint()
        local touchRect = cc.rect(position.x - nodeSize.width*self:getScaleX() * ap.x,position.y - nodeSize.height*self:getScaleY() * ap.y, nodeSize.width*self:getScaleX(), nodeSize.height*self:getScaleY())
        local b = cc.rectContainsPoint(touchRect, cc.p(x,y))
        return b
    elseif self.touchshape==2 then
        local position = self:getParent():convertToWorldSpace(cc.p(self:getPosition()))
        local nodeSize = self:getContentSize()
        local ap = self:getAnchorPoint()
        local centralposition=cc.p(0,0)
        if self:getRotation()==0 then
            centralposition.x=position.x-nodeSize.width*ap.x
            centralposition.y=position.y+nodeSize.height*(0.5-ap.y)
            local pianyijiao = c_liangdianlianxianpianyijiaodu(centralposition.x,centralposition.y,x,y)
            if (x-centralposition.x)*(x-centralposition.x)+(y-centralposition.y)*(y-centralposition.y)<=self.radius*self.radius then
                if pianyijiao>=90-self.angle/2 and pianyijiao<=90+self.angle/2 then
                    return true
                end
            end
        elseif self:getRotation()==-90 then
            centralposition.x=position.x-nodeSize.height*(0.5-ap.y)
            centralposition.y=position.y-nodeSize.width*ap.x
            local pianyijiao = c_liangdianlianxianpianyijiaodu(centralposition.x,centralposition.y,x,y)
            if (x-centralposition.x)*(x-centralposition.x)+(y-centralposition.y)*(y-centralposition.y)<=self.radius*self.radius then
                if pianyijiao>=-self.angle/2 and pianyijiao<=self.angle/2 then
                    return true
                end
            end
        elseif self:getRotation()==-180 then
            centralposition.x=position.x+nodeSize.width*ap.x
            centralposition.y=position.y-nodeSize.height*(0.5-ap.y)
            local pianyijiao = c_liangdianlianxianpianyijiaodu(centralposition.x,centralposition.y,x,y)
            if (x-centralposition.x)*(x-centralposition.x)+(y-centralposition.y)*(y-centralposition.y)<=self.radius*self.radius then
                if pianyijiao>=-90-self.angle/2 and pianyijiao<=-90+self.angle/2 then
                    return true
                end
            end
        elseif self:getRotation()==-270 then
            centralposition.x=position.x+nodeSize.height*(0.5-ap.y)
            centralposition.y=position.y+nodeSize.width*ap.x
            local pianyijiao = c_liangdianlianxianpianyijiaodu(centralposition.x,centralposition.y,x,y)
            if (x-centralposition.x)*(x-centralposition.x)+(y-centralposition.y)*(y-centralposition.y)<=self.radius*self.radius then
                if pianyijiao>=180-self.angle/2 or pianyijiao<=-180+self.angle/2 then
                    return true
                end
            end
        end
        return false
    elseif self.touchshape == 3 then
        local position = self:getParent():convertToWorldSpace(cc.p(self:getPosition()))
        local nodeSize = self:getContentSize()
        local ap = self:getAnchorPoint()
        local touchRect = cc.rect(position.x - nodeSize.width * ap.x,position.y - nodeSize.height * ap.y, nodeSize.width, nodeSize.height)
        local b = cc.rectContainsPoint(touchRect, cc.p(x,y))
        if b then
           -- 计算圆形的面积
           local clicklength = twoPointDistance(x, y , position.x, position.y)
            -- -- print("当前的锚点 位置 = ",json.encode(clicklength))  
           if clicklength <= self.radius then
              return true
           else
              return false
           end
           -- local originalPoint = cc.p(self:get)
          
           
        end
    end
end
 
-- 触摸开始
function CommonNode:onTouchBegan(touch, event)
  
    -- local beginPoint = touch:getLocation()
    -- print("beginPoint = ",beginPoint.x,beginPoint.y)
	return true
end

-- 触摸移动
function CommonNode:onTouchMoved(touch, event)
	 
end

-- 触摸结束
function CommonNode:onTouchEnded(touch, event)
	 
end
function CommonNode:onTouchCancelled(touch, event)

end
-- 节点进入
function CommonNode:onEnter()

end

-- 节点退出
function CommonNode:onExit()
    if self.Cleanupresources then
       self:Cleanupresources()
    end
end

-- 移除自己
function CommonNode:removeSelf()
    self:removeFromParent(true)
    self = nil
end


return CommonNode
