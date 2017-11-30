--
-- Author: Your Name
-- Date: 2017-08-08 14:22:18
--
--创建房间
local createRoom = class("createRoom",function()
      return cc.Layer:create()--cc.Scene:create()--
end)

createRoom.currentlayerisflush = nil
createRoom.createRoom = nil
createRoom.currentlayerisflush = false
local timemessage = {
      rooms = {
            {id = 110421,num=2, createTime = 43},
            {id = 110423,num=4, createTime = 43},
            {id = 110424,num=2, createTime = 422},
            {id = 110421,num=1, createTime = 43},
            {id = 111221,num=4, createTime = 45},
            {id = 110121,num=6, createTime = 543},
            {id = 114421,num=2, createTime = 443}
      }
     
}

function createRoom:ctor()--
      self:enableNodeEvents()
      createRoom.createRoom = self
	    self.createRoom_table={}
      self.createRoom_table.CB_innings_type=2  --局数选择
      self.createRoom_table.CB_bottnote_type=2  --底注选择
      self.createRoom_table.CB_score_type=2  --积分选择
      self.createRoom_table.CB_special_type=111  --特殊选择
      self.CB_special_type1=1  --特殊选择
      self.CB_special_type2=1  --特殊选择
      self.CB_special_type3=1  --特殊选择
      self.createRoom_table.CB_tuoguan_type=2
      self.createRoom_table.pay = 3
      self.createRoom_table.CB_rules_type=2  --坐庄选择
      self:fun_init()

      self.ishouseerpay = true

      self:requestRoomsData()
end


function createRoom:requestRoomsData()
    ServerWS:Instance():UserSelectRoomsMsgReq()
    local function request()
       print("开始请求房间信息 ")
       createRoom.currentlayerisflush = true
       ServerWS:Instance():UserSelectRoomsMsgReq()
    end
    self:stopAllActions()
    local call = cc.CallFunc:create(request)
    local delay = cc.DelayTime:create(5)
    local seq   = cc.Sequence:create(delay, call)
    local repe  = cc.RepeatForever:create(seq)
    self:runAction(repe)
end
 

-- 移除自己
function createRoom:removeSelf()
    if createRoom.createRoom then
       createRoom.createRoom:removeFromParent()
       createRoom.createRoom = nil
    end
end



function createRoom:fun_init(  )
		    self.CreateRoom = cc.CSLoader:createNode("csb/CreateRoom.csb")
        self:addChild(self.CreateRoom)
        self.bg=self.CreateRoom:getChildByName("bg") 
        self:fun_checkbox_innings()
        self:fun_checkbox_bottnote()
        self:fun_checkbox_checkbox()
        self:fun_checkbox_special()
        self:fun_checkbox_rules()
        self:fun_tuoguan()
        
        self:init_selectPayMethod()
        --  提交
        local createroom_bt=self.bg:getChildByName("createroom_bt")
        createroom_bt:addTouchEventListener(function(sender, eventType  )
                 if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                   print("创建房间",json.encode(self.createRoom_table)) 

                   Util:all_layer_Sound("Audio_Button_Click")
             
                   local _num_tag=tostring(self.createRoom_table.CB_special_type) ..    tostring(self.createRoom_table.CB_bottnote_type)
                  
                   ServerWS:Instance():UserCreateRoomMsgReq(self.createRoom_table)
                   -- self:removeSelf()
        end)
        --  返回
        local back=self.bg:getChildByName("back")
        back:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                   print("返回")
                   Util:all_layer_Sound("Audio_Button_Click")
                  self:removeSelf()
        end)

        -- self:flushHouseList({})

end

--局数选择
function createRoom:fun_checkbox_innings( ... )
	self.CB_innings_1=self.bg:getChildByName("CB_innings_1")
	self.CB_innings_2=self.bg:getChildByName("CB_innings_2")

	self.CB_innings_1:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.createRoom_table.CB_innings_type=1
                            self.CB_innings_2:setSelected(false)
                      elseif eventType == ccui.CheckBoxEventType.unselected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.CB_innings_1:setSelected(true)
                     end
            end)
	self.CB_innings_2:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.createRoom_table.CB_innings_type=2
                            self.CB_innings_1:setSelected(false)
                      elseif eventType == ccui.CheckBoxEventType.unselected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            if  not  self.CB_innings_1:isSelected() then
                              self.CB_innings_2:setSelected(true)
                            end
                     end
            end)
