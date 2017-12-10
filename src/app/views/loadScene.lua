--
-- Author: admin
-- Date: 2017-08-03 11:13:04
--


-- 游戏登陆界面
local loadScene = class("loadScene",function()
      return cc.Scene:create()--cc.Scene:create()--
end)


loadScene.loadScene = nil
function loadScene:start_load_scheduler()
 
  -- if self.schedulerID then
  --   cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
  --   self.schedulerID=nil
  -- end
  -- local scheduler = cc.Director:getInstance():getScheduler()  
  --   self.schedulerID = scheduler:scheduleScriptFunc(function()  
  --      if self and self.fun_load_upt then
  --         self:fun_load_upt() 
  --      end
  --   end,1,false)   

end

function loadScene:close_load_sched()
  if self.schedulerID then
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    self.schedulerID=nil
  end
   
  
end
function loadScene:fun_load_upt( )
   -- self.mian_num=self.mian_num+1
   -- if self.mian_num > 5 then
   --   self.mian_num=0
   --   self:close_load_sched()
   --   Util:fun_room_Offlinepopwindow("网络异常，请您重新连接",function (sender, eventType)
   --                    if self and self.start_load_scheduler then
   --                       self:start_load_scheduler()
   --                    end
   --   end)  
   -- end
end

function loadScene:ctor()
    AllRequire.requireAll()
    if not require("src.VersionUpdate").into then
       if not isIOS() or Tools.iscompanyipa  then
          require("src.VersionUpdate").into = false
       else
          require("src.VersionUpdate").into = true
       end
    end

    -- 请求跑马灯信息
    Server:Instance():HttpSendpost("http://admin.sharkpoker.cn/index.php/home/login/get_marquee?channel="..Tools.Channel().channel.."&game="..Tools.Channel().gamename,{}, function(data) 
         print("活动图 = ", json.encode(data))
         LocalData:Instance():set_Marquee(data.marquee_text)
    end, true)
 

    self._lo=0
    loadScene.loadScene = self
    print("是否安装微信了  =    ", hasWX())
    self.schedulerID=nil
    self.mian_num=0
    self.isfirst=true 
    if scene then
       Tools.showError("dddddddd",32)
    end
    -- self:open_update() 
    LocalData:Instance():close_sched()
    self:init() 
    self:registerScriptHandler(function (event)
        if event == "enter" then
            self:onEnter()

             NotificationCenter:Instance():PostNotification("abc")
        elseif event == "exit" then
            self:onExit()
        end
    end)
    
    self:onEnterBackground()
end

function loadScene:loginServer()
   local hasdate = Util:getWeixinLoginDate()
    print("weixinLoginweixinLoginweixinLoginweixinLogin",hasdate)
    if hasdate then
       local socketstatue = ServerWS:UserLoginMsgReq(1)
       if socketstatue ~= 1 then 
          -- ServerWS:Instance():connect()
          -- self:loginServer()
          return true
       end
       return true
    end
end

