
cc.FileUtils:getInstance():setPopupNotify(false)

require "src/app/protobuf/containers"
require "src/app/protobuf/decoder"
require "src/app/protobuf/descriptor"
require "src/app/protobuf/encoder"
require "src/app/protobuf/listener"
require "src/app/protobuf/protobuf"
require "src/app/protobuf/text_format"
require "src/app/protobuf/type_checkers"
require "src/app/protobuf/wire_format"


require "config"
require "cocos.init"
version_upd_voice=0
 _state_hallscenen=true
  radio_table_max=""
local function main()
	cc.FileUtils:getInstance():addSearchPath("src/app/protobuf")
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
