local RS = game:GetService("ReplicatedStorage")
local DataService = require(RS.Source.DataService:WaitForChild('DataService'))
require(RS.Source.DataService:WaitForChild('GameplayDataStoreService'))
local Rails = require(script.Parent.Rails)
local World = require(script.Parent.World)
local Components = require(RS.Source.Components)
local SyncData = require(script.Parent:WaitForChild('syncDataFromDS'))
local ContestEntity = require(script.Parent.Entities:WaitForChild('ContestEntity'))
local Cities = require(RS.Source:WaitForChild('Cities'))
local Trains = require(RS.Source:WaitForChild('Trains'))
local Players = game:GetService("Players")
local Utils = require(RS.Source.Utils.Utils)
local FinalizeAuction = require(script.Parent:WaitForChild('FinalizeAuction'))
local CoinDataStoreService = require(RS.Source.DataService:WaitForChild('CoinDataStoreService'))

DataService:Init()
World:Init() -- calls setupTags
Cities:Init()
local world = World:GetWorld()
Rails:BuildMap(world)
world:spawn(
	Components.Rail({
		rails = Rails.rails
	})
)
ContestEntity:Spawn()
task.spawn(function()
	SyncData:SyncAuction()
end)
task.spawn(function()
	SyncData:SyncGameplayDataService()
end)
task.spawn(function()
	SyncData:SyncGameplayDataServiceLessFrequent()
end)
task.spawn(function()
	FinalizeAuction:Finalize()
end)

Players.PlayerAdded:Connect(function(player)
	CoinDataStoreService:Initialize(player)
end)

Players.PlayerRemoving:Connect(function(player)
	for _, train, trainModel in world:query(Components.Train, Components.TrainModel) do
		if train.playerId == player.UserId then
			local headPosition = train.frames[1].Position
			local coordX, coordZ = Utils.positionToCoordinate(headPosition.X, headPosition.Z)
			DataService:Overwrite(player, 'LastCoord', {
				X=coordX,
				Z=coordZ,
			})
		end
	end

	local entityId = Trains:GetEntityId(player.UserId)
	world:despawn(entityId)
	Trains:RemoveTrain(entityId)
end)
-- createTestData()