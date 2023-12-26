local RS = game:GetService("ReplicatedStorage")
local Rodux = require(RS.Libs.Rodux)

return Rodux.makeActionCreator("setMessages", function(messages)
    return {
        messages = messages
    }
end)