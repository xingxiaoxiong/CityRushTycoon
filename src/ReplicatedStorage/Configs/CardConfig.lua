local RS = game:GetService('ReplicatedStorage')
local Card = require(RS.Source:WaitForChild("Constants"):WaitForChild("Card"))

local CardConfig = {
	[Card.DestroyRail] = {
		Name = 'Destroy Rail',
		Description = "Destroy the railway just behind you",
	},
	[Card.Teleport] = {
		Name = 'Teleport',
		Description = 'Teleport to any place',
	},
}

return CardConfig