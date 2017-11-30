

local PayMethodView = class("PayMethodView", require("src.app.layers.touchlayer"))



function PayMethodView:ctor(data)
	 self.super.ctor(self)
     self:addChild(require("src.app.layers.touchlayer").create(), -1)

	  self.layer = cc.CSLoader:createNode("res/csb/PayMethodView.csb")
     ccui.Helper:doLayout(self.layer)
     self:addChild(self.layer)
     
    -- 关闭
    local function closeCallBack()
       self:removeFromParent()
       self = nil
    end
   
     qq.tools.button(self.layer, "close", closeCallBack, true) 
     self.data = data

     qq.tools.button(self.layer, "wpay", function()
     self:requestPay()
     end, true) 
end


function PayMethodView:requestPay()
     local ip = "192.168.1.101"
     local tdata = {}
     local msg = LocalData:Instance():get_loading()

     tdata.account_id = msg.openID

     print("玩家OP嗯ID ",tdata.account_id)
     tdata.fee = self.data.fee
     tdata.want_num = self.data.diamond
     tdata.ip = ip
     -- tdata.fee =  "0.01"
     local payrequesturl = "http://wx.sharkpoker.cn/index.php/Home/ShopReturn/getPrePayOrder?account_id="..tdata.account_id.."&fee="..tdata.fee.."&want_num="..tdata.want_num
     Server:Instance():HttpSendpost(payrequesturl ,{}, function(data) 
            local time = tostring(os.time())

            local args = {data.appid,data.partnerid,data.prepayid,data.noncestr,tostring(data.timestamp),data.package,data.sign}
            
            -- 判断是否有微信
            if hasWX() then
               if isIOS() and Tools.iscompanyipa then
                  print("datmee  = ",json.encode(data))
                  local data = {partnerId = data.partnerid, prepayId = data.prepayid, nonceStr = data.noncestr,timeStamp= tostring(data.timestamp),package = data.package, sign =  data.sign}
                  local ok, ret = require"cocos.cocos2d.luaoc".callStaticMethod("AppController", "payWX",data)
                  print("当前是否安装了微信1 - ",ret)
                  if ret == 1 then
                     return true
                  else
                     return false
                  end
               else
                  local luaj = require "cocos.cocos2d.luaj"
                  local className = "org/cocos2dx/lua/AppActivity"
                  print("客服端安装了微信2")
                  serverpayorder = tdata.want_num.."钻石成功，请注意查收!!!"
                  local ok,ret  = luaj.callStaticMethod(className, "payByWC",args)
               end
            else
               -- 没有安装微信处理

            end

            
            print("支付信息。= ",ok,ret )
    end, true)
end



return PayMethodView





