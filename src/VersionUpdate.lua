
     
VersionUpdate = class("VersionUpdate",function() return cc.Scene:create() end)
cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath())
local targetPlatform = cc.Application:getInstance():getTargetPlatform()

local partchar = "."

local precurversion = "2.0.3"

-- local curversion = "2.0.4"
local curversion = "2.0.6"

-- 游戏是否更新过
VersionUpdate.into = false

-- 对包含有特殊字符的字符串进行分割 返回分割后的数组
-- @str:         被分割的数组
-- @delim:  特殊字符
cc.exports.getStringArray = function(s, delim, needtonuber)
    if type(delim) ~= "string" or string.len(delim) <= 0 or not s or s == "" then
        return {}
    end
    local start = 1
    local t = {}
    while true do
    local pos = string.find(s,delim, start, true) -- plain find
        if not pos then
          break
        end
        local tnumber = string.sub (s, start, pos - 1) 
        if needtonuber then
           tnumber = tonumber(tnumber)
        end
        table.insert (t,tnumber )
        start = pos + string.len (delim)
    end
    local tnumber = string.sub (s, start)
    if needtonuber then
       tnumber = tonumber(tnumber)
    end
    table.insert (t,tnumber )
    return t
end

-- 比较两个版本的大小
-- 比较两个相同格式 相同分隔符号的字符串的大小 
-- @注意:   是第一个是否比第二个大
-- @str1:  第一个字符串
-- @str2:  第二个字符串
-- @party: 分隔符
-- 返回1 等于 返回true 大于
local function CTString( str1, str2, party, needtonumber )
     local sa1 = getStringArray(str1, party, needtonumber)
     local sa2 = getStringArray(str2, party, needtonumber)
      -- print("两个数字 = ",json.encode(sa1),json.encode(sa2))
     if #sa2 == 0 or #sa2 == 0 then
        return 0
     end
     if sa1[1] == sa2[1] and sa1[2] == sa2[2] and sa1[3] == sa2[3] then
        return 0
     elseif sa1[1] >= sa2[1] then
        print(sa1[1] > sa2[1], sa1[1] == sa2[1] and sa1[2] > sa2[2], sa1[1] == sa2[1] and sa1[2] == sa2[2] and sa1[3] > sa2[3] )
        if sa1[1] > sa2[1] then
           return true
        elseif sa1[1] == sa2[1] and sa1[2] > sa2[2] then 
           return true
        elseif sa1[1] == sa2[1] and sa1[2] == sa2[2] and sa1[3] > sa2[3] then
           return true
        end
        return false
     else
        return false
     end
end



function VersionUpdate:ctor( callback )
   self.gocallback = gocallback
    self:enableNodeEvents()
end

