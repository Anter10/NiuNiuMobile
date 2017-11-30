local ShopViewCell = class("ShopViewCell", require("src.app.layers.shop_view.CommonNode"))


serverpayorder = nil

function onPayFail(data, receipt)
     serverpayorder = nil
     Tools.showError("你的订单支付失败!!!")
     print("IOS支付失败",data, receipt)
end


function onPaySuccess(data, receipt)
       print("IOS支付成功",data,receipt)
       if serverpayorder then
          -- 请求当前的支付订单
          Server:Instance():HttpSendpost("http://wx.sharkpoker.cn/index.php/Home/ShopReturn/iosnotify?order="..tostring(serverpayorder),{}, function(data) 
               print("aaaaadatadata",data)
               if data.code == "success" then
                  Tools.showError("你的订单支付成功!!!")
                  serverpayorder = nil
               end
          end)
      end
end


function ShopViewCell:ctor(data, parent)
	  self.super.ctor(self)
	  self.data = data
  	self.parent = parent

    self.layer= cc.CSLoader:createNode("csb/ShopCell.csb")
    ccui.Helper:doLayout(self.layer)
    self:addChild(self.layer,32)
    
    self.layer:getChildByName("znum"):setText(self.data.diamond.."钻")
    self.layer:getChildByName("buynum"):setText(self.data.fee.."元")
    self.layer:getChildByName("zpos"):setTexture("res/niuniu_shangcheng/ddz_shangchengzuanshi"..tostring(self.data.index)..".png")
    
    if self.data.isagent then
       self.layer:getChildByName("dl"):setVisible(true)
    end
    

    local function buyCallBack()
       self:buy()
    end

    self.bottomnode = self.layer:getChildByName("bottom")
    qq.tools.button(self.layer, "buynum1", buyCallBack, true) 
    
   
    self:OpenTouch()
    self:setTouchEnabled(true) 
end


-- 触摸结束
function ShopViewCell:onTouchEnded(touch, event)
    self.endPoint = touch:getLocation()
    if self:containsTouchLocation(touch:getLocation().x,touch:getLocation().y) then
        if twoPointDistance(self.endPoint.x,self.endPoint.y, self.beginPoint.x,self.beginPoint.y) > 10 then
           self.ismove = true  
        else
           self:buy()
        end
    end
end

-- 触摸开始
function ShopViewCell:onTouchBegan(touch, event)
    self.beginPoint = touch:getLocation()
    if self:containsTouchLocation(touch:getLocation().x,touch:getLocation().y) then
       return true
    end
    return false
end


function ShopViewCell:buy()
           local targetPlatform = cc.Application:getInstance():getTargetPlatform()
           print("targetPlatformtargetPlatformtargetPlatformtargetPlatform =  ",targetPlatform, cc.PLATFORM_OS_IPHONE, cc.PLATFORM_OS_IPAD)
           if ((cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform)) and not Tools.iscompanyipa then
               local msg = LocalData:Instance():get_loading()
               local tdata = {} 
               tdata.account_id = msg.openID
               tdata.fee = self.data.fee
               tdata.want_num = self.data.diamond
               if not serverpayorder then
                   -- 请求当前的支付订单
                   Server:Instance():HttpSendpost("http://wx.sharkpoker.cn/index.php/Home/ShopReturn/iosAppPay?account_id="..tdata.account_id.."&fee="..self.data.fee.."&want_num="..tdata.want_num,{}, function(data) 
                        print("aaaaadatadata",data.order)
                        serverpayorder = data.order
                        local args = {buyid = self.data.product}
                        local luaoc = require "cocos.cocos2d.luaoc"
                        local className = "iAPProductsRequestDelegate"
                        local ok,tip  = luaoc.callStaticMethod(className,"buyDiamond",args) 
                   end)
               else
                  Tools.showError("等待处理未完成的订单")
               end
           else
               local paymethod = require("src.app.layers.shop_view.PayMethodView").new(self.data, self)
               self.parent:addChild(paymethod, 320)
           end
end




return  ShopViewCell



























