local RS = game:GetService("ReplicatedStorage")
local GameplayDataStoreService = require(RS.Source.DataService:WaitForChild('GameplayDataStoreService'))
local AuctionDataStoreService = require(RS.Source.DataService:WaitForChild('AuctionDataStoreService'))
local CoinDataStoreService = require(RS.Source.DataService:WaitForChild('CoinDataStoreService'))
local MessageMemoryStoreService = require(RS.Source.DataService:WaitForChild('MessageMemoryStoreService'))
local DBKeys = require(RS.Source.Constants:WaitForChild('DatabaseKeys'))
local Promise = require(game:GetService('ReplicatedStorage').Packages.Promise)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CityConfig = require(RS.Source.Configs.CityConfig)
local tiledFolder = workspace:WaitForChild("Tiled")
local cityFolder = tiledFolder:WaitForChild("City")
local DataStoreService = game:GetService('DataStoreService')
local SoundService = game:GetService("SoundService")
local DataService = require(RS.Source.DataService.DataService)
local Mode = require(RS.Source.Constants.Mode)


local FinalizeAuction = {
	auctionStore = DataStoreService:GetDataStore(DBKeys:GetAuctionDSName()),
}

function FinalizeAuction:LockAuction(auctionId)
	local currentTime = os.time()
	local success, result = pcall(function()
        return self.auctionStore:UpdateAsync(auctionId, function(auction)
			-- check if auction ended here
			if auction and currentTime > auction['EndTime'] and auction['Status'] == 'Open' and (not auction['LockTime'] or (currentTime - auction['LockTime']) > (Mode:IsDevelopment() and 10 or 600)) then
				auction['LockTime'] = currentTime
				return auction
			else
				return nil
			end
		end)
    end)
	return success and result and result['LockTime'] == currentTime
end

function FinalizeAuction:_finalizeOne(auctionId)
	if not self:LockAuction(auctionId) then
        return false
    end
	local auction = AuctionDataStoreService:SyncData(auctionId)
	if auction then
		local cityDict = GameplayDataStoreService:SyncData('City')

		local bids = auction['Bids']
		local sellerId = auction['Seller']
		for i = 1, #bids do
			local bidderID = bids[#bids + 1 - i]['PlayerId']
			local bidPrice = bids[#bids + 1 - i]['BidPrice']

			local bidderKey = tostring(bidderID)
			local bidderBalance = CoinDataStoreService:SyncData(bidderKey) or 0
			if bidderBalance >= bidPrice then
				if sellerId then
					local sellerKey = tostring(sellerId)
					CoinDataStoreService:Increment(sellerKey, math.ceil(bidPrice * 0.95))
				end

				cityDict[auctionId] = cityDict[auctionId] or {}
				cityDict[auctionId]['owner'] = bidderID
				GameplayDataStoreService:UpdateData('City', cityDict)

				auction['Status'] = 'Close'
				AuctionDataStoreService:UpdateData(auctionId, auction)

				CoinDataStoreService:Increment(bidderKey, -bidPrice)
				MessageMemoryStoreService:AddAuctionResult(bidderID, auctionId, bidPrice, os.time())
				break
			end
		end

		-- In case of no winner
		if auction['Status'] == 'Open' then
			auction['Status'] = 'Close'
			AuctionDataStoreService:UpdateData(auctionId, auction)
		end
	end
	return true
end

function FinalizeAuction:_finalizeAll()
	local success, auctionIDs = pcall(function()
		return self.auctionStore:GetAsync(DBKeys.ActiveAuctions)
	end)

	if success and auctionIDs then
		for id, isActive in pairs(auctionIDs) do
			if not isActive then continue end
			if self:_finalizeOne(id) then
				local successAgain, data = pcall(function()
					return self.auctionStore:UpdateAsync(DBKeys.ActiveAuctions, function(current)
						current[id] = false
						return current
					end)
				end)
			end
		end
	end
end

function FinalizeAuction:Finalize()
	Promise.delay(10)
		:andThen(function()
			self:_finalizeAll()
		end)
		:catch(warn)
		:await()
	local interval = Mode:IsDevelopment() and 60 or 900
	while true do
		Promise.delay(interval)
			:andThen(function()
				self:_finalizeAll()
			end)
			:catch(warn)
			:await()
	end
end


return FinalizeAuction
