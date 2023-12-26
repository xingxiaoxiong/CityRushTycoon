local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)

return Rodux.makeActionCreator("updateShop", function(shop)
    return {
        shop = shop
    }
end)