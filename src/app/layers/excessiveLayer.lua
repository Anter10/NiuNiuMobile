--
-- Author: Your Name
-- Date: 2017-08-11 20:27:44
--load 进度条
local excessiveLayer = class("excessiveLayer",function()
      return cc.Layer:create()
end)
local schedulerID =nil
excessiveLayer.excessiveLayer = nil
function excessiveLayer:ctor()--
       --  定时器
       print("那儿创建的habi层")
       self.count_time=0
       excessiveLayer.excessiveLayer = self
       self:enableNodeEvents()
	     self:fun_init()
end


function excessiveLayer.create()
     excessiveLayer.removeSelf()
     return excessiveLayer.new()
end

-- 移除当前的层
function excessiveLayer.removeSelf()
     if excessiveLayer.excessiveLayer and excessiveLayer.excessiveLayer.close_update then
        excessiveLayer.excessiveLayer:close_update()
        excessiveLayer.excessiveLayer:removeFromParent(true)
        excessiveLayer.excessiveLayer = nil
     end
end

function excessiveLayer:fun_init( ... )
		    self.excessiveLayer = cc.CSLoader:createNode("csb/excessiveLayer.csb")
        self:addChild(self.excessiveLayer)
        self.bg=self.excessiveLayer:getChildByName("bg")

        self.lodbar=self.bg:getChildByName("lodbar")
        self.lodbar:setPercent(0)
        print("那儿开启的更新")
        self:open_update()	
        -- excessiveLayer.removeSelf()
end

function excessiveLayer:open_update()
        if self.schedulerID then
           cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
           self.schedulerID=nil
        end
        local scheduler = cc.Director:getInstance():getScheduler()  
        self.schedulerID = scheduler:scheduleScriptFunc(function() 
             -- printError("那儿报错的啊啊啊啊啊啊啊a") 
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
      	 excessiveLayer.removeSelf()
      end
end


function excessiveLayer:onExit_()
    print("进入excessiveLayer:onExit ")
    self:close_update()
    excessiveLayer.excessiveLayer = nil
end

return excessiveLayer




