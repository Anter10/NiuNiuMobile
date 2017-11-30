--
-- Author: Your Name
-- Date: 2016-05-05 10:31:25
--
--
-- Author: Your Name
-- Date: 2016-04-19 09:45:07
--

local GameScene = class("GameScene", function()
      return cc.Layer:create()
end)
local tanchuang_y=517.08
local new_tanchuang_y=367.08
local DISMIS_TEXT=
{
  "解散房间不扣房卡，是否解散?",
  "需要半数玩家同意才可以解散房间，是否发起解散申请？",
  "您的解散申请已发出，请等待其他玩家操作",
  "玩家%s 申请解散房间，您是否同意？超过3分钟未做选择，默认同意",
  "投票已通过，即将解散牌桌！",
  "投票未通过，即将回到牌桌！",
  "您同意解散房间，请等待其他玩家操作！",
  "您拒绝解散房间，请等待其他玩家操作！",
  "退出房间不扣房卡，是否退出?",
}


function GameScene:ctor(params)
   _state_hallscenen=false
    version_upd_voice=0
    dump(params)
     self:registerScriptHandler(function (event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        end
    end)
     self.type=params.type
     self.old_join=params.old_join
     
     self:init()
     
end


function GameScene:Destory()
      -- self.gameControl=require("app.layers.gameControl").new({delegate=self})
      -- self.gameControl:addTo(self)

      -- self.gameControl:function_Desk_show_Control("Desk_In")
end


function GameScene:init()

    local g_bg = cc.CSLoader:createNode("csb/gameScene.csb")
    g_bg:addTo(self)
    local excessiveLayer=require("app.layers.excessiveLayer").new()
     self:addChild(excessiveLayer,100,100)  

     
     
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


    local dizhu=1111
    local jifen=1
    local zuozhuang=1
    local is_tuogaun=1
    local data=LocalData:Instance():get_RoomInfo()

    dump(data.param_e)
    dump(data.param_d)
    if data then
       dizhu=tostring(data.param_e)  ..   tostring(data.param_d)
       dump(dizhu)
         jifen=tonumber(data.param_c) 
         zuozhuang=tonumber(data.param_b) 
         is_tuogaun=tonumber(data.param_f)
    end
    local Integraloptions=self.gameScene:getChildByName("Integraloptions")
      Integraloptions:loadTexture("gamescene/"..  dizhu..  ".png")


    local Integraloptions1=self.gameScene:getChildByName("Integraloptions1")   
    if jifen == 1  then
      Integraloptions1:loadTexture("gamescene/n_ing_yifenchang.png")
    elseif jifen == 2  then
      Integraloptions1:loadTexture("gamescene/n_ing_wufenchang.png")
    else

      Integraloptions1:loadTexture("gamescene/n_ing_shifenchang.png")
    end
    local Integraloptions2=self.gameScene:getChildByName("Integraloptions2")
    if zuozhuang == 2  then
      Integraloptions2:loadTexture("gamescene/n_ing_fansizhangqiangzhuang.png")
    elseif zuozhuang == 3  then
      Integraloptions2:loadTexture("gamescene/n_ing_jingdianqiangzhuang.png")
    else

      Integraloptions2:loadTexture("gamescene/n_ing_lunliuqiangzhuang.png")
    end

    local Integraloptions3=self.gameScene:getChildByName("Integraloptions3")
    if is_tuogaun == 1  then
      Integraloptions3:loadTexture("gameover/n_ing_chaoshituoguan.png")
    else
      Integraloptions3:loadTexture("gameover/n_ing_chaoshibutuoguan.png")
    end

    local back_bt=self.gameScene:getChildByName("bt_paixing")
    back_bt:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)
    end))


    local true_bt=self.gameScene:getChildByName("bt_yaoqing")--确定
    true_bt:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)

    end))

    local bt_msg_1=self.gameScene:getChildByName("bt_msg_1")--聊天
    bt_msg_1:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)

    end))

    local bt_msg_1=self.gameScene:getChildByName("bt_msg_2")--语音消息
    bt_msg_1:addTouchEventListener((function(sender, eventType  )
            
              if  self.voiceLayer.tape and self._massage then --self.voiceLayer.tape and
                return
              end


            if eventType == ccui.TouchEventType.began then --开始录音
              self._massage=false
              self.voiceLayer:startRecording()
              version_upd_voice=1
              cc.Director:getInstance():getRunningScene():removeChildByTag(999999, true)
                return
            end
             if eventType == 3 then --开始录音
                self._massage=true
               self.voiceLayer:StopRecording()
                return
            end

            if eventType == ccui.TouchEventType.ended then ----录音结束
                self._massage=true
                self.voiceLayer:StopRecording()
                version_upd_voice=0
                return
            end

          
    end))



    

    -- local true_bt=self.gameScene:getChildByName("n_node_qz"):getChildByName("bt_qz_1")--抢庄
    -- true_bt:addTouchEventListener((function(sender, eventType  )
    --      self:touch_btCallback(sender, eventType)

    -- end))


    -- local true_bt=self.gameScene:getChildByName("n_node_qz"):getChildByName("bt_qz_2")--不强
    -- true_bt:addTouchEventListener((function(sender, eventType  )
    --      self:touch_btCallback(sender, eventType)

    -- end))

    local n_star_node=self.gameScene:getChildByName("n_star_node"):getChildByName("bt_zb")--准备
    n_star_node:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)

    end))

    local bt_yq_wx_1=self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_1")--微信邀请
    bt_yq_wx_1:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)

    end))




    local bt_yq_wx_2=self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_2")--房主邀请好友
    self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_2"):addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)

    end))

    
    
    self.gameScene:getChildByName("n_star_node"):getChildByName("bt_star_game"):addTouchEventListener((function(sender, eventType  )
         --sender:setTouchEnabled(false)
         self:touch_btCallback(sender, eventType)

    end))

