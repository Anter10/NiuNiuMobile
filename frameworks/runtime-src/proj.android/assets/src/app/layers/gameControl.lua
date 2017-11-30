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

local ROOM_STATUS ={}
ROOM_STATUS[3]="gamescene/n_ing_dengdaiqiangzhuang.png"
ROOM_STATUS[4]="gamescene/n_ing_dengdaixiazhu.png"
ROOM_STATUS[5]="gamescene/n_ing_dengdaopeiniu.png"

GETPIC="GETPIC"

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
  self.user_all_num_new=6
  self.countTime=require("app.layers.countTime").new()
  self:addChild(self.countTime,1,1008)
  
  self.room_id=nil
  -- self.room_road=0
	self.delegate=params.delegate

  self.gameScene=params.delegate.gameScene

  self.ip_table={}--记录IP 地址
  
  self.tip_status=self.gameScene:getChildByName("Desk_Prepare"):getChildByName("Desk_Prepare_name")

  
  -- self.board_obj=self.delegate.board_obj
  -- self.user_Control_pai={}--存储玩家牌五张牌
  --  self.board_obj={}--存放队列，开局几家进入

  -- self.mode_board_obj={}--中间牌桌牌


  -- self.user_Banker_buf={}--玩家抢庄显示

  -- self.user_pos_desk={}--记录玩家座位

  

  -- self.show_card={}--名牌信息存储

  -- self.action_Offset=0--标记动画走向
  -- self.user_all_num=6 --记录参与玩家总数初始6
  self.user_buf={}--存储玩家信息
  self:function_play_head()


  

  self:function_Desk_show_Control("Desk_In")
  if self.delegate.type==0 and not self.delegate.old_join then
      
      self:UserCreateRoomMsgRes()
  else
    --todo
    -- self:function_Desk_show_Control("Desk_In")
    self:UserJoinRoomMsgRes()
  end
  
  
end



------------------------------前端内容初始化加载-----------------

--加载桌面牌
function gameControl:function_Desk()
    local mode_spr=self.delegate.gameScene:getChildByName("mode_pai")
    mode_spr:setVisible(true)
    mode_spr:setScale(0.5)
    self:function_for_Board(52,5,mode_spr)
end

function gameControl:function_for_Board(max,pos_dex,obj)
 
    for i=1,max do
      local obg_ = obj:clone()
      obg_:setPosition(obj:getPositionX()+pos_dex*i,obj:getPositionY())
      obg_:setScale(0.5)
      obg_:addTo(self.delegate.gameScene:getChildByName("n_card_show"))
      table.insert(self.mode_board_obj,obg_)
    end
end



function gameControl:function_play_head()
    for i=1,6 do
      local user_c=self.delegate.gameScene:getChildByName("n_usre_"..i)--玩家头像数据相关
      table.insert(self.user_buf,{user_c=user_c,pos=-1})
    end
end

--ref_paly_show_data
function gameControl:function_paly_show_data()

      for i=1,6 do
          self.user_Banker_buf[1][i]:setVisible(false)
          self.user_Banker_buf[2][i]:setVisible(false)
          self.user_Banker_buf[3][i]:setVisible(false)
          self.user_buf[i].user_c:getChildByName("n_zhang"):setVisible(false)
      end
end



function gameControl:function_add_Game_data()
  local n_zhang={}
  local user_mom={}
  local niu_num={}

  for i=1,6 do
    local n_pai_1=self.delegate.gameScene:getChildByName("n_pai_"..i)--初始牌坐标获取
    local n_Desk_1=self.delegate.gameScene:getChildByName("n_Desk_data"):getChildByName("n_zhang_"..i)--抢庄显示
    local n_Desk_2=self.delegate.gameScene:getChildByName("n_Desk_data"):getChildByName("user_mom_"..i)--抢庄显示
    local n_Desk_3=self.delegate.gameScene:getChildByName("n_Desk_data"):getChildByName("niu_num_"..i)--抢庄显示
     table.insert(self.board_obj,n_pai_1)
     table.insert(n_zhang,n_Desk_1)
     table.insert(user_mom,n_Desk_2)
     table.insert(niu_num,n_Desk_3)
  end

  table.insert(self.user_Banker_buf,n_zhang)
  table.insert(self.user_Banker_buf,user_mom)
  table.insert(self.user_Banker_buf,niu_num)
  -- dump(self.user_Banker_buf)
end





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
        self.action_Offset=1--标记动画走向
        self.user_all_num=6 --记录参与玩家总数初始6
        self:function_Desk_In(true)
        self.curr_play_num=0
        LocalData:Instance():set_is_myzhang(false)
        
        self.is_zhuang=false

        self.delegate.gameScene:getChildByName("n_card_show"):removeAllChildren()
        self.delegate.gameScene:getChildByName("mode_pai"):setVisible(false)
        self:function_add_Game_data()--洗牌
        
        -- self:is_start_but_touch(false)

        self.tip_status:loadTexture("gamescene/n_ing_dengdaiqiangzhuang.png")
        
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
  print("---button_control---",Status,self.delegate.type)
  if Status==1 then
    self.gameScene:getChildByName("n_star_node"):setVisible(true)
    if self.delegate.type~=0 then

      if LocalData:Instance():get_Gameswitch()  ==  0  then
       self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_1"):setVisible(false)
      end
        self.gameScene:getChildByName("n_star_node"):getChildByName("bt_zb"):setVisible(true)
        -- self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_1"):setVisible(true)
        -- self.gameScene:getChildByName("n_star_node"):getChildByName("bt_tc"):setVisible(true)
      return
    end
    self.gameScene:getChildByName("n_star_node"):getChildByName("bt_zb"):setVisible(false)
    self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_1"):setVisible(false)
    -- self.gameScene:getChildByName("n_star_node"):getChildByName("bt_tc"):setVisible(false)

     --self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_2"):setVisible(false)----------------
    self.gameScene:getChildByName("n_star_node"):getChildByName("bt_star_game"):setVisible(true)
  end

 

  if Status==2 then
    -- self.gameScene:getChildByName("n_star_node"):setVisible(false)
    self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_2"):setVisible(false)
    self.gameScene:getChildByName("n_star_node"):getChildByName("bt_star_game"):setVisible(false)
    -- self.gameScene:getChildByName("n_star_node"):getChildByName("bt_tc"):setVisible(false)
    self.gameScene:getChildByName("n_star_node"):getChildByName("bt_zb"):setVisible(false)
    self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_1"):setVisible(false)
  end

  if Status==3 then--抢庄
    self:remove_time_upd()
    self.delegate.gameScene:getChildByName("n_node_qz"):setVisible(false)
  end

  if Status==4 then--下注
      if LocalData:Instance():get_is_myhouse() then
        self:add_time_upd("N_USER_STATE_ZHUANG")
        self:roomInfo_control(true)
      end
  end

  if Status==5 then
    if LocalData:Instance():get_is_myhouse() then
        self:roomInfo_control(false)
        self:remove_time_upd()
    end
  end

  if Status==6 then--算牛
      self:add_time_upd("N_USER_STATE_BET")
      self.delegate.gameScene:getChildByName("bt_type_start"):setVisible(true)
  end

  if Status==7 then
     
      self.delegate.gameScene:getChildByName("bt_type_start"):setVisible(false)
  end
   if Status==8 then
    
  end
  
