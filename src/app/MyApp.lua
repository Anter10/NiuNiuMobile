
-- Util = require("app.model.Util")
local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
    math.randomseed(os.time())
    -- local scene = require("app.views.GameScene")
    -- print("scenescenescenescenescenescene111 = ",type(scene.new))
    -- if scene then
    --    Tools.showError("dddddddd",32)
    -- end
end

return MyApp
