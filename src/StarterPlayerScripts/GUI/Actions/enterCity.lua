local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)

return Rodux.makeActionCreator("enterCity", function(city)
    return {
        city = city
    }
end)