end






--初入场景
function gameControl:function_Desk_In(Status)
  -- local play_Prepare=self.delegate.gameScene:getChildByName("Desk_Prepare")

  --   if Status then
  --     local seq=cc.Sequence:create(cc.FadeOut:create(1),cc.FadeIn:create(1))
  --     play_Prepare:runAction(cc.RepeatForever:create(seq))

  --     return
  --   end
  --   play_Prepare:stopAllActions()
  --   play_Prepare:setVisible(false)
end

--等待玩家准备
function gameControl:function_Desk_PrepareW(Status)

    if Status then
     
      -- self:function_play_show(3)

      return
    end
  
end

--开始发牌
function gameControl:function_Desk_Start(Status)
  print("·--开始发牌----··")
    self:button_control(2)
    self:function_Desk()
    self:function_action_sque()
  
end

--抢庄
function gameControl:function_Desk_Z(Status)
    local n_node_qz=self.delegate.gameScene:getChildByName("n_node_qz")
    local n_star_node=self.delegate.gameScene:getChildByName("n_star_node")
    n_star_node:setVisible(false)
    self.user_Banker_buf[1][6]:setVisible(false)
    if Status then
      self:add_time_upd("N_USER_STATE_READY")
      n_node_qz:setVisible(true)
      
      return
    end
    
    n_node_qz:setVisible(false)
end

--押注状态
function gameControl:function_Desk_Bet(Status)

      
end







