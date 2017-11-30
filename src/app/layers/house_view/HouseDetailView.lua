

-- 聊天界面
local HouseDetailView = class("HouseDetailView", require("src.app.layers.touchlayer"))


HouseDetailView.detailLayer = nil


function HouseDetailView:ctor(data)
     self.super.ctor(self)
     self.data = data
     self:addChild(require("src.app.layers.touchlayer").create(), -1)
     self:addCSB()
     HouseDetailView.detailLayer = self
end


function HouseDetailView.createDetailLayer(data)
   if not HouseDetailView.detailLayer then
      HouseDetailView.detailLayer = HouseDetailView.new(data)
      return HouseDetailView.detailLayer
   end
end

 
function HouseDetailView:setID(id)
    self.id:setText(id)
end

function HouseDetailView:setTime(time)
    self.time:setText(os.date("%Y-%m-%d %H:%M:%S",time))
end

function HouseDetailView:setNum(num)
    self.acount = num
    self.num:setText(tostring(num).."/6")
    self:enuoughNumber()
end

function HouseDetailView:setGZ1(gz1)
    self.gz1:setText(gz1)
end

function HouseDetailView:setGZ2(gz2)
    self.gz2:setText(gz2)
end

function HouseDetailView:setGZ3(gz3)
    self.gz3:setText(gz3)
end

-- 判断当前的房间是否已经满了
function HouseDetailView:enuoughNumber()
   if self.acount >= 6 then
      self:grayButtons()
      return true
   else
      self:visGray( false )
   end
   return false
end


-- 将按钮弄灰
function HouseDetailView:grayButtons()
    if not self.hasgray then
        local content = self.layer:getChildByName("delete"):getContentSize()
        self.delGraysprite  = cc.Sprite:create("res/n_chuangjianfangjian1/n_bt_shanchu.png")
        self.intoGraysprite  = cc.Sprite:create("res/n_chuangjianfangjian1/n_bt_jiaru.png")
        self.shareGraysprite  = cc.Sprite:create("res/n_chuangjianfangjian1/n_bt_yaoqing1.png")
        
        Tools.setSpriteGray(self.delGraysprite)
        Tools.setSpriteGray(self.intoGraysprite)
        Tools.setSpriteGray(self.shareGraysprite)

        self.layer:getChildByName("delete"):addChild(self.delGraysprite,4)
        self.delGraysprite:setPosition(cc.p(content.width / 2, content.height / 2))
        
        self.layer:getChildByName("into"):addChild(self.intoGraysprite,4)
        self.intoGraysprite:setPosition(cc.p(content.width / 2, content.height / 2))

        self.layer:getChildByName("share"):addChild(self.shareGraysprite,4)
        self.shareGraysprite:setPosition(cc.p(content.width / 2, content.height / 2))
        self.hasgray = true
        self.hasgraysprite = true

    else
        self:visGray( true )
        self.hasgray = true
    end
end


function HouseDetailView:visGray( vis )
    if self.hasgraysprite then
       self.delGraysprite:setVisible(vis)
       self.intoGraysprite:setVisible(vis)
       self.shareGraysprite:setVisible(vis)
    end
end

function HouseDetailView:closeSelf()
       if HouseDetailView.detailLayer then
          HouseDetailView.detailLayer:removeFromParent()
          HouseDetailView.detailLayer = nil
       end
end

-- 添加CSB
function HouseDetailView:addCSB()
    self.layer= cc.CSLoader:createNode("res/csb/HouseDetail.csb")
    ccui.Helper:doLayout(self.layer)
    self:addChild(self.layer)

    -- 关闭
    local function closeCallBack()
        self:closeSelf()
    end
   
    qq.tools.button(self.layer, "close", closeCallBack, true) 

    qq.tools.button(self.layer, "delete", function()
        self:deleteHouse()
    end, true) 

    qq.tools.button(self.layer, "copy", function()
        self:copyHouse()
    end, true) 

    qq.tools.button(self.layer, "into", function()
       self:intoHouse()
    end, true) 

    qq.tools.button(self.layer, "share", function()
        self:shareHouse()
    end, true) 



   if getYKLogin() then
       self.layer:getChildByName("share"):setVisible(false)
       self.layer:getChildByName("copy"):setPositionX(self.layer:getChildByName("node1"):getPositionX())
    end

    
    self.id   = self.layer:getChildByName("id")
    self.time = self.layer:getChildByName("time")
    self.num  = self.layer:getChildByName("num")

    

    self.gz1 = self.layer:getChildByName("gz1")
    self.gz2 = self.layer:getChildByName("gz2")
    self.gz3 = self.layer:getChildByName("gz3")
    
    local gz1, gz2 , gz3= self:getGZ(self.data)
    self:setGZ1(gz1)
    self:setGZ2(gz2)
    self:setGZ3(gz3)

    self:setID(self.data["roomID"])
    self:setTime(self.data["createTime"])
    self:setNum(self.data["nowCount"])

