
-- 分润界面

local ShareMoneyView = class("ShareMoneyView", require("src.app.layers.touchlayer"))

ShareMoneyView.shareMoneyView = nil
ShareMoneyView.layertype = 1

function ShareMoneyView:ctor()
	  self.super.ctor(self)
    self:addChild(require("src.app.layers.touchlayer").create(), -1)
    ShareMoneyView.shareMoneyView = self
    self.layer = cc.CSLoader:createNode("csb/ShareMoneyLayer.csb")
    ccui.Helper:doLayout(self.layer)
    self:addChild(self.layer)

    self.bottom = self.layer:getChildByName("bottom")
    self.bottom:setPosition(display.cx, display.cy)
    -- 关闭
    local function closeCallBack()
       ShareMoneyView.shareMoneyView:removeFromParent()
       ShareMoneyView.shareMoneyView = nil
    end

    qq.tools.button(self.bottom, "close", closeCallBack, true) 
    qq.tools.button(self.bottom, "get", 
    function()
       -- self:getFR()
        if self.sprite:isVisible() == true then
            return;
        end
        local tLayer = require("src.app.layers.touchlayer")
        local visibleSize = cc.Director:getInstance():getVisibleSize()
        tLayer = tLayer.create();
        print("发反反复复")
        tLayer:setCSize(visibleSize)
        local exitLayer= cc.CSLoader:createNode("csb/fenrun.csb")
        exitLayer:setName("fenrunLayer")
        tLayer:addChild(exitLayer)
        tLayer:setName("lingqufenrun");
        self:addChild(tLayer)
        ----------init panel content
        local text_2 = exitLayer:getChildByName("Text_2")
        text_2:setVisible(false);
        local text_1 = exitLayer:getChildByName("Text_1")
        text_1:setString(self.bottom:getChildByName("lqbl"):setText(self.frnum.."/20"):getString())

        --------
        local function diaCb()
            self:getFR()
        end

        local function huafeiCb()
            text_2:setVisible(true);
            text_1:setVisible(false);
            exitLayer:getChildByName("Button_1"):setVisible(false);
            exitLayer:getChildByName("Button_2"):setVisible(false);
        end

        local function closeCb()
              tLayer:removeFromParent();
        end
        qq.tools.button(exitLayer,"Button_1",diaCb,true)
        qq.tools.button(exitLayer,"Button_2",huafeiCb,true)
        qq.tools.button(exitLayer,"Button_close",closeCb,true);
    end
    , true) 

    qq.tools.button(self.bottom, "adddia", 
    function()
        self:addChild(require("src.app.layers.shop_view.ShopView").new(),455)
    end
    , true) 
    
 
    local msg = LocalData:Instance():get_loading()
    self.tdata = {}
    self.tdata.openID = msg.openID
    self.tdata.nick = msg.nick
    self.tdata.diamond = msg.diamond
    self.bottom:getChildByName("nc"):setText("昵称: "..self.tdata.nick)
    self.bottom:getChildByName("id"):setText("ID: "..self.tdata.openID)
    self.bottom:getChildByName("dia"):setText(self.tdata.diamond)
    
    -- 当前分润数量
    self.frnum = 0
    self.cynum = 0
    
    self:initPlayerIcon()
    
    self:flushFrPercent()

    self:requestFRData()
end


-- 初始玩家头像
function ShareMoneyView:initPlayerIcon()
	  
	  	  local msg = LocalData:Instance():get_loading()
        local haer_pic=Util:sub_str(msg.head)
        if Util:isFileExist(haer_pic) then
           self.bottom:getChildByName("icon"):loadTexture(haer_pic)
        end
end


-- 请求分润信息数据
function ShareMoneyView:requestFRData()
	     local account_id = self.tdata.openID
        Server:Instance():HttpSendpost("http://wx.sharkpoker.cn/index.php/Home/ShopReturn/getReturn?account_id="..account_id,{},function(data) 
            print("玩家分润数据 = ",json.encode(data))
            if ShareMoneyView.shareMoneyView then
                ShareMoneyView.shareMoneyView.frnum = data.invite_income
                ShareMoneyView.shareMoneyView.cynum = data.next_account_count
                if ShareMoneyView.shareMoneyView.flushRFRData then 
                   ShareMoneyView.shareMoneyView:flushRFRData() 
                end
            end
       end)
end


-- 刷新成员, 钻石领取数量, 当前领取进度显示
function ShareMoneyView:flushRFRData()
	  self.bottom:getChildByName("lqbl"):setText(self.frnum.."/20")
	  self.bottom:getChildByName("mymember"):setVisible(true)
    self.bottom:getChildByName("mymember"):setText("我的成员: "..self.cynum.."位")
    self:flushFrPercent()
end


-- 刷新领取进度
function ShareMoneyView:flushFrPercent()
  	local percent = (self.frnum / 20) * 100
  	self.percent = percent
    self.bottom:getChildByName("lqbl"):setText(self.frnum.."/20")
    self.bottom:getChildByName("perbar"):setPercent(percent)
    self:addGraySprite()
    if self:getChildByName("lingqufenrun") ~= nil then
       local fenrunLayer = self:getChildByName("lingqufenrun"):getChildByName("fenrunLayer")
       local text_1 = fenrunLayer:getChildByName("Text_1")
       text_1:setString(self.frnum.."/20")
    end
end


-- 将领取分润按钮弄灰
function ShareMoneyView:addGraySprite()
    print("领取分润的进度",self.percent)
	  -- 判断当前是否可以领取分润
	  if self.percent < 100 then
       if not self.sprite then
          self.sprite = cc.Sprite:create("ddz_fenrun/ddz_bt_lingqu.png")
          Tools.setSpriteGray(self.sprite)
          self.bottom:getChildByName("get"):addChild(self.sprite,30)
          local content = self.bottom:getChildByName("get"):getContentSize()
          self.sprite:setPosition(cc.p(content.width / 2, content.height / 2))
       else
          self.sprite:setVisible(true)
       end   
       self.bottom:getChildByName("get"):setTouchEnabled(false)
    else
       if self.sprite then
          self.bottom:getChildByName("get"):setTouchEnabled(true)
       	  self.sprite:setVisible(false)
       end
	  end
end



-- 领取分润数据
function ShareMoneyView:getFR()
	  if self.percent >= 100 then
       local msg = LocalData:Instance():get_loading()
		   local account_id = msg.openID
	     Server:Instance():HttpSendpost("http://wx.sharkpoker.cn/index.php/Home/ShopReturn/doReturn?account_id="..account_id,{}, function(data) 
	         print("玩家领取分润数据 = ",json.encode(data))
           if ShareMoneyView.shareMoneyView then
               ShareMoneyView.shareMoneyView.frnum = data.invite_income
               if ShareMoneyView.shareMoneyView.flushFrPercent then
                  ShareMoneyView.shareMoneyView:flushFrPercent()   
               end
           end
	     end)
	  else
        require("src.app.common.gameui.my_house.MyHouseTools").showError("当前还不能领取分润, 加油哦!!!")
    end
end

--
function ShareMoneyView:updateDiamond(value)
    local msg = LocalData:Instance():get_loading()
    local tdata = {}
    tdata.diamond = msg.diamond
    self.bottom:getChildByName("dia"):setText(tdata.diamond)
end





-- qq.gameControl.userInfo.openID
return ShareMoneyView



