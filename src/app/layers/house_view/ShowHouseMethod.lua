

local ShowHouseMethod = class("ShowHouseMethod", require("src.app.layers.touchlayer"))

local buttondata = {
      {show = "加入房间"},
      {show = "邀请好友"},
      {show = "查看详情"},
      {show = "复制房间"},
      {show = "删除房间"}
}

function ShowHouseMethod:ctor(pos)
     self.super.ctor(self)
     self:flushHouseList(buttondata)
end



-- 初始化我的房间号
function ShowHouseMethod:flushHouseList(data)
    if not self.houseListView then
        local size = self.CreateRoom:getChildByName("house_list"):getContentSize()
        local posx, posy = self.CreateRoom:getChildByName("house_list"):getPosition()

        self.houseListView = ccui.ListView:create()
        self.houseListView:setDirection(ccui.ScrollViewDir.vertical)
        self.houseListView:setBounceEnabled(true)
        self.houseListView:setContentSize(cc.size(size.width + 20, size.height))

        self.houseListView:setPositionX(posx)
        self.houseListView:setPositionY(posy)
        self.CreateRoom:addChild(self.houseListView)
    end

    createRoom.currentlayerisflush = true

    if data then
       self.data = data.rooms
    end
    
    self.houseListView:removeAllItems()
    
    if self.data and #self.data > 0 then
        local datas = {}
        local function sortTime(r1, r2)
             return r1.createTime > r2.createTime
        end

        table.sort(self.data, sortTime )

        for i = 1, #self.data do
            local custom_button = require("src.app.layers.house_view.ShowHouseMethodCell").new(self.data[i], self)
            local layer = cc.LayerColor:create(cc.c4f(333,322,122,255))
            layer:setContentSize(cc.size(777, 80))
            -- if RequireModel.ui.HouseDetailLayer.detailLayer then
                  local roomid        = RequireModel.ui.HouseDetailLayer.detailLayer:getRoomId()
            --    local defaultroomid = custom_button:getRoomId()

            --    if roomid == defaultroomid then
            --       RequireModel.ui.HouseDetailLayer.detailLayer:setNum(self.data[i]["nowCount"])
            --    end
            -- end
            custom_button:setAnchorPoint(cc.p(0,0))
            -- custom_button:addChild(layer,-1)
            custom_button:setContentSize(cc.size(777, 94))
            local custom_item = ccui.Layout:create()
            custom_item:setContentSize(cc.size(777, 160))
            custom_button:setPosition(cc.p(14, -60))
            custom_item:addChild(custom_button)
            self.houseListView:addChild(custom_item)
        end
    end
end













return ShowHouseMethod