-- 更新指定的版本资源
function VersionUpdate:onEnter()
    Tools.hasnet = false
    local vvv1 = "1.0.1"
    local vvv2 = "1.0.2"
    VersionUpdate.into = true
    local stringstring = CTString(vvv2,vvv1,".",true)
    -- print("vvv1 和 vvv1比较大小 = ",stringstring)
    self.defuser       = cc.UserDefault:getInstance()
    local curusersversion = self.defuser:getStringForKey("versionofcode")
    self.issamenotupdate = false
    if curusersversion == "" or not curusersversion then
       self.issamenotupdate = true
       curusersversion = curversion
    end 
    
    self.isiosplatform = false
    if (cc.PLATFORM_OS_IPHONE == targetplatform) or (cc.PLATFORM_OS_IPAD == targetplatform) then
        self.isiosplatform = true
    end

    
   
    -- 读取已经更新的资源目录
    self.readdata = require("src.app.commonManager.FileManager").readFile("updatehasupdates.json")

    print("保存的更新信息  =" , json.encode(self.readdata ))

    print("本地存储的版本信息  = ", curusersversion, type(curusersversion))
    self:addChild(require("src.app.layers.touchlayer").create(), -1)
    self.layer = cc.Layer:create()
    self:addChild(self.layer,30)
    if not self.hasupdates then
        self.hasupdates = {}
    end
    self.curversion     = nil
    self.versions       = {}
    self.hasupdatefiles = false
   

    self.callback = function()
        AllRequire.requireAll()
        if cc.Director:getInstance():getRunningScene() then
           cc.Director:getInstance():replaceScene(require("src.app.views.loadScene").new())
        end
        if self.gocallback then
           self:gocallback()
        end
    end

     
    

    -- 开始Http请求资源目录
    local function getVersionData(data)
       
    end


    self.allversions = {}
    -- 是否需要更新
    self.needupdate  = true
    local function  dealdata(data) 
          print("热更新的资源目录数据 = ",json.encode(data))
         
          -- 上一个版本是否更新完成
          local upperversionfinish = true
          -- self.defuser:setStringForKey("versionofcode","1.0.0")
          -- 处理版本的数据信息
          if data and type(data) == "table" and #data ~= 0 then
             local uperversion = nil
           
             if self.readdata then
                for version,v in pairs(self.readdata) do
                    uperversion = version
                end   
             end
             
             -- print("上一次更新的版本 = ", uperversion)
             
             for i,version in ipairs(data) do
               local tdata     = {}
               tdata.version   = version.version
               tdata.zipres    = {}

               local updateres = getStringArray(version.resource,"#")

               -- 判断是否和上一次更新的版相同 相同的话 判断更新到了第几个zip文件
               local upperindex = 0
               if uperversion and uperversion ~= "" then
                  upperindex = #self.readdata[uperversion]
               end

               

               if updateres and type(updateres) == "table" and #updateres > 0  then 
                  for kvi,kv in ipairs(updateres) do
                       local canadd = true
                       if upperindex and kvi <= upperindex and uperversion == tdata.version and self.issamenotupdate then
                          canadd = false
                          upperversionfinish = false
                       end
                       -- print(kvi,"canaddcanadd = ",uperversion, canadd , upperindex)
                       if canadd then
                           local trdata = getStringArray(kv,"__")
                           local rdata  = {}
                           rdata.path   = trdata[1]
                           rdata.zip    = trdata[2]
                           rdata.url    = version.url
                           rdata.compel    = version.compel
                           rdata.version   = version.version 
                           tdata.zipres[#tdata.zipres + 1] = rdata
                       end
                   end
               end 
               if tdata.zipres and type(tdata.zipres) == "table" and #tdata.zipres > 0 then
                  self.allversions[#self.allversions + 1] = tdata
               end
             end
          end


          self.hotupdate = cc.AssetsManager:new():getVersion()
          
          print("检查后的更新信息  = ",json.encode(self.allversions))
          if #self.allversions  > 0 then
             -- 得到服务器端的最大版本
             self.maxversion    = self.allversions[#self.allversions].version
             self.minversion    = self.allversions[1].version
            
             local usersversion = self.defuser:getStringForKey("versionofcode")
             
             -- print("版本比较 = ", curusersversion, self.maxversion)
             local curversion   = CTString(curusersversion, self.maxversion, partchar, true)
             local userversion  = false
             
           



             -- 最开始的更新节点
             self.startversion  = curusersversion
             if usersversion and #getStringArray(usersversion,partchar) == 3 then
                local uam       = CTString(usersversion, self.maxversion, partchar, true)
                local uac       = CTString(self.maxversion, curusersversion,partchar, true)
                print(usersversion, self.maxversion,"uam uac = ", uam, uac)
                if uam and uac then
                   self.needupdate  = false 
                end
                self.startversion = usersversion
             end
             -- print(self.maxversion,self.startversion, "usersversion1 - ",usersversion)
             local hostversion = false
             if self.hotupdate and self.hotupdate ~= "" then
                hostversion       = CTString(hostversion, self.maxversion, partchar, true)
                local uah         = CTString(self.hotupdate, self.startversion, partchar, true)
                if uah then
                   self.startversion = self.hotupdate
                end
             end
            
             -- 最后判断从哪个版本开始更新
             local okversion = CTString(self.startversion, self.minversion, partchar, true)
             print(self.minversion,self.startversion, "usersversion2 - ",self.hotupdate,okversion)
             if not okversion then
                self.startversion = self.minversion
             end
              -- print(self.startversion, "usersversion3 - ",self.minversion)


             -- 得到当前存储的更新版本信息和服务器端端版本信息比较
             


             -- 最终需要更新的文件
             self.finalupdateres = {}
             -- 如果服务器端的版本大于本地的版本相同 不需要更新
             -- 判断当前是否需要更新
             if not self.needupdate and upperversionfinish then
                -- print("当前不需要更新")
                if self.callback then
                   self:callback()
                end
                self:removeFromParent(true)
                return 
             else
                self.needupdate = true
                -- 找出最终需要更新的文件
                for i, res in ipairs(self.allversions) do
                    local tstr = CTString( res.version,self.startversion, partchar, true)
                    -- print(tstr, "找出最后处理的版本 = ",self.startversion, res.version)
                  if tstr then
                       self.finalupdateres[#self.finalupdateres + 1] = res
                  end
                end

                -- 却掉每个版本中存在的相同的资源
                local tfinalres = clone(self.finalupdateres)
                local removemsg = {}
                -- print(self.startversion,"处理的数据  = ",json.encode(tfinalres))
                for tfresi,tfres in ipairs(tfinalres) do
                    for ti,tv in ipairs(tfres.zipres) do
                      for frei,fres in ipairs(self.finalupdateres) do
                          for fi,fv in ipairs(fres.zipres) do
                              local str = CTString(tfres.version,fres.version, partchar, true)
                              if tv.path == fv.path and tv.zip == fv.zip and str == true then
                                 local tdata = {}
                                 tdata.version = fres.version
                                 tdata.key     = fi
                                 local hasit   = false
                                 for tti,ttv in ipairs(removemsg) do
                                     if ttv.version == tdata.version and ttv.key == tdata.key then
                                        hasit   = true
                                        break
                                     end
                                 end
                                 if not hasit then
                                    removemsg[#removemsg + 1] = tdata 
                                 end
                              end
                           end
                        end
                    end
                end

                -- 删除多余的重复资源
                local groupremovemsg = {}
                for i,keys in ipairs(removemsg) do
                    if not groupremovemsg[keys.version] then
                       groupremovemsg[keys.version] = {}
                    end
                    groupremovemsg[keys.version][#groupremovemsg[keys.version] + 1] = keys.key
                end

                for version,keys in pairs(groupremovemsg) do
                  for ti,tf in ipairs(self.finalupdateres) do
                      if tf.version == version then
                         for i,key in ipairs(keys) do
                             for zkey,v in ipairs(tf.zipres) do
                                 if zkey == key then
                                    tf.zipres[key] = 0
                                 end
                             end
                         end
                      end
                   end
                end
                -- 在此处理所有版本信息
                for i,resv in ipairs(self.finalupdateres) do
                    local tcount = 0
                    for i,v in ipairs(resv.zipres) do
                        if not tonumber(v) then
                           tcount = tcount + 1
                        end
                    end
                    -- 需要更新的资源总个数
                    resv.count = tcount
                    -- 版本包含的资源总个数
                    resv.num   = #resv.zipres
                end
             end
          end
          -- 确定开始资源更新的下标 和 开始更新的资源下标
          -- 版本下标
          self.updateversionindex     = 0
          -- 版本下的资源下标
          self.curversionupdateindex  = 0
          -- 已经更新的资源
          self.hasupdates             = {}
          -- 当前正在更新的版本
          self.curversion             = self.startversion

          self:initUpdateParam()
          print(json.encode(self.curversionupdateres),self.updateversionindex,self.curversionupdateindex,"222最终需要更新的数据资源数据  =    ",json.encode(self.finalupdateres))
          if self.finalupdateres and #self.finalupdateres > 0 then
             local compel = false
             for k,verres in pairs(self.finalupdateres) do
                 for dataindex,data in ipairs(verres.zipres) do
                    if type(data) == "table" and data.compel and tonumber(data.compel) == 1 then
                       compel = data
                       break
                    end
                 end
             end
             if compel then
                self:addCSB()
                if self.isiosplatform then
                   if self.callback then
                      self:callback()
                   end
                   self:removeFromParent(true)
                else
                    -- print("当前的版本数据 = = ",json.encode(compel))
                    self.defuser:setStringForKey("versionofcode","")
                    local showtext = "又有新的游戏版本更新了,请您下载新版本，谢谢！"
                    self.ulabel:setText(showtext)
                    self.apkurl = compel.url.."/"..compel.path..compel.zip
                    Util:fun_Offlinepopwindow(showtext,self,function (sender, eventType)
                         -- cc.Director:getInstance():endToLua()
                         -- local closecall = loadstring("cc.Director:getInstance():end()")
                         cc.Application:getInstance():openURL(self.apkurl)
                         -- closecall()
                         os.exit()
                    end)
                end
             else
                local function call()
                    self:addCSB()
                    self:startUpdate()
                end
                local call = cc.CallFunc:create(call)
                local seq  = cc.Sequence:create(cc.DelayTime:create(0.5), call)
                self:runAction(seq)
             end
          else
             if self.callback then
                self:callback()
             end
             self:removeFromParent(true)
          end
          print(json.encode(self.curversionupdateres),self.updateversionindex,self.curversionupdateindex,"最终需要更新的数据资源数据  =    ",json.encode(self.finalupdateres))
    end
    local support = false

    if (cc.PLATFORM_OS_ANDROID == targetplatform) or (cc.PLATFORM_OS_MAC == targetplatform) or Tools.iscompanyipa then -- (cc.PLATFORM_OS_IPHONE == targetplatform) or (cc.PLATFORM_OS_IPAD == targetplatform) or 
        support = true
    end
    
    print(targetplatform, "222当前的状态 = ",support )
    
    if support then
       Server:Instance():HttpSendpost("http://admin.sharkpoker.cn/home/login/app_hot_update?version="..tostring(curusersversion).."&game="..Tools.Channel().updatename.."&test="..tostring(Tools.isceshi) ,data, dealdata, true)
    else
       if self.callback then
          self:callback()
       end
       local function call()
           self:removeFromParent(true)
       end
       local call = cc.CallFunc:create(call)
       local seq  = cc.Sequence:create(cc.DelayTime:create(0.2), call)
       self:runAction(seq)
    end
end

 

-- 得到跟新的资源数据
function VersionUpdate:getUpdateRes( verindex, curindex )
    if self.finalupdateres and type(self.finalupdateres) == "table" and #self.finalupdateres > 0 then
        self.curversionupdateres = self.finalupdateres[verindex].zipres[curindex]
        return self.curversionupdateres
    end
end

-- 初始化更新参数
function VersionUpdate:initUpdateParam()
           if self.finalupdateres and #self.finalupdateres > 0 then
               for i,res in ipairs(self.finalupdateres) do
                  if res.count > 0 and i > self.updateversionindex then
                     self.updateversionindex     = i
                     for i,v in ipairs(res.zipres) do
                         if not tonumber(v) then
                            self.curversionupdateindex = i
                            self.curversion = res.version
                            break
                         end
                     end
                     break
                  end
              end
          end
end

-- 更新资源的具体逻辑
function VersionUpdate:startUpdate()
    local function getRgx(data) 
       
    end
    
    local barlength  = 1001
    local startpx    = 125

    -- 错误的四中信息
    local function errorCall(code)
      print("code code = ",code)
      -- 网络
        if code == cc.ASSETSMANAGER_NO_NEW_VERSION then
           print("没有新版本")
        -- 不能解压
        elseif code == cc.ASSETSMANAGER_UNCOMPRESS then
        -- 开始新的更新
        else 
           -- 删除旧版本 开始新的更新
           getRgx(self:getUpdateRes(self.updateversionindex,self.curversionupdateindex)):deleteVersion()
           -- 检查有没有更新
           getRgx(self:getUpdateRes(self.updateversionindex,self.curversionupdateindex)):checkUpdate()
        end
    end

    -- 更新过程
    local  function updateProgress(percent)
        if not self.percent then
           self.percent = 0
        end

        if percent < self.percent then
           percent = self.percent
        end
        local tpox = startpx + (percent / 100) * barlength
        print("当前的更新进度 ＝ ",json.encode(self.updateres))
        if percent == 100 then
           if not self.hasupdates[self.curversion] then
              self.hasupdates[self.curversion] = {}
           end
           self.hasupdates[self.curversion][#self.hasupdates[self.curversion] + 1] = self.updateres
           table.sort(self.hasupdates)
        else
            self.ulabel:setText("更新进度: "..tostring(percent).."%")
            self.layer:setPositionX(-10)
        end
        self.percent = percent
        if percent > 2  then
           self.upbar:setPercent(percent)
        end
    end
     
    local function successCall()
        self.percent = 0
        self.hotupdate:deleteVersion()
        
        self.upbar:setPercent(self.percent)
        -- 每次成功都保存已经更新了的资源列表
        
        require("src.app.commonManager.FileManager").writePath("updatehasupdates.json",json.encode(self.hasupdates))
        print(self.updateversionindex,self.curversionupdateindex, self.curversion, " 资源  ",json.encode(self.hasupdates), "更新成功")
        -- 如果当前版本更新完成 判断是否还有下一个版本需要更新
        if self.curversionupdateindex == self.finalupdateres[self.updateversionindex].num then
           -- 如果还有继续更新 没有的话 更新完成  进行其他操作
           if self.updateversionindex < #self.finalupdateres then
              self:initUpdateParam()
              self.defuser:setStringForKey("versionofcode",self.finalupdateres[self.updateversionindex].version)
              getRgx(self:getUpdateRes(self.updateversionindex,self.curversionupdateindex)):checkUpdate()
           else
              if self.callback then
                 self:callback()
              end
              self.defuser:setStringForKey("versionofcode",self.finalupdateres[self.updateversionindex].version)


              self:removeFromParent(true)

           end
        else
           for i,res in ipairs(self.finalupdateres[self.updateversionindex].zipres) do
               if not tonumber(res) and i > self.curversionupdateindex then
                  self.curversionupdateindex = i
                  break
               end
           end
           self.defuser:setStringForKey("versionofcode",self.finalupdateres[self.updateversionindex].version)
           getRgx(self:getUpdateRes(self.updateversionindex,self.curversionupdateindex)):checkUpdate()
        end 
        
    end
    
    -- 开始热更新
    getRgx = function(data)
            -- 获得更新的包的路径 和包的名称
            local savePath = self:getSavePath()..data.path
            if not cc.FileUtils:getInstance():isFileExist(savePath) then
                cc.FileUtils:getInstance():createDirectory(savePath)
            end
            self.updateres = data
            cc.FileUtils:getInstance():addSearchPath(savePath)


            local respath = data.url.."/"..data.path..data.zip
            printError("热更新的目录 = "..respath)
            local verpath = "http://admin.sharkpoker.cn/home/login/gethtml?game=niuniu"
            print(savePath,"更新信息 = ",respath, verpath)
            self.hotupdate = cc.AssetsManager:new(respath,verpath,savePath)
            self.hotupdate:retain()
            -- print("存储路径 = ",self.hotupdate:getStoragePath())
            self.hotupdate:setDelegate(errorCall, cc.ASSETSMANAGER_PROTOCOL_ERROR)
            self.hotupdate:setDelegate(updateProgress, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
            self.hotupdate:setDelegate(successCall, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
            self.hotupdate:setConnectionTimeout(15)
            return self.hotupdate
    end
    
    -- 热更新开始
    getRgx(self:getUpdateRes(self.updateversionindex,self.curversionupdateindex)):checkUpdate()
end

function VersionUpdate:getSavePath()
    local writePath = cc.FileUtils:getInstance():getWritablePath()
    local savePath = writePath
    if not cc.FileUtils:getInstance():isFileExist(savePath) then
        cc.FileUtils:getInstance():createDirectory(savePath)
    end

    return savePath
end


function VersionUpdate:addCSB()
    self.csblayer = cc.CSLoader:createNode("csb/UpdateLayer.csb")
    ccui.Helper:doLayout(self.csblayer)
    self:addChild(self.csblayer)

    -- 判断当前的渠道包
    if Tools.currentchannelid == Tools.allchannel[2] then
       self.csblayer:getChildByName("n_logo_2"):setTexture(Tools.Channel().logo)
    end
    self.ulabel = self.csblayer:getChildByName("ulabel")
    self.upbar  = self.csblayer:getChildByName("ldd"):getChildByName("lb")
    self.upbar:setPercent(0)
end


VersionUpdate.show = function(callback)
    local dllayer = VersionUpdate.new(callback)
    return dllayer
end

return VersionUpdate
