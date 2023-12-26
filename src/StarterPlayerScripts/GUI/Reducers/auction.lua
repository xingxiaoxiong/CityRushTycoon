local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)


local reducer = Rodux.createReducer({}, {
	updateAuction = function(state, action)
		return action.auction
	end,
})

return reducer