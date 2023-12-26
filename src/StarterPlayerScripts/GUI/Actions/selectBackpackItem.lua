local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)

return Rodux.makeActionCreator("selectBackpackItem", function(card)
    return {
        card = card,
    }
end)