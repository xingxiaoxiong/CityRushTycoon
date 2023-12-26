local RS = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService('DataStoreService')
local DBKeys = require(RS.Source.Constants:WaitForChild('DatabaseKeys'))
local Red = require(RS.Packages.Red)

local Net = Red.Server(DBKeys:GetAuctionDSName(), { "DataUpdated", "Comm" })

local AuctionDataStoreService = {
	store = DataStoreService:GetDataStore(DBKeys:GetAuctionDSName()),
	cache = {},
}

Net:On("Comm", function(_, action)
	if action == "GetData" then
		return AuctionDataStoreService.cache
	end
end)

function AuctionDataStoreService:InsertActiveAuctionID(id)
	local success, data = pcall(function()
		return self.store:UpdateAsync(DBKeys.ActiveAuctions, function(old)
			old = old or {}
			old[tostring(id)] = true
			return old
		end)
	end)
	if not success then
		warn("Error AuctionDataStoreService:InsertActiveAuctionID " .. data)
	end
	return success
end

function AuctionDataStoreService:SetData(key, value)
	local success, data = pcall(function()
		return self.store:SetAsync(key, value)
	end)
	if success then
		self:SyncData(key) -- Do compare and fire event in case of difference
	else
		warn('AuctionDataStoreService:SetData ' .. data)
	end
end

function AuctionDataStoreService:UpdateData(key, value)
	local success, data = pcall(function()
		return self.store:UpdateAsync(key, function(_)
			return value
		end)
	end)
	if success then
		self:SyncData(key)
	else
		warn('AuctionDataStoreService:UpdateData ' .. data)
	end
	return success
end

function AuctionDataStoreService:UpdateBid(key, playerId, bidPrice)
	local success, data = pcall(function()
		return self.store:UpdateAsync(key, function(auction)
			if auction then
				if #auction['Bids'] > 0 then
					local currentHigh = auction['Bids'][#auction['Bids']]['BidPrice']
					if bidPrice > currentHigh then
						table.insert(auction['Bids'], {
							['PlayerId'] = playerId,
							['BidPrice'] = bidPrice,
						})
					else
						return nil
					end
				else
					table.insert(auction['Bids'], {
						['PlayerId'] = playerId,
						['BidPrice'] = bidPrice,
					})
				end
			end
			return auction
		end)
	end)
	if success then
		self:SyncData(key)
	else
		warn('AuctionDataStoreService:UpdateData ' .. data)
	end
end

function AuctionDataStoreService:SyncData(key)
	local success, data = pcall(function()
		return self.store:GetAsync(key)
	end)
	if success then
		self.cache[key] = data
		Net:FireAll('DataUpdated', self.cache)
	else
		warn('AuctionDataStoreService:SyncData ' .. data)
	end
	return self.cache[key]
end

function AuctionDataStoreService:SyncAllActiveAuction()
	local success, auctionIDs = pcall(function()
		return self.store:GetAsync(DBKeys.ActiveAuctions)
	end)
	if success then
		if auctionIDs then
			self.cache = {}
			for id, isActive in pairs(auctionIDs) do
				if not isActive then continue end
				local successAgain, auction = pcall(function()
					return self.store:GetAsync(id)
				end)
				if successAgain then
					self.cache[id] = auction
				else
					warn("Error GetAsync failed " .. id .. ' ' .. auction)
				end
			end
			Net:FireAll('DataUpdated', self.cache)
		end
	else
		warn("Error GetAsync failed " .. DBKeys.ActiveAuctions .. ' ' .. auctionIDs)
	end
	return self.cache
end

function AuctionDataStoreService:GetData(key)
	if self.cache[key] == nil then
		return self:SyncData(key)
	end
	return self.cache[key]
end

return AuctionDataStoreService
