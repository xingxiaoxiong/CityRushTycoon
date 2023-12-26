local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)

return Rodux.makeActionCreator("updateCoin", function(coin)
    return {
        coin = coin
    }
end)