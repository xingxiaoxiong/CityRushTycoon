local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)


local reducer = Rodux.createReducer({}, {
	updateToll = function(state, action)
		return action.toll
	end,
})

return reducer