function loadScene:init()
     LocalData:Instance():start_scheduler()
    -- dump(device.platform)
   
    local g_bg = cc.CSLoader:createNode("csb/lodingScene.csb")
    self:addChild(g_bg,2)

    
    -- 更新Logo
    local logo = Tools.Channel().logo
    print("logologologo = ",logo)
    g_bg:getChildByName("n_bg"):getChildByName("n_icon"):loadTexture(logo)

    self.loadScene=g_bg:getChildByName("n_bg")

    local back_bt_yk=self.loadScene:getChildByName("n_yk")
    back_bt_yk:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)
    end))

  
    local true_bt=self.loadScene:getChildByName("n_wx")--微信
    true_bt:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)

    end))
    local hswx = hasWX()
    print("限制登陆按钮",hswx)
    if hasWX() then
       true_bt:setPositionX(display.cx + 30)
       -- true_bt:setPositionY(true_bt:getPositionY() - 60)
       if not Tools.iscompanyipa then
          true_bt:setPositionX(display.cx + 240)
       else
          back_bt_yk:setVisible(false)
       end
       back_bt_yk:setPositionX(display.cx - 240)
    else
       true_bt:setVisible(false)
       back_bt_yk:setPositionX(960)
    end
    
    -- 是否隐藏游客
    print("限制登陆按钮",hswx,Tools.channelandioscompany)
    if Tools.channelandioscompany then
       back_bt_yk:setVisible(false)
       true_bt:setPositionX(display.cx + 30)
       true_bt:setPositionY(true_bt:getPositionY() - 60)
    end
    -- back_bt_yk:setVisible(true)
    print("vvvvvv呃呃呃呃rege",not require("src.VersionUpdate").into)
    if not require("src.VersionUpdate").into then
       local version = require("src.VersionUpdate").new(
           function()
              self:intoHallScene()
           end
        )
       self:addChild(version,99999913333, 0)
    else
       self:intoHallScene()
    end
 
    local n_icon=self.loadScene:getChildByName("n_icon")--用户协议
    if n_icon and heheniuniu == 1 then
       n_icon:loadTexture("res/niuniu_loding/niuniu_denglu/n_logo_1.png")
    end
    
    local n_icon_0=self.loadScene:getChildByName("n_icon_0")--用户协议
    n_icon_0:addTouchEventListener((function(sender, eventType  )
         if eventType ~= ccui.TouchEventType.ended then
            return
         end
         local rulesUsers=require("app.layers.rulesUsers").new(2)   --  协议
         self:addChild(rulesUsers,100,100)
    end))
    n_icon_0:setVisible(false)
    self.CB_selected=self.loadScene:getChildByName("CB_selected")--用户协议
    self.xieyi_Text=self.loadScene:getChildByName("xieyi_Text")--用户协议
    self.CB_selected:addEventListener(function(sender, eventType  )
                     if eventType == ccui.CheckBoxEventType.selected then
                        Util:all_layer_Sound("Audio_Button_Click")
                        self.xieyi_Text:setVisible(false)
                        self.loadScene:getChildByName("n_yk"):setTouchEnabled(true)
                        self.loadScene:getChildByName("n_wx"):setTouchEnabled(true)
                      elseif eventType == ccui.CheckBoxEventType.unselected then
                        Util:all_layer_Sound("Audio_Button_Click")
                        self.loadScene:getChildByName("n_yk"):setTouchEnabled(true)
                        self.loadScene:getChildByName("n_wx"):setTouchEnabled(true)
                     end
            end)
    self.CB_selected:setVisible(false)

    --self:start_load_scheduler()  --开启

end


function loadScene:intoHallScene()
     NotificationCenter:Instance():AddObserver("loading", self,
                       function()
                        self:close_load_sched()
                        package.loaded["src/app/views/gameHallScene"] = nil
                        local scenes = require("src/app/views/gameHallScene")
                        if cc.Director:getInstance():getRunningScene() then
                           cc.Director:getInstance():replaceScene(scenes.new())
                        end  
      end)

     self:loginServer()
end

function loginCallBack()
                -- loadScene.loadScene:removeFromParent()
              --   if tonumber(ServerWS:Instance().socket:getReadyState())  ~= 1 then
              --        loadScene.loadScene:removeFromParent()
              --         cc.Director:getInstance():getRunningScene():addChild(require("app.views.loadScene").new()) 
              --        return
              --     end
                  
             
              -- local function removeThis()
              --         _sender:setTouchEnabled(true)                     
              --    end

              --    loadScene.loadScene:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(removeThis)))

 
              -- LocalData:Instance():start_scheduler()
              
              --  --Util:share() 
              --  -- Util:fun_loadbar(cc.Director:getInstance():getRunningScene(),999999) 
              --  dump(loadScene.loadScene.CB_selected:isSelected())
              --  dump(Util:getWeixinLoginDate())
              --  dump("章鱼互动")
              --  if not loadScene.loadScene.CB_selected:isSelected() then
              --   loadScene.loadScene.xieyi_Text:setVisible(true)
              --   return
              -- end
              -- loadScene.loadScene:start_load_scheduler()
              --  if Util:getWeixinLoginDate() then
              --     ServerWS:UserLoginMsgReq(1)
              --     return
              --  end
              --  dump("微信")
               -- Util:weixinLogin() 
               -- loadScene.loadScene:open_update()
end