end


-- 支付方式选择
function createRoom:init_selectPayMethod()
     self.housePay = self.CreateRoom:getChildByName("fzdk")
     self.aaPay    = self.CreateRoom:getChildByName("aazf")
    
     self.housePay:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.createRoom_table.pay = 3
                            self.CreateRoom:getChildByName("diamond1"):setText("10局（钻石x5)")
                            self.CreateRoom:getChildByName("diamond2"):setText("20局（钻石x10)")
                            self.aaPay:setSelected(false)
                      elseif eventType == ccui.CheckBoxEventType.unselected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.housePay:setSelected(true)
                     end
            end)

    self.aaPay:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.createRoom_table.pay = 1
                            self.CreateRoom:getChildByName("diamond1"):setText("10局（钻石x1)")
                            self.CreateRoom:getChildByName("diamond2"):setText("20局（钻石x2)")
                            self.housePay:setSelected(false)
                      elseif eventType == ccui.CheckBoxEventType.unselected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            if not self.housePay:isSelected() then
                               self.housePay:setSelected(true)
                            end
                     end
            end)


end


--底注选择
function createRoom:fun_checkbox_bottnote( ... )
	self.CB_bottnote_1=self.bg:getChildByName("CB_bottnote_1")
	self.CB_bottnote_2=self.bg:getChildByName("CB_bottnote_2")
	self.CB_bottnote_3=self.bg:getChildByName("CB_bottnote_3")
	self.CB_bottnote_1:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.createRoom_table.CB_bottnote_type=1
                            self.CB_bottnote_2:setSelected(false)
                            self.CB_bottnote_3:setSelected(false)
                      elseif eventType == ccui.CheckBoxEventType.unselected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.CB_bottnote_1:setSelected(true)

                     end
            end)
	self.CB_bottnote_2:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.createRoom_table.CB_bottnote_type=2
                            self.CB_bottnote_1:setSelected(false)
                            self.CB_bottnote_3:setSelected(false)
                      elseif eventType == ccui.CheckBoxEventType.unselected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            if  not  self.CB_bottnote_1:isSelected() and  not  self.CB_bottnote_3:isSelected() then
                              self.CB_bottnote_2:setSelected(true)
                            end
                     end
            end)
	self.CB_bottnote_3:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            self.createRoom_table.CB_bottnote_type=3
                            self.CB_bottnote_1:setSelected(false)
                            self.CB_bottnote_2:setSelected(false)
                      elseif eventType == ccui.CheckBoxEventType.unselected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            if  not  self.CB_bottnote_2:isSelected() and  not  self.CB_bottnote_3:isSelected() then
                              self.CB_bottnote_1:setSelected(true)
                            end
                     end
            end)
end
--积分选择
function createRoom:fun_checkbox_checkbox( ... )
	self.CB_score_1=self.bg:getChildByName("CB_score_1")
	self.CB_score_2=self.bg:getChildByName("CB_score_2")
	self.CB_score_1:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.createRoom_table.CB_score_type=1
                            self.CB_score_2:setSelected(false)
                      elseif eventType == ccui.CheckBoxEventType.unselected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.CB_score_1:setSelected(true)

                     end
            end)
	self.CB_score_2:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.createRoom_table.CB_score_type=2
                            self.CB_score_1:setSelected(false)
                      elseif eventType == ccui.CheckBoxEventType.unselected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            if  not  self.CB_score_1:isSelected() then
                              self.CB_score_2:setSelected(true)
                            end

                     end
            end)
