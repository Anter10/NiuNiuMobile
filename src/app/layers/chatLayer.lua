--
-- Author: Your Name
-- Date: 2017-08-10 15:00:51
--
--聊天
local chatLayer = class("chatLayer",function()
      return cc.Layer:create()
end)

function chatLayer:ctor()--
    self._text_str={
    "     大家好，很高兴见到各位！",
    "     快点吧，我等到花儿也谢了!",
    "     我是庄家谁敢挑战我？",
    "     怎么又掉线了，网络怎么这么差！ ",
    "     看我通杀全场！这些钱都是我的！",
    "     风水轮流转，底裤都输光了！",
    "     底牌亮出来绝对吓死你！",
    "     不要吵啦，不要吵啦，专心玩游戏吧!",
    "     君子报仇下局不晚，这局暂且放过你!",
    "     你这就是厕所里打灯笼，找屎啊！"
  }
  self._text_str1={
    "大家好，很高兴见到各位！",
    "快点吧，我等到花儿也谢了! ",
    "我是庄家谁敢挑战我？",
    "怎么又掉线了，网络怎么这么差！ ",
    "看我通杀全场！这些钱都是我的！",
    "风水轮流转，底裤都输光了！",
    "底牌亮出来绝对吓死你！",
    "不要吵啦，不要吵啦，专心玩游戏吧! ",
    "君子报仇下局不晚，这局暂且放过你! ",
    "你这就是厕所里打灯笼，找屎啊！"
  }
    
    self._table_name_bg={510,540,510,670,460,680,500,640,520,530}
    self._con_table={320,350,340,390,300,440,330,400,340,340}
	  self.obj_tag=1  --  其他玩家对象
	  self.ISplayer_voice=1  --  1   语音   2   动画  是语音还是表情动画
	  self.player_act_tag=1    --  其他玩家动画编号
    self._oneself  =  nil
    self:registerScriptHandler(function (event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        end
    end)

    self.node_buf={}

	  self:fun_init()
	  
end
function chatLayer:fun_init( ... )
		self.chatLayer = cc.CSLoader:createNode("csb/chatLayer.csb")
        self:addChild(self.chatLayer)
        self.bg=self.chatLayer:getChildByName("bg")
        self.chatLayer:setLocalZOrder(100)
        self.bg:setVisible(false)
        
        self._obj_table = {}
        for i=1,6 do
        	local _tag_bj=self.chatLayer:getChildByName("tag"  ..  i)   --  标记
        	self._obj_table[i]=_tag_bj
        end
        --  其他玩家动画  
       
        --self.bg:setVisible(true)
        

      
        --  点击背景  去除聊天
        self.bg:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                   self:setVisible(false)
                   self.bg:setVisible(false)
                   
        end)

        self.img=self.bg:getChildByName("img")
        self.voice_bg=self.img:getChildByName("voice_bg")  --  文字描述
        self.voice_bg:setItemModel(self.voice_bg:getItem(0))
        self.voice_bg:removeAllItems()
        for i=1,10 do
          self.voice_bg:pushBackDefaultItem()
          local  cell = self.voice_bg:getItem(i-1)
          local  voice_1=cell:getChildByName("voice_1")
          voice_1:setVisible(false)
          local Text_1=cell:getChildByName("Text_1")
          Text_1:setString(self._text_str[i])
          cell:addTouchEventListener(function(sender, eventType  )
                  if eventType == ccui.TouchEventType.began then
                       voice_1:setVisible(true)
                   else
                     voice_1:setVisible(false)
                  end
                   
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  
                   print("播放对应的语音"  ..   i)
                   
                    self:send_server_type(1,i)

                    self:fun_act_voice(6,i,1,1)
                    self.bg:setVisible(false)
                   

        end)

        end
        self.act_bg=self.img:getChildByName("act_bg")  --   动画

        self.input_bg=self.img:getChildByName("input_bg")  ---  暂时  用来点击文字
        self.input_bg:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                   self.voice_bg:setVisible(true)
                   self.act_bg:setVisible(false)
        end)
        self.act_but=self.img:getChildByName("act_but")  ---  动画界面按钮
        self.act_but:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                   self.voice_bg:setVisible(false)
                   self.act_bg:setVisible(true)
        end)
        self.send_but=self.img:getChildByName("send_but")  ---  发送
        self.send_but:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                   print("发送")
        end)
        
       
        self:fun_act()
        
end

--  动画点击
function chatLayer:fun_act( ... )
	local act_table={}
	for i=1,12 do
		local _act=self.act_bg:getChildByName("act"  ..   i)
		act_table[i]=_act
	end
	for j=1,12 do
		act_table[j]:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  self:send_server_type(2,sender:getTag()-900)
                   print("播放对应的动画"  ..   j)
                   self.bg:setVisible(false)
                    
                   	self:fun_act_img(6,sender:getTag()-900,1)
                   
                   
        end)
	end
end


function chatLayer:send_server_type(type,data)--type 1 是语音，2 是动画
local infotype =2 
if type==2 then
  infotype=4
