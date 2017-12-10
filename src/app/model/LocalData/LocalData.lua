LocalData = {}

function LocalData:new(o)  
    o = o or {}  
    setmetatable(o,self)  
    self.__index = self 
    self.schedulerID=nil
    -- 全局UPDATE刷新资源，等于同时实现心跳
    return o
end 

function LocalData:start_scheduler()
  if self.schedulerID then
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    self.schedulerID=nil
  end
  local scheduler = cc.Director:getInstance():getScheduler()  
 
    self.schedulerID = scheduler:scheduleScriptFunc(function()  
       self:updateSockt() 
    end,3,false)   

end

function LocalData:close_sched()
    if self.schedulerID then
       cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
       self.schedulerID=nil
    end
end



function LocalData:updateSockt()
  print("3秒走一次")
  dump(ServerWS:Instance().socket:getReadyState())
  if not hasInternet() or tonumber(ServerWS:Instance().socket:getReadyState())  ~= 1  then
     -- ServerWS:Instance():Destory()
     ServerWS:Instance():connect()
     if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(require("src.app.views.loadScene").new())
     end  
  else
     ServerWS:Instance():ClientTickMsg()
  end
  
end

function LocalData:Instance()  
    if self.instance == nil then  
	   self.instance =  self:new()
    end  
    return self.instance
end

function LocalData:Destory() 
    self.instance =  nil
end



require("app.model.LocalData.LocalGame")