end
--特殊选择
function createRoom:fun_checkbox_special( ... )
	self.CB_special_1=self.bg:getChildByName("CB_special_1")
	self.CB_special_2=self.bg:getChildByName("CB_special_2")
	self.CB_special_3=self.bg:getChildByName("CB_special_3")
	self.CB_special_1:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                           Util:all_layer_Sound("Audio_Button_Click")
                           self.CB_special_type1=1
                           self.createRoom_table.CB_special_type=self.CB_special_type1 .. self.CB_special_type2  .. self.CB_special_type3
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                            Util:all_layer_Sound("Audio_Button_Click")
                     	      self.CB_special_type1=0
                            self.createRoom_table.CB_special_type=self.CB_special_type1 .. self.CB_special_type2  .. self.CB_special_type3
                     end
            end)
	self.CB_special_2:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.CB_special_type2=1
                            self.createRoom_table.CB_special_type=self.CB_special_type1 .. self.CB_special_type2  .. self.CB_special_type3
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                          Util:all_layer_Sound("Audio_Button_Click")
                     	     self.CB_special_type2=0
                           self.createRoom_table.CB_special_type=self.CB_special_type1 .. self.CB_special_type2  .. self.CB_special_type3
                     end
            end)
	self.CB_special_3:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.CB_special_type3=1
                            self.createRoom_table.CB_special_type=self.CB_special_type1 .. self.CB_special_type2  .. self.CB_special_type3
                     elseif eventType == ccui.CheckBoxEventType.unselected then
                             Util:all_layer_Sound("Audio_Button_Click")
                     	      self.CB_special_type3=0
                           self.createRoom_table.CB_special_type=self.CB_special_type1 .. self.CB_special_type2  .. self.CB_special_type3
                     end
            end)
end
--坐庄选择
function createRoom:fun_checkbox_rules( ... )
	self.CB_rules_1=self.bg:getChildByName("CB_rules_1")
	self.CB_rules_2=self.bg:getChildByName("CB_rules_2")
	self.CB_rules_3=self.bg:getChildByName("CB_rules_3")
  
	self.CB_rules_1:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.createRoom_table.CB_rules_type=2
                            self.CB_rules_2:setSelected(false)
                            self.CB_rules_3:setSelected(false)
                      elseif eventType == ccui.CheckBoxEventType.unselected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.CB_rules_1:setSelected(true)
                            
                     end
            end)
	self.CB_rules_2:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.createRoom_table.CB_rules_type=3
                            self.CB_rules_1:setSelected(false)
                            self.CB_rules_3:setSelected(false)
                      elseif eventType == ccui.CheckBoxEventType.unselected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            if  not  self.CB_rules_1:isSelected() and  not  self.CB_rules_3:isSelected() then
                              self.CB_rules_2:setSelected(true)
                            end
                     end
            end)
	self.CB_rules_3:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.createRoom_table.CB_rules_type=1
                            self.CB_rules_1:setSelected(false)
                            self.CB_rules_2:setSelected(false)
                      elseif eventType == ccui.CheckBoxEventType.unselected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            if  not  self.CB_rules_1:isSelected() and  not  self.CB_rules_2:isSelected() then
                              self.CB_rules_3:setSelected(true)
                            end
                     end
            end)
end
function createRoom:fun_tuoguan( ... )
  self.CB_tuoguan=self.bg:getChildByName("CB_tuoguan")
  self.CB_tuoguan:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.createRoom_table.CB_tuoguan_type=1
                            
                      elseif eventType == ccui.CheckBoxEventType.unselected then
                            Util:all_layer_Sound("Audio_Button_Click")
                            self.createRoom_table.CB_tuoguan_type=2
                     end
            end)
end

function createRoom:onEnter()
      -- NotificationCenter:Instance():AddObserver("CreateRoom", self,
      --                  function()
                       	  
      --                 end)--
	 

      
end

-- 隐藏和显示没有创建房间的提示
function createRoom:visibleNohouseLabel(vis)
    self.CreateRoom:getChildByName("nouhouselabel"):setVisible(vis)
end


-- 删除指定的房间
function createRoom:deleteRoomById( id )
    if self.roomdata and #self.roomdata > 0 then
       local rindex = #self.roomdata
       for count =1, rindex do
           if self.roomdata[count].roomID == id then
              table.remove(self.roomdata, count)
              break
           end
       end
       self:flushHouseList({rooms = self.roomdata})
    end
end

