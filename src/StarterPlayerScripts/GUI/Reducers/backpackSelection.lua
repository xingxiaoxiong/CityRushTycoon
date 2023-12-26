local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)


local reducer = Rodux.createReducer(nil, {
	selectBackpackItem = function(state, action)
		return action.card
	end,
})

return reducer