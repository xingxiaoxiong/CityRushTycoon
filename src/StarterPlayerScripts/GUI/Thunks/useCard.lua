local RS = game:GetService("ReplicatedStorage")
local Net = require(RS.Packages.Net)
local DataController = require(RS.Source.DataService.DataController)
local DBKeys = require(RS.Source.Constants.DatabaseKeys)
local Card = require(RS.Source.Constants:WaitForChild("Card"))
local player = game:GetService("Players").LocalPlayer


local useBreakRailCardEvent = Net:RemoteEvent("UseBreakRailCard")

local function _useCard(cardName)
	local backpackData = DataController:GetData(player, DBKeys.Backpack)
	if backpackData[cardName] ~= nil and backpackData[cardName] > 0 then
		if cardName == Card.DestroyRail then
			useBreakRailCardEvent:FireServer()
		end
	end
end


local function useCard(cardName)
	return function(store)
		_useCard(cardName)
	end
end

return useCard