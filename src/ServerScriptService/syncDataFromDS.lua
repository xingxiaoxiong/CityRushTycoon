local RS = game:GetService("ReplicatedStorage")
local GameplayDataStoreService = require(RS.Source.DataService:WaitForChild('GameplayDataStoreService'))
local AuctionDataStoreService = require(RS.Source.DataService:WaitForChild('AuctionDataStoreService'))
local MessageMemoryStoreService = require(RS.Source.DataService:WaitForChild('MessageMemoryStoreService'))
local CoinDataStoreService = require(RS.Source.DataService:WaitForChild('CoinDataStoreService'))
local DBKeys = require(RS.Source.Constants:WaitForChild('DatabaseKeys'))
local Promise = require(game:GetService('ReplicatedStorage').Packages.Promise)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CityConfig = require(RS.Source.Configs.CityConfig)
local tiledFolder = workspace:WaitForChild("Tiled")
local cityFolder = tiledFolder:WaitForChild("City")
local Mode = require(RS.Source.Constants.Mode)


local SyncData = {}

function _call_func_with_delay(delay, func)
	Promise.delay(delay)
		:andThen(func)
		:catch(warn)
		:await()
end

function SyncData:SyncGameplayDataService()
	GameplayDataStoreService:SyncData('City')
	while true do
		Promise.delay(Mode:IsDevelopment() and 30 or 120)
			:andThen(function()
				GameplayDataStoreService:SyncData('City')
				CoinDataStoreService:SyncAllPlayers()
			end)
			:catch(warn)
			:await()
	end
end

function SyncData:SyncGameplayDataServiceLessFrequent()
	GameplayDataStoreService:SyncData(DBKeys.StartCity)
	GameplayDataStoreService:SyncData(DBKeys.ArriveReward)
	GameplayDataStoreService:SyncData(DBKeys.CoinValue)
	GameplayDataStoreService:SyncData(DBKeys.BreakTime)
	GameplayDataStoreService:SyncData(DBKeys.ContestTime)
	GameplayDataStoreService:SyncData(DBKeys.CoinCount)
	while true do
		_call_func_with_delay(3600, function()
			GameplayDataStoreService:SyncData(DBKeys.StartCity)
		end)

		_call_func_with_delay(60, function()
			GameplayDataStoreService:SyncData(DBKeys.ArriveReward)
		end)

		_call_func_with_delay(60, function()
			GameplayDataStoreService:SyncData(DBKeys.CoinValue)
		end)

		_call_func_with_delay(60, function()
			GameplayDataStoreService:SyncData(DBKeys.BreakTime)
		end)

		_call_func_with_delay(60, function()
			GameplayDataStoreService:SyncData(DBKeys.ContestTime)
		end)

		_call_func_with_delay(60, function()
			GameplayDataStoreService:SyncData(DBKeys.CoinCount)
		end)
	end
end

function SyncData:SyncAuction()
	AuctionDataStoreService:SyncAllActiveAuction()
	MessageMemoryStoreService:SyncData(DBKeys.Auction)
	local interval = Mode:IsDevelopment() and 60 or 900
	while true do
		_call_func_with_delay(interval, function()
			AuctionDataStoreService:SyncAllActiveAuction()
			MessageMemoryStoreService:SyncData(DBKeys.Auction)
		end)
	end
end

return SyncData