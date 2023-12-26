local RS = game:GetService("ReplicatedStorage")
local Red = require(RS.Packages.Red)
local Signal = require(RS.Packages.Signal)
local DBKeys = require(RS.Source.Constants:WaitForChild('DatabaseKeys'))

local Net = Red.Client(DBKeys:GetAuctionDSName())

local AuctionDataStoreController = {
	dataUpdated = Signal.new(),
}

Net:On('DataUpdated', function(data)
	AuctionDataStoreController.cache = data
	AuctionDataStoreController.dataUpdated:Fire(data)
end)

function AuctionDataStoreController:_fetch()
	Net:Call("Comm", "GetData"):Then(function(data)
		self.cache = data
		self.dataUpdated:Fire(data)
	end):Catch(function()
		warn("Error Fetching data")
	end)
end

function AuctionDataStoreController:GetData()
	if self.cache == nil then
		self:_fetch()
	end
	return self.cache
end

return AuctionDataStoreController
