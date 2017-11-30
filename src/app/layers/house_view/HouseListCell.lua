


local HouseListCell = class("HouseListCell", require("src.app.layers.shop_view.CommonNode"))

function HouseListCell:ctor(data, parent)
	  self.super.ctor(self)
    self.data = data
	  self.parent = parent

    self.layer= cc.CSLoader:createNode("res/csb/HouseListCell.csb")
    ccui.Helper:doLayout(self.layer)
    self:addChild(self.layer,32)
    self.layer:setAnchorPoint(cc.p(0, 0))
    self.layer:setPositionX(146)
    self.layer:setPositionY(66)

  
    
    self:OpenTouch()
    self:setTouchEnabled(true) 
    self:flushData()
    -- local layer = cc.LayerColor:create(cc.c4f(233,122,233,255))
    -- self:addChild(layer, -1)
    -- layer:setContentSize(cc.size(320,160))

end

function HouseListCell:setData( data )
    self.data = data
end

function HouseListCell:flushData()
    self.layer:getChildByName("id"):setText(self.data.roomID)
    self.layer:getChildByName("num"):setText(self.data.nowCount .."/6")
end

function HouseListCell:getRoomId()
   return self.data.roomID
end



-- 触摸结束
function HouseListCell:onTouchEnded(touch, event)
    self.endPoint = touch:getLocation()
    if self:containsTouchLocation(touch:getLocation().x,touch:getLocation().y) then
        if twoPointDistance(self.endPoint.x,self.endPoint.y, self.beginPoint.x,self.beginPoint.y) > 20 then
           self.ismove = true
        else
           -- 显示操作信息
           self.parent:addChild(AllRequire.ui.HouseDetailView.createDetailLayer(self.data),320)
           print(json.encode(position),"当前点击的房间的ID  = ", self.data.id)
        end
    end
end

-- 触摸开始
function HouseListCell:onTouchBegan(touch, event)
    self.beginPoint = touch:getLocation()
    if self:containsTouchLocation(touch:getLocation().x,touch:getLocation().y) then
       return true
    end
    return false
end
 
return HouseListCell



