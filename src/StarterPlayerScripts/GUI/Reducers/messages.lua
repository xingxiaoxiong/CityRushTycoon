local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)


local reducer = Rodux.createReducer({}, {
    addMessage = function(state, action)
        local newState = {}
        newState = table.clone(state)
		table.insert(newState, 1, action.message)
        return newState
    end,
    setMessages = function(state, action)
        return action.messages
    end,
})

return reducer