if LocalData:Instance():get_Gameswitch()  ==  0    then
       bt_yq_wx_1:setVisible(false)
       bt_yq_wx_2:setVisible(false)
       self.gameScene:getChildByName("n_star_node"):getChildByName("bt_star_game"):setPositionX(960)
    end

    -- local n_star_node=self.gameScene:getChildByName("bt_tc")--退出房间
    --  n_star_node:addTouchEventListener((function(sender, eventType  )
    --      self:touch_btCallback(sender, eventType)

    -- end))



    local bt_qz_1=self.gameScene:getChildByName("n_node_qz"):getChildByName("bt_qz_1")--抢庄
    bt_qz_1:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)

    end))


    local bt_qz_2=self.gameScene:getChildByName("n_node_qz"):getChildByName("bt_qz_2")--不抢
    bt_qz_2:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)

    end))
    

    for i=1,5 do
      local buf=string.format("bt_db_%s",i)
      local n_star_node=self.gameScene:getChildByName("bt_db_type_1"):getChildByName(buf)--下注倍数
        n_star_node:addTouchEventListener((function(sender, eventType  )
         self:touch_db_btCallback(sender, eventType)

      end))

        local n_star_node=self.gameScene:getChildByName("bt_db_type_2"):getChildByName(buf)--下注倍数
        n_star_node:addTouchEventListener((function(sender, eventType  )
         self:touch_db_btCallback(sender, eventType)

      end))

        local n_star_node=self.gameScene:getChildByName("bt_db_type_3"):getChildByName(buf)--下注倍数
        n_star_node:addTouchEventListener((function(sender, eventType  )
         self:touch_db_btCallback(sender, eventType)

      end))
    end
    local n_star_node=self.gameScene:getChildByName("bt_type_start"):getChildByName("bt_n_niu")--没牛
    n_star_node:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)

    end))

    local n_star_node=self.gameScene:getChildByName("bt_type_start"):getChildByName("bt_y_niu")--有妞
    n_star_node:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)

    end))

    local n_star_node=self.gameScene:getChildByName("bt_type_start"):getChildByName("bt_auto_niu")--自动算牛
    n_star_node:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)

    end))


    local n_star_node=self.gameScene:getChildByName("bt_tc")--解散房间
      n_star_node:addTouchEventListener((function(sender, eventType  )
         self:touch_btCallback(sender, eventType)

    end))
    --  操作
      local operation=self.gameScene:getChildByName("operation")
      operation:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                   operation:setVisible(false)
                  
        end)
      --operation:setVisible(false)
  
      local operation_bt=self.gameScene:getChildByName("back")--操作
      operation_bt:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  print("操作")
                   operation:setVisible(true)   
        end)
      
      local operation_friend=operation:getChildByName("operation_friend")--邀请好友
      local operation_friend1=operation:getChildByName("operation_friend1")--邀请好友
      operation_friend:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  Util:share(self.gameControl.room_id)

                  operation:setVisible(false)

                   print("邀请好友")  
        end)

      if LocalData:Instance():get_Gameswitch()  ==  0     then
         operation_friend1:setVisible(false)
         operation_friend:setPositionX(960)
      end



      local operation_dissolution=operation:getChildByName("operation_dissolution")--解散房间
      operation_dissolution:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  self:dismis_room(1,nil,self.gameControl.user_buf)
                  operation:setVisible(false)
                   print("解散房间")

        end)

    


