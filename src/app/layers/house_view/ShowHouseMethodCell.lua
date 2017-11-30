


local ShowHouseMethodCell = class("ShowHouseMethodCell", require("src.app.layers.shop_view.CommonNode"))

function ShowHouseMethodCell:ctor(data, parent)
	self.super.ctor(self)

	self.data = data
	self.parent = parent

    self.layer= cc.CSLoader:createNode("res/csb/ShowHouseMethodCell.csb")
    ccui.Helper:doLayout(self.layer)
    self:addChild(self.layer,32)
    
    self.layer:getChildByName("show"):setText(self.data.show .."/6")

    self:OpenTouch()
    self:setTouchEnabled(true) 
end



-- 触摸结束
function ShowHouseMethodCell:onTouchEnded(touch, event)
    self.endPoint = touch:getLocation()
    if self:containsTouchLocation(touch:getLocation().x,touch:getLocation().y) then
        if twoPointDistance(self.endPoint.x,self.endPoint.y, self.beginPoint.x,self.beginPoint.y) > 10 then
           self.ismove = true
        else
           -- 显示操作信息
           print("当前点击的房间的ID  = ", self.data.id)
        end
    end
end

-- 触摸开始
function ShowHouseMethodCell:onTouchBegan(touch, event)
    self.beginPoint = touch:getLocation()
    if self:containsTouchLocation(touch:getLocation().x,touch:getLocation().y) then
       return true
    end
    return false
end















return ShowHouseMethodCell

