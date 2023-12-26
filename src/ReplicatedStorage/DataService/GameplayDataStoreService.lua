local DataStoreService = require(script.Parent:WaitForChild('DataStoreService'))
local DBKeys = require(game:GetService("ReplicatedStorage").Source.Constants:WaitForChild('DatabaseKeys'))

local gameplayDataStoreService = DataStoreService.new(DBKeys:GetGameplayDSName())
return gameplayDataStoreService
