local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Components = require(RS.Source.Components)
local Matter = require(RS.Packages.matter)
local Utils = require(RS.Source.Utils.Utils)
local Constants = require(RS.Source.Constants.Constants)


local function damageRail(world)
	for id, record in world:queryChanged(Components.DamagedRailSegment) do
		local modelComp = world:get(id, Components.Model)
		if record.old == nil then
			modelComp.model.BrickColor = BrickColor.new("Bright red")
		end
	end
end

return damageRail