function gameControl:function_action_sque()
    -- local idx=#self.mode_board_obj
    local time=0.3
    local sub_pos=30
    local deletime=0.1
    local board_obj=#self.board_obj

    local table_board={}

    for j=self.action_Offset,#self.user_buf do
      if self.user_buf[j].pos~=-1 then
              self.action_Offset=j 
              if j==6 then sub_pos=150 end
              break
      end
    end
        
          
    for i=1,5 do
     local move=cc.MoveTo:create(time, cc.p(self.board_obj[self.action_Offset]:getPositionX()+sub_pos*(i-1),self.board_obj[self.action_Offset]:getPositionY()))
     local fun=cc.CallFunc:create(function()
                if i==5 then
                  self:function_recursive()
                end
            end)
      
      if self.action_Offset==6 then
        local spawn=cc.Spawn:create(move,cc.ScaleTo:create(time,1.0))
        self.mode_board_obj[#self.mode_board_obj]:runAction(cc.Sequence:create(cc.DelayTime:create(i * deletime),spawn,fun))
      else
         self.mode_board_obj[#self.mode_board_obj]:runAction(cc.Sequence:create(cc.DelayTime:create(i * deletime),move,fun))

      end
      
      table.insert(table_board,self.mode_board_obj[#self.mode_board_obj])
      table.remove(self.mode_board_obj,#self.mode_board_obj)
end
table.insert(self.user_Control_pai,table_board)
   

end

function gameControl:clear_mode_card()
  self.gameScene:getChildByName("mode_pai"):setVisible(false)
  for i=1,#self.mode_board_obj do
      self.mode_board_obj[i]:setVisible(false)
  end
  
    
end

function gameControl:function_recursive()

        -- table.remove(self.board_obj,1)
         Util:all_layer_Sound("fapai")
        if self.action_Offset==6 then
            local msg=LocalData:Instance():get_NotifyRoomUserActionMsg()
             print("轮状抢-----",msg.zhuangPos,self.user_buf[6].pos,self.action_Offset)

            self.gameScene:getChildByName("n_star_node"):setVisible(false)
            if self.ifrob and self.ifrob==1 then
                self:function_Desk_show_Control("Desk_Z")
            elseif msg.zhuangPos~=self.user_buf[6].pos and msg.zhuangPos~=-1 then
                self:button_control(4)
                
            end
                self:self_CardMsg()
                self:clear_mode_card()
              return
        end
        self.action_Offset=self.action_Offset+1
        -- dump(#self.board_obj)
        self:function_action_sque()
end



--牌翻转动画
function gameControl:openCard(cardBg,cardFg)
    print("zoumei--------")
    local time = 0.2

    cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION2_D)--cocos2d::DisplayLinkDirector::Projection::_2D
    -- cardBg:stopAllActions()
    cardBg:runAction(cc.Sequence:create(cc.OrbitCamera:create(time,1,0,0,90,0,0),cc.Hide:create(),cc.CallFunc:create(--开始角度设置为0，旋转90度

        function()
            
            cardFg:runAction(cc.Sequence:create(cc.Show:create(),cc.OrbitCamera:create(time,1,0,270,90,0,0)))--开始角度是270，旋转90度

        end

    )))
    --  翻牌动画（阻止用self 出现卡顿）
    self.gameScene:runAction(cc.Sequence:create(cc.DelayTime:create(time),cc.CallFunc:create(function()
                                     cardFg:setVisible(true)
                            end)))    

end





--其他玩家正面牌信息
function gameControl:show_other_user_card()
  local c_msg=LocalData:Instance():get_NotifyRoomUserCardMsg()
    for i=1,#self.user_buf do
      for j=1,#c_msg.userCard do
          if self.user_buf[i].pos ==c_msg.userCard[j].pos then
                self:other_niu_num(i,c_msg.userCard[j].type)
              for h=1,#c_msg.userCard[j].cards do
                
                  local dex=i
                  if i==#self.user_buf then
                    dex=#self.user_Control_pai
                  end
                  local spr=self.user_Control_pai[dex][h]
                  local coler = c_msg.userCard[j].cards[h].coler
                  local num = c_msg.userCard[j].cards[h].number
                  local str_pic=string.format("gamescene/nnCards/card_0%s_0%s.png",coler,num)
                  -- self.user_Control_pai[dex][h]:ignoreContentAdaptWithSize(true)
                  self.user_Control_pai[dex][h]:loadTexture(str_pic)
                  spr:setLocalZOrder(h)

                  if dex==#self.user_Control_pai and coler<5 then

                    table.insert(self.show_card,spr)
                  end
                  -- spr:setPosition(spr:getPositionX()-(40*(dex-1)),spr:getPositionY())
                 
              end
              
          end
      end
      
    end

end


function gameControl:new_self_CardMsg(pai,coler,num)
    print("自己的拍张信息-----",coler,num)
    local str_pic=string.format("gamescene/nnCards/card_0%s_0%s.png",coler,num)
         local spr=display.newSprite(str_pic)
         spr:setVisible(false)
         spr:setPosition(pai:getPositionX(),pai:getPositionY())
         self.delegate.gameScene:getChildByName("n_card_show"):addChild(spr)
         table.insert(self.show_card,spr)


end

function gameControl:self_zhuang_tip()
    
    self.tip_status:loadTexture(ROOM_STATUS[4])
    self:room_status_tip_action(self.tip_status:getParent())
    self.tip_status:getParent():setVisible(true)
        
end

--自己牌面正面信息
function gameControl:self_CardMsg()

   local c_msg=LocalData:Instance():get_NotifyRoomUserCardMsg()
   local roomInfo=LocalData:Instance():get_RoomInfo() --庄提示语
   print("--执行翻牌动画-",roomInfo.state)

    
    if roomInfo.param_b==1 and LocalData:Instance():get_is_myzhang() and roomInfo.state==4 then
        self:self_zhuang_tip()
    end

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
      self:new_self_CardMsg(pai,coler,num)
     end
   end
   dump(#self.show_card)
   dump((num))
  for i=num,#self.show_card do
    
    self:runAction(cc.Sequence:create(cc.DelayTime:create(i * 0.2),cc.CallFunc:create(function()

                self:openCard(self.user_Control_pai[card_num][i],self.show_card[i])

            end)))

  end
   
end



function gameControl:other_niu_num(pos,type)

  print("··other_niu_num牛几- ·",pos,type,self.user_buf[6].pos)
    if type==-1 then
      return
    end
    Util:all_layer_Sound(string.format("niu_%s_w",type))
    local str_pic=string.format("gamescene/n_ing_niu%s.png",type)

    
    self.user_Banker_buf[3][pos]:setVisible(true)
    self.user_Banker_buf[3][pos]:loadTexture(str_pic)
end


function gameControl:user_state_upd(dex,c_msg)
      if c_msg.actionType==1 then --1准备
        self.user_Banker_buf[1][dex]:setVisible(true)
        self.user_Banker_buf[1][dex]:loadTexture("gamescene/n_ing_zhunbei.png")
        -- self:is_start_but_touch(true)
      end

      if c_msg.actionType==3 then --抢庄
        self.user_Banker_buf[1][dex]:setVisible(true)

        if c_msg.robValue==2 then
          self.user_Banker_buf[1][dex]:loadTexture("gamescene/n_icon_buqiang.png")
          return
        end
        self.user_Banker_buf[1][dex]:loadTexture("gamescene/n_icon_qiangzhuang.png")
      end

      print("下注倍数-------——————",c_msg.betValue)
      if c_msg.actionType==4 then --4下注
        self.user_Banker_buf[1][dex]:setVisible(false)
        self.user_Banker_buf[2][dex]:setVisible(true)
        self.user_Banker_buf[2][dex]:loadTexture("gamescene/n_ing_xiazhubeishu"..c_msg.betValue..".png")
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
      print("---进入了没-3",msg.actionType,msg.robValue)
       self.user_Banker_buf[1][self_num]:setVisible(true)
       if msg.robValue==2 then
          self.user_Banker_buf[1][self_num]:loadTexture("gamescene/n_icon_buqiang.png")
         return
       end
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
  if msg.zhuangPos~=-1 and msg.actionType~=1 then
   self.user_Banker_buf[1][self_num]:setVisible(false)
  end
  if self.user_buf[self_num].pos==msg.zhuangPos and msg.zhuangPos~=-1 and not self.is_zhuang then
         self.is_zhuang=true
         self:fun_headanimation(self.user_buf[self_num].user_c,self_num)

        LocalData:Instance():set_is_myzhang(true)
      
        Util:all_layer_Sound("zuozhuang1_1")
  end
  -- if msg.actionType==3 and self.user_buf[self_num].pos~=msg.zhuangPos and msg.zhuangPos~=-1 then  
  --     self:button_control(4)
  --     return
  -- end
        
end




function gameControl:add_same_ip(ip)
  if not self.ip_table[tostring(ip)] then
      self.ip_table[tostring(ip)]=1
  else
    self.ip_table[tostring(ip)]=self.ip_table[tostring(ip)]+1
  end
end


function gameControl:self_paly_status()
    local num=6

   local msg=LocalData:Instance():get_loading()
    self.user_buf[num].user_c:setVisible(true)
    self.user_buf[num].user_c:getChildByName("name"):setString(tostring(Util:GetShortName(tostring(msg.nick),7,14)))
    self.user_buf[num].user_c:getChildByName("ip"):setString("IP:"..tostring(msg.userIp))
    self.user_buf[num].user_c:getChildByName("score_name_0"):setString("0")
    
    self:add_same_ip("IP:"..tostring(msg.userIp))

    -- table.insert(self.ip_table,tostring(msg.userIp))
    self:ref_all_head(msg.head,num)
end

--刷新头像信息
function gameControl:ref_all_head(head,dex)
        
  if not head then
    return
  end
  local haer_pic=Util:sub_str(head)
    if Util:isFileExist(haer_pic) then
        self.user_buf[dex].user_c:getChildByName("head_pic"):loadTexture(haer_pic)
      else
        Server:Instance():request_pic(head,GETPIC,dex)
     end
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




function gameControl:user_room_id(roomID,round,all_round,state)
  if roomID then
    self.room_id=roomID
    self.delegate.gameScene:getChildByName("romeId_1"):setString(tostring(roomID))
  end
  if all_round then
    self.all_round=all_round*10
    self.delegate.gameScene:getChildByName("romeId_2"):setString(tostring("/"..all_round*10))
  end
  -- local curr_round=round+1
  -- if state and  state>1 then
  --   curr_round=round-1
  -- end
  LocalData:Instance():set_Room_round(round)
  self.delegate.gameScene:getChildByName("romeId_3"):setString(tostring(round))

    print("设置房间号----",self.delegate.type,round)
    if round>0 then
      -- self.gameScene:getChildByName("bt_tc"):setVisible(false)
       self.gameScene:getChildByName("bt_tc"):setVisible(false)
        LocalData:Instance():set_Room_Start(true)

      self.gameScene:getChildByName("n_star_node"):getChildByName("bt_zb"):setPositionX(display.cx)
      self.gameScene:getChildByName("n_star_node"):getChildByName("bt_star_game"):setPositionX(display.cx)
      self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_1"):setVisible(false)
      self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_2"):setVisible(false)
    else

      if self.delegate.type~=0 then
        if LocalData:Instance():get_Gameswitch()  ==  0    then
           self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_1"):setVisible(false)
           return
        end

        self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_1"):setVisible(true)
      else
         -- self:is_start_but_touch(false)
          self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_2"):setVisible(true)
          self.gameScene:getChildByName("bt_tc"):loadTextures("gamescene/n_bt_jiesanfangjian.png","gamescene/n_bt_jiesanfangjian1.png")
         if LocalData:Instance():get_Gameswitch()  ==  0  then
             self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_2"):setVisible(false)
             return
          end
       
      end
    end 
end




function gameControl:players_Info(dex,user_info,zhuangpos,roomInfo)
  
    self.user_buf[dex].pos=user_info.pos
    self.user_buf[dex].user_c:setVisible(true)
    self.user_buf[dex].user_c:getChildByName("name"):setString(tostring(Util:GetShortName(tostring(user_info.nike),7,14)))
    self.user_buf[dex].user_c:getChildByName("ip"):setString("IP:"..tostring(user_info.userIp))

    
    -- self.user_buf[i].user_c:getChildByName("n_zhang")
    self:add_same_ip("IP:"..tostring(user_info.userIp))

    self.user_buf[dex].user_c:getChildByName("score_name_0"):setString(tostring(user_info.score))
    if user_info.online==2 then
      self.user_buf[dex].user_c:getChildByName("offline"):setVisible(true)
    else
      self.user_buf[dex].user_c:getChildByName("offline"):setVisible(false)
    end
    self:ref_all_head(user_info.head,dex)

    -- self:user_state_upd()
    if (user_info.userstate==1 and roomInfo~=1) or (user_info.userstate==2 and roomInfo==1) then --1准备
        self.user_Banker_buf[1][dex]:setVisible(true)
        self.user_Banker_buf[1][dex]:loadTexture("gamescene/n_ing_zhunbei.png")
        if dex==6 then
          self:button_control(2)
        end
        
        -- self:is_start_but_touch(true)
      end
      
      
      if user_info.userstate==2 and roomInfo~=1 then --抢庄
          self.user_Banker_buf[1][dex]:setVisible(true)
         self.user_Banker_buf[1][dex]:loadTexture("gamescene/n_icon_qiangzhuang.png")
          
       
      end


      if user_info.userstate==3 then --4下注
        self.user_Banker_buf[1][dex]:setVisible(false)
        self.user_Banker_buf[2][dex]:setVisible(true)
        self.user_Banker_buf[2][dex]:loadTexture("gamescene/n_ing_xiazhubeishu"..user_info.betvalue..".png")
      end
      print("庄------",zhuangpos,self.user_buf[dex].pos)
      if tonumber(self.user_buf[dex].pos)== tonumber(zhuangpos) and zhuangpos~=-1 then
            if self.user_buf[6].pos== zhuangpos then
              LocalData:Instance():set_is_myzhang(true)
            else
              LocalData:Instance():set_is_myzhang(false)
            end
              
              self.user_buf[dex].user_c:getChildByName("n_zhang"):setVisible(true)
      end
      if zhuangpos~=-1 then
        self.user_Banker_buf[1][dex]:setVisible(false)
      end
      self:is_same_ip()

    -- self.user_buf[dex].user_c:getChildByName("head_pic")
end

function gameControl:is_same_ip()
    for k,v in pairs(self.ip_table) do
      if v<2 then break  end
      self.gameScene:getChildByName("same_ip"):stopAllActions()
     self.gameScene:getChildByName("same_ip"):setVisible(true)
     self.gameScene:getChildByName("same_ip"):getChildByName("same_ip_text"):setString(k.."同时存在"..tostring(v).."个玩家")
     self.gameScene:getChildByName("same_ip"):runAction(cc.Sequence:create(cc.DelayTime:create(3),cc.FadeOut:create(1),cc.CallFunc:create(function()
                                     self.gameScene:getChildByName("same_ip"):setVisible(false)
                                     self.gameScene:getChildByName("same_ip"):setOpacity(255)
                            end)))

    end

end





--控制倍数选择显示
function gameControl:roomInfo_control(strcu)
  local roomInfo=LocalData:Instance():get_RoomInfo()
  -- roomInfo.rule_a ---游戏圈数
  -- roomInfo.rule_c ---抵住，控制倍数按钮
  if roomInfo.param_c==1 then --基础倍数
      self.delegate.gameScene:getChildByName("bt_db_type_1"):setVisible(strcu)
    end 

    if roomInfo.param_c==2 then --5倍数
      self.delegate.gameScene:getChildByName("bt_db_type_2"):setVisible(strcu)
    end 

    if roomInfo.param_c==3 then --10倍数
      self.delegate.gameScene:getChildByName("bt_db_type_3"):setVisible(strcu)
    end 



end
function gameControl:settlement_action(sprite)
  --cc.DelayTime:create(3)
      local  moveby=cc.MoveBy:create(2, cc.p(0,100))
      local fadeout=cc.FadeOut:create(2)
          sprite:runAction(cc.Sequence:create(cc.Spawn:create(moveby,fadeout),cc.CallFunc:create(function()

                    

                end)))
    -- sprite:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))
end

function gameControl:back_online_card()
      local sub_pos=30
      local action_Offset=1
      
      -- dump(self.board_obj)
      -- dump(self.mode_board_obj)
      self.user_Control_pai={}
      for i=1,self.user_all_num do
        action_Offset=i
        local table_board={}
        if i==self.user_all_num then
            sub_pos=150
            action_Offset=6
        end
        
        for j=1,5 do
          if action_Offset==6 then
            self.mode_board_obj[#self.mode_board_obj]:setScale(1.0)
            self.mode_board_obj[#self.mode_board_obj]:setPosition(cc.p(self.board_obj[action_Offset]:getPositionX()+sub_pos*(j-1),self.board_obj[action_Offset]:getPositionY()))
          else
             self.mode_board_obj[#self.mode_board_obj]:setPosition(cc.p(self.board_obj[action_Offset]:getPositionX()+sub_pos*(j-1),self.board_obj[action_Offset]:getPositionY()))
          end
          
          table.insert(table_board,self.mode_board_obj[#self.mode_board_obj])
          table.remove(self.mode_board_obj,#self.mode_board_obj)
        end
        -- print("3333333333",i)
      table.insert(self.user_Control_pai,table_board)
      end
end

function gameControl:break_online(type,ifniu)
    self:function_Desk()--加载牌
    self:back_online_card()--加载牌背面信息
    self:show_other_user_card()--展示牌
    self:button_control(2)
    self:clear_mode_card()--清除牌面

    if type==3 then
        if ifniu and ifniu==1 then
          self:function_Desk_Z(true)
        end
    end
    if type==4 then
      -- self.gameScene:getChildByName("bt_tc"):setVisible(false)
      -- LocalData:Instance():set_Room_Start(true)
      if not LocalData:Instance():get_is_myzhang() then
        self:button_control(4)
      end
      
    end
    print("-----------",type,ifniu)
    if type==5 and ifniu==1 then
      -- self.gameScene:getChildByName("bt_tc"):setVisible(false)
      -- LocalData:Instance():set_Room_Start(true)
      self:button_control(6)
    end
end

function gameControl:is_start_but_touch(type)
      self.gameScene:getChildByName("n_star_node"):getChildByName("bt_star_game"):setBright(type); 
      self.gameScene:getChildByName("n_star_node"):getChildByName("bt_star_game"):setTouchEnabled(type)
end

function gameControl:clean_state()
      for i=1,6 do
        self.user_Banker_buf[1][i]:setVisible(false)
      end
end




function gameControl:add_time_upd(type)
  -- self:removeChildByTag(10086)
  print("---加时间等待---",type)
  self.countTime:fun_init(type)
end

function gameControl:remove_time_upd()
  
   if self:getChildByTag(1008) then
    print("---加时间删除 33---")
      self:getChildByTag(1008):close_update()
      -- self.countTime=nil
   end
end


function gameControl:Leave_room()
    local msg=LocalData:Instance():get_NotifyRoomUserActionMsg()
    
    for i=1,#self.user_buf do
      if self.user_buf[i].pos~= -1 and self.user_buf[i].pos== msg.actionPos then
            self.user_buf[i].user_c:setVisible(false)
            self.user_Banker_buf[1][i]:setVisible(false)
            self.user_buf[i].pos= -1
            local ip=self.user_buf[i].user_c:getChildByName("ip"):getString()
            self.ip_table[ip]=self.ip_table[ip]-1
            return
      end
    end
    
end


function gameControl:game_start_status(actionType)
  if actionType==N_DESK_STATE.N_DESK_STATE_READY then --房间准备完成
    self:is_start_but_touch(true)
  else
    self:is_start_but_touch(false)
  end

end
function gameControl:room_status_tip_action(act)
    local fadout=cc.FadeOut:create(1.0)
    local fadin=cc.FadeIn:create(1.0)
    local seq=cc.Sequence:create(fadout,fadin)
    local repat=cc.RepeatForever:create(seq)
    act:stopAllActions()
    act:runAction(repat)
end

function gameControl:room_status_tip(actionType,type)

    print("房间提示语----",actionType,type)


    if type==1 then
      if actionType==3 or actionType==4 or actionType==5  then
           self.tip_status:loadTexture(ROOM_STATUS[actionType])
           self:room_status_tip_action(self.tip_status:getParent())
           self.tip_status:getParent():setVisible(true)
            return
      end
       
    end
      

          if actionType==N_DESK_STATE.N_DESK_STATE_BET  then --房间进入下注
            local msg=LocalData:Instance():get_UserActionMsgRes()
           if msg and msg.actionType ~=4 then
              self.tip_status:getParent():stopAllActions()
              self.tip_status:getParent():setVisible(false)
            end
            -- self.tip_status:loadTexture("gamescene/n_ing_dengdaixiazhu.png")
          end

         if actionType==N_DESK_STATE.N_DESK_STATE_OPEN then --房间进入比牛
          self.tip_status:getParent():stopAllActions()
          self.tip_status:getParent():setVisible(false)
          -- self.tip_status:loadTexture("gamescene/n_ing_dengdaopeiniu.png")
         end

         if actionType==0 then --房间进入比牛
          self.tip_status:getParent():stopAllActions()
          self.tip_status:getParent():setVisible(false)
          -- self.tip_status:loadTexture("gamescene/n_ing_dengdaopeiniu.png")
         end

         -- if actionType==N_DESK_STATE.N_DESK_STATE_END then --房间进入比牛
         --  self.tip_status:getParent():stopAllActions()
         --  self.tip_status:getParent():setVisible(false)
         -- end

end


--创建房间
function gameControl:UserCreateRoomMsgRes()
     local c_msg=LocalData:Instance():get_CreateRoom()
     local roomInfo=c_msg.roomInfo
     local self_num=6    
     print("创建房间",self.user_buf[self_num].pos,c_msg.m_pos)

      self:user_room_id(roomInfo.roomID,roomInfo.round,roomInfo.param_a,roomInfo.state)

       LocalData:Instance():set_is_myhouse(c_msg.m_pos)
       
      self.user_buf[self_num].pos=c_msg.m_pos
      self:self_paly_status()

      self.delegate.chatLayer:set_pos_node(self.user_buf)--常用语聊天
      self.delegate.voiceLayer:set_pos_node(self.user_buf)--语音聊天
end

--加入房间
function gameControl:UserJoinRoomMsgRes()
     local c_msg=LocalData:Instance():get_UserJoinRoomMsgRes()
     local roomInfo=c_msg.roomInfo
     local userInfo=c_msg.users.pos
     local self_num=6
     self.user_all_num_new=1
     self:user_room_id(roomInfo.roomID,roomInfo.round,roomInfo.param_a,roomInfo.state)
     --房间号--romeId_1
     dump(c_msg.m_pos)
     self.user_buf[self_num].pos=c_msg.m_pos

     LocalData:Instance():set_is_myhouse(c_msg.m_pos)--记录是否是房主

     self.curr_play_num=c_msg.usercount
     dump(c_msg.zhuangpos)
    -- dump(c_msg.roomInfo)
     ---加载其他玩家
     for j=1,#c_msg.users do
        for i=1,#self.user_buf do
            if i==self_num and c_msg.users[j].pos== c_msg.m_pos then
                local user_info=c_msg.users[j]
                  self:players_Info(i,user_info,c_msg.zhuangpos,c_msg.roomInfo.param_b)
            end
            if self.user_buf[i].pos== -1 and c_msg.users[j].pos~= c_msg.m_pos then
                local user_info=c_msg.users[j]
                  self:players_Info(i,user_info,c_msg.zhuangpos,c_msg.roomInfo.param_b)
                break
            end
        end

     end
     self.delegate.chatLayer:set_pos_node(self.user_buf)--常用语聊天
     self.delegate.voiceLayer:set_pos_node(self.user_buf)--语音聊天
end


--亮牌
function gameControl:NotifyRoomUserCardMsg()
   local c_msg=LocalData:Instance():get_NotifyRoomUserCardMsg()
   print("------断线重连---",c_msg.ifniu,c_msg.type,c_msg.roomstate,c_msg.ifrob,c_msg.round)
   dump(c_msg.usercount)
    self.user_all_num=c_msg.usercount

  LocalData:Instance():set_Room_round(c_msg.round)
  self.delegate.gameScene:getChildByName("romeId_3"):setString(tostring(c_msg.round))

    -- if self.user_all_num>1 then
    --   self:is_start_but_touch(true)
    -- end
    -- dump(c_msg.roomstate)
    -- dump(self.user_all_num)
    -- dump(N_DESK_STATE.N_DESK_STATE_ZHUANG)
    if c_msg.roomstate==N_DESK_STATE.N_DESK_STATE_ZHUANG and c_msg.type==4 then--抢庄
        self:break_online(3,c_msg.ifrob)
        return
    end

    if c_msg.roomstate==N_DESK_STATE.N_DESK_STATE_BET and c_msg.type==4 then--下注
        self:clean_state()
        self:break_online(4)
        return
    end

    if c_msg.roomstate==N_DESK_STATE.N_DESK_STATE_OPEN and c_msg.type==4 then--比牌
        self:break_online(5,c_msg.ifniu)
        return
    end



    if c_msg.type==1 then
      LocalData:Instance():set_Room_Start(true)
      self.ifrob=c_msg.ifrob
      self:game_start()
      
    end
    if c_msg.type==2 then
        self:clean_state()
        self:room_status_tip(c_msg.roomstate)
        self:self_CardMsg()
        self.delegate:card_touch()
    end

    if c_msg.type==3 then
      -- self:room_status_tip(msg.roomstate)
        self:show_other_user_card()
    end

end


function gameControl:game_start()

                 -- if LocalData:Instance():get_is_myhouse()==0 then
                 --    self:function_Desk_show_Control("Desk_Start")
                 --    return
                 -- end
                self.Startanimation = cc.CSLoader:createNode("csb/Startanimation.csb")
                self:addChild(self.Startanimation)
                self.shareroleAction = cc.CSLoader:createTimeline("csb/Startanimation.csb")
                self.Startanimation:runAction(self.shareroleAction)
                self.shareroleAction:gotoFrameAndPlay(0,53, false)

                local function removeThis()
                    if self.Startanimation then
                        self.Startanimation:removeFromParent()
                        self.Startanimation=nil   
                        self:clean_state()
                        -- if LocalData:Instance():get_is_myhouse()==0 then
                        --   ServerWS:Instance():UserActionMsgReq(2)
                        -- end
                        self:function_Desk_show_Control("Desk_Start")             
                    end
              end
              
              self:runAction(cc.Sequence:create(cc.DelayTime:create(1.0),cc.CallFunc:create(removeThis)))
end

function gameControl:fun_headanimation( _obj,_tag )
         local _table={}
          local headanimation = cc.CSLoader:createNode("csb/headanimation.csb")
          self.delegate:addChild(headanimation,1,9999)
          local headanimation_act = cc.CSLoader:createTimeline("csb/headanimation.csb")
          --headanimation_act:setTimeSpeed(1.5)
          local _act_bg=headanimation:getChildByName("act")
          for i=1,6 do
            local act=headanimation:getChildByName("act"  ..   i)
            act:setVisible(false)
            _table[i]=act
          end
          local _tag=_tag
          _table[_tag]:runAction(headanimation_act)
          _act_bg:runAction(headanimation_act)
          _table[_tag]:setVisible(true)
         headanimation_act:gotoFrameAndPlay(0,42, false)
          local function removeThis()
                self.delegate:removeChildByTag(9999, true)
                _obj:getChildByName("n_zhang"):setVisible(true)
                if _tag==6 then
                  local roomInfo=LocalData:Instance():get_RoomInfo()
                  if roomInfo.param_b==1 then
                    return
                  end
                  self:self_zhuang_tip()
                end

          end
          headanimation:runAction(cc.Sequence:create(cc.DelayTime:create(1.4),cc.CallFunc:create(removeThis)))

end

function gameControl:NotifyRoomUserActionMsg()

   local c_msg=LocalData:Instance():get_NotifyRoomUserActionMsg()
   
    for i=1,#self.user_buf-1 do
      if tonumber(self.user_buf[i].pos)== tonumber(c_msg.actionPos) then
        -- print("准备打印了没----",c_msg.actionType,c_msg.actionPos,c_msg.zhuangPos)
          
          self:user_state_upd(i,c_msg)
      end
      if tonumber(self.user_buf[i].pos)== tonumber(c_msg.zhuangPos) and c_msg.zhuangPos~=-1 then

            print("章鱼1")
             if not self.is_zhuang then
              print("章鱼2")
                self.is_zhuang=true
                self:fun_headanimation(self.user_buf[i].user_c,i)
             end
             
          
              -- self.delegate:removeChildByTag(9999, true)
              -- self.user_buf[i].user_c:getChildByName("n_zhang"):setVisible(true)
          -- end
      end
      if c_msg.zhuangPos~=-1 then
        self.user_Banker_buf[1][i]:setVisible(false)
      end
    end

    --------按钮控制-----------------
    print("房间状态打印----",c_msg.roomstate)
    if c_msg.roomstate ==N_DESK_STATE.N_DESK_STATE_BET then
      if tonumber(self.user_buf[6].pos)~= tonumber(c_msg.zhuangPos) then
        local msg=LocalData:Instance():get_UserActionMsgRes()
          if msg and msg.actionType ~=4 then
            self:button_control(4)
          end
      end
    end
     if c_msg.roomstate ==N_DESK_STATE.N_DESK_STATE_OPEN then
        self:button_control(6)
    end

end



--别的玩家加入广播
function gameControl:NotifyRoomUserMsg()
  local msg=LocalData:Instance():get_NotifyRoomUserMsg()
  -- dump(msg.msg_ID)
  -- dump(msg.usercount)

    local c_msg= msg.users[1]
    for i=1,#self.user_buf-1 do
      if self.user_buf[i].pos~=-1 and self.user_buf[i].pos== c_msg.pos then --说明断线重连不加信息

        if c_msg.online==2 then
          self.user_buf[i].user_c:getChildByName("offline"):setVisible(true)
        else
          self.user_buf[i].user_c:getChildByName("offline"):setVisible(false)
        end

        return
      end
      if self.user_buf[i].pos== -1 then
          self.user_buf[i].pos=c_msg.pos
          self:players_Info(i, c_msg)
          self.user_all_num_new=1
          return
      end
    end
    
end


function gameControl:once_Settlement()
      local colorlayer=cc.LayerColor:create(cc.c4b(0,0,0, 150))
      self.delegate.gameScene:getChildByName("result_node"):addChild(colorlayer,-1,225)

      self.delegate.gameScene:getChildByName("result_node"):setVisible(true)
      local msg=LocalData:Instance():get_NotifyRoomResultMsg()
      print("---结算页面---")
      dump(msg.round)
     



      for i=1,#msg.result do
        for j=1,#self.user_buf do
           if self.user_buf[j].pos==msg.result[i].pos then
                local num=self.delegate.gameScene:getChildByName("result_node"):getChildByName(tostring("result_bg_"..j)):getChildByName(tostring("result_"..j))
                local num_L=self.delegate.gameScene:getChildByName("result_node"):getChildByName(tostring("result_bg_"..j)):getChildByName(tostring("result_L_"..j))
                local num_fh=self.delegate.gameScene:getChildByName("result_node"):getChildByName(tostring("result_bg_"..j)):getChildByName(tostring("Image_"..j))
                if tonumber(msg.result[i].score) < 0   then
                  self.delegate.gameScene:getChildByName("result_node"):getChildByName(tostring("result_bg_"..j)):loadTexture("niuniu_tanchuang/n_frame_jianhaodi.png")
                  num:setVisible(false)
                  num_L:setVisible(true)
                  num_fh:loadTexture("gameover/n_ing_jianhao.png")
                else
                  num:setVisible(true)
                  num_L:setVisible(false)
                  num_fh:loadTexture("gameover/n_ing_jiahao.png")
                  self.delegate.gameScene:getChildByName("result_node"):getChildByName(tostring("result_bg_"..j)):loadTexture("niuniu_tanchuang/n_frame_jiahaodi.png")
                end
                num:setString(tostring(msg.result[i].score))
                num_L:setString(tostring(msg.result[i].score))
                local sceor_curr=self.user_buf[j].user_c:getChildByName("score_name_0"):getString()
                self.user_buf[j].user_c:getChildByName("score_name_0"):setString(tostring(msg.result[i].score+tonumber(sceor_curr)))
                self.delegate.gameScene:getChildByName("result_node"):getChildByName(tostring("result_bg_"..j)):setVisible(true)

                num:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(function()
                                     num:getParent():setVisible(false)
                            end)))
           end
         
        end
        if self.user_buf[6].pos==msg.result[i].pos then
              local resultLayer = cc.CSLoader:createNode("csb/resultLayer.csb")
              resultLayer:setTag(963)
              print("-----",msg.result[i].result)
              if msg.result[i].result==1 then
                resultLayer:getChildByName("n_win"):setVisible(true)
                local shareroleAction = cc.CSLoader:createTimeline("csb/resultLayer.csb")
                 resultLayer:runAction(shareroleAction)
                  shareroleAction:gotoFrameAndPlay(0,60, true)
                  Util:all_layer_Sound("sound_win")
              else
                Util:all_layer_Sound("sound_lose")
                resultLayer:getChildByName("n_lose"):setVisible(true)
              end
              resultLayer:getChildByName("prepare_but"):setVisible(false)
              resultLayer:addTo(colorlayer)
             --  local prepare_but=resultLayer:getChildByName("prepare_but")
             --  prepare_but:addTouchEventListener(function(sender, eventType  )
             --       if eventType ~= ccui.TouchEventType.ended then
             --           return
             --      end
             --      for i=1,6 do
             --        self.delegate.gameScene:getChildByName("result_node"):getChildByName(tostring("result_bg_"..i)):setVisible(false)
             --      end
             --      self.delegate.gameScene:getChildByName("result_node"):removeChildByTag(225)
             --      -- self:user_room_id(nil,msg.round,nil)--房间号
             --      -- self:function_Desk_show_Control("Desk_In") 
                 
             -- end)

        end
      end


      self:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(function()
                                      self.delegate.gameScene:getChildByName("result_node"):removeChildByTag(225)
                                      local is_over=self.delegate:game_over()
                                      if is_over then
                                        return
                                      end
                                       self:user_room_id(nil,msg.round,nil)--房间号
                                      -- if self.all_round==msg.round+1 then
                                      --   local layer=require("app.views.gameHallScene").new()
                                      --     cc.Director:getInstance():getRunningScene():addChild(layer) 
                                      --     self:removeFromParent()  
                                      -- end
                                      self:function_Desk_show_Control("Desk_In") 
    
                            end)))

      
end

function gameControl:onEnter()
      NotificationCenter:Instance():AddObserver("NotifyRoomUserMsg", self,
                       function()
                              -- self:game_start_status(0,1)
                              self:NotifyRoomUserMsg()      
                      end)--
      NotificationCenter:Instance():AddObserver("NotifyRoomUserActionMsg", self,
                       function()
                            local msg=LocalData:Instance():get_NotifyRoomUserActionMsg()
                            -- print("广播内容---",msg.actionType)

                            -- self:game_start_status(msg.roomstate,1)
                            self:room_status_tip(msg.roomstate)
                            
                            if msg.actionType==6 then --谁发起了解散，是否同意
                                self.delegate:dismis_room(2,msg.username,self.user_buf)
                                return
                            end
                            if msg.actionType==7 then --广播内容
                                self.delegate:dismis_room_stuck(msg,self.user_buf)
                                return
                            end

                            if msg.actionType==8 then --广播内容
                                self:Leave_room()
                                return
                            end

                            


                            self:NotifyRoomUserActionMsg() 
                            self:self_Refresh()     
                      end)

      NotificationCenter:Instance():AddObserver("UserActionMsgRes", self,
                       function()
          --                      
          --self.gameScene:getChildByName("n_star_node"):getChildByName("bt_zb")
                              local msg=LocalData:Instance():get_UserActionMsgRes()
                              print("自己操作返回---",msg.actionType)
                              -- if conditions then
                              --   --todo
                              -- end
                                self:room_status_tip(msg.actionType,1)

                              if msg.actionType==8 then
                                self.delegate:call_back_up_layer()--退出房间
                                return
                              end
                              -- if msg.actionType==2 then
                              --   self:game_start()
                              -- end

                              if msg.actionType==3 then
                                self:button_control(3)
                              end
                              if msg.actionType==4 then
                                
                                self:button_control(5)
                              end
                              if msg.actionType==5 then
                                self:button_control(7)
                                self:remove_time_upd()
                                -- self:add_time_upd("N_USER_STATE_OPEN")
                              end
                              -- if msg.actionType==5 then
                              --   self:button_control(7)
                              -- end
                                self:self_niu_info()
                                
                               
                                
                      end)

      NotificationCenter:Instance():AddObserver("NotifyRoomUserCardMsg", self,--手牌消息
                       function()
                                
                                print("----------手牌消息---")
                                local c_msg=LocalData:Instance():get_NotifyRoomUserCardMsg()
                                if c_msg.roomstate > 2 then 
                                  self.gameScene:getChildByName("bt_tc"):setVisible(false)
                                end
                                 
                                 self:NotifyRoomUserCardMsg()
                      end)


      NotificationCenter:Instance():AddObserver("NotifyRoomResultMsg", self,--结算消息
                       function()
                            self.is_once=false
                            
                            self.tip_status:stopAllActions()
                             self.tip_status:getParent():setVisible(false)
                             
                            self:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(function()
                                    self:function_paly_show_data()
                                    self:once_Settlement()
                              end)))

                                  
                      end)



       NotificationCenter:Instance():AddObserver("NotifyRoomDisbandMsg", self,--解散房间
                       function()
                                    print("··NotifyRoomDisbandMsg·")
                                    self.delegate:is_dismis_room()
                          
                                 
                      end)
NotificationCenter:Instance():AddObserver(GETPIC, self, function(target, data) --下载图片
                            -- dump(data)
                            self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
                                    self:ref_all_head(data.url,data.dex)
                              end)))

                            
                      end)
NotificationCenter:Instance():AddObserver("ZHANGYU", self,--解散房间
                       function()


                        dump(LocalData:Instance():get_Room_round())
                                 if LocalData:Instance():get_Room_round() and LocalData:Instance():get_Gameswitch()  ~=  0 then
                                      if LocalData:Instance():get_Room_round() < 1 then
                                         self.gameScene:getChildByName("n_star_node"):getChildByName("bt_yq_wx_2"):setVisible(true)
                                      end
                                 end
                                    
                                    
                                   
                                    self.gameScene:getChildByName("n_star_node"):getChildByName("bt_star_game"):setVisible(true)
                                 
                      end)

      
end

function gameControl:onExit()
    NotificationCenter:Instance():RemoveObserver("ZHANGYU", self)
    NotificationCenter:Instance():RemoveObserver("NotifyRoomUserMsg", self)
    NotificationCenter:Instance():RemoveObserver("NotifyRoomUserActionMsg", self)
    NotificationCenter:Instance():RemoveObserver("UserActionMsgRes", self)
    -- NotificationCenter:Instance():RemoveObserver("Userzhunbei", self)
    NotificationCenter:Instance():RemoveObserver("NotifyRoomResultMsg", self)
    NotificationCenter:Instance():RemoveObserver("NotifyRoomDisbandMsg", self)
    NotificationCenter:Instance():RemoveObserver("NotifyRoomUserCardMsg", self)
    NotificationCenter:Instance():RemoveObserver(GETPIC, self)
end


return  gameControl