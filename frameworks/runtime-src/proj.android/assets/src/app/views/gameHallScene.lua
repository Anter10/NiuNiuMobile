--
-- Author: admin
-- Date: 2017-08-02 10:05:49
--
local gameHallScene = class("gameHallScene",function()
      return cc.Layer:create()--cc.Scene:create()--
end)

local control_list={}

function gameHallScene:ctor()
  LocalData:Instance():start_scheduler()--心跳消息
   self._main_bcak=1--  物理返回键
	 self:registerScriptHandler(function (event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        end
    end)
   
  LocalData:Instance():set_NotifyRoomAllScoreMsg(nil)
  local fileName = cc.FileUtils:getInstance():getWritablePath().."down_pic/printScreen.png"
  cc.FileUtils:getInstance():removeDirectory(fileName)

  self:init() 
  self:onEnterBackground()
end
function gameHallScene:fun_notOpen()
        self.notopenedLayer = cc.CSLoader:createNode("csb/notopenedLayer.csb")
        self:addChild(self.notopenedLayer,99999,99999)
        local Button_1=self.notopenedLayer:getChildByName("Button_1")
        Button_1:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                    self:removeChildByTag(99999, true)
        end)
        
 

end

--  广播 跑马灯
function gameHallScene:fun_radio_act(_text)
            --local _text="开始的减肥加快速度附近看到司机反馈的就是开了房间的时刻"
                --描述动画
            self.t_title:setString(_text)
            local move = cc.MoveTo:create((self.t_title:getContentSize().width+1263)/(210 ), cc.p(-self.t_title:getContentSize().width,13))
             local callfunc = cc.CallFunc:create(function(node, value)
                    self.t_title:setPosition(cc.p(1263,13))
                  end, {tag=0})
             local seq = cc.Sequence:create(move,callfunc  ) 
            local rep = cc.RepeatForever:create(seq)
            self.t_title:stopAllActions()
            self.t_title:runAction(rep)
end
--  跑马灯
function gameHallScene:fun_radio( ... )
         self.gamescene_radio_bg=self.gameScene:getChildByName("radio_bg")
         self.gamescene_radio_bg:setVisible(true)
         self.gamescene_horn=self.gameScene:getChildByName("horn")
         self.gamescene_horn:setVisible(true)
          local crn=cc.ClippingRectangleNode:create(cc.rect(0,0,1255,66))
          crn:setAnchorPoint(cc.p(0,0))
          crn:setPosition(cc.p(self.gamescene_radio_bg:getPositionX()-self.gamescene_radio_bg:getContentSize().width/2+6,self.gamescene_radio_bg:getPositionY()-self.gamescene_radio_bg:getContentSize().height/2))
          self.gameScene:addChild(crn)

          self.t_title = ccui.Text:create("", "back.ttf", 36)
          self.t_title:setPosition(cc.p(1263,13))
          self.t_title:setAnchorPoint(cc.p(0,0))
          crn:addChild(self.t_title)
          self.t_title:setColor(cc.c3b(246, 233, 206))


          local actionT2 = cc.ScaleTo:create(1.2,1.2)
          local actionTo2 = cc.ScaleTo:create(0.8,0.8)
          self.gamescene_horn:runAction(cc.RepeatForever:create(cc.Sequence:create(actionT2, actionTo2))) 


end

