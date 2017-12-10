
cc.FileUtils:getInstance():setPopupNotify(false)

cc.FileUtils:getInstance():setSearchPaths({})
cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath())
cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath().."src/app/")
cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath().."res/")

cc.FileUtils:getInstance():addSearchPath("res/")
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("src/app/")


require "src/app/protobuf/containers"
require "src/app/protobuf/decoder"
require "src/app/protobuf/descriptor"
require "src/app/protobuf/encoder"
require "src/app/protobuf/listener"
require "src/app/protobuf/protobuf"
require "src/app/protobuf/text_format"
require "src/app/protobuf/type_checkers"
require "src/app/protobuf/wire_format"
require "src/app/model/IosAndAndroidCommon"

require "config"
require "cocos.init"

require("src.app.AllRequire")

cc.exports.targetplatform = cc.Application:getInstance():getTargetPlatform()

cc.exports.heheniuniu  =  0



cc.exports.twoPointDistance   = function(pointOnex,pointOney, pointTwox,pointTwoy)
    pointTwox = pointTwox or pointOnex or 0
    pointTwoy = pointTwoy or pointOney or 0
    local xDistance = math.abs(pointOnex  -  pointTwox) 
    local yDistance = math.abs(pointOney  -  pointTwoy)
    return math.sqrt(xDistance * xDistance +  yDistance * yDistance)
end



cc.exports.decodeMsgData = function(t)
    local msg = {};
    if type(t) ~= "table" then
        return t;
    end
    for k,v in pairs(t._fields) do
        if type(v) == "table" and v._fields ~= nil then --reuqired optinal
            msg[k.name] = decodeMsgData(v); 
            -- msg[k.name] = {};
            -- table.insert(msg[k.name],qq.modifyTable(v));
        elseif type(v) == "table" and v._fields==nil then
            msg[k.name] = {};
            for ii,vv in ipairs(v) do
                local tmp = decodeMsgData(vv)
                -- dump(tmp);
                table.insert(msg[k.name],tmp);
            end
        elseif type(v) == "string" or type(v) == "number" then
            msg[k.name] = v
        end
    end
    return msg;
end


version_upd_voice=0
_state_hallscenen=true
  radio_table_max=""
local function main()
	cc.FileUtils:getInstance():addSearchPath("src/app/protobuf")
    cc.FileUtils:getInstance():addSearchPath("res/niuniu_shangcheng")
    cc.FileUtils:getInstance():addSearchPath("files")
	print("开始")
    
    
	
    Server:Instance():request_http_open("http://admin.sharkpoker.cn/index.php/Home/Login/appset/versions/1.0")--("http://www.novold.com/octopus.php")
    require("app.MyApp"):create():run()
    -- print("开始")
    -- Server:Instance():request_http_open("http://www.novold.com/octopus.php")
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end

qq = {}
qq.tools = {}

cc.exports.targetPlatform = cc.Application:getInstance():getTargetPlatform()

cc.exports.isIOS   = function()
   if ((cc.PLATFORM_OS_IPHONE == targetplatform) or (cc.PLATFORM_OS_IPAD == targetplatform)) then 
      return true
   else
      return false
   end
end

cc.exports.isYKLogin = false



cc.exports.hasWX = function()
        if isIOS() and not Tools.iscompanyipa then
            local ok, ret = require"cocos.cocos2d.luaoc".callStaticMethod("AppController", "hasWX")
            print("客服端是否安装有微信 = ",ret )
            if ret and ret == 1 then
               return true
            else
               return false
            end
         else
            return true
         end
end


cc.exports.getYKLogin = function()
    return isYKLogin and isIOS()
end

function hasWX()
    
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
        local ok, ret = require"cocos.cocos2d.luaoc".callStaticMethod("AppController", "hasWX")
        print("当前是否安装了微信 - ",ret)
        if ret == 1 then
           return true
        else
           return false
        end
    elseif cc.PLATFORM_OS_ANDROID == targetPlatform then
        local luaj = require "cocos.cocos2d.luaj"
        local className = "org/cocos2dx/lua/AppActivity"
        -- 判断是否有微信
        local ok, haswx = luaj.callStaticMethod(className, "hasWX",{},"()Z")
        if haswx then
           return true
        else
           return false
        end
    end

end


function hasInternet()
     if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
        local ok, ret = require"cocos.cocos2d.luaoc".callStaticMethod("AppController", "isExistenceNetwork")
        -- print("当前是否安装了微信555 - ",ok,ret)
        if  ret == 1 then
            return true
        else
            return false
        end
     elseif cc.PLATFORM_OS_ANDROID == targetPlatform then
        local luaj = require "cocos.cocos2d.luaj"
        local className = "org/cocos2dx/lua/AppActivity"
        -- 判断是否有微信
        local ok, haswx = luaj.callStaticMethod(className, "isNetworkConnected",{},"()Z")
        if haswx then
           return true
        else
           return false
        end
     end


end
function qq.tools.button(panel, name, cb, isClick)
    -- qq.log("button "..name);
    local btn = panel:getChildByName(name)
    local clickPanel;
    local function onBank(sender, eventType)
        local size = sender:getContentSize();
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.ended then
            Util:all_layer_Sound("Audio_Button_Click")
            cb(sender);
        end
    end
  
    btn:setTouchEnabled(true)
    btn:addTouchEventListener(onBank)
    --    btn:setPressedActionEnabled(true)
    btn:setSwallowTouches(true);
    if isClick == true then
        btn:setPressedActionEnabled(false)
        btn:getRendererClicked():setColor(cc.c3b(180, 180, 180))
    end

    return btn
end