end
  local table ={
         pos=tonumber(self.node_buf[6].pos),
         infotype=infotype,
         -- talkinfo=
         -- talkurl=
         infoindex=tonumber(data),
    }
    dump(data)
    ServerWS:Instance():UserTalkMsg(table)
end


--  聊天表情动画
function chatLayer:fun_act_img(_obj,start_img,_oneself)
  dump(start_img)
	--  缓存动画
	 local cache = cc.SpriteFrameCache:getInstance()
    cache:addSpriteFrames("niuniu_gameover/GameChatexpression.plist", "niuniu_gameover/GameChatexpression.png")
    local m_pSprite1 = cc.Sprite:create("niuniu_gameover/touming.png" )
    if _oneself then
       self._oneself=1
    end
    m_pSprite1:setVisible(false)
    m_pSprite1:setPosition( cc.p(self._obj_table[_obj]:getPositionX(),self._obj_table[_obj]:getPositionY()) )
    if _obj==5 then
     m_pSprite1:setPosition( cc.p(self._obj_table[_obj]:getPositionX()-380,self._obj_table[_obj]:getPositionY()) )
    elseif _obj==4  or _obj==3  then
      m_pSprite1:setPosition( cc.p(self._obj_table[_obj]:getPositionX()-200,self._obj_table[_obj]:getPositionY()) )
    end
    
    self:addChild(m_pSprite1)
    m_pSprite1:setLocalZOrder(10)
	 
    m_pSprite1:setVisible(true)
    local animFrames = {}
    for i = 0,3 do 
        local frame = cache:getSpriteFrame( string.format("chart_expression".. start_img .."_".."%d.png", i) )
        animFrames[i] = frame
    end
    local function removeThis()
                    if _oneself then
                      self._oneself=0
                      
                       self:setVisible(false)
                    end
                    m_pSprite1:setVisible(false)
                		
	end
    local animation = cc.Animation:createWithSpriteFrames(animFrames, 0.2)
    m_pSprite1:runAction( cc.Sequence:create(cc.Repeat:create( cc.Animate:create(animation),3 ),cc.CallFunc:create(removeThis)))
    
end
--  聊天语音动画  
function chatLayer:fun_act_voice(_obj,_text,_gender,_oneself)  --  对象位置  是否翻转
   print("···",_text,self._text_str[_text])
  if _gender==1 then
       Util:all_layer_Sound("man_"   ..  _text )
   else
      Util:all_layer_Sound("woman_"  ..   _text)
   end
  local yu_img=self.chatLayer:getChildByName("yu_img")  --  语音效果 
  local yu_img1=yu_img:getChildByName("yu_img1")  --  语音效果 
  if _oneself then
     self._oneself=1
   end 
  yu_img:setVisible(true)
  yu_img:setPosition(cc.p(self._obj_table[_obj]:getPositionX(),self._obj_table[_obj]:getPositionY()))
  local yu_text=yu_img:getChildByName("yu_text")  --  
   yu_text:setString(self._text_str1[_text])
  yu_img1:setContentSize(cc.size(yu_text:getContentSize().width *  1.2, yu_img1:getContentSize().height ))

	 local function stopAction()
                   if _oneself then
                     self._oneself=0
                     self:setVisible(false)
                    
                   end
                   yu_img:setVisible(false) 
                   
	                 
	 end
	local callfunc = cc.CallFunc:create(stopAction)   -- Repeat   RepeatForever
	
  yu_img:runAction(cc.Sequence:create(cc.DelayTime:create(3),cc.CallFunc:create(stopAction)))
  

end


--刷新位置节点
function chatLayer:set_pos_node(node_buf)
   self.node_buf=node_buf

end

function chatLayer:accept_talk()
  local msg=LocalData:Instance():get_UserTalkMsg()
   self:setVisible(true)
  --self.bg:setVisible(false)
  -- self.act_bg:setVisible(true)
  -- self.voice_bg:setVisible(false)
  print("语音聊天----",msg.infotype,msg.infoindex)
   for i=1,#self.node_buf-1 do
      if self.node_buf[i].pos==msg.pos then
        if msg.infotype==2 then --预设聊天内容
          self:fun_act_voice(i,msg.infoindex,1)
        elseif msg.infotype==4 then
          dump(msg.infoindex)
          self:fun_act_img(i,msg.infoindex)
        end

      end
   end

end



function chatLayer:onEnter()
      NotificationCenter:Instance():AddObserver("UserTalkMsg", self,
                       function()
                        local msg=LocalData:Instance():get_UserTalkMsg()
                        if msg.infotype==3 then
                          return
                        end
                               self:accept_talk()     
                      end)--
end


function chatLayer:onExit()
    print("当前是什么情况啊")
    local cache = cc.SpriteFrameCache:getInstance()
    cache:removeSpriteFramesFromFile("niuniu_gameover/GameChatexpression.plist")
    NotificationCenter:Instance():RemoveObserver("UserTalkMsg", self)
end


return chatLayer