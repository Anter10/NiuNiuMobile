--
-- Author: Your Name
-- Date: 2017-08-14 17:23:55
--
--  查看详情

local checkLayer = class("checkLayer",function()
      return cc.Layer:create()
end)

function checkLayer:ctor()--
   
	  self:fun_init()
end
function checkLayer:fun_init( ... )
		self.checkLayer = cc.CSLoader:createNode("csb/check.csb")
        self:addChild(self.checkLayer)
        self.xiang_BG=self.checkLayer:getChildByName("xiang_BG")

        --  返回
        local back=self.xiang_BG:getChildByName("back")
        back:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                   print("返回")
                   Util:all_layer_Sound("Audio_Button_Click")
                   self:removeFromParent()
        end)
        
        self.xiang_title=self.xiang_BG:getChildByName("xiang_title")
        --self:fun_inningsName()

        --  列表
        self.xiang_listView=self.xiang_BG:getChildByName("xiang_listView")  --  文字描述
        self.xiang_listView:setItemModel(self.xiang_listView:getItem(0))
        self.xiang_listView:removeAllItems()

        self:fun_list()
        
end
--  局数昵称
function checkLayer:fun_inningsName( ... )
	 local game_over_data=LocalData:Instance():get_NotifyRoomAllScoreMsg()
     if not game_over_data then return false end
      
	for i=1,6 do
		local name=self.xiang_title:getChildByName("xiang_name_"  ..   i)
		local data=game_over_data.allscore[i]
    if data then
      name:setString(tostring(data.name))
    end
		
	end
end
function checkLayer:fun_list( ... )
	 local game_over_data=LocalData:Instance():get_NotifyRoomAllScoreMsg()
     if not game_over_data then return false end
	for i=1,#game_over_data.sinfo do
          self.xiang_listView:pushBackDefaultItem()
          local  cell = self.xiang_listView:getItem(i-1)
          local RoundData=game_over_data.sinfo[i]  --   局数
          local  xiang_num=cell:getChildByName("xiang_num")
          if i<20 then  --   只做到20啦  后期美术改
          	xiang_num:loadTexture("gameover/n_ing_"  ..   i   ..   ".png")
          end
          local  list_bg=cell:getChildByName("list_bg")
          for j=1,#RoundData.scoreinfo do
          	    local data=RoundData.scoreinfo[j]  --   局数
                
                if data then
                    local  xiang_niu_=list_bg:getChildByName("xiang_niu_" ..  tostring(j) )
                    xiang_niu_:setString(N_NIU_STATE[tonumber(data.niu)])
                    local name=self.xiang_title:getChildByName("xiang_name_"  ..   j)
                    name:setString(tostring(Util:GetShortName(tostring(data.name),7,14)))

                    local  zhuang1=xiang_niu_:getChildByName("zhuang1") 
                       dump(j)
                       dump(data.zhuang)
                       if data.zhuang  ==  1   then
                               zhuang1:setVisible(true)             --todo
                      else
                                zhuang1:setVisible(false) 
                         end                   
                                       
                    -- local  zhuang_text1=xiang_niu_:getChildByName("zhuang_text1")
                    -- zhuang_text1:setString(data.score)  --  分数
                    --  if  data.score<0  then  --  负数
                    --    zhuang_text1:setColor(cc.c3b(190, 122, 19))
                    --  else  --  正数
                    --    zhuang_text1:setColor(cc.c3b(82, 82, 198))
                    --  end
                    local  result_bg=xiang_niu_:getChildByName("result_bg")
                    if data.score then
                      result_bg:setVisible(true)
                    end
                    local  fen1=result_bg:getChildByName("fen1")
                    local  fen2=result_bg:getChildByName("fen2")
                    local  biaoji=result_bg:getChildByName("biaoji")
                    fen1:setString(data.score)
                    fen2:setString(data.score)
                     if  data.score<0  then  --  负数
                        fen1:setVisible(true)
                        fen2:setVisible(false)
                        biaoji:loadTexture("gameover/n_ing_jianhao.png")
                        result_bg:loadTexture("niuniu_tanchuang/n_frame_jianhaodi.png")
                     else  --  正数
                        fen1:setVisible(false)
                        fen2:setVisible(true)
                        biaoji:loadTexture("gameover/n_ing_jiahao.png")
                        result_bg:loadTexture("niuniu_tanchuang/n_frame_jiahaodi.png")
                     end




                end
	          	
          end
     end
end


     return checkLayer