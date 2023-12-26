local DataStoreController = require(script.Parent:WaitForChild('DataStoreController'))
local DBKeys = require(game:GetService("ReplicatedStorage").Source.Constants:WaitForChild('DatabaseKeys'))

local gameplayDataStoreController = DataStoreController.new(DBKeys:GetGameplayDSName())
return gameplayDataStoreController
