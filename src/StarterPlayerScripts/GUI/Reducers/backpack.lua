local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)


local reducer = Rodux.createReducer({}, {
	addToBackpack = function(state, action)
		local newState = {}
        newState = table.clone(state)
		newState[action.card] = action.count
		return newState
	end,
})

return reducer