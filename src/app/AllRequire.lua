AllRequire = {}

AllRequire.ui    = {}
AllRequire.logic = {}

require("src.app.commonManager.Tools")



function AllRequire.requireAll()
    package.loaded["src.app.commonManager.Tools"] = nil
    package.loaded["src.app.commonManager.Tools"] = nil
    -- package.loaded["app.layers.shop_view.ShopView"] = nil

    require("src.app.commonManager.Tools")
	AllRequire.ui.createRoom = require("app.layers.createRoom")
	AllRequire.ui.HouseDetailView = require("app.layers.house_view.HouseDetailView")
	AllRequire.ui.excessiveLayer = require("app.layers.excessiveLayer")
	-- AllRequire.ui.gameHallScene = require("src.app.views.gameHallScene")

	AllRequire.ui.GameScene = require("app.views.GameScene")
end


AllRequire.logic.Parameter = require("src.app.commonManager.Parameter")

