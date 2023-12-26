local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)
local Players = game:GetService("Players")

local reducer = Rodux.createReducer({}, {
    updateGameState = function(state, action)
        local newState = action.gameState
        if newState.numberOfArrivedPlayers == 0 then
            newState.rank = nil
        elseif newState.lastArrivedPlayer == Players.LocalPlayer.UserId then
            newState.rank = newState.numberOfArrivedPlayers
        else
            newState.rank = state.rank
        end
        return newState
    end,
})

return reducer