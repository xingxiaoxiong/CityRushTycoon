local RS = game:GetService("ReplicatedStorage")
local Net = require(RS.Packages.Net)
local DataController = require(RS.Source.DataService.DataController)
local DBKeys = require(RS.Source.Constants.DatabaseKeys)
local Card = require(RS.Source.Constants:WaitForChild("Card"))
local player = game:GetService("Players").LocalPlayer


local buyCardEvent = Net:RemoteEvent("BuyCard")

local function buyCard(cardName)
	return function(store)
		buyCardEvent:FireServer(cardName)
	end
end

return buyCard