-- local n_star_node=self.delegate.gameScene:getChildByName("n_star_node")


    self.voiceLayer=require("app.layers.voiceLayer").new()--语音消息
    self:addChild(self.voiceLayer)

    self.chatLayer=require("app.layers.chatLayer").new()
    self.chatLayer:setVisible(false)
    self:addChild(self.chatLayer)
    -- self:function_Desk()--加载桌面54张牌
    -- self:function_action_sque()--启动加载牌型动画
   self.gameControl=require("app.layers.gameControl").new({delegate=self})
   self.gameControl:addTo(self)


   


  -- self.gameControl:function_Desk_show_Control("Desk_In")
end




function GameScene:touch_db_btCallback( sender, eventType)
            if eventType ~= ccui.TouchEventType.ended then
                return
            end
          Util:all_layer_Sound("Audio_Button_Click")
            touch_name=sender:getName()

            for i=0,5 do
              if touch_name=="bt_db_"..i then
                  
                  ServerWS:Instance():UserActionMsgReq(4,i)
              end
             
            end

end

-- function GameScene:game_start()

  
--                 self.Startanimation = cc.CSLoader:createNode("csb/Startanimation.csb")
--                 self:addChild(self.Startanimation)
--                 self.shareroleAction = cc.CSLoader:createTimeline("csb/Startanimation.csb")
--                 self.Startanimation:runAction(self.shareroleAction)
--                 self.shareroleAction:gotoFrameAndPlay(0,51, false)

--                 local function removeThis()
--                     if self.Startanimation then
--                         self.Startanimation:removeFromParent()
--                         self.Startanimation=nil
--                         if LocalData:Instance():get_is_myhouse()==0 then
--                           ServerWS:Instance():UserActionMsgReq(2)
--                         end
                                                
--                     end
--               end

--               self:runAction(cc.Sequence:create(cc.DelayTime:create(1.5),cc.CallFunc:create(removeThis)))
-- end

