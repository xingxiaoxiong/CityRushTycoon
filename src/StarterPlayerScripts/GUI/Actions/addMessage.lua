local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)

return Rodux.makeActionCreator("addMessage", function(message)
    return {
        message = message
    }
end)