---  广播 跑马灯
function gameHallScene:fun_new_radio_act(_text)
            --local _text="开始的减肥加快速度附近看到司机反馈的就是开了房间的时刻"
                --描述动画
            if self.t_title then
              self.t_title:setVisible(false)
            end
            self.t_title1:setVisible(true)
            self.t_title1:setString(_text)
            local move = cc.MoveTo:create((self.t_title1:getContentSize().width+1263)/(210 ), cc.p(-self.t_title1:getContentSize().width,13))
             local callfunc = cc.CallFunc:create(function(node, value)
                    self.t_title1:setPosition(cc.p(1263,13))
                  end, {tag=0})
             local seq = cc.Sequence:create(move,callfunc ) 

          local callfunc1 = cc.CallFunc:create(function(node, value)
                    radio_table_max=""
                   LocalData:Instance():set_Marquee_new()
                    self.gamescene_radio_bg:setVisible(false)
                    self.gamescene_horn:setVisible(false)
                    self.t_title:setVisible(false)
                    self.t_title1:setVisible(false)
                    if LocalData:Instance():get_Marquee() then
                       self:fun_radio_act(LocalData:Instance():get_Marquee())
                       self.t_title:setVisible(true)
                       self.t_title1:setVisible(false)
                       self.gamescene_radio_bg:setVisible(true)
                       self.gamescene_horn:setVisible(true)
                    else
                       --self:fun_radio_act("暂未广播")
                       self.gamescene_radio_bg:setVisible(false)
                       self.gamescene_horn:setVisible(false)
                    end  
                  end, {tag=0})


            local rep = cc.Sequence:create(cc.Repeat:create(seq,3),callfunc1)
            self.t_title1:stopAllActions()
            self.t_title1:runAction(rep)
end
--  跑马灯
function gameHallScene:fun_new_radio( ... )
         self.gamescene_radio_bg=self.gameScene:getChildByName("radio_bg")
         self.gamescene_radio_bg:setVisible(true)
         self.gamescene_horn=self.gameScene:getChildByName("horn")
         self.gamescene_horn:setVisible(true)
          local crn=cc.ClippingRectangleNode:create(cc.rect(0,0,1255,66))
          crn:setAnchorPoint(cc.p(0,0))
          crn:setPosition(cc.p(self.gamescene_radio_bg:getPositionX()-self.gamescene_radio_bg:getContentSize().width/2+6,self.gamescene_radio_bg:getPositionY()-self.gamescene_radio_bg:getContentSize().height/2))
          self.gameScene:addChild(crn)

          self.t_title1 = ccui.Text:create("", "back.ttf", 36)
          self.t_title1:setPosition(cc.p(1263,13))
          self.t_title1:setAnchorPoint(cc.p(0,0))
          crn:addChild(self.t_title1)
          self.t_title1:setColor(cc.c3b(246, 233, 206))
          local actionT2 = cc.ScaleTo:create(1.2,1.2)
          local actionTo2 = cc.ScaleTo:create(0.8,0.8)
          self.gamescene_horn:runAction(cc.RepeatForever:create(cc.Sequence:create(actionT2, actionTo2))) 



end