function GameScene:touch_btCallback( sender, eventType)
            local _sender=sender
            if eventType ~= ccui.TouchEventType.ended then
                return
            end
            Util:all_layer_Sound("Audio_Button_Click")

            touch_name=sender:getName()
            if touch_name=="bt_paixing" then
              local _bg = cc.CSLoader:createNode("csb/card_layer.csb")
              _bg:addTo(self.gameScene)
              local back_bt=_bg:getChildByName("game_mod"):getChildByName("bt_back")
              back_bt:addTouchEventListener((function(sender, eventType  )
                   self:touch_btCallback(sender,eventType)
              end))
            elseif touch_name=="bt_back" then 
              sender:getParent():getParent():removeFromParent()
            elseif touch_name=="bt_yq_wx_1" or touch_name=="bt_yq_wx_2" then 
                Util:share(self.gameControl.room_id)
            elseif touch_name=="bt_zb" then 
               --_sender:setVisible(false)
               Util:all_layer_Sound("ready_1")
                ServerWS:Instance():UserActionMsgReq(1,1)
                -- _sender:getParent():setVisible(false)

            elseif touch_name=="bt_qz_1" then 


                Util:all_layer_Sound("qiangzhuang0_1")
                ServerWS:Instance():UserActionMsgReq(3,1)
                
               --  local _table={}
               --  self.headanimation = cc.CSLoader:createNode("csb/headanimation.csb")
               --  self:addChild(self.headanimation,1,9999)
               --  self.headanimation_act = cc.CSLoader:createTimeline("csb/headanimation.csb")
               --  for i=1,5 do
               --    local act=self.headanimation:getChildByName("act"  ..   i+1)
               --    act:setVisible(false)
               --    _table[i]=act
               --  end
               --  local _tag=self.gameControl.user_all_num
               --  _table[_tag-1]:runAction(self.headanimation_act)
               --  _table[_tag-1]:setVisible(true)
               -- self.headanimation_act:gotoFrameAndPlay(0,12+6*(_tag-2), true)

            elseif touch_name=="bt_qz_2" then 

                -- local _table={}
                -- self.headanimation = cc.CSLoader:createNode("csb/headanimation.csb")
                -- self:addChild(self.headanimation,1,9999)
                -- self.headanimation_act = cc.CSLoader:createTimeline("csb/headanimation.csb")
                -- for i=1,5 do
                --   local act=self.headanimation:getChildByName("act"  ..   i+1)
                --   act:setVisible(false)
                --   _table[i]=act
                -- end
                -- local _tag=self.gameControl.user_all_num
                -- _table[_tag-1]:runAction(self.headanimation_act)
                -- _table[_tag-1]:setVisible(true)
                -- self.headanimation_act:gotoFrameAndPlay(0,12+6*(_tag-2), true)


                Util:all_layer_Sound("buqiang_1")
                ServerWS:Instance():UserActionMsgReq(3,2)
            elseif touch_name=="bt_star_game" then 
                --房主开始游戏
                _sender:setVisible(false)
                self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_2"):setVisible(false)
                -- local function removeThis()
                --             _sender:setTouchEnabled(true)                     
                --  end

                --  self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(removeThis)))


                -- _sender:getParent():setVisible(false)
                ServerWS:Instance():UserActionMsgReq(2) 
                -- Util:all_layer_Sound("ready_1")
                
                --ServerWS:Instance():UserActionMsgReq(2)

            elseif touch_name=="bt_tc" then --退出房间
                --房主开始游戏
                self:dismis_room(1,nil,self.gameControl.user_buf)
            elseif touch_name=="bt_n_niu" then --没牛
                ServerWS:Instance():UserActionMsgReq(5,2)
            elseif touch_name=="bt_y_niu" then --有妞
                ServerWS:Instance():UserActionMsgReq(5,1) 
            elseif touch_name=="bt_auto_niu" then --自动算牛
                ServerWS:Instance():UserActionMsgReq(5,3)
            elseif touch_name=="bt_msg_1" then 
                -- local chatLayer=require("app.layers.chatLayer").new()
                -- self:addChild(chatLayer,10) 
                if self.chatLayer._oneself ~=1 then
                   self.chatLayer:setVisible(true)
                   self.chatLayer.bg:setVisible(true)
                 end 
                
            end

            
 end


