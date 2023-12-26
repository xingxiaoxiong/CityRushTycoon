local MemoryStoreService = require(script.Parent:WaitForChild('MemoryStoreService'))
local DBKeys = require(game:GetService("ReplicatedStorage").Source.Constants:WaitForChild('DatabaseKeys'))
local RS = game:GetService("ReplicatedStorage")

local TableUtil = require(RS.Packages.TableUtil)

local MessageMemoryStoreService = MemoryStoreService.new(DBKeys:GetMessageMSName())

function MessageMemoryStoreService:AddAuctionResult(winnerId, city, bidPrice, time)
    local success, data = pcall(function()
		return self.store:UpdateAsync(DBKeys.Auction, function(auction)
			auction = auction or {}
			table.insert(auction, 1, {
				winnerId = winnerId,
				city = city,
				bidPrice = bidPrice,
				time = time,
			})
			auction = TableUtil.Truncate(auction, 10)
			return auction
		end, 3000000)
	end)
    if success then
        self:SyncData(DBKeys.Auction)
    else
        warn('MessageMemoryStoreService:AddAuctionResult ' .. data)
    end
end

return MessageMemoryStoreService
