local RS = game:GetService("ReplicatedStorage")
local Signal = require(RS.Packages.Signal)


local Signals = {
	IncrementCoin = Signal.new(),
}

return Signals