function GameScene:card_touch()
    print("牌型触摸")
      dump(#self.gameControl.show_card)
      self.curr_pos=self.gameControl.show_card[1]:getPositionY()
      self.gameControl:setTouchEnabled(true)
      self.gameControl:registerScriptTouchHandler(function (event,x,y)
        if "began" == event then             
          return self:card_info(x,y)             
        end 
        end)
  
end

function GameScene:card_info(x,y)
  
  if self.gameControl.show_card and #self.gameControl.show_card==5 then 
      for i=1,#self.gameControl.show_card do
          local is_pu=false
          local spr=self.gameControl.show_card[i]
          local s = spr:getContentSize()
          local rect = cc.rect(spr:getPositionX()-s.width/2,spr:getPositionY()-s.height/2, s.width, s.height)
          local locationInNode = self.gameScene:getChildByName("n_card_show"):convertToNodeSpace(cc.p(x,y))
          if cc.rectContainsPoint(rect, locationInNode) then
            Util:all_layer_Sound("Audio_Button_Click")
              local up_x=50
              if  self.curr_pos < spr:getPositionY() then
                        up_x=-50
              end
                spr:setPositionY(spr:getPositionY()+up_x)
                  return true
          end    
      end
   end
   return false
end

function GameScene:dismis_room(type,username,user_buf)
  -- local  imageview=ccui.ImageView:create() 
  --  self:addChild(imageview)
  --  imageview:setTouchEnabled(true)
    self:removeChildByTag(52100)
    local g_bg = cc.CSLoader:createNode("csb/dismissLayer.csb")
    self.gamescene_g_bg=g_bg
    g_bg:addTo(self,10000,52100)
    local bg=g_bg:getChildByName("n_bg")
    self.dis_txt_table={}

    self.dis_text=bg:getChildByName("Text_0")
    self.dis_text:setTextHorizontalAlignment(1)
    self.dis_text:setTextVerticalAlignment(0)
    self.dis_text:ignoreContentAdaptWithSize(false); 
    self.dis_text:setSize(cc.size(700, 250))
    self.dis_text:setPositionY(tanchuang_y)

    if  type==1 then
       -- self.dis_text:setPositionY(self.dis_text:getPositionY())
       self.dis_text:setString(DISMIS_TEXT[2])
       self.dis_text:setPositionY(tanchuang_y)  

       if not LocalData:Instance():get_Room_Start() then

            if LocalData:Instance():get_is_myhouse() == 0  then
                self.dis_text:setString(DISMIS_TEXT[1])
                self.dis_text:setPositionY(new_tanchuang_y)
            else
                self.dis_text:setString(DISMIS_TEXT[9])
                self.dis_text:setPositionY(new_tanchuang_y)
            end
      end
          
    else
      self.dis_text:setString(string.format(DISMIS_TEXT[4],username))
      self.dis_text:setPositionY(tanchuang_y)
      self:fun_gamescene_time(180,"threetime")
    end



    for i=1,6 do
      local text=bg:getChildByName(tostring("Text_"..i))
      table.insert(self.dis_txt_table,text)
    end


      self.n_star_node1=bg:getChildByName("dis_btn_2")--取消
      self.n_star_node1:addTouchEventListener((function(sender, eventType )
        self:dismis_touch(sender,eventType,type,bg,username)
          
    end))
      self.n_star_node=bg:getChildByName("dis_btn_1")--同意
      self.n_star_node:addTouchEventListener((function(sender, eventType)
              self:dismis_touch(sender,eventType,type,bg,user_buf,username)
      end)) 




      

    self:upd_play(type,user_buf,username)

end


function GameScene:upd_play(type, user_buf,username)

  if not user_buf then  return end--房间没人操作

    if type~=1  then
      for i=1,#user_buf-1 do
        name= user_buf[i].user_c:getChildByName("name"):getString()
        if user_buf[i].pos~=-1 and name~= username then

          local str=string.format("玩家%s,房间解散等待状态",name)
          self.dis_txt_table[i]:setString(str)
        end 
      end
    end
end

function GameScene:dismis_touch(sender, eventType,type,bg,user_buf)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end
        Util:all_layer_Sound("Audio_Button_Click")
        touch_name=sender:getName()
        bg:getChildByName("dis_btn_1"):setVisible(false)
        bg:getChildByName("dis_btn_2"):setVisible(false)
      if touch_name=="dis_btn_1" then
        if self.gameControl.user_all_num~=6 then
            self.dis_text:setString(DISMIS_TEXT[3])
            self.dis_text:setPositionY(tanchuang_y)
            self:fun_gamescene_time(180)
        end
        
        
        if type==1 then
            if not LocalData:Instance():get_Room_Start() then
                if LocalData:Instance():get_is_myhouse() ~= 0  then
                    ServerWS:Instance():UserActionMsgReq(8)--非玩家退出房间
                    return
                end
            end

            -- self.dis_text:setPositionY(self.dis_text:getPositionY()+100)
            self:upd_play(2, user_buf)
            dump(self.gameControl.user_all_num_new)
            dump("zhangyu1")
             if self.gameControl.user_all_num_new~=6 then
                self.dis_text:setString(DISMIS_TEXT[3])
                self.dis_text:setPositionY(tanchuang_y)
                dump("zhangyu2")
            end
            dump("zhangyu3")
            ServerWS:Instance():UserActionMsgReq(6) 
            return
        end 
        self.dis_text:setString(DISMIS_TEXT[7])
        self.dis_text:setPositionY(tanchuang_y)
        ServerWS:Instance():UserActionMsgReq(7,1)
    end

     if touch_name=="dis_btn_2" then
        if type==2 then
            self.dis_text:setString(DISMIS_TEXT[8])
            self.dis_text:setPositionY(tanchuang_y)
            ServerWS:Instance():UserActionMsgReq(7,2)
            -- dump("zhangyu3")
            return
          end
         bg:getParent():removeFromParent()
        
    end



end

function GameScene:dismis_room_stuck(msg,user_buf)
  
    for i=1,#user_buf-1 do
        if user_buf[i].pos~=-1 and user_buf[i].pos==msg.actionPos then
           -- name= user_buf.user_c:getChildByName("name"):getString()
           local is_e="同意"
           if msg.replyValue==2 then
              is_e="拒绝"
           end
           local str=string.format("玩家%s,%s房间解散",msg.username,is_e)
           
          
          self.dis_txt_table[i]:setString(str)
        end 
    end

end



function GameScene:is_dismis_room()
      print("---is_dismis_room--",LocalData:Instance():get_Room_round(),self.gameControl.user_all_num)
      local c_msg=LocalData:Instance():get_NotifyRoomDisbandMsg()
      self:removeChildByTag(9999)

      if c_msg.result==1 then 
          --self:removeChildByTag(52100)
          if LocalData:Instance():get_Room_round()==0  then
              self:fun_room_Offlinepopwindow("房间已解散",function (sender, eventType)
                      if eventType==1 then
                            self:call_back_up_layer()
                      end
                  end)  
            return
          end
          -- if self.gameControl.user_all_num==6 then
          --   self:call_back_up_layer()
          --   return
          --  end
            if self.n_star_node1 then
                self.n_star_node1:setVisible(false)
                self.n_star_node:setVisible(false)
                self.dis_txt_table[6]:setVisible(true)
                self.dis_txt_table[6]:loadTexture("niuniu_tanchuang/n_ing_jiesanfangjian4.png")
            end
              
             self:fun_gamescene_time(2)
            
          -- if not self:game_over() then
          --   self:call_back_up_layer(1)
          -- end
         -- self.dis_text:setString(DISMIS_TEXT[5])
      else
        self.dis_txt_table[6]:setVisible(true)
        self.dis_txt_table[6]:loadTexture("niuniu_tanchuang/n_ing_jiesanfangjian5.png")
        self:fun_gamescene_time(2)
        local function removeThis()
                  self:removeChildByTag(52100)                       
       end

       self.dis_txt_table[6]:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(removeThis)))



        -- self.dis_text:setString(DISMIS_TEXT[6])
       end