end

function HouseDetailView:getRoomId()
    return self.data["roomID"]
end

 


function HouseDetailView:getGZ(roominfo)
	       local round,difen,jifen,fufei,mingpai,jiabei,tuoguan = "10局", "AA支付", "AA支付", "底注1分", "有明牌","有加倍","有托管"
            
            if roominfo.param_a == 1 then
                round = "10局"
            elseif roominfo.param_a == 2 then
                round = "20局"
            end
          
            if roominfo.param_c == 1 then
                difen = "一分场"
            elseif roominfo.param_c == 2 then
                difen = "五分场"
            elseif roominfo.param_c == 3 then
                difen = "十分场"
            end

            if roominfo.param_d == 1 then
               jifen = "牛牛 *3, 牛九 *2, 牛八 *2, 牛七 *2"
            elseif roominfo.param_d == 2 then
               jifen = "牛牛 *4, 牛九 *3, 牛八 *2, 牛七 *2"
            end
 
            if roominfo.param_b == 1 then
                mingpai = "轮流坐庄"
            elseif roominfo.param_b == 2 then
                mingpai = "翻四张抢庄"
            elseif roominfo.param_b == 3 then
                mingpai = "经典抢庄"
            end

            local specialselect = ""
            local sparray = {"五花牛 *5", "炸弹牛 *6", "五小牛 *8"}

            if roominfo.param_e == 111 then
                specialselect = sparray[1]..sparray[2]..sparray[3]
            elseif roominfo.param_e == 110 then
                specialselect = sparray[1]..sparray[2]
            elseif roominfo.param_e == 010 then
                specialselect = sparray[2]
            elseif roominfo.param_e == 011 then
                specialselect = sparray[2]..sparray[3]
            elseif roominfo.param_e == 101 then
                specialselect = sparray[1]..sparray[3]
            elseif roominfo.param_e == 001 then
                specialselect = sparray[3]
            end

            if roominfo.param_f == 1 then
                tuoguan = "超时有托管"
            elseif roominfo.param_f == 2 or roominfo.param_f == 0 then
                tuoguan = "超时无托管"
            end

            if roominfo.param_g == 1 then
                fufei = "AA支付"
            elseif roominfo.param_g == 2 then
                fufei = "房主支付"
            elseif roominfo.param_g == 4 then
                fufei = "代开AA支付"
            elseif roominfo.param_g == 3 then
                fufei = "代开房主支付"
            end

            return round.."-"..fufei, difen.."-"..mingpai.."-"..tuoguan, specialselect.."-"..jifen
end

-- 删除
function HouseDetailView:deleteHouse()
   if self.hasgray then
      return
   end
   serverpayorder = nil
   Tools.showError("房间已解散")
   if AllRequire.ui.createRoom.createRoom then
      AllRequire.ui.createRoom.createRoom:deleteRoomById(self.data["roomID"] )
   end
   ServerWS:Instance():UserActionMsgReq(6, self.data["roomID"])
   self:closeSelf()
   -- require("lord/src/lordmsg").UserSelectRoomsMsgReq();
end


-- 进入房间
function HouseDetailView:intoHouse()
   print("进入房间")
   if self.hasgray then
      return
   end

   ServerWS:Instance():UserJoinRoomMsgReq(self.data["roomID"])
   self:closeSelf()
   -- RequireModel.ui.MyHouseLayer.remove()
end


-- 分享房间
function HouseDetailView:shareHouse()
   print("分享房间")
   if self.hasgray then
      return
   end
   local function callBack()
   	   print("分享成功")
   end
   
   local content = "房主支付 "

   if self.data["param_g"] == 1 or self.data["param_g"] == 4 then
      content = "AA支付 "
   end
   Util:share(self.data["roomID"], content, nil, self.data)
   -- self:closeSelf()

end

-- 复制房间
function HouseDetailView:copyHouse()
    
   -- Tools.showError("复制房间成功")
   local contents    = {}
   contents.roomID   = self.data["roomID"]
   contents.gameType = self.data["gameType"]
   contents.state    = self.data["state"]
   contents.round    = self.data["round"]
   contents.param_a  = self.data["param_a"]
   contents.param_b  = self.data["param_b"]
   contents.param_c  = self.data["param_c"]
   contents.param_d  = self.data["param_d"]
   contents.param_e  = self.data["param_e"]
   contents.param_f  = self.data["param_f"]
   contents.param_g  = self.data["param_g"]
   contents.gps      = "北京市海淀区"
   
   ServerWS:Instance():UserCreateRoomMsgReq1(contents)
   -- RequireModel.ui.MyHouseTools.showError("房间复制成功")
   -- self:closeSelf()
   -- require("lord/src/lordmsg").UserSelectRoomsMsgReq();
end




return HouseDetailView














