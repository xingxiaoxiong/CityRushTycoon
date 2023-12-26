local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Constants = require(RS.Source.Constants:WaitForChild('Constants'))
local DBKeys = require(RS.Source.Constants:WaitForChild('DatabaseKeys'))
local DataService = require(RS.Source.DataService:WaitForChild('DataService'))
local Net = require(RS.Packages:WaitForChild('Net'))
local Signals = require(RS.Source.Utils:WaitForChild('Signals'))

local productFunctions = {}

productFunctions[Constants.BuyCoin1ProductID] = function(receipt, player)
	local amount = Constants.BuyCoinAmount[Constants.BuyCoin1ProductID]
	Signals.IncrementCoin:Fire(player.UserId, amount)
end

productFunctions[Constants.BuyCoin2ProductID] = function(receipt, player)
	local amount = Constants.BuyCoinAmount[Constants.BuyCoin2ProductID]
	Signals.IncrementCoin:Fire(player.UserId, amount)
end


local function processReceipt(receiptInfo)
	local userId = receiptInfo.PlayerId
	local productId = receiptInfo.ProductId

	local player = Players:GetPlayerByUserId(userId)
	if player then
		-- Get the handler function associated with the developer product ID and attempt to run it
		local handler = productFunctions[productId]
		local success, result = pcall(handler, receiptInfo, player)
		if success then
			-- The user has received their benefits!
			-- return PurchaseGranted to confirm the transaction.
			return Enum.ProductPurchaseDecision.PurchaseGranted
		else
			warn("Failed to process receipt:", receiptInfo, result)
		end
	end

	-- the user's benefits couldn't be awarded.
	-- return NotProcessedYet to try again next time the user joins.
	return Enum.ProductPurchaseDecision.NotProcessedYet
end

-- Set the callback; this can only be done once by one script on the server!
MarketplaceService.ProcessReceipt = processReceipt