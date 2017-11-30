--
-- Author: Your Name
-- Date: 2017-08-08 14:22:18
--
--创建房间
local createRoom = class("createRoom",function()
      return cc.Layer:create()--cc.Scene:create()--
end)


function createRoom:ctor()--
	  self.createRoom_table={}
      self.createRoom_table.CB_innings_type=2  --局数选择
      self.createRoom_table.CB_bottnote_type=2  --底注选择
      self.createRoom_table.CB_score_type=2  --积分选择
      self.createRoom_table.CB_special_type=111  --特殊选择
      self.CB_special_type1=1  --特殊选择
      self.CB_special_type2=1  --特殊选择
      self.CB_special_type3=1  --特殊选择
      self.createRoom_table.CB_tuoguan_type=2
      self.createRoom_table.CB_rules_type=2  --坐庄选择
      self:fun_init()
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
        --  提交
        local createroom_bt=self.bg:getChildByName("createroom_bt")
        createroom_bt:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                   print("提交")
                   Util:all_layer_Sound("Audio_Button_Click")
                   dump(self.createRoom_table.CB_score_type)
                   local _num_tag=tostring(self.createRoom_table.CB_special_type) ..    tostring(self.createRoom_table.CB_bottnote_type)
                  
                   ServerWS:Instance():UserCreateRoomMsgReq(self.createRoom_table)
                   self:removeFromParent()
        end)
        --  返回
        local back=self.bg:getChildByName("back")
        back:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                   print("返回")
                   Util:all_layer_Sound("Audio_Button_Click")
                   self:removeFromParent()
        end)
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

function createRoom:onExit()
    --NotificationCenter:Instance():RemoveObserver("CreateRoom", self)
end


return createRoom