end
function GameScene:fun_gamescene_time( _time,_name)
            self.gamescene_g_bg:removeChildByTag(110)
            self:unscheduleUpdate()
         
         self.gamenscene_ct_time=_time
         self.gamenscene_ct_nanme=_name
         local countTime = cc.CSLoader:createNode("csb/countTime.csb")
         countTime:setPosition(cc.p(1400-960,790-613))
         self.gamescene_g_bg:addChild(countTime,1,110)
         self.gamescene_countTime_text=countTime:getChildByName("countTime_text")
         countTime:getChildByName("name_bg"):setVisible(false)
         self.gamescene_countTime_text:setString(self.gamenscene_ct_time)
         self:scheduleUpdateWithPriorityLua(function(dt)
             self:update(dt) 
         end,1)
end
--  所谓的定时器
function GameScene:update(dt)
      
      self.sconde_time=self.sconde_time+dt
      if self.sconde_time < 1 then return end
       self.sconde_time=0  
      self.gamenscene_ct_time=self.gamenscene_ct_time-1
      if self.gamenscene_ct_time <0 then 
           self:unscheduleUpdate()
          if self.gamescene_countTime_text then
              if self.gamenscene_ct_nanme then
                 self.dis_text:setString(DISMIS_TEXT[7])
                 self.dis_text:setPositionY(new_tanchuang_y)
                 ServerWS:Instance():UserActionMsgReq(7,1)
                 self:fun_gamenscene_update(5)
                 self.gamenscene_ct_nanme=nil
              end
              self.gamescene_countTime_text:getParent():removeFromParent()
              self.gamescene_countTime_text=nil
              self:removeChildByTag(52100)
              if not self:game_over() then
                self:removeChildByTag(52100, true)
                self:call_back_up_layer()
                
              end
          end
          
         return
     end
      self.gamescene_countTime_text:setString(self.gamenscene_ct_time)
      
      
end


--房间规则信息完善
function GameScene:roomInfo_rule()
  local roomInfo=LocalData:Instance():get_RoomInfo()

  -- optional int32 param_a        = 5; //创建是的规则配置 1 圈数N:10     2 圈数 M:20
  -- optional int32 param_b        = 6;//创建是的规则配置 1 经典轮庄   2 四张牌抢庄  3 五张暗牌 抢庄
  -- optional int32 param_c        = 7; //创建是的规则配置; 1  1分底注  2 5分底注    3  10分底注
  -- optional int32 param_d        = 8;//创建是的规则配置; 1  翻倍规则1 牛牛3 牛九2 牛八2 牛七2  2 翻倍规则2 牛牛4 牛九3 牛八2 牛七2
  -- optional int32 param_e        = 9;//创建是的规则配置;   111 百位 五花牛*5  十位 炸弹牛*6  个位  五小牛 *8 
 

end



function GameScene:sort_rank(data)
   table.sort(data, function(a, b)
         return tonumber(a.score) > tonumber(b.score)
   end)
   return data
