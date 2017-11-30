--
-- Author: admin
-- Date: 2017-08-23 11:43:36
--
local voiceLayer = class("voiceLayer",function()
      return cc.Layer:create()
end)

function voiceLayer:ctor()--
    self:registerScriptHandler(function (event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        end
    end)
    self._voice_obj=nil
    self._massage=true
    self.time_count=0

    self.tape  =  nil
    local cache = cc.SpriteFrameCache:getInstance()
    cache:addSpriteFrames("yuyinPlist.plist", "yuyinPlist.png")

    self.voiceLayer = cc.CSLoader:createNode("csb/voiceLayer.csb")
    self:addChild(self.voiceLayer,1,19999)
    self.voiceLayer_act = cc.CSLoader:createTimeline("csb/voiceLayer.csb")
    self.voiceLayer_act:gotoFrameAndPlay(0,60, true)
    self.voiceLayer:setVisible(false)
    self.voiceLayer:runAction(self.voiceLayer_act)
    
    self.voice=Util:getVoice()--
    self:addChild(self.voice)

    local msg=LocalData:Instance():get_loading()
    self.voice:Init_Voice(tostring(msg.openID))

    self.sconde_time=0
end
--   播放动画
function voiceLayer:fun_voiceLayer(_tag )
          
          local _table={}
          for i=1,6 do
            local act=self.voiceLayer:getChildByName("tag"  ..   i)
            _table[i]=act
          end
          local voice_act=self.voiceLayer:getChildByName("voice_act")
          local Sprite_2=voice_act:getChildByName("Sprite_2")
           voice_act:setVisible(true)
          voice_act:setPosition(cc.p(_table[_tag]:getPositionX(),_table[_tag]:getPositionY()))
          
          -- Sprite_2:runAction(self.voiceLayer_act)
          return  voice_act
end



--  录音动画
function voiceLayer:fun_voiceAct( ... )
          local voiceAct = cc.CSLoader:createNode("csb/voiceAct.csb")
          self:addChild(voiceAct,1,29999)
          local voiceAct_act = cc.CSLoader:createTimeline("csb/voiceAct.csb")
          voiceAct:runAction(voiceAct_act)
          voiceAct_act:gotoFrameAndPlay(0,40, true)
end

--录音动画存放位置
function voiceLayer:startRecording()
      self:voice_audio(false)
      self.voice:StartRecording()--开始录音
      self:fun_voiceAct()
end

--停止录音动画
function voiceLayer:StopRecording()       
       self:voice_audio(true)
      self:removeChildByTag(29999)
      self.voice:StopRecording()--录音结束
      -- self:removeChildByTag(29999, true)
      self:open_update()--停止录音开启定时器，监听上传是否完成
      -- 
end

--自己播放
function voiceLayer:self_playRec()       
    local fileid=cc.UserDefault:getInstance():getStringForKey("fileId","-1")
    self.voice:DownloadRecordedFile(tostring(fileid))

    self._voice_obj= self:fun_voiceLayer(6)
    self.voiceLayer:setVisible(true)
    self.tape=self._voice_obj  
  end

--执行播放动画
function voiceLayer:Notify_Recording()
  if not self.node_buf then return end

  local msg=LocalData:Instance():get_UserTalkMsg()
  self:Stop_Notify_Recording()
  self:open_update()--接收广播开启定时器
  self.voice:DownloadRecordedFile(tostring(msg.talkurl))

      for i=1,#self.node_buf-1 do
        print("dayin ----",self.node_buf[i].pos,msg.pos,i)
        if self.node_buf[i].pos==msg.pos then
          --执行循环动画
          self._voice_obj= self:fun_voiceLayer(i)
          self.voiceLayer:setVisible(true)
          self.tape=self._voice_obj
          return
        end
      end

end

--停止播放动画
function voiceLayer:Stop_Notify_Recording()
  self:close_update()--播放完毕完毕定时器
  self.tape=nil
  self.voiceLayer:setVisible(false)
  --self._voice_obj:setVisible(false)
  --动画隐藏----
  self.time_count=0
  self:voice_audio(true)
  
end


function voiceLayer:Send_Server()
  self:close_update()--播放完毕完毕定时器
  local table ={
         pos=tonumber(self.node_buf[6].pos),
         infotype=3,
         talkurl=cc.UserDefault:getInstance():getStringForKey("fileId","-1"),
         infoindex=0,
    }
    ServerWS:Instance():UserTalkMsg(table)

end


-- --  所谓的定时器
function voiceLayer:fun_update(dt)
      
    self.sconde_time=self.sconde_time+dt
    if self.sconde_time < 0.5 then return end
    self.sconde_time=0 

    if cc.UserDefault:getInstance():getStringForKey("OnUploadFile","-1")=="1" then --上传完成通知语音消息
      cc.UserDefault:getInstance():setStringForKey("OnUploadFile","-1")
      self:Send_Server()
      self:self_playRec()
    end

    if cc.UserDefault:getInstance():getStringForKey("OnDownloadFile","-1")=="1" then --下载完成完成通知语音消息
      self.time_count=1
      cc.UserDefault:getInstance():setStringForKey("OnDownloadFile","-1")
    end
    if self.time_count  ~=  0 then
      self.time_count=self.time_count+1
    end
    if self.time_count>60 then

       self:Stop_Notify_Recording()
       cc.UserDefault:getInstance():setStringForKey("OnPlayRecordedFile","-1")
    end
    print("-----毕完成通知----",cc.UserDefault:getInstance():getStringForKey("OnPlayRecordedFile","-1"),"   ",self.time_count)
    
    if cc.UserDefault:getInstance():getStringForKey("OnPlayRecordedFile","-1")=="1" then --播放完毕完成通知语音消息
      print("播放完毕完成通知语音消息")
      self:Stop_Notify_Recording()
      cc.UserDefault:getInstance():setStringForKey("OnPlayRecordedFile","-1")
    end   
end


-- function voiceLayer:update()
--       --  self.sconde_time=self.sconde_time+1
      

--       -- self.sconde_time=self.sconde_time+dt
--       -- if self.sconde_time < 0.5 then return end
--       -- self.sconde_time=0 

--       if cc.UserDefault:getInstance():getStringForKey("OnUploadFile","-1")=="1" then --上传完成通知语音消息
--         cc.UserDefault:getInstance():setStringForKey("OnUploadFile","-1")
--         self:Send_Server()
--         self:self_playRec()
--       end

--       if cc.UserDefault:getInstance():getStringForKey("OnDownloadFile","-1")=="1" then --下载完成完成通知语音消息
--         self.time_count=1
--         cc.UserDefault:getInstance():setStringForKey("OnDownloadFile","-1")
--       end
--       if self.time_count  ~=  0 then
--         self.time_count=self.time_count+1
--       end
--       if self.time_count>60 then

--          self:Stop_Notify_Recording()
--          cc.UserDefault:getInstance():setStringForKey("OnPlayRecordedFile","-1")
--       end
--        print("-----毕完成通知----",cc.UserDefault:getInstance():getStringForKey("OnPlayRecordedFile","-1"))
      
--       if cc.UserDefault:getInstance():getStringForKey("OnPlayRecordedFile","-1")=="1" then --播放完毕完成通知语音消息
--         print("播放完毕完成通知语音消息")
--         self:Stop_Notify_Recording()
--         cc.UserDefault:getInstance():setStringForKey("OnPlayRecordedFile","-1")
--       end


-- end




--刷新位置节点
function voiceLayer:set_pos_node(node_buf)
   self.node_buf=node_buf

end

function voiceLayer:open_update()
      self:close_update()
      self:scheduleUpdateWithPriorityLua(function(dt)
        self:fun_update(dt) 
    end,1)
       
end

function voiceLayer:close_update()
    if device.platform~="android" then
       self:unscheduleUpdate()
    end
    
end

-- function voiceLayer:open_update()
--   if self.schedulerID then
--     cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
--     self.schedulerID=nil
--   end
--   local scheduler = cc.Director:getInstance():getScheduler()  
 
--     self.schedulerID = scheduler:scheduleScriptFunc(function()  
--        self:update() 
--     end,1,false)   

-- end

-- function voiceLayer:close_update()
--   if self.schedulerID then
--     cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
--     self.schedulerID=nil
--   end
-- end

function voiceLayer:voice_audio(is_play)
    if is_play then
      if LocalData:Instance():get_music_hit() then
          Util:player_music_hit("hall_bg_voice",true )
       end
      return
    end

    audio.pauseMusic()
end


function voiceLayer:onEnter()
    
      NotificationCenter:Instance():AddObserver("UserTalkMsg", self,
                       function()
                            local msg=LocalData:Instance():get_UserTalkMsg()
                            if msg.infotype~=3 then return end
                                -- self._massage=false
                                self:voice_audio(false)

                                self:Notify_Recording()
                      end)--
end


function voiceLayer:onExit()  
    -- local cache = cc.SpriteFrameCache:getInstance()
    -- cache:removeSpriteFramesFromFile("yuyinPlist.plist", "yuyinPlist.png")  
     NotificationCenter:Instance():RemoveObserver("UserTalkMsg", self)
end


return voiceLayer