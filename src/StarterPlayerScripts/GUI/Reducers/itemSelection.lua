local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)


local reducer = Rodux.createReducer(nil, {
	selectItem = function(state, action)
		return action.item
	end,
})

return reducer