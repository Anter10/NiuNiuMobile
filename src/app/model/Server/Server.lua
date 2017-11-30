Server = {}


--传输加密Key
MD5_KEY="PINLEGAME@4007007"


function Server:new(o)  
    o = o or {}  
    setmetatable(o,self)  
    self.__index = self 
    return o  
end 

function Server:Instance()  
    if self.instance == nil then  
        self.instance =  self:new()
        --self.url = "http://tank.g.catcap.cn/"
        self.login_url="http://60.205.5.22:33001/"
        self.writablePath = cc.FileUtils:getInstance():getWritablePath()
        self.timediff = 0

    end
    return self.instance
end

function Server:Destory()
   self.instance = nil
end

function Server:time()
   return os.time() - self.timediff
end

function Server:setTime(time)
   self.timestamp = time
end




--数据接口
--[[
    --command --命名的方法字符转，用于回调 以文档 functionname 值为准
    -- params --传输数据
]]
function Server:request_http(command , params)
     
    local login_url=self.login_url..command
 
    local xhr = cc.XMLHttpRequest:new() -- 新建一个XMLHttpRequest对象  
      xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON -- json数据类型  
      xhr:open("POST", login_url)-- POST方式  --.."/post"
      local function onReadyStateChange()  
        -- 显示状态码,成功显示200  
        -- labelStatusCode:setString("Http Status Code:"..xhr.statusText)  
        local response   = xhr.response -- 获得响应数据  
        local output = json.decode(response,1) -- 解析json数据  
       
        print("headers are")  
        table.foreach(output.headers,print)  
      end  
      local params_encoded = json.encode(params)
      -- 注册脚本方法回调  
      xhr:registerScriptHandler(function() self:on_request_finished_http(xhr,command) end)
      xhr:send(params_encoded)-- 发送请求  
end


  
function Server:on_request_finished_http(event , command)
    local code = event.statusText
        dump(code)
    if code ~= "200 OK" then
        -- 请求结束，但没有返回 200 响应代码
        -- self:show_float_message("服务器返回代码错误:" .. code)
        print("response status code : " .. code)
        return
    end
 
    self.data =output
    -- 调用回调方法
    local callback = loadstring("Server:Instance():" .. command .. "_callback()")
    callback()
end



--下载图片
function Server:request_pic(url,command,num, png)
    -- self.pic_url=url
    png = png 
    local turl = url
    if png then
       turl = png
    end
    printError("当前活动的图片在哪儿下载"..url)
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open("GET", url)
    xhr:registerScriptHandler(function() self:on_request_finished_pic(xhr,command,num,turl) end)
    xhr:send()
end

function Server:HttpSendpost( url ,data , func, notk )
    --生成数据
    local _param = data
    print("请求地址 = ",url)
    --  相关的请求回调设置
    local callfunc = func
    local posturl = url
    local postdata = data
    local postnotk = notk
    local request = cc.XMLHttpRequest:new()
    request.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    local function onReadyStateChange()
            if request.readyState == 4 and request.status == 200 then
               
               isguanbi = true
               local response = request.response
               -- print("response",response)
               local output = json.decode(response,1)    
               if output["st"] then
                  myseverTime = math.floor(tonumber(output["st"])/1000)   
               end    
               func(output)
            else
               local showtext = "网络请求错误，请重试。"
               print("什么意思啊啊")
               if postnotk then
                  Util:fun_Offlinepopwindow(showtext,cc.Director:getInstance():getRunningScene(),function (sender, eventType)
                        local function call()
                             self:HttpSendpost(posturl ,postdata , callfunc,postnotk)  
                        end
                        local call1 = cc.CallFunc:create(call)
                        local seq  = cc.Sequence:create(cc.DelayTime:create(2),call1 )
                        cc.Director:getInstance():getRunningScene():runAction(seq)

                  end)
               else
                  self:HttpSendpost(posturl ,postdata , callfunc,postnotk)  
               end
            end 
    end

    --  相关的请求设置 
    request:open("GET",url,true)
    request:registerScriptHandler(onReadyStateChange)
    --  开始请求
    request:send()
end

function Server:on_request_finished_pic(xhr , command,num,pic_url)
    
    local response = xhr.response
    -- dump(request)
    if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
                    print(xhr.response)
                    
                        dump(xhr.statusText)
                   
    else
       print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status)
        
        xhr:unregisterScriptHandler()
    end
    local dataRecv = response
    -- local fileObject = self.download_file_list[self.download_progress]
    -- dump(pic_url)
    local str = Util:sub_str(pic_url) 
    -- dump(str)   
    local file_path = str
    -- cc.FileUtils:getInstance():removeFile(file_path)
    print(file_path,"保存图片名称 = ", file_path, Util:isFileExist(file_path))
    if not Util:isFileExist(file_path) then
       local file = io.open(file_path, "w+b")
       if file then
          if file:write(dataRecv) == nil then
          -- self:show_error("can not save file : " .. file_path)
              print("can not save file")
              return false
          end
          file:flush()
          io.close(file)
       end
   end
    -- dump(pic_url)
    -- dump(command)
   NotificationCenter:Instance():PostNotification(command,{dex=num,url=pic_url})
end


--判断网络是否链接
-- function Server:NetworkStatus()
--         local is_network=true
--         if tonumber(network.getInternetConnectionStatus())==0 then --无网状态
--             print("当前网络不可用，请检查是否连接了可用的Wifi或移动网络")     

--             is_network=false
--         end

--         return is_network
-- end
--  游戏上线和非上线  开关
function Server:request_http_open(command , params)
     
    local login_url=command
 
    local xhr = cc.XMLHttpRequest:new() -- 新建一个XMLHttpRequest对象  
      xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON -- json数据类型  
      xhr:open("POST", login_url)-- POST方式  --.."/post"
      local function onReadyStateChange()  

        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
        
        -- else
            local response   = xhr.response -- 获得响应数据  
            local output = json.decode(response) -- 解析json数据  
           
            print("headers are",output) 
            local w_number=0
            dump(tonumber(output))
            dump(01)
            if tonumber(output) ==   01  then
               w_number=0
            elseif tonumber(output) ==   10 then
              w_number=1
            end
            LocalData:Instance():set_Gameswitch(w_number)
            NotificationCenter:Instance():PostNotification("switch")   
         end

      
        -- table.foreach(output.headers,print)  
      end  
    local params_encoded = json.encode(params)
      -- 注册脚本方法回调  
      xhr:registerScriptHandler(function() onReadyStateChange() end)
      xhr:send(params_encoded)-- 发送请求  
end

-- 强制热更非热更开关
function Server:request_http_version(command , params)
    local login_url="http://admin.sharkpoker.cn/index.php/Home/login/doupdate/equipment/"..tostring(device.platform).."/versions/"..VERSION
    dump(login_url)
    local xhr = cc.XMLHttpRequest:new() -- 新建一个XMLHttpRequest对象  
      xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON -- json数据类型  
      xhr:open("POST", login_url)-- POST方式  --.."/post"
      local function onReadyStateChange()  
        local response   = xhr.response -- 获得响应数据  
        -- response=Util:sub_url(response,"\n","")
               -- dump(response)
        if  response then
         local output = json.decode(response) -- 解析json数据  --json.encode(response)--
       
        dump(output)
        NotificationCenter:Instance():PostNotification("Version_Ref",{version=output})
        end
        
        ---------- table.foreach(output.headers,print)  
      end  
    local params_encoded = json.encode(params)
      -- 注册脚本方法回调  
      xhr:registerScriptHandler(function() onReadyStateChange() end)
      xhr:send(params_encoded)-- 发送请求  


end


