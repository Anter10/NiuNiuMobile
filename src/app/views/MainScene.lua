
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function globals(data)
   print("datassssssssjava",data)
end
-- 
-- GameScene=require("app.views.GameScene")
-- require "app.views.WebProxyTest"
function MainScene:onCreate()
   -- 开启Socket网络链接
   ServerWS:Instance():connect()

   self.excessiveLayer = cc.CSLoader:createNode("csb/excessiveLayer.csb")
   self:addChild(self.excessiveLayer)
   self.excessiveLayer:setTag(1023)
   
   self.excessiveLayer:getChildByName("bg"):getChildByName("lod_bg"):setVisible(false)
   self.excessiveLayer:getChildByName("bg"):getChildByName("lodbar"):setVisible(false)
   self.excessiveLayer:getChildByName("bg"):getChildByName("lod_text"):setVisible(false)
   


   -- local _bj = 0
   -- local function removeThis()
   --       if _bj==1 then
   --          return
   --       end
   --       Util:fun_room_Offlinepopwindow("网络异常，请您重新连接",function (sender, eventType)
   --            if eventType==1  then
   --               Server:Instance():request_http_open("http://admin.sharkpoker.cn/index.php/Home/Login/appset/versions/1.0")
   --               self:runAction(cc.Sequence:create(cc.DelayTime:create(5),cc.CallFunc:create(removeThis)))
   --            end
   --       end)                      
   -- end
  
   -- 请求

   -- self:runAction(cc.Sequence:create(cc.DelayTime:create(5),cc.CallFunc:create(removeThis)))
   -- NotificationCenter:Instance():AddObserver("switch", self, function(target, data) --下载图片
   --       _bj=1
   --       self:removeChildByTag(1023, true)
   --       self:addChild(require("app.views.loadScene").new())
   -- end)

   local writablePath = cc.FileUtils:getInstance():getWritablePath()
   local  path_res    = writablePath.."down_pic/"
   cc.FileUtils:getInstance():removeDirectory(path_res)
   cc.FileUtils:getInstance():createDirectory(path_res)
   cc.FileUtils:getInstance():addSearchPath(path_res)
end


function MainScene:onEnter()
    if cc.Director:getInstance():getRunningScene() then
       cc.Director:getInstance():replaceScene(require("src.VersionUpdate").new())
    end 
end




return MainScene
