local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)

return Rodux.makeActionCreator("addToBackpack", function(card, count)
    return {
        card = card,
		count = count,
    }
end)