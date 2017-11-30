--
-- Author: admin
-- Date: 2017-08-03 11:13:04
--
local loadScene = class("loadScene",function()
      return cc.Layer:create()--cc.Scene:create()--
end)


function loadScene:start_load_scheduler()
  if self.schedulerID then
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    self.schedulerID=nil
  end
  local scheduler = cc.Director:getInstance():getScheduler()  
 dump("深刻的飞机上看到")
    self.schedulerID = scheduler:scheduleScriptFunc(function()  
       self:fun_load_upt() 
    end,1,false)   

end

function loadScene:close_load_sched()
  if self.schedulerID then
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    self.schedulerID=nil
  end
   
  
end
function loadScene:fun_load_upt( )
  dump("就是东风科技的快乐飞")
   self.mian_num=self.mian_num+1
   if self.mian_num > 5 then
     self.mian_num=0
     self:close_load_sched()
     Util:fun_room_Offlinepopwindow("网络异常，请您重新连接",function (sender, eventType)
                      self:start_load_scheduler()
                    end)  
   end
end

function loadScene:ctor()
 dump("牛牛====----88--=-=-=-=-=")
 self._lo=0
  -- self.Record = cc.CSLoader:createNode("csb/Record.csb")
  --       self:addChild(self.Record)
  --     Util:FormatTime_colon(1506413049)
  --       if 1 then
  --         return
  --       end
   self.schedulerID=nil
   self.mian_num=0
   --Util:deleWeixinLoginDate() 
  
    self.isfirst=true 
    -- self:open_update() 
    LocalData:Instance():close_sched()
    --LocalData:Instance():start_scheduler()
 
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



function loadScene:init()

   -- dump(device.platform)
    ServerWS:Instance():connect()
	local g_bg = cc.CSLoader:createNode("csb/lodingScene.csb")
    self:addChild(g_bg,2)


    self.loadScene=g_bg:getChildByName("n_bg")

    local back_bt_yk=self.loadScene:getChildByName("n_yk")
    back_bt_yk:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)
    end))

    
    local true_bt=self.loadScene:getChildByName("n_wx")--微信
    true_bt:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)

    end))

    if LocalData:Instance():get_Gameswitch()  ==  0  then
       true_bt:setVisible(false)
       back_bt_yk:setPositionX(960)
     else
        back_bt_yk:setVisible(false)
        true_bt:setPositionX(960)
    end
    -- if device.platform=="android" then
    --       back_bt_yk:setVisible(false)
    --       true_bt:setPositionX(960)
    -- end

    
    local n_icon_0=self.loadScene:getChildByName("n_icon_0")--用户协议
    n_icon_0:addTouchEventListener((function(sender, eventType  )
         if eventType ~= ccui.TouchEventType.ended then
                         return
         end
                    print("JDGJDFK ")
                    local rulesUsers=require("app.layers.rulesUsers").new(2)   --  协议
                   self:addChild(rulesUsers,100,100)
          
    end))
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
    --self:start_load_scheduler()  --开启

end


function loadScene:touch_btCallback( sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                return
            end
            local _sender=sender
            Util:all_layer_Sound("Audio_Button_Click")
            touch_name=sender:getName()

            self.loadScene:getChildByName("n_yk"):setTouchEnabled(false)
            self.loadScene:getChildByName("n_wx"):setTouchEnabled(false)
            if touch_name=="n_yk" then

              if not self.CB_selected:isSelected() then
                self.xieyi_Text:setVisible(true)
                return
              end
              

               if tonumber(ServerWS:Instance().socket:getReadyState())  ~= 1 then
                     self:removeFromParent()
                     Util:fun_room_Offlinepopwindow("网络异常，请您重新连接",function (sender, eventType)
                      
                    end)     
                     cc.Director:getInstance():getRunningScene():addChild(require("app.views.loadScene").new()) 
                     return
                  end
              
               local function removeThis()
                            _sender:setTouchEnabled(true)                     
                 end

                 self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(removeThis)))


              -- Util:fun_loadbar(cc.Director:getInstance():getRunningScene(),999999) 
              
              
              
              ServerWS:UserLoginMsgReq(2)
              self:start_load_scheduler()
              -- local excessiveLayer=require("app.layers.activityLayer").new()
              -- self:addChild(activityLayer,100,100)
            elseif touch_name=="n_wx" then
                  dump("微信网络是否正常")
                  dump(ServerWS:Instance().socket:getReadyState())
                  if tonumber(ServerWS:Instance().socket:getReadyState())  ~= 1 then
                     self:removeFromParent()
                     Util:fun_room_Offlinepopwindow("网络异常，请您重新连接",function (sender, eventType)
                      
                    end)     
                     cc.Director:getInstance():getRunningScene():addChild(require("app.views.loadScene").new()) 
                     return
                  end
                  
             
              local function removeThis()
                            _sender:setTouchEnabled(true)                     
                 end

                 self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(removeThis)))

              --if ServerWS.show_close_tip then
                 --ServerWS:Instance():connect()
              --end
              --ServerWS:Instance():connect()
              LocalData:Instance():start_scheduler()
              
               --Util:share() 
               -- Util:fun_loadbar(cc.Director:getInstance():getRunningScene(),999999) 
               dump(self.CB_selected:isSelected())
               dump(Util:getWeixinLoginDate())
               dump("章鱼互动")
               if not self.CB_selected:isSelected() then
                self.xieyi_Text:setVisible(true)
                return
              end
              self:start_load_scheduler()
               if Util:getWeixinLoginDate() then
                     ServerWS:UserLoginMsgReq(1)
                     return
               end
               dump("微信")
                Util:weixinLogin() 
                 
                self:open_update()
                -- Util:share()

             
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
      cc.Director:getInstance():getRunningScene():removeChildByTag(999999, true)
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
      self._lo=0
      Server:Instance():request_http_version()--版本检测更新
      
      --Util:player_music_hit("bg_music0",true )
      NotificationCenter:Instance():AddObserver("loading", self,
                       function()
                        self:close_load_sched()
                       		--self:close_load_sched()
                       		local layer=require("app.views.gameHallScene").new()
                            cc.Director:getInstance():getRunningScene():addChild(layer) 
                             self:removeFromParent()    
                      end)--

        NotificationCenter:Instance():AddObserver("Version_Ref", self, function(target, data) --
                              print("更新1111")
                              self:Version_Ref(data)
                         
                      end)


      
end

function loadScene:onExit()
  self._lo=1
    NotificationCenter:Instance():RemoveObserver("loading", self)
    NotificationCenter:Instance():RemoveObserver("Version_Ref", self)

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
    dump(LocalData:Instance():get_Share_RoomID())

      if LocalData:Instance():get_Share_RoomID() then
          -- if Util:getWeixinLoginDate() then
          --            ServerWS:UserLoginMsgReq(1)
          --            return
          -- end
          Util:weixinLogin() 
          self:open_update()
      end
end


return loadScene