end


--刷新头像信息
function GameScene:fun_ref_all_head(head,dex)
      
      
  if not head then
    return
  end
  local haer_pic=Util:sub_str(head)
    if Util:isFileExist(haer_pic) then
         print("----头像连接----",haer_pic,dex)
        -- self.user_buf[dex].user_c:getChildByName("head_pic"):loadTexture(haer_pic)
      else
        Server:Instance():request_pic(head,"jiesuanHead",dex)
     end
end


function GameScene:game_over()
    local game_over_data=LocalData:Instance():get_NotifyRoomAllScoreMsg()
    -- print("大结算消息 ------",game_ovexxxxr_data.allscore[1].name)
    if not game_over_data then return false end
      print("大结算消息 222------",game_over_data.allscore[1].name)
    --LocalData:Instance():set_NotifyRoomAllScoreMsg(nil)
    
    local game_over = cc.CSLoader:createNode("csb/JieSuan.csb")
    game_over:addTo(self)

    local  allscore= self:sort_rank(game_over_data.allscore)
    local _bg=game_over:getChildByName("Image_1")
    self._head_img_table={}
    for i=1,6 do
      local jie_di=_bg:getChildByName("jie_di_"..i)
      local data=allscore[i]
       if data then
          jie_di:getChildByName("jie_name_"..i):setString(tostring(Util:GetShortName(tostring(data.name),7,14)))  -- 名字

          jie_di:getChildByName("result_bg"..i):getChildByName("fen1"):setString(data.score)
          jie_di:getChildByName("result_bg"..i):getChildByName("fen2"):setString(data.score)
          if  tonumber(data.score) < 0  then
            jie_di:getChildByName("result_bg"..i):getChildByName("fen1"):setVisible(true)
            jie_di:getChildByName("result_bg"..i):getChildByName("fen2"):setVisible(false)
            jie_di:getChildByName("result_bg"..i):getChildByName("biaoji"):loadTexture("shuzi/n_ing_jianhao1.png")
            jie_di:getChildByName("result_bg"..i):loadTexture("shuzi/n_frame_jianhaodi1.png")
          else
            jie_di:getChildByName("result_bg"..i):getChildByName("fen1"):setVisible(false)
            jie_di:getChildByName("result_bg"..i):getChildByName("fen2"):setVisible(true)
            jie_di:getChildByName("result_bg"..i):getChildByName("biaoji"):loadTexture("shuzi/n_ing_jiahao1.png")
            jie_di:getChildByName("result_bg"..i):loadTexture("shuzi/n_frame_jiahaodi1.png")
          end

          dump(data.head)
          if data.head then
           jie_di:getChildByName("jie_tou_"..i):loadTexture(tostring(data.head))
           self._head_img_table[i]=jie_di:getChildByName("jie_tou_"..i)
           jie_di:getChildByName("jie_tou_"..i):loadTexture(Util:sub_str(data.head))
          end
           
           

           --self:fun_ref_all_head(data.head,i)
           
           if data.master  == 1 then
             jie_di:getChildByName("jie_fangzhu_"..i):setVisible(true)
          else
             jie_di:getChildByName("jie_fangzhu_"..i):setVisible(false)
           end
                     -- jie_di::getChildByName("jie_fangzhu_"..i):setVisible(data.)
        else
          jie_di:setVisible(false)
       end
    end
    local jie_xiangqing=game_over:getChildByName("jie_xiangqing")--详情
      jie_xiangqing:addTouchEventListener((function(sender, eventType  )
         if eventType ~= ccui.TouchEventType.ended then
            return
        end
        Util:all_layer_Sound("Audio_Button_Click")
        local checkLayer=require("app.layers.checkLayer").new()
        self:addChild(checkLayer,100,100) 

    end))

      

      local jie_share=game_over:getChildByName("jie_share")--分享
      jie_share:addTouchEventListener((function(sender, eventType  )
         if eventType ~= ccui.TouchEventType.ended then
                       return
          end
        Util:captureScreen()--提前截屏
        self:fun_loadbar()
        local function removeThis()
              Util:share()
              self:removeChildByTag(10000, true)
        end
        self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(removeThis)))

    end))


      local jie_back=game_over:getChildByName("jie_back")--返回
      jie_back:addTouchEventListener((function(sender, eventType  )
         self:game_over_touch(sender, eventType)

    end))


      if LocalData:Instance():get_Gameswitch()  ==  0  then
         jie_share:setVisible(false)
         jie_xiangqing:setVisible(true)
         jie_xiangqing:setPositionX(960)

     else
        jie_share:setVisible(true)
         jie_xiangqing:setVisible(true)
    end




      return true
