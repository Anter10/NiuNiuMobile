--
-- Author: admin
-- Date: 2017-07-28 17:38:10
--

local Desk_Status=
{
  Desk_In="Desk_In",--进入游戏
  Desk_PrepareW="Desk_PrepareW",--准备等待状态
  Desk_Start="Desk_Start",--开始发牌状态
  Desk_Z="Desk_Z",--抢庄状态
  Desk_Bet="Desk_Bet",--押注状态
  Desk_Compare="Desk_Compare",--比牌状态
  Desk_Over="Desk_Over",--胜利失败状态
}


local gameControl = class("gameControl", function()
      return cc.Layer:create()
end)

function gameControl:ctor(params)


  self:registerScriptHandler(function (event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        end
    end)



  
	self.delegate=params.delegate

  self.gameScene=params.delegate.gameScene
  


  self.user_buf={}--存储玩家信息
  self:add_play_data()()


  self:function_Desk_show_Control("Desk_In")


  if self.delegate.type==0 and not self.delegate.old_join then
      self:UserCreateRoomMsgRes()
  else
    --todo
    self:UserJoinRoomMsgRes()
  end
  
  
end

------------------进入房间状态(加载数据，准备，开始)----------------
--初入场景
function gameControl:function_Desk_In(Status)
    self:add_Desk_card()
    self:add_Desk_info()
end

--等待玩家准备
function gameControl:function_Desk_PrepareW(Status)
    self:ready_contl(true)
end


--加载桌面牌信息
function gameControl:add_Desk_card()
    local mode_spr=self.delegate.gameScene:getChildByName("mode_pai")
    mode_spr:setVisible(true)
    self:function_for_Board(52,5,mode_spr)
end
--同上
function gameControl:function_for_Board(max,pos_dex,obj)
    for i=1,max do
      local obg_ = obj:clone()
      obg_:setPosition(obj:getPositionX()+pos_dex*i,obj:getPositionY())
      obg_:addTo(self.delegate.gameScene:getChildByName("n_card_show"))
      table.insert(self.mode_board_obj,obg_)
    end
end

--加载桌面玩家牌位置，抢庄，押注，比牛，信息加载
function gameControl:add_Desk_info()
  local n_zhang={}
  local user_mom={}
  local niu_num={}

  for i=1,6 do
    local n_pai_1=self.delegate.gameScene:getChildByName("n_pai_"..i)--初始牌坐标获取
    local n_Desk_1=self.delegate.gameScene:getChildByName("n_Desk_data"):getChildByName("n_zhang_"..i)--抢庄
    local n_Desk_2=self.delegate.gameScene:getChildByName("n_Desk_data"):getChildByName("user_mom_"..i)--押注
    local n_Desk_3=self.delegate.gameScene:getChildByName("n_Desk_data"):getChildByName("niu_num_"..i)--比牛
     table.insert(self.board_obj,n_pai_1)
     table.insert(n_zhang,n_Desk_1)
     table.insert(user_mom,n_Desk_2)
     table.insert(niu_num,n_Desk_3)
  end

  table.insert(self.user_Banker_buf,n_zhang)
  table.insert(self.user_Banker_buf,user_mom)
  table.insert(self.user_Banker_buf,niu_num)
end



--加载个人用户信息
function gameControl:add_play_data()
    for i=1,6 do
      local user_c=self.delegate.gameScene:getChildByName("n_usre_"..i)--玩家头像数据相关
      table.insert(self.user_buf,{user_c=user_c,pos=-1})
    end
end



--准备按钮控制
function gameControl:ready_contl(is_show)
    self.gameScene:getChildByName("n_star_node"):setVisible(is_show)
    if self.delegate.type~=0 then
        self.gameScene:getChildByName("n_star_node"):getChildByName("bt_zb"):setVisible(true)
        self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_1"):setVisible(true)
      return
    end
    self.gameScene:getChildByName("n_star_node"):getChildByName("bt_zb"):setVisible(false)
    self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_1"):setVisible(false)
     
    self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_2"):setVisible(true)
    self.gameScene:getChildByName("n_star_node"):getChildByName("bt_star_game"):setVisible(true)
 
end

---抢庄按钮控制
function gameControl:zhuang_contl(is_show)
   self.gameScene:getChildByName("n_node_qz"):setVisible(is_show)
end

---下注按钮
function gameControl:bet_contl(is_show)
   
   local roomInfo=LocalData:Instance():get_RoomInfo()
  -- roomInfo.rule_a ---游戏圈数
  -- roomInfo.rule_c ---抵住，控制倍数按钮
    if roomInfo.param_c==1 then --基础倍数
      self.delegate.gameScene:getChildByName("bt_db_type_1"):setVisible(is_show)
    end 
    if roomInfo.param_c==2 then --5倍数
      self.delegate.gameScene:getChildByName("bt_db_type_2"):setVisible(is_show)
    end 

    if roomInfo.param_c==3 then --10倍数
      self.delegate.gameScene:getChildByName("bt_db_type_3"):setVisible(is_show)
    end 

end


---算牛按钮
function gameControl:compare_contl(is_show)
    self.gameScene:getChildByName("bt_type_start"):setVisible(is_show)
end




----------------发牌动画，抢庄，下注-------------------------------

--发牌阶段
function gameControl:function_Desk_Start(Status)
  print("·--开始发牌----··")
    self:button_control(2)
    self:function_Desk()
    self:function_action_sque()
  
end


--抢庄阶段
function gameControl:function_Desk_Z(Status)
    local n_node_qz=self.delegate.gameScene:getChildByName("n_node_qz")
    local n_star_node=self.delegate.gameScene:getChildByName("n_star_node")
    if Status then
      n_node_qz:setVisible(true)
      n_star_node:setVisible(false)
      return
    end
      n_node_qz:setVisible(false)
end



--押注状态
function gameControl:function_Desk_Bet(Status)

      
end

--------------------算牛--比牌阶段---------------------------------




-------------------小圈小结----------------------------------------




-------------------大圈结算----------------------------------------



--桌面显示控制 事件分发
function gameControl:function_Desk_show_Control(Status)
    if Desk_Status.Desk_In== Status then
        
        self.user_Control_pai={}--存储玩家牌五张牌
        self.board_obj={}--存放队列，开局几家进入

        self.mode_board_obj={}--中间牌桌牌
        -- self.user_buf={}--存储玩家信息

        self.user_Banker_buf={}--玩家抢庄显示

        self.user_pos_desk={}--记录玩家座位

        self.show_card={}--名牌信息存储
        self.action_Offset=0--标记动画走向
        self.user_all_num=6 --记录参与玩家总数初始6
        self:function_Desk_In(true)

        self.delegate.gameScene:getChildByName("n_card_show"):removeAllChildren()
        self.delegate.gameScene:getChildByName("mode_pai"):setVisible(false)
        self:function_add_Game_data()--洗牌
        self:ref_paly_show_data()

        self:button_control(1)
        
        
        
    elseif Desk_Status.Desk_PrepareW== Status then
          self:function_Desk_In(false)
         self:function_Desk_PrepareW(true)
             
    elseif Desk_Status.Desk_Start== Status then
          self:function_Desk_Start()
    elseif Desk_Status.Desk_Z== Status then
        self:function_Desk_Z(true)

    elseif Desk_Status.Desk_Bet== Status then
        
    elseif Desk_Status.Desk_Compare== Status then
    --todo
    elseif Desk_Status.Desk_Over== Status then
    --todo
    end


end



function gameControl:button_control(Status)
  

  if Status==4 then
        self:roomInfo_control(true)
  end

  if Status==5 then
        self:roomInfo_control(false)
  end

  if Status==6 then
      self.delegate.gameScene:getChildByName("bt_type_start"):setVisible(true)
  end

  if Status==7 then
      self.delegate.gameScene:getChildByName("bt_type_start"):setVisible(false)
  end
   if Status==8 then
    
  end
  
end














function gameControl:function_action_sque()
    -- local idx=#self.mode_board_obj
    
    local time=0.3
    local sub_pos=30
    local deletime=0.1
    local board_obj=#self.board_obj
    self.action_Offset=self.action_Offset+1
    if self.action_Offset==self.user_all_num then
        sub_pos=150
        self.action_Offset=6
    end

    local table_board={}
    for i=1,5 do
         local move=cc.MoveTo:create(time, cc.p(self.board_obj[self.action_Offset]:getPositionX()+sub_pos*(i-1),self.board_obj[self.action_Offset]:getPositionY()))
         local fun=cc.CallFunc:create(function()
                    if i==5 then 
                      self:function_recursive()
                    end
                end)
          
          if self.action_Offset==6 then
            local spawn=cc.Spawn:create(move,cc.ScaleTo:create(time,150/75,206/104))
            self.mode_board_obj[#self.mode_board_obj]:runAction(cc.Sequence:create(cc.DelayTime:create(i * deletime),spawn,fun))
          else
             self.mode_board_obj[#self.mode_board_obj]:runAction(cc.Sequence:create(cc.DelayTime:create(i * deletime),move,fun))

          end
          
          table.insert(table_board,self.mode_board_obj[#self.mode_board_obj])
          table.remove(self.mode_board_obj,#self.mode_board_obj)
    end
    table.insert(self.user_Control_pai,table_board)

end


function gameControl:function_recursive()

        -- table.remove(self.board_obj,1)

        if self.action_Offset==6 then
        dump("动画展示完毕，调用下一步逻辑处理")
          self:function_Desk_show_Control("Desk_Z")
          self:self_CardMsg()

          return
        end

        -- dump(#self.board_obj)
        self:function_action_sque()
end



--牌翻转动画
function gameControl:openCard(cardBg,cardFg)
    print("zoumei--------")
    local time = 0.1

    cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION2_D)--cocos2d::DisplayLinkDirector::Projection::_2D

    cardBg:runAction(cc.Sequence:create(cc.OrbitCamera:create(time,1,0,0,90,0,0),cc.Hide:create(),cc.CallFunc:create(--开始角度设置为0，旋转90度

        function()

            cardFg:runAction(cc.Sequence:create(cc.Show:create(),cc.OrbitCamera:create(time,1,0,270,90,0,0)))--开始角度是270，旋转90度

        end

    )))

end




--清理桌面
function gameControl:ref_paly_show_data()

      for i=1,6 do
          self.user_Banker_buf[1][i]:setVisible(false)
          self.user_Banker_buf[2][i]:setVisible(false)
          self.user_Banker_buf[3][i]:setVisible(false)
          self.user_buf[i].user_c:getChildByName("n_zhang"):setVisible(false)
      end
end




--更新用户信息
function gameControl:NotifyRoomUserMsg()
  local msg=LocalData:Instance():get_NotifyRoomUserMsg()

    local c_msg= msg
    for i=1,#self.user_buf-1 do
      if self.user_buf[i].pos== -1 then
          self.user_buf[i].pos=c_msg.pos
          self:players_Info(i, c_msg)
          return
      end
    end
    
end


--其他玩家正面牌信息
function gameControl:show_other_user_card( ... )
  local c_msg=LocalData:Instance():get_NotifyRoomUserCardMsg()

    for i=1,#self.user_buf do
      for j=1,#c_msg.userCard do
        
          if self.user_buf[i].pos ==c_msg.userCard[j].pos then
              self:other_niu_num(i,c_msg.userCard[j].type)
              local dex=#c_msg.userCard[j].cards
              for h=1,#c_msg.userCard[j].cards do
                  local spr=self.user_Control_pai[i][h]
                  local coler = c_msg.userCard[j].cards[h].coler
                  local num = c_msg.userCard[j].cards[h].number
                  local str_pic=string.format("gamescene/nnCards/card_0%s_0%s.png",coler,num)
                  self.user_Control_pai[i][h]:loadTexture(str_pic)
                  spr:setLocalZOrder(h)                 
              end
              
          end
      end
      
    end

end
--自己牌面正面信息
function gameControl:self_CardMsg()

   local c_msg=LocalData:Instance():get_NotifyRoomUserCardMsg()
 
   --执行翻牌动画
   local card_num=#self.user_Control_pai
   local num=1
   if #self.show_card>0 then
     num=#self.show_card+1
   end

   for i=num,#self.user_Control_pai[card_num] do
     local pai=self.user_Control_pai[card_num][i]
     local coler = c_msg.userCard[1].cards[i].coler
     local num = c_msg.userCard[1].cards[i].number
     -- dump(coler)
     if coler<5 then
      
         local str_pic=string.format("gamescene/nnCards/card_0%s_0%s.png",coler,num)
         local spr=display.newSprite(str_pic)
         spr:setPosition(pai:getPositionX(),pai:getPositionY())
         spr:setVisible(false)
         -- spr:setScaleX(150/101)
         -- spr:setScaleY(208/139)
         self.delegate.gameScene:getChildByName("n_card_show"):addChild(spr)
         table.insert(self.show_card,spr)
      
     end
   end
  
  for i=num,#self.show_card do
    
    self:runAction(cc.Sequence:create(cc.DelayTime:create(i * 0.1),cc.CallFunc:create(function()

                self:openCard(self.user_Control_pai[card_num][i],self.show_card[i])

            end)))

  end
   
end



function gameControl:other_niu_num(pos,type)
    print("---other_niu_num-牛几---",pos,type)
    local str_pic=string.format("gamescene/n_ing_niu%s.png",type)
    print("··other_niu_num ·",pos,type)
    self.user_Banker_buf[3][pos]:setVisible(true)
    self.user_Banker_buf[3][pos]:loadTexture(str_pic)
end


function gameControl:NotifyRoomUserActionMsg()

   local c_msg=LocalData:Instance():get_NotifyRoomUserActionMsg()
   
    for i=1,#self.user_buf-1 do
      if tonumber(self.user_buf[i].pos)== tonumber(c_msg.actionPos) then
          if c_msg.actionType==1 then --1准备
              self.user_Banker_buf[1][i]:setVisible(true)
              self.user_Banker_buf[1][i]:loadTexture("gamescene/n_ing_zhunbei.png")
          end

          if c_msg.actionType==3 then --抢庄
              self.user_Banker_buf[1][i]:setVisible(true)
              self.user_Banker_buf[1][i]:loadTexture("gamescene/n_icon_qiangzhuang.png")
          end


          if c_msg.actionType==4 then --4下注
              self.user_Banker_buf[1][i]:setVisible(false)
              self.user_Banker_buf[2][i]:setVisible(true)
              self.user_Banker_buf[2][i]:loadTexture("gamescene/n_ing_xiazhubeishu"..c_msg.betValue..".png")
          end

      end
      if tonumber(self.user_buf[i].pos)== tonumber(c_msg.zhuangPos) and c_msg.zhuangPos~=-1 then
        if c_msg.actionType==3  then
  
              self.user_buf[i].user_c:getChildByName("n_zhang"):setVisible(true)
          end
      end
      if c_msg.zhuangPos~=-1 then
        self.user_Banker_buf[1][i]:setVisible(false)
      end
    end
end



function gameControl:self_niu_info()
  local msg=LocalData:Instance():get_UserActionMsgRes()
  local self_num = 6
  print("---self_niu_info--",msg.actionType,msg.betvalue)
   if msg.actionType==4 then
        print("---进入了没-4",msg.actionType,msg.betvalue) 
       self.user_Banker_buf[1][self_num]:setVisible(false)
       self.user_Banker_buf[2][self_num]:setVisible(true)
       self.user_Banker_buf[2][self_num]:loadTexture("gamescene/n_ing_xiazhubeishu"..msg.betvalue..".png")
   end


    if msg.actionType==3 then 
      print("---进入了没-3",msg.actionType,msg.betvalue)
       self.user_Banker_buf[1][self_num]:setVisible(true)
       self.user_Banker_buf[1][self_num]:loadTexture("gamescene/n_icon_qiangzhuang.png")
   end

   if msg.actionType==1 then 
       self:button_control(2)
       self.user_Banker_buf[1][self_num]:setVisible(true)
       self.user_Banker_buf[1][self_num]:loadTexture("gamescene/n_ing_zhunbei.png")
   end

end


function gameControl:self_Refresh()
  local msg=LocalData:Instance():get_NotifyRoomUserActionMsg()
  local self_num = 6
  print("self_Refresh -----",msg.actionType,self.user_buf[self_num].pos,msg.zhuangPos)
  if msg.zhuangPos~=-1 then
   self.user_Banker_buf[1][self_num]:setVisible(false)
  end
  if self.user_buf[self_num].pos==msg.zhuangPos then
      self.user_buf[self_num].user_c:getChildByName("n_zhang"):setVisible(true)
  end
  if msg.actionType==3 and self.user_buf[self_num].pos~=msg.zhuangPos and msg.zhuangPos~=-1 then  
      self:button_control(4)
      return
  end
        
end






function gameControl:self_paly_status()
    local num=6
    self.user_buf[num].user_c:setVisible(true)
    self.user_buf[num].user_c:getChildByName("name"):setString(c_msg.nike)
    self.user_buf[num].user_c:getChildByName("ip"):setString(c_msg.userIp)
    -- self.user_buf[num].user_c:getChildByName("n_wt")
    -- self.user_buf[num].user_c:getChildByName("n_zhang")
    -- self.user_buf[num].user_c:getChildByName("score_name_0")
    -- self.user_buf[num].user_c:getChildByName("head_pic")

end





function gameControl:user_show_last_card(num)
  
    local str_pic=string.format("gamescene/nnCards/card_0%s_0%s.png",coler,num)
     local spr=display.newSprite(str_pic)
     spr:setPosition(pai:getPositionX(),pai:getPositionY())
     spr:setVisible(false)
     spr:setScaleX(150/101)
     spr:setScaleY(208/139)
     self.delegate.gameScene:addChild(spr,20)
     table.insert(self.show_card,spr)

    local c_msg=LocalData:Instance():get_NotifyRoomUserCardMsg()

    local card_num=#self.user_Control_pai

     local pai=self.user_Control_pai[card_num][5]
     local coler = c_msg.userCard[1].cards[5].coler
     local num = c_msg.userCard[1].cards[5].number
     dump(coler)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(i * 0.1),cc.CallFunc:create(function()

                self:openCard(self.user_Control_pai[card_num][i],self.show_card[i])

            end)))
end


function gameControl:UserCreateRoomMsgRes()
     local c_msg=LocalData:Instance():get_CreateRoom()
     local roomInfo=c_msg.roomInfo
     local self_num=6
     print("创建房间")
    
     self:user_room_id(roomInfo.roomID,roomInfo.round,roomInfo.param_a)

    self.user_buf[self_num].pos=c_msg.m_pos
   
end

function gameControl:user_room_id(roomID, round,all_round)
  if roomID then
    self.delegate.gameScene:getChildByName("romeId_1"):setString(tostring(roomID))
  end
  if all_round then
    self.delegate.gameScene:getChildByName("romeId_2"):setString(tostring("/"..all_round*10))
  end
    
    self.delegate.gameScene:getChildByName("romeId_3"):setString(tostring(round+1))
end


function gameControl:UserJoinRoomMsgRes()
     local c_msg=LocalData:Instance():get_UserJoinRoomMsgRes()
     local roomInfo=c_msg.roomInfo
     local userInfo=c_msg.users.pos
     local self_num=6

     self:user_room_id(roomInfo.roomID,roomInfo.round,roomInfo.param_a)
     --房间号--romeId_1
     dump(c_msg.m_pos)
     self.user_buf[self_num].pos=c_msg.m_pos
    
     ---加载其他玩家
     for j=1,#c_msg.users do
        for i=1,#self.user_buf-1 do
            if self.user_buf[i].pos== -1   then
                local user_info=c_msg.users[j]
                  self:players_Info(i,user_info)
                break
            end
        end

     end
     -- self:button_control(1)
end


function gameControl:players_Info(dex,user_info)

    self.user_buf[dex].pos=user_info.pos
    self.user_buf[dex].user_c:setVisible(true)
    self.user_buf[dex].user_c:getChildByName("name"):setString(user_info.nike)
    self.user_buf[dex].user_c:getChildByName("ip"):setString(user_info.userIp)
    -- self.user_buf[i].user_c:getChildByName("n_zhang")
    self.user_buf[dex].user_c:getChildByName("score_name_0")
    self.user_buf[dex].user_c:getChildByName("head_pic")
end


function gameControl:once_Settlement()
      local colorlayer=cc.LayerColor:create(cc.c4b(0,0,0, 150))
      self.delegate.gameScene:getChildByName("result_node"):addChild(colorlayer,-1,225)

      self.delegate.gameScene:getChildByName("result_node"):setVisible(true)
      local msg=LocalData:Instance():get_NotifyRoomResultMsg()
      print("---结算页面---")
      dump(msg.round)
      self:user_room_id(nil,msg.round,nil)--房间号



      for i=1,#msg.result do
        for j=1,#self.user_buf do
           if self.user_buf[j].pos==msg.result[i].pos then
                local num=self.delegate.gameScene:getChildByName("result_node"):getChildByName( tostring("result_"..i))
                num:setString(tostring(msg.result[i].score))
                num:setVisible(true)
                num:setOpacity(255)
                self:settlement_action(num)
           end
         
        end
        print("---结算页面---",self.user_buf[6].pos,msg.result[i].pos)
        if self.user_buf[6].pos==msg.result[i].pos then
              local resultLayer = cc.CSLoader:createNode("csb/resultLayer.csb")
              print("-----",msg.result[i].result)
              if msg.result[i].result==1 then
                resultLayer:getChildByName("n_win"):setVisible(true)
                local shareroleAction = cc.CSLoader:createTimeline("csb/resultLayer.csb")
                 resultLayer:runAction(shareroleAction)
                  shareroleAction:gotoFrameAndPlay(0,60, true)
              else
                resultLayer:getChildByName("n_lose"):setVisible(true)
              end
              
              resultLayer:addTo(colorlayer)
        end
      end


      self:runAction(cc.Sequence:create(cc.DelayTime:create(4),cc.CallFunc:create(function()
                                      self.delegate.gameScene:getChildByName("result_node"):removeChildByTag(225)
                                      self:function_Desk_show_Control("Desk_In") 
    
                            end)))

      
end


--控制倍数选择显示
function gameControl:roomInfo_control(strcu)
  


end
function gameControl:settlement_action(sprite)
  --cc.DelayTime:create(3)
      local  moveby=cc.MoveBy:create(2, cc.p(0,100))
      local fadeout=cc.FadeOut:create(2)
          sprite:runAction(cc.Sequence:create(cc.Spawn:create(moveby,fadeout),cc.CallFunc:create(function()

                    

                end)))
    -- sprite:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))
end



function gameControl:onEnter()
      NotificationCenter:Instance():AddObserver("NotifyRoomUserMsg", self,
                       function()
                              self:NotifyRoomUserMsg()      
                      end)--
      NotificationCenter:Instance():AddObserver("NotifyRoomUserActionMsg", self,
                       function()
                            local msg=LocalData:Instance():get_NotifyRoomUserActionMsg()
                            if msg.actionType==6 then --谁发起了解散，是否同意
                                self.delegate:dismis_room(2,msg.username,self.user_buf)
                                return
                            end
                            if msg.actionType==7 then --广播内容
                                self.delegate:dismis_room_stuck(msg.actionPos,msg.replyValue,msg.username,self.user_buf)
                                return
                            end


                            self:NotifyRoomUserActionMsg() 
                            self:self_Refresh()     
                      end)

      NotificationCenter:Instance():AddObserver("UserActionMsgRes", self,
                       function()

                        -- dump(self.msg.actionType)
                              local msg=LocalData:Instance():get_UserActionMsgRes()
                              if msg.actionType==3 then
                                self:button_control(3)
                              end
                              if msg.actionType==4 then
                                self:button_control(5)
                              end
                              -- if msg.actionType==7 then
                                self:button_control(7)
                              -- end
                                self:self_niu_info()
                                
                               
                                
                      end)

      NotificationCenter:Instance():AddObserver("NotifyRoomUserCardMsg", self,--手牌消息
                       function()
                                  local c_msg=LocalData:Instance():get_NotifyRoomUserCardMsg()
                                  self.user_all_num=c_msg.usercount
                                  if c_msg.type==1 then
                                    self:function_Desk_show_Control("Desk_Start")
                                  end
                                  if c_msg.type==2 then
                                      self:button_control(6)
                                      self:self_CardMsg()
                                      self.delegate:card_touch()
                                  end

                                  if c_msg.type==3 then
                                      self:show_other_user_card()
                                  end

                                   -- self:NotifyRoomUserCardMsg()
                      end)


      NotificationCenter:Instance():AddObserver("NotifyRoomResultMsg", self,--结算消息
                       function()
                            self.is_once=false
                            self:runAction(cc.Sequence:create(cc.DelayTime:create(5),cc.CallFunc:create(function()
                                    self:once_Settlement()
                              end)))

                                  
                      end)



       NotificationCenter:Instance():AddObserver("NotifyRoomDisbandMsg", self,--解散房间
                       function()
                                    print("··NotifyRoomDisbandMsg·")
                                    self.delegate:is_dismis_room()
                          
                                 
                      end)


      
end

function gameControl:onExit()
    NotificationCenter:Instance():RemoveObserver("NotifyRoomUserMsg", self)
    NotificationCenter:Instance():RemoveObserver("NotifyRoomUserActionMsg", self)
    NotificationCenter:Instance():RemoveObserver("UserActionMsgRes", self)
    NotificationCenter:Instance():RemoveObserver("Userzhunbei", self)
    NotificationCenter:Instance():RemoveObserver("NotifyRoomResultMsg", self)
    NotificationCenter:Instance():RemoveObserver("NotifyRoomDisbandMsg", self)
    NotificationCenter:Instance():RemoveObserver("NotifyRoomUserCardMsg", self)
end


return  gameControl