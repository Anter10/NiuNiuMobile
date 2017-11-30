

local ShopView = class("ShopViewCell", require("src.app.layers.touchlayer"))


ShopView.shopdasta = nil





function ShopView.create()
	local sc = ShopView.new()
	return sc
end

function ShopView:ctor()
     self.super.ctor(self)
     self:addChild(require("src.app.layers.touchlayer").create(), -1)
     self:addCSB()
end
 
-- 添加CSB
function ShopView:addCSB()
    self.layer = cc.CSLoader:createNode("res/csb/Shop.csb")
    ccui.Helper:doLayout(self.layer)
    self:addChild(self.layer)

    -- 关闭
    local function closeCallBack()
       self:removeFromParent()
       self = nil
    end

    self.bottomnode = self.layer:getChildByName("bottom")
    qq.tools.button(self.layer, "close", closeCallBack, true) 
    self.size = self.bottomnode:getContentSize()
    

    self.lx, self.ly = self.bottomnode:getChildByName("pos"):getPosition()
    

    
    self:requestShopData()
end


function ShopView:requestShopData()
	if not ShopView.shopdasta then
		
       local account_id = 222222
       Server:Instance():HttpSendpost("http://admin.sharkpoker.cn/home/login/gears_setting_api?account_id=15133&game=niuniu",{}, function(data) 
           local tdata = {}
           for dataIndex, sdata in pairs(data) do
           	   sdata.key = dataIndex
               tdata[#tdata + 1] = sdata
           end

           local function sort( s1,s2 )
              return tonumber(s1.fee) < tonumber(s2.fee)
           end
           table.sort(tdata,sort )
           print("商城档位数据 = ",json.encode(tdata))
           ShopView.shopdasta = tdata
           self:initShop()
       end)
    else
       self:initShop()
    end
end


function ShopView:initShop()
	  self.listView = ccui.ListView:create()
    self.listView:setDirection(ccui.ScrollViewDir.horizontal)
    self.listView:setBounceEnabled(true)
    self.listView:setContentSize(cc.size(self.size.width - 70, self.size.height - 150))
    self.listView:setPositionX(self.lx)
    self.listView:setPositionY(self.ly)
    self.listView:setAnchorPoint(cc.p(0,0))
    self.bottomnode:addChild(self.listView)
    if ShopView.shopdasta and #ShopView.shopdasta > 0 then
        for i = 1, #ShopView.shopdasta do
            local tdata = ShopView.shopdasta[i]
            tdata.index = i
            local custom_button = require("src.app.layers.shop_view.ShopViewCell").new(tdata, self)
            custom_button:setAnchorPoint(cc.p(0,0))
            -- custom_button:setContentSize(cc.size(260, self.size.height - 150))

            local custom_item = ccui.Layout:create()
            custom_item:setContentSize(cc.size(260, self.size.height - 150))
            custom_button:setPosition(cc.p(7, 20))
            custom_item:addChild(custom_button)
            self.listView:addChild(custom_item)
        end
    end
end


return ShopView