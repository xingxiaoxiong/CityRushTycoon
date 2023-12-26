local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)

return Rodux.makeActionCreator("updateGameState", function(gameState)
    return {
        gameState = gameState
    }
end)
