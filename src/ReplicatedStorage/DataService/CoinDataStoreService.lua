local DataStoreService = require(script.Parent:WaitForChild('DataStoreService'))
local DBKeys = require(game:GetService("ReplicatedStorage").Source.Constants:WaitForChild('DatabaseKeys'))
local Players = game:GetService('Players')

local CoinDataStoreService = DataStoreService.new(DBKeys:GetCoinDSName())

function CoinDataStoreService:Increment(key, delta)
	local success, data = pcall(function()
		return self.store:IncrementAsync(key, delta)
	end)
	if success then
		self:SyncData(key) -- Do compare and fire event in case of difference
	else
		warn('CoinDataStoreService:Increment ' .. data)
	end
end

function CoinDataStoreService:Initialize(player)
	local key = player.UserId
	local success, data = pcall(function()
		return self.store:GetAsync(key)
	end)
	if success then
		if data == nil then
			local success, data = pcall(function()
				return self.store:SetAsync(key, 100)
			end)
			if not success then
				warn('CoinDataStoreService:Initialize ' .. data)
				player:Kick("Data could not be initialized, try again shortly. If the issue persists, please contact the support!")
			end
		end
	else
		warn('CoinDataStoreService:Initialize ' .. data)
		player:Kick("Data could not be loaded, try again shortly. If the issue persists, please contact the support!")
	end
end

function CoinDataStoreService:SyncAllPlayers()
	for _, player in ipairs(Players:GetPlayers()) do
		self:SyncData(tostring(player.UserId))
	end
end

return CoinDataStoreService
