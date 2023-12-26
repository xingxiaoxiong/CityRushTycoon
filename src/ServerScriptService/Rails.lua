local RS = game:GetService("ReplicatedStorage")
local CS = game:GetService("CollectionService")
local Tag = require(RS.Source.Constants.Tag)
local Net = require(RS.Packages.Net)
local Components = require(RS.Source.Components)
local Utils = require(RS.Source.Utils.Utils)


local Rails = {}
Rails.rails = {}

function Rails:generateKey(x, y)
	return x .. ',' .. y
end

function Rails:BuildMap(world)
	for entityId, railSegment in world:query(Components.RailSegment) do
		local coordX, coordZ = railSegment.X, railSegment.Z
		self.rails[self:generateKey(coordX, coordZ)] = entityId
	end
end

function Rails:FindComp(coordX, coordZ)
	return self.rails[self:generateKey(coordX, coordZ)]
end

return Rails