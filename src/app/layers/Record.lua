--
-- Author: Your Name
-- Date: 2017-08-09 11:17:29
----  战绩
local wanfa={"轮流坐庄","翻四张抢庄","经典抢庄"}
local Record = class("Record",function()
      return cc.Layer:create()
end)

function Record:ctor()--

  self:registerScriptHandler(function (event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        end
    end)

	  self:fun_init()
    --Server:Instance():fun_pic()
    -- local path=cc.FileUtils:getInstance():getWritablePath()
    -- dump(path)
    -- local fragment_sprite = display.newSprite(path .. "httpcocos2d-x.orgsimagesimg-cocos2dx.jpg")
    -- self:addChild(fragment_sprite)
    
end
function Record:fun_init( ... )
		    self.Record = cc.CSLoader:createNode("csb/Record.csb")
        self:addChild(self.Record)
        self.record_BG=self.Record:getChildByName("record_BG")
        self.Text_1=self.record_BG:getChildByName("Text_1")
        self.Text_1:setVisible(false)
        --  返回
        local record_back=self.record_BG:getChildByName("record_back")
        record_back:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                  Util:all_layer_Sound("Audio_Button_Click")
                  self:setVisible(false)
        end)

        --  初始化列表
        self.record_listView=self.record_BG:getChildByName("record_listView")
        self.record_listView:setItemModel(self.record_listView:getItem(0))
        self.record_listView:removeAllItems()

        Util:fun_loadbar(self,222 )

        -- self:fun_list_data()
end

function Record:fun_list_data(  )
self.Text_1:setVisible(false)
  self.record_listView=self.record_BG:getChildByName("record_listView")
        self.record_listView:setItemModel(self.record_listView:getItem(0))
        self.record_listView:removeAllItems()
        
   --  战绩数据
   dump("战绩数据")
   local msg=LocalData:Instance():get_HistoryResultMsgRes()
   if not msg then
      self.Text_1:setVisible(true)
      if self:getChildByName(222) then
         self:removeChildByTag(222, true)
      end
     return
   end

   if self:getChildByName(222) then
      self:removeChildByTag(222, true)
   end 
   
   self:setVisible(true)
   local _num=#msg
   dump(_num)

   --dump(os.date("%Y%m%d%H",tonumber(msg["time"])/1000))
   -- if _num<=0 then
   --   return
   -- end
	  for i=1,_num do
          self.record_listView:pushBackDefaultItem()
          local  cell = self.record_listView:getItem(i-1)
          local  all=msg[i]
          local record_ID=cell:getChildByName("record_ID")
          if all["deskID"] then
             record_ID:setString("房间ID："  ..   all["deskID"])
          end
          local record_rule=cell:getChildByName("record_rule")
          if all["type"] then
            record_rule:setString("玩法："  ..   wanfa[all["type"]])
          end
          local record_time=cell:getChildByName("record_time")
          if all["time"] then
            record_time:setString(os.date("%Y-%m-%d %H:%M:%S",tonumber(all["time"])))
          end
          --(tostring(Util:FormatTime_colon(tonumber(all["time"]))))  
          local scoreInfo=all["scoreInfo"]
          for j=1,#scoreInfo do
          	local record_name=cell:getChildByName("record_name_"  ..  tostring(j))
            record_name:setVisible(true)
          	record_name:setString(scoreInfo[j]["userName"])
          	local record_score=cell:getChildByName("record_score_" ..   j)
            record_score:setVisible(true)
            local result_1=record_score:getChildByName("result_1")  --  证书
            local Image_1=record_score:getChildByName("Image_1")
            local result_L_1=record_score:getChildByName("result_L_1") --  负数
          	result_1:setString(scoreInfo[j]["score"])
            result_L_1:setString(scoreInfo[j]["score"])
            if tonumber(scoreInfo[j]["score"]) >0 then
              result_1:setVisible(true)
              result_L_1:setVisible(false)
              Image_1:loadTexture("niuniu_gameover/n_ing_jiahao.png")  --  加号
              --Image_1:loadTexture("gameover/n_ing_jianhao.png")  --减号
            else
               result_1:setVisible(false)
               result_L_1:setVisible(true)
               --Image_1:loadTexture("gameover/n_ing_jiahao.png")  --  加号
               Image_1:loadTexture("niuniu_gameover/n_ing_jianhao.png")  --减号
            end
            
          end
          local record_copy=cell:getChildByName("record_copy")
          record_copy:setVisible(false)
          record_copy:addTouchEventListener(function(sender, eventType  )
                   if eventType ~= ccui.TouchEventType.ended then
                       return
                  end
                   print("复盘")
                   Util:all_layer_Sound("Audio_Button_Click")
          end)
      end
end
function Record:onEnter()
      -- NotificationCenter:Instance():AddObserver("HistoryResultMsgRes", self,
      --                  function()
      --                   dump("战绩成绩消息")    
      --                 end)--
end


function Record:onExit()

     --NotificationCenter:Instance():RemoveObserver("HistoryResultMsgRes", self)
end




return Record