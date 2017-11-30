--
-- Author: Your Name
-- Date: 2017-08-12 16:27:20

--
-- Author: Your Name
-- Date: 2017-08-11 18:43:44 
--
--用倒计时
local countTime = class("countTime",function()
      return cc.Layer:create()
end)
local schedulerID =nil

function countTime:ctor(_type)--  时间  类型
	 
    dump(_type)
    --  抢庄  下注  配牛   结算   空白
    self._name_table={"请抢庄","请下注","请配牛","请抢庄","请抢庄",}
	  --   对应时间
    self._time_table={10,10,10,10}

    self.countTime = cc.CSLoader:createNode("csb/countTime.csb")
    self:addChild(self.countTime)
    self:setVisible(false)
    -- self:fun_init()

    self.sconde_time=0
end
function countTime:fun_init(_type)
          self:setVisible(true)

	        self.ct__type=N_USER_STATE[tostring(_type)]
       	   
           self.ct_time=self._time_table[self.ct__type]
           self.countTime_text=self.countTime:getChildByName("countTime_text")
           self.countTime_text:setString(self.ct_time)
           self.name_bg=self.countTime:getChildByName("name_bg")
           if self.ct__type==4  or   self.ct__type== 5 then
                self.name_bg:setVisible(false)
           else
                self.name_bg:setVisible(true)
           end
           self.name=self.name_bg:getChildByName("name")
           for i=1,#self._name_table do
             if self.ct__type==i then
                self.name:setString(self._name_table[i])
             end
             
           end

           self:open_update()

	   
end
function countTime:open_update()

      self:scheduleUpdateWithPriorityLua(function(dt)
        self:fun_update(dt) 
    end,1)
    -- local scheduler = cc.Director:getInstance():getScheduler()  
 
    -- schedulerID = scheduler:scheduleScriptFunc(function()  
    --    self:fun_update() 
    -- end,1,false)     
end
--  所谓的定时器
function countTime:fun_update(dt)
      
      self.sconde_time=self.sconde_time+dt
      if self.sconde_time < 1 then return end
       self.sconde_time=0 
      
      
      self.ct_time=self.ct_time-1

      if self.ct_time <0 then
         
          self:unscheduleUpdate()
          return
        -- self:close_update()
        print("发送时间")
      end
      self.countTime_text:setString(self.ct_time)
      
      if LocalData:Instance():get_sound()  and  self.ct_time <5  then
              Util:all_layer_Sound("game_timeto")
      end
      
end
function countTime:close_update()
    self:unscheduleUpdate()
    self:setVisible(false)
end

function countTime:onExit()
  print("进入excessiveLayer:onExit ")
    self:close_update()
  
end


return countTime