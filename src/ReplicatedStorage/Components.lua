local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Matter = require(ReplicatedStorage.Packages.matter)

local COMPONENTS = {
	"Rail",
	"RailSegment",
	"DamagedRailSegment",
	"Model",
	"Health",
	"Transform",
	"Train",
	"TrainModel",
	"Mode",
	"Contest",
}

local components = {}

for _, name in ipairs(COMPONENTS) do
	components[name] = Matter.component(name)
end

return components