function gameHallScene:init()

	local g_bg = cc.CSLoader:createNode("csb/gamehallScene.csb")
    self:addChild(g_bg,2)
   
    local excessiveLayer=require("app.layers.excessiveLayer").new()
     self:addChild(excessiveLayer,100,100)



     

    self.mian_Record_layer=require("app.layers.Record").new()   --  规则
    self:addChild(self.mian_Record_layer,200,200)
    self.mian_Record_layer:setVisible(false)


    -- local bg = cc.CSLoader:createNode("csb/layerInjon.csb")
    -- g_bg:addChild(bg,2)

    self.gameScene=g_bg:getChildByName("n_bg")

    self:fun_radio()
    self:fun_new_radio( )
    
     if LocalData:Instance():get_Marquee() then
       self:fun_radio_act(LocalData:Instance():get_Marquee())
       self.gamescene_radio_bg:setVisible(true)
       self.gamescene_horn:setVisible(true)
    else
       --self:fun_radio_act("暂未广播")
       self.gamescene_radio_bg:setVisible(false)
       self.gamescene_horn:setVisible(false)
    end
                  
    local Button_1=self.gameScene:getChildByName("Button_1")--创建房间
    Button_1:addTouchEventListener((function(sender, eventType)
         self:touch_btCallback(sender, eventType)
    end))


    local Button_2=self.gameScene:getChildByName("Button_2")--加入房间
    Button_2:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)

    end))
    local Image_67=self.gameScene:getChildByName("Image_67")--加入房间
    local Image_66=self.gameScene:getChildByName("Image_66")--创建房间
    if LocalData:Instance():get_Gameswitch()  ==  0  then
           Button_2:setPositionX(960+400)
           Image_67:setPositionX(960+400)
           Button_1:setPositionX(960-400)
           Image_66:setPositionX(960-400)
    end

    

    -- if LocalData:Instance():get_Gameswitch()  ==  0  then
    --    true_bt_3:setVisible(false)
    --    -- back_bt_yk:setPositionX(960)
    -- end

    -- local true_bt=self.gameScene:getChildByName("Button_5")--登陆
    -- true_bt:addTouchEventListener((function(sender, eventType  )
    --      self:touch_btCallback(sender, eventType)

    -- end))


    local true_bt_more=self.gameScene:getChildByName("Button_6")--登陆
    true_bt_more:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)

    end))
    local Button_8=self.gameScene:getChildByName("Button_8")--规则
    Button_8:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)

    end))
    local Button_9=self.gameScene:getChildByName("Button_9")--战绩
    Button_9:addTouchEventListener((function(sender, eventType  )
         if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  --Util:fun_notOpen(sender,100,150,19998)
                  self:touch_btCallback(sender, eventType)

    end))
    local Button_3=self.gameScene:getChildByName("Button_3")--登陆
    Button_3:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)

    end))
    local Image_1=self.gameScene:getChildByName("Image_1")--登陆
    local Image_68=self.gameScene:getChildByName("Image_68")--登陆
     
    if LocalData:Instance():get_Gameswitch()  ==  0  then
       Button_3:setVisible(false)
       Image_68:setVisible(false)
       Image_1:setVisible(false)
       --Button_9:setVisible(false)
       
    end

    local Button_10=self.gameScene:getChildByName("Button_10")--消息
    Button_10:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)

    end))
    local Button_5=self.gameScene:getChildByName("Button_5")--更多
    Button_5:addTouchEventListener((function(sender, eventType  )
      print("更多")
         if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  Util:fun_notOpen(sender,100,-50,9997)
    end))

    
    
    local Button_7=self.gameScene:getChildByName("Button_7")--商城
    
    Button_7:addTouchEventListener((function(sender, eventType  )
    
         if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  if LocalData:Instance():get_Gameswitch()  ==  0  then
                     local newmall = require("app.layers.newmall")  --设置 
                      self:addChild(newmall.new(),100,100)

                       local luaoc = require"cocos.cocos2d.luaoc"
                        local ok, ret = luaoc.callStaticMethod("iospay", "requestProUpgradeProductData")
                     dump(ok)
                     dump(ret)

                  else
                    self:fun_notOpen(self,100,150,9998)
                  end
                  

    end))
    local Button_11=self.gameScene:getChildByName("Button_11")--活动
    Button_11:addTouchEventListener((function(sender, eventType  )
      print("活动")
         if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  local activityLayer = require("app.layers.activityLayer")  --设置 
                  self:addChild(activityLayer.new(),100,100)
    end))

        if LocalData:Instance():get_Gameswitch()  ==  0  then
          Button_5:setVisible(false)
          Button_10:setVisible(false)
          Button_11:setVisible(false)

        end
        if LocalData:Instance():get_Gameswitch()  ==  0  then
           Button_7:setPositionX(960-400)
           Button_8:setPositionX(960)
           Button_9:setPositionX(960+400)
           -- Button_10:setPositionX(960+300)
           -- Button_11:setPositionX(960+600)
           
        end


    self:ref_user_info()
    self:ref_diamond()
	-- self:push_layer(require("views.gameScene").new())
end



