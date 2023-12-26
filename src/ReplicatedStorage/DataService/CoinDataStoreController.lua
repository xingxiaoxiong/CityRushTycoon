local DataStoreController = require(script.Parent:WaitForChild('DataStoreController'))
local RS = game:GetService("ReplicatedStorage")
local DBKeys = require(game:GetService("ReplicatedStorage").Source.Constants:WaitForChild('DatabaseKeys'))
local UI = require(RS.Source.Utils:WaitForChild('UI'))
local Players = game:GetService('Players')

local CoinDataStoreController = DataStoreController.new(DBKeys:GetCoinDSName())

CoinDataStoreController.Net:On('DataUpdated', function(key, data)
	if CoinDataStoreController.cache[key] and data and CoinDataStoreController.cache[key] ~= data and key == tostring(Players.LocalPlayer.UserId) then
		UI:ShowBalanceUpdate(data - CoinDataStoreController.cache[key])
	end
	CoinDataStoreController.cache[key] = data
	CoinDataStoreController.dataUpdated:Fire(key, data)
end)

return CoinDataStoreController
