local RS = game:GetService('ReplicatedStorage')
local Card = require(RS.Source:WaitForChild("Constants"):WaitForChild("Card"))

local SaveStructure = {
	PlayTime = 0,
	Coin = 100,
	Backpack = {
		[Card.Teleport] = 2,
		[Card.DestroyRail] = 10,
		[Card.Beijing] = 1,
	}
}

return SaveStructure