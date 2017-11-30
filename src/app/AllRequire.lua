AllRequire = {}

AllRequire.ui    = {}
AllRequire.logic = {}

require("src.app.commonManager.Tools")



function AllRequire.requireAll()
	-- for i,models in pairs(AllRequire.ui) do
		-- local lua = "src/app/views/"..models.__cname
        package.loaded["src/app/views/gameHallScene"] = nil

		 
	-- end
	print("ABCDEF")
	AllRequire.ui.createRoom = require("src.app.layers.createRoom")
	AllRequire.ui.HouseDetailView = require("src.app.layers.house_view.HouseDetailView")
	AllRequire.ui.excessiveLayer = require("src.app.layers.excessiveLayer")
	AllRequire.ui.gameHallScene = require("src/app/views/gameHallScene")
	AllRequire.ui.ShopView = require("app.layers.shop_view.ShopView")
	AllRequire.ui.GameScene = require("app.views.GameScene")
end


AllRequire.logic.Parameter = require("src.app.commonManager.Parameter")