-- 初始化我的房间号
local cheight = 170
function createRoom:flushHouseList(data)
    if not self.houseListView then
        local size = self.CreateRoom:getChildByName("house_list"):getContentSize()
        local posx, posy = self.CreateRoom:getChildByName("house_list"):getPosition()
        self.houseListView = ccui.ListView:create()
        self.houseListView:setDirection(ccui.ScrollViewDir.vertical)
        self.houseListView:setBounceEnabled(true)
        self.houseListView:setGravity(ccui.ListViewGravity.top)
        self.houseListView:setContentSize(cc.size(size.width + 5, size.height - 130))
        cheight = (size.height - 140) / 5
        self.houseListView:setPositionX(posx / 2 - 20)
        self.houseListView:setPositionY(posy / 2 - 140)
        self.CreateRoom:addChild(self.houseListView)
    end

    createRoom.currentlayerisflush = true
     
    -- 用于判断当前的房间是否存在
    local updatepreData = clone(self.roomdata)
    local pproomdata = updatepreData
    local firstcreate = false
    self.roomdata = {}
    print("传进来的房间信息  = ", json.encode(data))
    if data and data.rooms and #data.rooms > 0 then
       if self.roomdata and self.roomdata == #data.rooms then
          self.roomdata = data.rooms
          local function sortTime(r1, r2)
             return r1.createTime > r2.createTime
          end
          if #self.roomdata > 1 then
             table.sort(self.roomdata, sortTime )
          end
          for i,data in ipairs(self.roomdata) do
              local item = self.houseListView:getItem(i)
              if item then
                 local housecell = item:getChildByName("housecell")
                 if housecell and housecell.setData then
                    housecell:setData(data)
                    housecell:flushData()
                    if AllRequire.ui.HouseDetailView.detailLayer and AllRequire.ui.HouseDetailView.detailLayer.getRoomId then
                       local roomid        = AllRequire.ui.HouseDetailView.detailLayer:getRoomId()
                       local defaultroomid = housecell:getRoomId()
                       if roomid and defaultroomid and roomid == defaultroomid then
                          AllRequire.ui.HouseDetailView.detailLayer:setNum(self.roomdata[i]["nowCount"])
                       end
                    end
                 end
              end 
          end
          return 
       end
       self.roomdata = data.rooms
       if not updatepreData then
          updatepreData = clone(self.roomdata)
          firstcreate = data.rooms[1]
       end
       self.houseListView:removeAllItems()
       self:visibleNohouseLabel(false)
    else
       self.houseListView:removeAllItems()
       self.houseListView:refreshView()
       self:visibleNohouseLabel(true)
    end
    

    
    local nothasit = false
    -- self.houseListView:refreshView()
    if self.roomdata and #self.roomdata > 0 then
        local datas = {}
        local function sortTime(r1, r2)
             return r1.createTime > r2.createTime
        end
        if #self.roomdata > 1 then
           table.sort(self.roomdata, sortTime )
        end
        local tdata = {}
        for i = 1, #self.roomdata do
            hasit = false
            if updatepreData and #updatepreData > 0 then
                for roomIndex,room in ipairs(updatepreData) do
                    if self.roomdata[i].roomID == room.roomID then
                       hasit = true
                       break
                    end
                end
            end
            if not hasit and not nothasit then
               nothasit = self.roomdata[i]
            end
            local custom_button = require("src.app.layers.house_view.HouseListCell").new(self.roomdata[i], self)
            local layer = cc.LayerColor:create(cc.c4f(333,322,122,255))
            -- layer:setContentSize(cc.size(265, 104))
            custom_button:setPosition(cc.p(5, 5))
            if AllRequire.ui.HouseDetailView.detailLayer and AllRequire.ui.HouseDetailView.detailLayer.getRoomId then
               local roomid        = AllRequire.ui.HouseDetailView.detailLayer:getRoomId()
               local defaultroomid = custom_button:getRoomId()
               if roomid and defaultroomid and roomid == defaultroomid then
                  AllRequire.ui.HouseDetailView.detailLayer:setNum(self.roomdata[i]["nowCount"])
               end
            end
            custom_button:setAnchorPoint(cc.p(0,0))
            -- custom_button:addChild(layer,-1)
            custom_button:setContentSize(cc.size(265, 130))
            local custom_item = ccui.Layout:create()
            custom_item:setContentSize(cc.size(265, cheight))
            custom_button:setName("housecell")
            custom_item:addChild(custom_button)
            self.houseListView:addChild(custom_item)
        end
    end

    if nothasit then
       local tlayer = AllRequire.ui.HouseDetailView.createDetailLayer(nothasit)
       if tlayer then
          self:addChild(tlayer, 320)
       end
    -- elseif firstcreate and #updatepreData == 1 and pproomdata then
    --    self:addChild(AllRequire.ui.HouseDetailView.createDetailLayer(firstcreate),320)
    end
    self.houseListView:refreshView()
end

 



function createRoom:onExit_()
  -- -- print("什么意思啊——")
  -- if self.removeSelf then
  --    self:removeSelf()
  -- end
    --NotificationCenter:Instance():RemoveObserver("CreateRoom", self)
end


return createRoom