function loadScene:touch_btCallback( sender, eventType)
            loadScene.loadScene.sender = sender

            print("当前的WebSocket链接状态 = ",ServerWS:Instance().socket:getReadyState())
            if eventType ~= ccui.TouchEventType.ended then
                return
            end
            local _sender=sender
            Util:all_layer_Sound("Audio_Button_Click")
            touch_name=sender:getName()
            
       
            
            
            if not self.CB_selected:isSelected() then
               self.xieyi_Text:setVisible(true)
               return
            end
            
            if touch_name=="n_yk" then
               if tonumber(ServerWS:Instance().socket:getReadyState())  ~= 1 then
                  -- self:removeFromParent()
                  Util:fun_room_Offlinepopwindow("网络异常，请您重新连接",function (sender, eventType)
                       ServerWS:Instance():connect()
                  end)    
               -- cc.Director:getInstance():getRunningScene():addChild(require("app.views.loadScene").new()) 
                  return
               end
               isYKLogin = true
               ServerWS:UserLoginMsgReq(2)
               self:start_load_scheduler()
            elseif touch_name=="n_wx" then
              
               if not self.CB_selected:isSelected() then
                  self.xieyi_Text:setVisible(true)
                  return
               end
               self:start_load_scheduler()
               isYKLogin = false
               if not self:loginServer() then
                  Util:weixinLogin() 
                  self:open_update()
               end
         
            end
 end


function loadScene:open_update()
   self:scheduleUpdateWithPriorityLua(function(dt)
        self:update(dt) 
    end,1)   
end

function loadScene:close_update()
    self:unscheduleUpdate()
    self:close_load_sched()
    
end
function loadScene:update(dt)
    
    if cc.UserDefault:getInstance():getStringForKey("share_call","-1")=="2" then
        self.loadScene:getChildByName("n_wx"):setTouchEnabled(true)
        cc.UserDefault:getInstance():setStringForKey("share_call","-1")
        Util:removeloadBar()
    end

    if Util:getWeixinLoginDate() then
        ServerWS:UserLoginMsgReq(1)
        self:close_update()
    end
end


function loadScene:Version_Ref(data)
  if tonumber(data["code"]) ==0 then
    
    return
  end

  local function open_url()
    print("更新喽")
      cc.Application:getInstance():openURL("http://www.sharkpoker.cn/index.php/Home/Index/do_download/game_id/21")--("https://www.baidu.com/")--("http://www.sharkpoker.cn/index.php/Home/download/game_id/21")
  end

  local str_xx = "当前游戏有新版本，是否更新?"
  if tonumber(data["version"]["code"]) ==1 then --强制的
     str_xx="当前游戏有新版本,请前往下载"
     Util:fun_Offlinepopwindow(str_xx,self,function (sender, eventType)
             open_url()
     end)
  elseif tonumber(data["version"]["code"]) ==2 then--询问的
     Util:fun_sameIp_Pop(str_xx,function (sender, eventType)
     if eventType ==1 then
        open_url()
     end

     end)
  end
  
end


function loadScene:onEnter()
      print("哦乒乒乓乓乒乒乓乓片")
      self._lo=0
      if Tools.hasnet then
         Tools.hasnet = false
      end
     --  Server:Instance():request_http_version()--版本检测更新
      
     --  --Util:player_music_hit("bg_music0",true )
     --  NotificationCenter:Instance():AddObserver("loading", self,
     --                   function()
     --                    self:close_load_sched()
     --                    if cc.Director:getInstance():getRunningScene() then
     --                       cc.Director:getInstance():replaceScene(require("src.app.views.gameHallScene").new())
     --                    end  
     --  end)

     -- self:loginServer()
end



function loadScene:onExit()
  self._lo=1
  NotificationCenter:Instance():RemoveObserver("loading", self)
  NotificationCenter:Instance():RemoveObserver("Version_Ref", self)
  print("onexit loading")
  ServerWS:Instance():removeloadBar()
  
end


function loadScene:onEnterBackground()
      local is_relay=true
      if LocalData:Instance():get_Share_RoomID() then
          is_relay=false
      end
      local function onEnterBackground(event)
          print("每次启动走")
          dump(is_relay)
          if is_relay then
            is_relay=false
             self:Share_Jion_Room()
          end
         
      end

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    local msg= "APP_IOS_BACKGROUND_EVENT"   
    if device.platform=="android" then
      msg="APP_ENTER_BACKGROUND_EVENT"
    end
    local customListenerBg = cc.EventListenerCustom:create(msg,
                                onEnterBackground
                                --handler(self, self.onEnterBackground)
                                )

    
    eventDispatcher:addEventListenerWithFixedPriority(customListenerBg, 1) 

    self:Share_Jion_Room()
end

function loadScene:Share_Jion_Room()
      if LocalData:Instance():get_Share_RoomID() then
         Util:weixinLogin() 
         self:open_update()
      end
end


return loadScene
