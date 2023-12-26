local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)

return Rodux.makeActionCreator("updateDestination", function(destination)
    return {
        destination = destination
    }
end)