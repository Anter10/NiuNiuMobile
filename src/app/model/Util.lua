Util = {}
_share_num=1





function Util:CenterNodeInParent(node, use_boundbox)
   local parent = node:getParent()
   local size = parent:getContentSize()
   if (use_boundbox) then
      size = parent:getCascadeBoundingBox()
   end
   node:setPosition(size.width / 2, size.height / 2)
end




-- 除头尾空格
function Util:trim (s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

-- 除头尾空格
function Util:sub_str(s,parm,parm1)
  parm=parm or "/"
  parm1=parm1 or ":"
  local str=string.gsub(s, "/", "")
  str=string.gsub(str, ":", "")

  str=cc.FileUtils:getInstance():getWritablePath().."down_pic/"..str
  return str 
end

--拆分字符串返回表
function Util:lua_string_split(str, split_char)      
 local sub_str_tab = {};  
 while (true) do          
 local pos = string.find(str, split_char);    
 if (not pos) then              
  local size_t = table.getn(sub_str_tab)  
  table.insert(sub_str_tab,size_t+1,str);  
  break;    
 end  
   
 local sub_str = string.sub(str, 1, pos - 1);                
 local size_t = table.getn(sub_str_tab)  
 table.insert(sub_str_tab,size_t+1,sub_str);  
 local t = string.len(str);  
 str = string.sub(str, pos + 1, t);     
 end      
 return sub_str_tab;  
end  



function Util:FormatTime(orginSecond)
   local d = orginSecond
   local h = math.floor(d/3600)
   local m = (d - h * 3600) / 60
   local s = (m - math.floor(m)) *60
   local hour = math.floor(h)
   if (hour < 10) then
	  hour = '0' .. hour
   end
   local minutes = math.floor(m)
   if (math.abs(minutes) < 10) then
	  minutes= '0' .. math.abs(minutes)
   end
   local second = math.floor(s)
   if (math.abs(second) < 10) then
	  second = '0' .. math.abs(second)
   end
   return string.format("%sh%sm%ss", hour, minutes, second)
end

-- 冒号格式时间显示
function Util:FormatTime_colon(orginSecond)

   local d = tonumber(orginSecond)
   local day  = math.floor(d/60/60/24)
   local h = math.floor((d/60/60)%24)
   local m = (d/60)%60
   local s = d%60
   local hour = math.floor(h)
   if (hour < 10) then
    hour = '0' .. hour
   end
   local minutes = math.floor(m)
   if (math.abs(minutes) < 10) then
    minutes= '0' .. math.abs(minutes)
   end
   local second = math.floor(s)
   if (math.abs(second) < 10) then
    second = '0' .. math.abs(second)
   end
    local _table={day.."天",hour.."小时",minutes.."分",second.."秒"}
     dump(_table)
   return _table--string.format("%s:%s:%s", hour, minutes, second)
end

-- 字符串拆成字符（中文）
function Util:UTF8ToCharArray(str)
   -- local UTF8ToCharArray = function(str)
   local charArray = {};
   local iStart = 0;
   local strLen = str:len();

   local function bit(b)
     return 2 ^ (b - 1);
   end

   local function hasbit(w, b)
     return w % (b + b) >= b;
   end

   local checkMultiByte = function(i)
     if (iStart ~= 0) then
         charArray[#charArray + 1] = str:sub(iStart, i - 1);
         iStart = 0;
     end        
   end
    
   for i = 1, strLen do
     local b = str:byte(i);
     local multiStart = hasbit(b, bit(7)) and hasbit(b, bit(8));
     local multiTrail = not hasbit(b, bit(7)) and hasbit(b, bit(8));

     if (multiStart) then
         checkMultiByte(i);
         iStart = i;
         
     elseif (not multiTrail) then
         checkMultiByte(i);
         charArray[#charArray + 1] = str:sub(i, i);
     end
   end

   -- process if last character is multi-byte
   checkMultiByte(strLen + 1);

   return charArray;
end

-- 冒号格式时间显示
function Util:FormatTime_colon_bar(_time)

   local d = _time
   local day  = math.floor(d/60/60/24)
   local h = math.floor((d/60/60)%24)
   local m = (d/60)%60
   local s = d%60
   local hour = math.floor(h)
   if (hour < 10) then
    hour = '0' .. hour
   end
   local minutes = math.floor(m)
   if (math.abs(minutes) < 10) then
    minutes= '0' .. math.abs(minutes)
   end
   local second = math.floor(s)
   if (math.abs(second) < 10) then
    second = '0' .. math.abs(second)
   end
    local _table={day..":",hour..":",minutes..":",second}
    -- dump(_table)
   return string.format("%s:%s:%s", hour, minutes, second)
end
-- 冒号格式时间显示
function Util:FormatTime_colon(orginSecond)

   local d = orginSecond
   local day  = math.floor(d/60/60/24)
   local h = math.floor((d/60/60)%24)
   local m = (d/60)%60
   local s = d%60
   local hour = math.floor(h)
   if (hour < 10) then
    hour = '0' .. hour
   end
   local minutes = math.floor(m)
   if (math.abs(minutes) < 10) then
    minutes= '0' .. math.abs(minutes)
   end
   local second = math.floor(s)
   if (math.abs(second) < 10) then
    second = '0' .. math.abs(second)
   end
    local _table={day.."天",hour.."小时",minutes.."分",second.."秒"}
    -- dump(_table)
   return _table--string.format("%s:%s:%s", hour, minutes, second)
end


function Util:FormatTime_colon_bar_time(_time)

   local d = _time
   local day  = math.floor(d/60/60/24)
   local h = math.floor((d/60/60)%24)
   local m = (d/60)%60
   local s = d%60
   local hour = math.floor(h)
   if (hour < 10) then
    hour = '0' .. hour
   end
   local minutes = math.floor(m)
   if (math.abs(minutes) < 10) then
    minutes= '0' .. math.abs(minutes)
   end
   local second = math.floor(s)
   if (math.abs(second) < 10) then
    second = '0' .. math.abs(second)
   end
    local _table=day*24*60 + hour*60 +minutes
    -- dump(_table)
   return  _table--string.format("%s:%s:%s", hour, minutes, second)
end

-- 字符串拆成字符（中文）
function Util:UTF8ToCharArray(str)
   -- local UTF8ToCharArray = function(str)
   local charArray = {};
   local iStart = 0;
   local strLen = str:len();

   local function bit(b)
     return 2 ^ (b - 1);
   end

   local function hasbit(w, b)
     return w % (b + b) >= b;
   end

   local checkMultiByte = function(i)
     if (iStart ~= 0) then
         charArray[#charArray + 1] = str:sub(iStart, i - 1);
         iStart = 0;
     end        
   end
    
   for i = 1, strLen do
     local b = str:byte(i);
     local multiStart = hasbit(b, bit(7)) and hasbit(b, bit(8));
     local multiTrail = not hasbit(b, bit(7)) and hasbit(b, bit(8));

     if (multiStart) then
         checkMultiByte(i);
         iStart = i;
         
     elseif (not multiTrail) then
         checkMultiByte(i);
         charArray[#charArray + 1] = str:sub(i, i);
     end
   end

   -- process if last character is multi-byte
   checkMultiByte(strLen + 1);

   return charArray;
end
-- 判断是否有敏感词
function Util:isExistSensitiveWord(str)
  local sensitive_csv = LocalConfig:Instance():get_table("sensitiveWord")
  for i,v in ipairs(sensitive_csv) do
    local begin_, end_ = string.find(str, v.mask_word)
    if begin_ ~= nil then
      return true
    end
  end
  return false
end

-- 替换敏感词
function Util:filterSensitiveWord(str)
  local sensitive_csv = LocalConfig:Instance():get_table("sensitiveWord")
  local text = str
  for i,v in ipairs(sensitive_csv) do
    text = string.gsub(text, v.mask_word, "**")
  end
  return text
end

--是否下载成功
function Util:isFileExist(_path)
 
    if cc.FileUtils:getInstance():isFileExist(_path) then
       return _path
    end
    return nil
end

function Util:removeDirectory(path)
   local path = cc.FileUtils:getInstance():getWritablePath() .. path .. "/"
   cc.FileUtils:getInstance():removeDirectory(path)
end



function Util:file_createDic(_path)
    
    os.execute("mkdir -p \"" .. _path .. "\"")
   return _path
end 


-- 删除目录
function Util:file_delete(_path)
        -- 设置SD卡路径
        os.execute("rm -rf -p \"" .. _path .. "\"")
end 




function Util:dumpTexture()
        print("\n___________________TextureData__________________________\n")
        print(cc.Director:getInstance():getTextureCache():getCachedTextureInfo())
        print("\n___________________TextureData__________________________\n")
end

function Util:scene_control(scene)
        local str_scene="app.scenes."..scene
        
        --display.replaceScene(cc.TransitionProgressInOut:create(0.3, require(str_scene):new()))
        display.replaceScene(require(str_scene):new())
end
function Util:scene_controlid(scene,params)
        local str_scene="app.scenes."..scene
        display.replaceScene(require(str_scene).new(params))-- （.与：区别）
end



function Util:tableLength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end
--随机数
function Util:rand(  )
       return math.random(1000,9999)
end
function Util:getdays(  )
            local year,month = os.date("%Y", os.time()), os.date("%m", os.time())+1 -- 正常是获取服务器给的时间来算
            local dayAmount = os.date("%d", os.time({year=year, month=month, day=0})) -- 获取当月天数
            return  dayAmount
end



--分享相关
--截屏功能
function Util:captureScreen()
    
    -- local is_succ=false
        local fileName = cc.FileUtils:getInstance():getWritablePath().."down_pic/printScreen" ..  _share_num ..  ".png"
        
        local glView = cc.Director:getInstance():getOpenGLView()
        local frameSize = glView:getFrameSize()
        local tempWidth = frameSize.width
        local tempHeight = frameSize.height
        local scaleX = glView:getScaleX()
        local scaleY = glView:getScaleY()
        glView:setFrameSize(display.width*scaleX,display.height*scaleY)
        -- glView:setFrameSize(tempWidth,tempHeight)
    

    
        print("---分享----",display.width*scaleX,display.height*scaleY,scaleX,scaleY)
          if device.platform=="android" then
            fileName= "/sdcard/printScreen"   ..  _share_num ..  ".png"
          else
            cc.FileUtils:getInstance():removeDirectory(fileName)
          end
           
           -- 截屏 
           cc.utils:captureScreen(function(succeed, outputFile)  
               if succeed then  
                  -- local spr=display.newSprite(fileName)
                  -- spr:setPosition(display.cx, display.cy)
                  -- cc.Director:getInstance():getRunningScene():addChild(spr, 11)
                   print("成功提示",outputFile)  
               else  
                   cc.showTextTips("截屏失败")  
               end  
           end, fileName)  

           -- print("------分享提示222",fileName)
      return fileName
end

function Util:share_content(troominfo)
  local roomInfo = LocalData:Instance():get_RoomInfo()
  if troominfo then
     roomInfo = troominfo
  end
  local str_content=PARMS_A[roomInfo.param_a]..PARMS_C[roomInfo.param_c]..PARMS_B[roomInfo.param_b]..PARMS_D[roomInfo.param_d]
  if roomInfo.param_e==0 then
    str_content=str_content..PARMS_E[2]
  else
    str_content=str_content..PARMS_E[1]
  end

  str_content=str_content.."快点加入,一起斗起来吧！！！"
  print("分享邀请内容----",roomInfo.param_a,roomInfo.param_b,roomInfo.param_e,str_content)
   return str_content

end
--分享功能
function Util:share(type_, paytype, tpath, roominfo)
    
    local sheredata=LocalData:Instance():get_ShareInfoMsgRes()
    -- if not sheredata then return end
   -- local  out_pic=Util:captureScreen()
  
   local path="http://texas-cdn.oss-cn-beijing.aliyuncs.com/web/niuniu.jpg"
   local title=Tools.Channel().name
   local content= Tools.Channel().name.."，惊险好玩"
   local openid="111"
   if sheredata and sheredata.content then
     content=sheredata.content
   end
   if sheredata and sheredata.pictureurl then
     path=sheredata.pictureurl
   end

   if type_ then
     title="【"..Tools.Channel().name.."】房号:"..tostring(type_)
     openid=tostring(type_)
     content=Util:share_content(roominfo)
     path=Util:sub_str("http://texas-cdn.oss-cn-beijing.aliyuncs.com/web/niuniu.jpg")
   end
   
   -- dump(sheredata.content)
   -- dump(sheredata.pictureurl)

   if  not type_  then
     path =cc.FileUtils:getInstance():getWritablePath().."down_pic/printScreen" ..  _share_num ..  ".png"
     if device.platform=="android" then
          path= "/sdcard/printScreen"   ..  _share_num ..  ".png"
          -- content="火爆朋友圈在线约局牛牛游戏"
      end
      title=""--"【掌间牛牛】房号:"..tostring(type_)
      content=""--Util:share_content()
   end
   if tpath then
      path = tpath
   else
      _share_num=_share_num+1
   end
   paytype = paytype or ""
  
   print("分享提示------",path,content,title,openid)
   local share=cc.UM_Share:createWithShare(path,title,paytype..content,openid)
   share:setPosition(display.cx, 0)
   share:addTo(cc.Director:getInstance():getRunningScene(),1000)
   return share
end


-- --读取json 文件
function Util:read_json(path_json)

  local file_path=path_json
 
  -- if device.platform=="mac" then
  --   file_path=cc.FileUtils:getInstance():getWritablePath()..path_json
  -- end
  local fileStr = cc.HelperFunc:getFileData(file_path)
  -- dump(fileStr)
  local fileData = json.decode(fileStr)
  return fileData

end

--去除json 括号
function Util:remove_json_str(pathname)
  string.gsub(pathname, "%b()", "")
end

--日期转成时间戳
function Util:dateTotimestamp(birthday)
  local secondOfToday = os.time({day=birthday.day, month=birthday.month,
    year=birthday.year, hour=1, minute=0, second=0})

  dump(secondOfToday)
  return secondOfToday
end
--  增加光标
--  增加光标
function Util:function_keyboard(_parent,target,font_size)
        local alert = ccui.Text:create()
        alert:setString("|")
        -- alert:setFontName("png/chuti.ttf")
        local _guangbiao_x=target:getPositionX()
        alert:setPosition(target:getPositionX(),target:getPositionY()+5)
        alert:setFontName(font_TextName)
        alert:setFontSize(35)
        alert:setColor(cc.c3b(0, 0, 0))
        _parent:addChild(alert)

       

        alert:setVisible(false)

        local function textFieldEvent(sender, eventType)  
              if eventType == ccui.TextFiledEventType.attach_with_ime then  
                  -- print("attach_with_ime") 
                   local  move=cc.Blink:create(1, 1)  
                   target:setPlaceHolder("")
                    local action = cc.RepeatForever:create(move)
                    alert:runAction(action) 
                  alert:setVisible(true)
              elseif eventType == ccui.TextFiledEventType.detach_with_ime then  
                  -- print("detach_with_ime") 
                  alert:stopAllActions() 
                  alert:setVisible(false)
              elseif eventType == ccui.TextFiledEventType.insert_text then  
                  -- print("insert_text")  
                  local str=tostring(target:getString())
                 local len = Util:fun_Strlen(str) --Util:fun_Strlen(str)
                 alert:setPositionX(_guangbiao_x+len*font_size)    
              elseif eventType == ccui.TextFiledEventType.delete_backward then  
                  -- print("delete_backward")
                  local str=tostring(target:getString())
                 local len = Util:fun_Strlen(str)
                 alert:setPositionX(_guangbiao_x+len*font_size)      
      
        end  
      end
      target:addEventListener(textFieldEvent) 


end


function Util:fun_Strlen(str)

    local bytes = { string.byte(str, 1, #str) }
    local length, begin = 0, false
    for _, byte in ipairs(bytes) do
        if byte < 128 or byte >= 192 then
            begin = false
            length = length + 1
        elseif not begin then
            begin = true
            length = length + 1
        end
    end
    return length
end
function Util:function_advice_keyboard(_parent,target,font_size)
        local alert = ccui.Text:create()
        alert:setString("|")
        --alert:setFontName("png/chuti.ttf")
        local _guangbiao_x=target:getPositionX()
        alert:setPosition(target:getPositionX(),target:getPositionY())
        alert:setFontName(font_TextName)
        alert:setFontSize(30)
        alert:setColor(cc.c3b(0, 0, 0))
        _parent:addChild(alert)

       

        alert:setVisible(false)

        local function textFieldEvent(sender, eventType)  
              if eventType == ccui.TextFiledEventType.attach_with_ime then  
                  -- print("attach_with_ime") 
                   local  move=cc.Blink:create(1, 1)  
                   target:setPlaceHolder("")
                    local action = cc.RepeatForever:create(move)
                  --   alert:runAction(action) 
                  -- alert:setVisible(true)
              elseif eventType == ccui.TextFiledEventType.detach_with_ime then  
                  -- print("detach_with_ime") 
                  -- alert:stopAllActions() 
                  -- alert:setVisible(false)
              elseif eventType == ccui.TextFiledEventType.insert_text then  
                  -- print("insert_text")  
                  local str=tostring(target:getString())
                 local len = Util:fun_Strlen(str) --Util:fun_Strlen(str)
                 alert:setPositionX(_guangbiao_x+len*font_size)    
              elseif eventType == ccui.TextFiledEventType.delete_backward then  
                  -- print("delete_backward")
                  local str=tostring(target:getString())
                 local len = Util:fun_Strlen(str)
                 alert:setPositionX(_guangbiao_x+len*font_size)      
      
        end  
      end
      target:addEventListener(textFieldEvent) 


end

function Util:getWeixinLoginDate()
  --is_weixin 字段，-1 代表未进行授权之前状态，0 代表授权成功，1 代表授权失败或者取消授权
          local curr_time=cc.UserDefault:getInstance():getStringForKey("wx_time","1")
          local sytime = tonumber(os.time())-tonumber(curr_time)
       
          if sytime > 7200 then--7200
              cc.UserDefault:getInstance():setStringForKey("wx_time",tostring(os.time()))
              Util:deleWeixinLoginDate()
          end

          local user=
          {
              name=cc.UserDefault:getInstance():getStringForKey("name","-1"),
              country=cc.UserDefault:getInstance():getStringForKey("country","-1"),
              city=cc.UserDefault:getInstance():getStringForKey("city","-1"),
              iconurl=cc.UserDefault:getInstance():getStringForKey("iconurl","-1"),
              accessToken=cc.UserDefault:getInstance():getStringForKey("accessToken","-1"),
              openid=cc.UserDefault:getInstance():getStringForKey("openid","-1"),
              gender=cc.UserDefault:getInstance():getStringForKey("gender","男")
          }
      
      if user.name=="-1" then
           return nil
      end      
      -- dump(user)
      return user
end

function Util:deleWeixinLoginDate()
      cc.UserDefault:getInstance():setStringForKey("name","-1")
      cc.UserDefault:getInstance():setStringForKey("country","-1")
      cc.UserDefault:getInstance():setStringForKey("city","-1")
      cc.UserDefault:getInstance():setStringForKey("iconurl","-1")
      cc.UserDefault:getInstance():setStringForKey("accessToken","-1") 
      cc.UserDefault:getInstance():setStringForKey("city","-1")
      cc.UserDefault:getInstance():setStringForKey("openid","-1")
      cc.UserDefault:getInstance():setStringForKey("gender","-1")    
      cc.UserDefault:getInstance():setIntegerForKey("openID_y",0)         
end


function Util:weixinLogin()
    local weinxin=cc.UM_Share:create()
    weinxin:getlogin()
end


function Util:getVoice()
   return cc.CloudVoice:create()
end



--  辨别字符串中中包含数字
function Util:judgeIsAllNumber(string)
          local isAllNum = false


          --先屏蔽加号和空格
          local s1, e1 = string.find(string, "+")
          local s2, e2 = string.find(string, " ")
          if s1 ~= nil or e1 ~= nil or  s2 ~= nil or e2 ~= nil then
          isAllNum = false
          else
          --判断是否有其他符号或者文字
          local n = tonumber(string)
          if n then
          -- print("this num is  ======= " .. n)
          if n<0 then
          --是负数，肯定有负号
          isAllNum = false
          else
          local pn = n --此处为取整数部分参见http://blog.csdn.net/daydayup_chf/article/details/46351947
          -- print("number int part ====== " .. pn)


          if pn == n then
          -- print("***********************")
          isAllNum = true
          else
          --不相等说明有小数点
          isAllNum = false
          end
          end
          else
          isAllNum = false
          -- print("this string is not a number !!!!!")
          end
          end


          -- --提示
          -- if isAllNum == false then
          -- -- print("not is all number !!!!!!!!!!!!")
          -- self:inputSysTips(InputIsNumber, displayCenter)
          -- end


          return isAllNum
end



--  过滤特殊字符
function Util:filter_spec_chars(s)  
    local ss = {}  
    for k = 1, #s do  
        local c = string.byte(s,k)  
        if not c then break end  
        if (c>=48 and c<=57) or (c>= 65 and c<=90) or (c>=97 and c<=122) then  
            table.insert(ss, string.char(c))  
        elseif c>=228 and c<=233 then  
            local c1 = string.byte(s,k+1)  
            local c2 = string.byte(s,k+2)  
            if c1 and c2 then  
                local a1,a2,a3,a4 = 128,191,128,191  
                if c == 228 then a1 = 184  
                elseif c == 233 then a2,a4 = 190,c1 ~= 190 and 191 or 165  
                end  
                if c1>=a1 and c1<=a2 and c2>=a3 and c2<=a4 then  
                    k = k + 2  
                    table.insert(ss, string.char(c,c1,c2))  
                end  
            end  
        end  
    end  
    return table.concat(ss)  
end  



-- 弹办弹出动作 
function Util:layer_action(object,parent,type)  

      if type=="open" then
          local actionTo = cc.ScaleTo:create(0.15, 1.1)
          local actionTo1 = cc.ScaleTo:create(0.1, 1)
          object:runAction(cc.Sequence:create(actionTo,actionTo1  ))
          return
      end

      local function stopAction()
            parent:removeFromParent()
      end
      local actionTo = cc.ScaleTo:create(0.1, 1.1)
      local actionTo1 = cc.ScaleTo:create(0.1, 0.7)
      local callfunc = cc.CallFunc:create(stopAction)
      object:runAction(cc.Sequence:create(actionTo,actionTo1,callfunc  ))

end


--音乐开始
function Util:player_music_hit(musicname,cycle ) --音乐名字，是否重播
    if LocalData:Instance():get_music_hit() then  --  后期改成开关
      audio.playMusic(G_MUSIC[musicname],cycle)
      
       AudioEngine.setMusicVolume(0.3)
    else
      audio.stopMusic(G_MUSIC[musicname])
   end   

end

--关闭
function Util:stop_music_hit( musicname ) -- 停止播放音乐
    
      if not LocalData:Instance():get_music_hit() then
       audio.stopMusic(G_MUSIC[musicname])
     else
       print("关闭音乐")
    end   
end
-- 音效开始
function Util:all_layer_Sound(soundname) -- 音效
  if LocalData:Instance():get_sound() then
    audio.playSound(G_SOUND[soundname],false)
    AudioEngine.setEffectsVolume(1)
  end

end


--  网络连接错误
function Util:fun_Offlinepopwindow( popup_text ,_obj,_call)
                    -- if not Tools.hasnet then
                        self.Offlinepopwindow = cc.CSLoader:createNode("csb/Offlinepopwindow.csb");
                        _obj:addChild(self.Offlinepopwindow,222300,300)
                        
                        print("当前的网络异常错误1")
                        local Offlpop_bt    = self.Offlinepopwindow:getChildByName("bg"):getChildByName("Offlpop_bt")
                        local Offlpop_text  = self.Offlinepopwindow:getChildByName("bg"):getChildByName("Offlpop_text")

                        Offlpop_text:setTextHorizontalAlignment(1)
                        Offlpop_text:setTextVerticalAlignment(0)
                        Offlpop_text:ignoreContentAdaptWithSize(false); 
                        Offlpop_text:setSize(cc.size(700, 200))
                        
                        Offlpop_text:setString(popup_text)
                        if _call then
                          local call=_call
                        end

                        Offlpop_bt:addTouchEventListener(function(sender, eventType  )
                                   if eventType ~= ccui.TouchEventType.ended then
                                          return
                                   end
                                   dump(_call)
                                  if _call then
                                    _call(self,1)
                                    _obj:removeChildByTag(300)
                                    return
                                  end
                                  _obj:removeChildByTag(300)
                        end)
                      
                      
                      return  self.Offlinepopwindow
                -- end

end



function Util:fun_room_Offlinepopwindow( popup_text ,_call)
                    local sameIplayer = cc.CSLoader:createNode("csb/Offlinepopwindow.csb");
                    cc.Director:getInstance():getRunningScene():addChild(sameIplayer,30201,321)
                    printError("当前网络弹出的的信息")  
                    local determine_bt=sameIplayer:getChildByName("bg"):getChildByName("Offlpop_bt")
                    local Offlpop_text=sameIplayer:getChildByName("bg"):getChildByName("Offlpop_text")


                    Offlpop_text:setTextHorizontalAlignment(1)
                    Offlpop_text:setTextVerticalAlignment(0)
                    Offlpop_text:ignoreContentAdaptWithSize(false); 
                    Offlpop_text:setSize(cc.size(700, 200))
                    Offlpop_text:setString(popup_text)
                    local call=nil
                    if _call then
                       call=_call
                    end
                    determine_bt:addTouchEventListener(function(sender, eventType  )
                               if eventType ~= ccui.TouchEventType.ended then
                                      return
                               end
                               dump(call)
                              if call then
                               
                                call(cc.Director:getInstance():getRunningScene(),1)
                                cc.Director:getInstance():getRunningScene():removeChildByTag(321)
                                return
                              end
                              
                    end)
                  
                  return  sameIplayer

end

function Util:fun_sameIp_Pop( popup_text ,_call)
                    local sameIplayer = cc.CSLoader:createNode("csb/sameIplayer.csb");
                    cc.Director:getInstance():getRunningScene():addChild(sameIplayer,30001,301)
                    

                    local determine_bt=sameIplayer:getChildByName("bg"):getChildByName("determine_bt")
                    local same_text=sameIplayer:getChildByName("bg"):getChildByName("same_text")
                    local cancel_bt=sameIplayer:getChildByName("bg"):getChildByName("cancel_bt")

                    same_text:setTextHorizontalAlignment(1)
                    same_text:setTextVerticalAlignment(0)
                    same_text:ignoreContentAdaptWithSize(false); 
                    same_text:setSize(cc.size(700, 200))
                    
                    same_text:setString(popup_text)
                    local call=nil
                    if _call then
                       call=_call
                    end
                    determine_bt:addTouchEventListener(function(sender, eventType  )
                               if eventType ~= ccui.TouchEventType.ended then
                                      return
                               end
                               dump(call)
                              if call then
                                call(cc.Director:getInstance():getRunningScene(),1)
                                return
                              end
                              cc.Director:getInstance():getRunningScene():removeChildByTag(301)
                    end)
                  cancel_bt:addTouchEventListener(function(sender, eventType  )
                               if eventType ~= ccui.TouchEventType.ended then
                                      return
                               end
                               if call then
                                call(cc.Director:getInstance():getRunningScene(),2)
                                 
                              end
                              
                              cc.Director:getInstance():getRunningScene():removeChildByTag(301)
                    end)
                  
                  return  sameIplayer

end


function Util:removeloadBar()
     if self.loadbar then
        -- self.loadbar:removeFromParent(true)
        -- self.loadbar = nil
     end
end

function Util:fun_loadbar(_obj,_tag )
     -- printError("当前的那儿转圈的")
     -- self:removeloadBar()
     -- self.loadbar = cc.CSLoader:createNode("csb/loadbar.csb")
     -- cc.Director:getInstance():getRunningScene():addChild(self.loadbar,_tag,_tag)
     -- -- self.loadbar:addChild(require("src.app.layers.touchlayer").create(), -1)
     -- self.loadbar_act = cc.CSLoader:createTimeline("csb/loadbar.csb")
     -- self.loadbar:runAction(self.loadbar_act)
     -- self.loadbar_act:gotoFrameAndPlay(0,46, true)   
end



--  暂未开放
function Util:fun_notOpen(_obj,_x,_y,_tag)
   local m_pSprite1 = cc.Sprite:create("niuniu_gameover/m_frame_wenzikuang.png" )
   _obj:addChild(m_pSprite1,10000000)
   -- _obj:setLocalZOrder(100000000)
   m_pSprite1:setTag(_tag)
   m_pSprite1:setPosition(cc.p(_x,_y))
   local _text = ccui.Text:create("暂未开放", "Arial", 50)
   _text:setColor(cc.c3b(0, 0, 0))
   m_pSprite1:addChild(_text)
   _text:setPosition(cc.p(200,44))
   local function removeThis()
      _obj:removeChildByTag(_tag, true)
   end
   m_pSprite1:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(removeThis)))

end
function Util:GetShortName(sName,nMaxCount,nShowCount)
    if sName == nil or nMaxCount == nil then
        return
    end
    local sStr = sName
    local tCode = {}
    local tName = {}
    local nLenInByte = #sStr
    local nWidth = 0
    if nShowCount == nil then
       nShowCount = nMaxCount - 3
    end
    for i=1,nLenInByte do
        local curByte = string.byte(sStr, i)
        local byteCount = 0;
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
        local char = nil
        if byteCount > 0 then
            char = string.sub(sStr, i, i+byteCount-1)
            i = i + byteCount -1
        end
        if byteCount == 1 then
            nWidth = nWidth + 1
            table.insert(tName,char)
            table.insert(tCode,1)
            
        elseif byteCount > 1 then
            nWidth = nWidth + 2
            table.insert(tName,char)
            table.insert(tCode,2)
        end
    end
    
    if nWidth > nMaxCount then
        local _sN = ""
        local _len = 0
        for i=1,#tName do
            _sN = _sN .. tName[i]
            _len = _len + tCode[i]
            if _len >= nShowCount then
                break
            end
        end
        sName = _sN 
    end
    return sName
end


function Util:second2DateString(second, withSecond)  
    local hms = Split(FxGameMaths:formatSecondsToTime(second), ":")  
    local dateStr = ""  
      
    local h = tonumber(hms[1])  
    if h > 0 then  
        if h >= 24 then  
            local d = math.floor(h / 24)  
            dateStr = d .. FxLanguage:getInstance():getString("@Days")  
        end  
        dateStr = dateStr .. (h % 24) .. FxLanguage:getInstance():getString("@Hour")  
    end  
      
    local m = tonumber(hms[2])  
    if h > 0 or m > 0 then  
        dateStr = dateStr .. m .. FxLanguage:getInstance():getString("@Minute")  
    end  
      
    if withSecond == nil or withSecond == true or dateStr == "" then  
        local s = tonumber(hms[3])  
        dateStr = dateStr .. s .. FxLanguage:getInstance():getString("@Second")  
    end  
      
    return dateStr  
end 


return Util


