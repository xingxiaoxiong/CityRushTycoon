local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)


local reducer = Rodux.createReducer({}, {
	updateShop = function(state, action)
		return action.shop
	end,
})

return reducer