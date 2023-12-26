local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)

return Rodux.makeActionCreator("updateAuction", function(auction)
    return {
        auction = auction
    }
end)