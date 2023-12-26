local MemoryStoreController = require(script.Parent:WaitForChild('MemoryStoreController'))
local DBKeys = require(game:GetService("ReplicatedStorage").Source.Constants:WaitForChild('DatabaseKeys'))

local MessageMemoryStoreController = MemoryStoreController.new(DBKeys:GetMessageMSName())
return MessageMemoryStoreController
