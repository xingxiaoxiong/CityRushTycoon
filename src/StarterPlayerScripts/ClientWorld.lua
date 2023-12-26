
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local start = require(ReplicatedStorage.Source.Start)
local receiveReplication = require(script.Parent:WaitForChild("ReceiveReplication"))


local World = {}

function World:Init()
	self.world, self.state = start({
		ReplicatedStorage.Source.Systems,
		script.Parent:WaitForChild("Systems"),
	})

	receiveReplication(self.world, self.state)
end

function World:GetWorld()
	return self.world
end

return World
