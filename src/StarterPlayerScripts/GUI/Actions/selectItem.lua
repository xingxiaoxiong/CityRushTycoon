local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)

return Rodux.makeActionCreator("selectItem", function(item)
    return {
        item = item,
    }
end)