function gameHallScene:touch_btCallback( sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                return
            end
            Util:all_layer_Sound("Audio_Button_Click")
            touch_name=sender:getName()
            if touch_name=="Button_1" then
               local creatm=require("app.layers.createRoom").new()
               self:addChild(creatm,10)
                -- ServerWS:Instance():UserCreateRoomMsgReq()
            elseif touch_name=="Button_2" then 
            	self:UserJoinRoomMsgReq()
            elseif touch_name=="Button_3" then 
            elseif touch_name=="Button_5" then 
            elseif touch_name=="Button_6" then 
            	-- cc.Director:getInstance():getRunningScene():addChild(require("app.views.loadScene").new())
            	-- self:removeFromParent()
              local setLayer = require("app.layers.setLayer")  --设置 
              self:addChild(setLayer.new(),100,100)
            elseif touch_name=="Button_8" then
                local rulesUsers=require("app.layers.rulesUsers").new(1)   --  规则
                self:addChild(rulesUsers,100,100)
            elseif touch_name=="Button_9" then  --  新的战绩
                self.mian_Record_layer:setVisible(true)

                ServerWS:Instance():HistoryResultMsgReq()

            elseif touch_name=="Button_10" then
                local messageLayer = require("app.layers.messageLayer")  --消息
                self:addChild(messageLayer.new(),100,100)
                
            
            end
 end

 function gameHallScene:touchjoin_btCallback( sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                return
            end
            Util:all_layer_Sound("Audio_Button_Click")
            touch_name=sender:getName()

            
            for i=0,9 do
            	if touch_name=="j_Button_"..i then
                    if string.len(self.room_num)>5 then
                        return
                    end 
            		self.room_num=self.room_num..tostring(i)
            		self.room_join:setString(self.room_num)
            	end
            end
            if touch_name=="j_Button_10" then
            	if string.len(self.room_num) ~= 0 then
                    self.room_num=string.sub(self.room_num, 1, -2)
                    self.room_join:setString(self.room_num)
                end
            end
            
            if touch_name=="j_Button_11" then
            	if string.len(self.room_num)==6 then
                    ServerWS:Instance():UserJoinRoomMsgReq(tonumber(self.room_num))
                end
            end

            if touch_name=="jion_back" then
                self.gameScene:removeChildByTag(255)
            end
 end


function gameHallScene:UserJoinRoomMsgReq()
	
	local bg = cc.CSLoader:createNode("csb/layerInjon.csb")
	self.gameScene:addChild(bg,2,255)
	self.join=bg:getChildByName("n_bg")
	self.room_join=self.join:getChildByName("room_num")
  self.is_room=self.join:getChildByName("is_room")
  self.is_room:setVisible(false)
	self.room_num=""
	for i=0,11 do
		local buf=string.format("j_Button_%s",i)
		self.join:getChildByName(buf):addTouchEventListener((function(sender, eventType  )
         	self:touchjoin_btCallback(sender, eventType)

    	end))
	end

    local true_bt=self.join:getChildByName("jion_back")--删除弹板
    true_bt:addTouchEventListener((function(sender, eventType  )
         self:touchjoin_btCallback(sender, eventType)

    end))
    

end

--更新用户信息

function gameHallScene:ref_diamond()
local _msg=LocalData:Instance():get_NotifyMoneyMsg()
if not _msg then return end

  self.gameScene:getChildByName("n_zs"):getChildByName("n_g_num"):setString(_msg.value)
end
function gameHallScene:ref_user_info()
      local msg=LocalData:Instance():get_loading()
      
      self.gameScene:getChildByName("n_name"):setString(tostring(Util:GetShortName(tostring(msg.nick),7,14)))
      self.gameScene:getChildByName("n_id"):setString(tostring("ID:"..msg.openID))
      self.gameScene:getChildByName("n_zs"):getChildByName("n_g_num"):setString(msg.diamond)

     local haer_pic=Util:sub_str(msg.head)
     if Util:isFileExist(haer_pic) then
        self.gameScene:getChildByName("n_head"):loadTexture(haer_pic)
      else
        Server:Instance():request_pic(msg.head,"hallshead")
     end
end
function gameHallScene:ref_user_heard()
  local msg=LocalData:Instance():get_loading()
  self.gameScene:getChildByName("n_head"):loadTexture(Util:sub_str(msg.head))

end

function gameHallScene:push_layer(layerName,params)

	local string = string.format("app.%s",layerName)
	
	local layer = require(string).new(params)

	table.insert(control_list,layer)
	self:addChild(layer)
end

function gameHallScene:pop_layer(layer)
	if #self.control_list==0 then
		return
	end
	local layer=table.remove(self.control_list,#self.control_list)
	layer:removeFromParent()
	
end


function gameHallScene:onEnter()
  ServerWS:Instance():open_update()
      Server:Instance():request_pic("http://texas-cdn.oss-cn-beijing.aliyuncs.com/web/niuniu.jpg","icoshare",1)
      LocalData:Instance():set_NotifyRoomAllScoreMsg(nil)
      
      self:tele_call_back()

      Util:player_music_hit("hall_bg_voice",true )
      NotificationCenter:Instance():AddObserver("UserCreateRoomMsgRes", self,
                       function()
                            print("··gameHallScene · UserCreateRoomMsgRes")

                            local c_msg=LocalData:Instance():get_CreateRoom()
                            local type_ = c_msg.m_pos
                            
                       		local layer=require("app.views.GameScene").new({type=type_,old_join=false})
                            cc.Director:getInstance():getRunningScene():addChild(layer) 
                            self:removeFromParent()  
                           
                      end)--
	 NotificationCenter:Instance():AddObserver("UserJoinRoomMsgRes", self,
                       function()
                            local c_msg=LocalData:Instance():get_UserJoinRoomMsgRes()
                            local type_ = c_msg.m_pos
                            if self.is_room then
                              self.is_room:setVisible(false)
                            end
                            
                            self:removeChildByTag(100)
                       		local layer=require("app.views.GameScene").new({type=type_,old_join=true})
                            cc.Director:getInstance():getRunningScene():addChild(layer) 
                            self:removeFromParent()  
                         -- self:push_layer(require("views.gameScene").new())   
                      end)

    NotificationCenter:Instance():AddObserver("hallshead", self,
                       function()
                            self:ref_user_heard()
                      end)

    NotificationCenter:Instance():AddObserver("UserJoinRoomMsgResfalse", self, function(target, data) --下载图片
                           dump(data)
                           dump("钻石开始")
                            LocalData:Instance():set_Share_RoomID()
                          if self.is_room then
                              self.is_room:setVisible(true)
                              self.is_room:setString(N_room_STATE[tonumber(data)])
                          else
                            Util:fun_Offlinepopwindow(N_room_STATE[tonumber(data)],self)
                          end
                            
                      end)
    NotificationCenter:Instance():AddObserver("NotifyMoneyMsg", self, function(target, data) --下载图片
                            self:ref_diamond()
                            local meg=LocalData:Instance():get_NotifyMoneyMsg()
                            dump("送我钻石吧")
                            dump(meg.type)
                            if meg.type==1 then
                              self:fun_Giving(meg.name  ..  "送给您"  .. meg.changeValue  ..   "钻石")
                            end



                            
                      end)
    NotificationCenter:Instance():AddObserver("Marquee", self, function(target, data) --下载图片
                            if self.t_title then
                                  if LocalData:Instance():get_Marquee() then
                                     self:fun_radio_act(LocalData:Instance():get_Marquee())
                                     self.gamescene_radio_bg:setVisible(true)
                                     self.gamescene_horn:setVisible(true)

                                  else
                                     self:fun_radio_act("暂未广播")
                                     self.gamescene_radio_bg:setVisible(false)
                                     self.gamescene_horn:setVisible(false)
                                  end
                                  
                            end
                            
                      end)
    NotificationCenter:Instance():AddObserver("MarqueeJS", self, function(target, data) --下载图片

                                         if self.t_title1 then
                                              if LocalData:Instance():get_Marquee_new() then
                                                self:fun_new_radio_act(LocalData:Instance():get_Marquee_new())
                                              end
                                              
                                        end        
                           
                           
                      end)
    NotificationCenter:Instance():AddObserver("HistoryResultMsgRes", self,
                       function()
                        print("章鱼互动战绩消息")
                         self.mian_Record_layer:fun_list_data()
                
   
                      end)--



      
end

--local is_up=false
function gameHallScene:tele_call_back()

      -- if is_up then
      --   return
      -- end
      -- is_up=true
    local function onrelease(code, event)

        if code == cc.KeyCode.KEY_BACK then 
            if self._main_bcak==1 then
                 Util:fun_sameIp_Pop("您确定要退出游戏？",function (sender, eventType)
                       self._main_bcak=1
                       print("退您确定要退")
                       --is_up=false
                      if eventType==1 then
                            ServerWS:Instance():close()
                            cc.Director:getInstance():endToLua()
                      end
                  end)  
            end
            self._main_bcak=2
              

        elseif code == cc.KeyCode.KEY_HOME then 

            print("你点击了HOME键")

            cc.Director:getInstance():endToLua()

        end

    end

    --监听手机返回键

    local listener = cc.EventListenerKeyboard:create()

    listener:registerScriptHandler(onrelease, cc.Handler.EVENT_KEYBOARD_RELEASED)

    --lua中得回调，分清谁绑定，监听谁，事件类型是什么

    local eventDispatcher =self:getEventDispatcher()

    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)
end


function gameHallScene:onExit()
    self.t_title=nil
    NotificationCenter:Instance():RemoveObserver("UserCreateRoomMsgRes", self)
    NotificationCenter:Instance():RemoveObserver("Marquee", self)
    NotificationCenter:Instance():RemoveObserver("MarqueeJS", self)
    NotificationCenter:Instance():RemoveObserver("UserJoinRoomMsgRes", self)
    NotificationCenter:Instance():RemoveObserver("hallshead", self)
    NotificationCenter:Instance():RemoveObserver("UserJoinRoomMsgResfalse", self)
    NotificationCenter:Instance():RemoveObserver("NotifyMoneyMsg", self)
    NotificationCenter:Instance():RemoveObserver("HistoryResultMsgRes", self)
end


function gameHallScene:onEnterBackground()
      local function onEnterBackground(event)
          print("每次启动走")
          self:Share_Jion_Room()
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

function gameHallScene:Share_Jion_Room()
  if not _state_hallscenen then
     return
  end
      local share_roomid=LocalData:Instance():get_Share_RoomID()
      print("分享的ID 是 多少类",share_roomid)
      if share_roomid then
         ServerWS:Instance():UserJoinRoomMsgReq(tonumber(share_roomid))
         LocalData:Instance():set_Share_RoomID()
      end
end
--  赠送钻石提示
function gameHallScene:fun_Giving( _text )
         if not self.gameScene then
           return
         end
         self.Image_105_bg_bg=self.gameScene:getChildByName("Image_105")
         self.Image_105_bg_bg:setTag(9001)
         self.Image_105_bg_bg:setVisible(true)
         self.Image_105_bg_bg:setScaleX(0)
         self.Text_26_bg=self.Image_105_bg_bg:getChildByName("Text_26")
         self.Text_26_bg:setString(tostring(_text))
         self.Text_26_bg:setVisible(true)
         self.Image_105_bg_bg:setScale(1)


          local function removeThis()
                  self.Image_105_bg_bg:setVisible(false) 
                  self.Text_26_bg:setVisible(false)                     
          end
         local actionTo2 = cc.ScaleTo:create(2,1)
         local actionTo21 = cc.ScaleTo:create(1,0)

         self.Image_105_bg_bg:runAction(cc.Sequence:create(actionTo2,cc.DelayTime:create(2),actionTo21,cc.CallFunc:create(removeThis)))
end




return gameHallScene