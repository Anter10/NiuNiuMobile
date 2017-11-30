--region 监听类
--Author : zzx
--Date   : 2014/7/30
--此文件由[BabeLua]插件自动生成
NotificationCenter = {}

local Global_pairs = pairs
function NotificationCenter:new(o)  
    o = o or {}  
    setmetatable(o,self)  
    self.__index = self 
    
    return o  
end 

function NotificationCenter:Instance()  
	-- print("come in Instance")
    if self.instance == nil then  
        self.instance =  self:new()  
        self.instance.miNotificationList = {}
    end  
    return self.instance  
end

function NotificationCenter:AddObserver( aiNotificationID, aiObserver, aiHandler )
	if self:IsObserverHaveListenedNotification( aiNotificationID, aiObserver ) == true then
		return
	end
	
	if self.miNotificationList[aiNotificationID] == nil then
		local tObserverData = {}
		tObserverData.miObserver = aiObserver
		tObserverData.miHandler = aiHandler

		local tObserverDataList = {}
		table.insert( tObserverDataList, tObserverData )
		print(aiNotificationID)
		self.miNotificationList[aiNotificationID] = tObserverDataList
	else 
		local tObserverData = {}
		tObserverData.miObserver = aiObserver
		tObserverData.miHandler = aiHandler

		table.insert( self.miNotificationList[aiNotificationID], tObserverData )
	end
	return true
end

function  NotificationCenter:RemoveObserver( aiNotificationID, aiObserver )
	local index = 0
	if self.miNotificationList[aiNotificationID] ~= nil then
		for i=1, table.getn( self.miNotificationList[aiNotificationID] ) do
			if self.miNotificationList[aiNotificationID][i].miObserver == aiObserver  then
	 			index = i
			end
		end
    else
        return
	end
	if index ~= 0 then
		table.remove( self.miNotificationList[aiNotificationID], index )
	end
end
 
function NotificationCenter:PostNotification( aiNotificationID, aiData )
	-- print("come in postNotifaction  ", aiNotificationID)
	if self.miNotificationList[aiNotificationID] == nil then
		-- print(":nil")
		return
	end

	-- if aiNotificationID=="stop building animation" then
	-- 	print("PostNotifcation ：".. aiNotificationID )
 --  	end

	for i, observerData in Global_pairs( self.miNotificationList[aiNotificationID] ) do
		observerData.miHandler( observerData.miObserver, aiData )
		-- print(": not  nil")
	end
end

function NotificationCenter:IsObserverHaveListenedNotification( aiNotificationID, aiObserver )
	if self.miNotificationList[aiNotificationID] == nil then
		return false
	end
	for i, observerData in Global_pairs( self.miNotificationList[aiNotificationID] ) do
		if observerData.miObserver == aiObserver then
			return true
		end
	end
	return false
end

return NotificationCenter

--endregion
