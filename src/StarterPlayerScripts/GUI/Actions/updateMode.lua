local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)

return Rodux.makeActionCreator("updateMode", function(mode)
    return {
        mode = mode
    }
end)