end

function GameScene:fun_loadbar( )
  
          self.loadbar = cc.CSLoader:createNode("csb/loadbar.csb")
          -- self.loadbar:setLocalZOrder(99999999)
          self:addChild(self.loadbar,10000,10000)
          self.loadbar_act = cc.CSLoader:createTimeline("csb/loadbar.csb")
          self.loadbar:runAction(self.loadbar_act)
          self.loadbar_act:gotoFrameAndPlay(0,46, true)
          local Image_1=self.loadbar:getChildByName("Image_1")--返回
          Image_1:setVisible(true)

          
end


function GameScene:game_over_touch(sender, eventType,type,bg)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end
        Util:all_layer_Sound("Audio_Button_Click")
        touch_name=sender:getName()
        dump(touch_name)
        if touch_name=="jie_iangqing" then
            local checkLayer=require("app.layers.checkLayer").new()
              self:addChild(checkLayer,100,100)  

        elseif touch_name=="jie_back" then
           LocalData:Instance():set_NotifyRoomAllScoreMsg(nil)
           self:call_back_up_layer()
        end

end

function GameScene:call_back_up_layer()
    
        
        LocalData:Instance():set_Room_Start(nil)
        LocalData:Instance():set_is_myhouse(-1)
         _state_hallscenen=true
        LocalData:Instance():set_Share_RoomID()
        local layer=require("app.views.gameHallScene").new()
        cc.Director:getInstance():getRunningScene():addChild(layer) 
        self:removeFromParent()

end

function GameScene:onEnter()
  Util:player_music_hit("game_bg_music",true )
  self.sconde_time=0
      NotificationCenter:Instance():AddObserver("GAMEOVERLOSE", self,
                       function()
                              Util:fun_Offlinepopwindow("申请解散房间失败!",cc.Director:getInstance():getRunningScene()) 
                              self:removeChildByTag(52100)      
                      end)--
      NotificationCenter:Instance():AddObserver("jiesuanHead", self, function(target, data) --下载图片
                            -- dump(data)
                            if  data.url then
                              self._head_img_table[data.dex]:loadTexture(Util:sub_str(data.url))
                            end
                            
                      end)
       NotificationCenter:Instance():AddObserver("CALLBACK_LOSE", self, function(target, data) --下载图片
                           
                            Util:fun_Offlinepopwindow("退出房间失败!",cc.Director:getInstance():getRunningScene())
                            self:removeChildByTag(52100)
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
                                dump(LocalData:Instance():get_Marquee_new())
                            if self.t_title1 then
                                  if LocalData:Instance():get_Marquee_new() then
                                    self:fun_new_radio_act(LocalData:Instance():get_Marquee_new())
                                  end
                                  
                            end
                            
                      end)

      
end

function GameScene:onExit()
    self:unscheduleUpdate()
    NotificationCenter:Instance():RemoveObserver("GAMEOVERLOSE", self)
    NotificationCenter:Instance():RemoveObserver("Marquee", self)
    NotificationCenter:Instance():RemoveObserver("MarqueeJS", self)
    NotificationCenter:Instance():RemoveObserver("CALLBACK_LOSE", self)
    NotificationCenter:Instance():RemoveObserver("jiesuanHead", self)
end


--  广播 跑马灯
function GameScene:fun_radio_act(_text)
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
function GameScene:fun_radio( ... )
         self.gamescene_radio_bg=self.gameScene:getChildByName("Image_7")
         self.gamescene_horn=self.gameScene:getChildByName("Image_8")
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
function GameScene:fun_new_radio_act(_text)
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
function GameScene:fun_new_radio( ... )
         self.gamescene_radio_bg=self.gameScene:getChildByName("Image_7")
         self.gamescene_radio_bg:setVisible(true)
         self.gamescene_horn=self.gameScene:getChildByName("Image_8")
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


function GameScene:fun_room_Offlinepopwindow( popup_text ,_call)
                    local sameIplayer = cc.CSLoader:createNode("csb/Offlinepopwindow.csb");
                    self:addChild(sameIplayer,30201,321)
                    

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
                                call(self,1)
                                self:removeChildByTag(321)
                                return
                              end
                              
                    end)
                  
                  return  sameIplayer

end


return GameScene








