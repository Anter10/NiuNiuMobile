
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
-- 
-- GameScene=require("app.views.GameScene")
-- require "app.views.WebProxyTest"
function MainScene:onCreate()
    -- add background image
    -- display.newSprite("HelloWorld.png")
    --     :move(display.center)
    --     :addTo(self)
    -- display.runScene(require("app.views.gameHallScene").new())
    -- self:addChild(require("app.views.gameScene").new())
   -- self:addChild(require("app.views.gameHallScene").new())
   -- self:addChild(require("app.views.loadScene").new())
   --  目的是  在没网的时候  没有返回开关时候  出现的面板
   self.excessiveLayer = cc.CSLoader:createNode("csb/excessiveLayer.csb")
   self:addChild(self.excessiveLayer)
   self.excessiveLayer:setTag(1023)
   self.excessiveLayer:getChildByName("bg"):getChildByName("lod_bg"):setVisible(false)
   self.excessiveLayer:getChildByName("bg"):getChildByName("lodbar"):setVisible(false)
   self.excessiveLayer:getChildByName("bg"):getChildByName("lod_text"):setVisible(false)
   --Util:fun_loadbar(cc.Director:getInstance():getRunningScene(),999999)
   local _bj=0
    local function removeThis()
              --cc.Director:getInstance():getRunningScene():removeChildByTag(999999, true)
               if _bj==1 then
                  return
               end
                Util:fun_room_Offlinepopwindow("网络异常，请您重新连接",function (sender, eventType)
                      if eventType==1  then
                            Server:Instance():request_http_open("http://admin.sharkpoker.cn/index.php/Home/Login/appset/versions/1.0")
                            --Util:fun_loadbar(cc.Director:getInstance():getRunningScene(),999999)
                            self:runAction(cc.Sequence:create(cc.DelayTime:create(5),cc.CallFunc:create(removeThis)))
                      end
                  end)                      
     end
     self:runAction(cc.Sequence:create(cc.DelayTime:create(5),cc.CallFunc:create(removeThis)))



   NotificationCenter:Instance():AddObserver("switch", self, function(target, data) --下载图片
                                _bj=1
                                --cc.Director:getInstance():getRunningScene():removeChildByTag(999999, true)
                               self:removeChildByTag(1023, true)
                               self:addChild(require("app.views.loadScene").new())
                      end)

   

   -- local scene=require("app.views.loadScene").new()
   -- dump(scene.name_)
   -- cc.Director:getInstance():replaceScene(scene)
    -- add HelloWorld label
 --    cc.Label:createWithSystemFont("Hello World", "Arial", 40)
 --        :move(display.cx, display.cy + 200)
 --        :addTo(self)

 --  local node = cc.CSLoader:createNode("csb/gameScene.csb")
	-- node:addTo(self)
    -- local str=cc.hello:create()
    -- str:helloMsg()

    -- local cache = cc.SpriteFrameCache:getInstance()
    -- cache:addSpriteFrames("GameChatexpression.plist", "GameChatexpression.png")

    -- local cache1 = cc.SpriteFrameCache:getInstance()
    -- cache1:addSpriteFrames("douniurenwu.plist", "douniurenwu.png")



    -- local sprite = cc.Sprite:createWithSpriteFrameName("chart_expression0_0.png")
    -- sprite:setPosition(cc.p(display.cx, display.cy + 200))
    --   self:addChild(sprite)
    -- local sprite1 = cc.Sprite:createWithSpriteFrameName("chart_expression10_0.png")
    -- sprite1:setPosition(cc.p(display.cx, display.cy + 400))
    -- self:addChild(sprite1)

    -- local sprite2 = cc.Sprite:createWithSpriteFrameName("chart_expression1_0.png")
    -- sprite2:setPosition(cc.p(display.cx, display.cy))
    -- self:addChild(sprite2)


    -- local sprite3 = cc.Sprite:createWithSpriteFrameName("chart_expression2_0.png")
    -- sprite3:setPosition(cc.p(display.cx, display.cy-200))
    -- self:addChild(sprite3)

    -- local orbit3 = cc.OrbitCamera:create(2,1, 0, 0, 180, 90, 0)
    -- local action3 = cc.Sequence:create(orbit3, orbit3:reverse())

    -- local orbit1 = cc.OrbitCamera:create(2,1, 0, 0, 180, 0, 0)
    -- local action1 = cc.Sequence:create(orbit1, orbit1:reverse())

    -- local orbit2 = cc.OrbitCamera:create(2,1, 0, 0, 180, -45, 0)
    -- local action2 = cc.Sequence:create(orbit2, orbit2:reverse())


   
    -- sprite:runAction(cc.RepeatForever:create(action1))

    -- sprite1:runAction(cc.RepeatForever:create(action2))

    -- sprite2:runAction(cc.RepeatForever:create(action3))
  
    
    -- self:function_action(cache,"chart_expression0_",sprite)
    -- self:function_action(cache,"chart_expression10_",sprite1)
    -- self:function_action(cache,"chart_expression1_",sprite2)
    -- self:function_action(cache,"chart_expression2_",sprite3)

   
   -- local particle = cc.ParticleSystemQuad:create("particle/bomb_tianwang.plist")
   -- particle:setPosition(cc.p(display.cx-300, display.cy+500))
   -- self:addChild(particle)


   -- local particle1 = cc.ParticleSystemQuad:create("particle/shine5.plist")
   -- particle1:setPosition(cc.p(display.cx-300, display.cy))
   -- -- particle1:setDuration(-1)
   -- self:addChild(particle1)


   -- local particle2 = cc.ParticleSystemQuad:create("particle/tonghua1.plist")
   -- particle2:setPosition(cc.p(display.cx+300, display.cy+500))
   -- self:addChild(particle2)


   -- local particle3 = cc.ParticleSystemQuad:create("particle/touyou.plist")
   -- particle3:setPosition(cc.p(display.cx+300, display.cy))
   -- self:addChild(particle3)


   -- local particle4 = cc.ParticleSystemQuad:create("particle/tonghua2.plist")
   -- particle4:setPosition(cc.p(display.cx+300, display.cy-500))
   -- self:addChild(particle4)


   --  local particle5 = cc.ParticleSystemQuad:create("particle/tonghua4.plist")
   -- particle5:setPosition(cc.p(display.cx-300, display.cy-500))
   -- -- particle5:setDuration(-1)
   -- self:addChild(particle5)
   -- cc.Director:getInstance():replaceScene(runWebSocketTest())
   -- ServerWS:Instance():connect()
   
  -- Server:Instance():register()
   

   -- dump(Util:judgeIsAllNumber("abc32ab"))
  --   local label = cc.Label:createWithTTF("MainMenu", "arial.ttf", 40)
  --   label:setAnchorPoint(cc.p(0.5, 0.5))
  --   local MenuItem = cc.MenuItemLabel:create(label)
  --   -- MenuItem:registerScriptTapHandler(MainMenuCallback)
  --    local Menu = cc.Menu:create()
  --   Menu:addChild(MenuItem)
  --   Menu:setPosition(0, 0)
  --   MenuItem:setPosition(display.cx, display.cy)
  --   self:addChild(Menu)

  -- self:function_Flop()
    local writablePath = cc.FileUtils:getInstance():getWritablePath()
   local  path_res=writablePath.."down_pic/"
    cc.FileUtils:getInstance():removeDirectory(path_res)

  lfs.mkdir(path_res)
  cc.FileUtils:getInstance():addSearchPath(path_res)

end




return MainScene
