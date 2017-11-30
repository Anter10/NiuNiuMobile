--
-- Author: Your Name
-- Date: 2017-08-11 20:27:44
--load 进度条
local excessiveLayer = class("excessiveLayer",function()
      return cc.Layer:create()
end)
local schedulerID =nil

function excessiveLayer:ctor()--
     --  定时器
       self.count_time=0

       self:registerScriptHandler(function (event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exitTransitionStart" then
            self:onExit()
        end
    end)

       
	  self:fun_init()
	  
	  
end

function excessiveLayer:fun_init( ... )
		self.excessiveLayer = cc.CSLoader:createNode("csb/excessiveLayer.csb")
        self:addChild(self.excessiveLayer)
        self.bg=self.excessiveLayer:getChildByName("bg")

        self.lodbar=self.bg:getChildByName("lodbar")
        self.lodbar:setPercent(0)
        self:open_update()	

end
function excessiveLayer:open_update()
 

     if self.schedulerID then
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    self.schedulerID=nil
  end
  local scheduler = cc.Director:getInstance():getScheduler()  
 
    self.schedulerID = scheduler:scheduleScriptFunc(function()  
       self:update() 
    end,0.01,false)   

end

function excessiveLayer:close_update()
    if self.schedulerID then
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    self.schedulerID=nil
   end 
end
--  所谓的定时器
function excessiveLayer:update()
      
      self.count_time=5+self.count_time
      self.lodbar:setPercent(self.count_time)

      if self.lodbar:getPercent() ==100 then

      	self:close_update()
      	
      	self:removeFromParent()
      end
end

function excessiveLayer:onExit()
  -- print("进入excessiveLayer:onExit ")
    self:close_update()
end

return excessiveLayer