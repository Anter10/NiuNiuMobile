--
-- Created by IntelliJ IDEA.
-- User: ms
-- Date: 2016/11/28
-- Time: 18:53
-- To change this template use File | Settings | File Templates.
--
local TouchLayer = class("TouchLayer",function()
    return cc.Layer:create();
end)

function TouchLayer.create(hide)
    local layer = TouchLayer.new();
    layer:createLayer(hide);
    return layer;
end


function TouchLayer:setCb(cb)
    self.cb = cb;
end
function TouchLayer:createLayer(hide)
    local function onTouchBegan(touch, event)
        return true
    end
    
    local function onTouchMoved(touch, event)
    end

    local function onTouchEnded(touch, event)
        if self.cb~=nil then
           self.cb();
        end

    end
   

    self:setColorLayer(hide);
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)
end
function TouchLayer:setCSize(size)
    self:setContentSize(size)
end
function TouchLayer:setLoading(tag)
end
function TouchLayer:setColorLayer(color)
    if not color then
       color = cc.c4b(28,22,7,125);
        local pLayerBG = cc.LayerColor:create(color)
        local visibleSize = cc.Director:getInstance():getVisibleSize();
        pLayerBG:setContentSize(cc.size(visibleSize.width*2,visibleSize.height*2))
        self:addChild(pLayerBG);
    end
   
end
return TouchLayer;

