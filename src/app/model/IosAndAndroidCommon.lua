

IosAndAndroidCommon = {}



-- 微信登陆服务器
function IosAndAndroidCommon.login()
	if (cc.PLATFORM_OS_IPHONE == tarPlatform) or (cc.PLATFORM_OS_IPAD == tarPlatform) then
	   local luaoc = require"cocos.cocos2d.luaoc"
       local ok, ret = luaoc.callStaticMethod("AppController", "sendAuthRequest")
       if ok then
          return 1
       end
	else


	end
end































return IosAndAndroidCommon