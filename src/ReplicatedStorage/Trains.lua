local RS = game:GetService("ReplicatedStorage")
local CS = game:GetService("CollectionService")
local Tag = require(RS.Source.Constants.Tag)
local Net = require(RS.Packages.Net)
local Components = require(RS.Source.Components)
local Utils = require(RS.Source.Utils.Utils)


local Trains = {
	playerIdToEntityId = {},
	entityIdToPlayerId = {},
}

function Trains:AddTrain(playerId, entityId)
	self.playerIdToEntityId[playerId] = entityId
	self.entityIdToPlayerId[entityId] = playerId
end

function Trains:RemoveTrain(entityId)
	local playerId = self.entityIdToPlayerId[entityId]
	if playerId then
		self.playerIdToEntityId[playerId] = nil
	end
	self.entityIdToPlayerId[entityId] = nil
end

function Trains:GetEntityId(playerId)
	return self.playerIdToEntityId[playerId]
end


return Trains