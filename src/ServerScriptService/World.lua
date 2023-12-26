
local RS = game:GetService("ReplicatedStorage")
local start = require(RS.Source.Start)
local setupTags = require(RS.Source.SetupTags)
local Components = require(RS.Source.Components)
local Rails = require(script.Parent.Rails)

local World = {}

function World:Init()
	self.world = start({
		script.Parent.Systems,
		RS.Source.Systems,
	})

	setupTags(self.world)
end

function World:GetWorld()
	return self.world
end

return World