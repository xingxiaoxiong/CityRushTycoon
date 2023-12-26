local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Components = require(ReplicatedStorage.Source.Components)
local Utils = require(ReplicatedStorage.Source.Utils.Utils)

local boundTags = {
	RailSegment = Components.RailSegment,
}

local function setupTags(world)
	local function spawnBound(instance, component)
		local x, z = Utils.positionToCoordinate(instance.Position.X, instance.Position.Z)
		local id = world:spawn(
			component({
				X = x,
				Z = z,
			}),
			Components.Model({
				model = instance,
			})
		)

		instance:SetAttribute("serverEntityId", id)
	end

	for tagName, component in pairs(boundTags) do
		for _, instance in ipairs(CollectionService:GetTagged(tagName)) do
			spawnBound(instance, component)
		end

		CollectionService:GetInstanceAddedSignal(tagName):Connect(function(instance)
			spawnBound(instance, component)
		end)

		CollectionService:GetInstanceRemovedSignal(tagName):Connect(function(instance)
			local id = instance:GetAttribute("serverEntityId")
			if id then
				world:despawn(id)
			end
		end)
	end
end

return setupTags
