local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Components = require(RS.Source.Components)
local Matter = require(RS.Packages.matter)
local TableUtil = require(RS.Packages.TableUtil)
local Utils = require(RS.Source.Utils.Utils)
local Constants = require(RS.Source.Constants.Constants)
local DBKeys = require(RS.Source.Constants.DatabaseKeys)
local DataService = require(RS.Source.DataService.DataService)
local GameplayDataStoreService = require(RS.Source.DataService:WaitForChild('GameplayDataStoreService'))
local Cities = require(RS.Source:WaitForChild('Cities'))
local Trains = require(RS.Source:WaitForChild('Trains'))
local Mode = require(RS.Source.Constants.Mode)


local function spawnTrain(world)
	for _, player in ipairs(Players:GetPlayers()) do
		for _, character in Matter.useEvent(player, "CharacterAdded") do

			local x, z = Utils.coordinateToPosition(0, 0)
			local humanoidRootPart = character:FindFirstChild('HumanoidRootPart')

			local coord = DataService:GetData(player, 'LastCoord')
			if coord then
				local positionX, positionZ = Utils.coordinateToPosition(coord.X, coord.Z)
				humanoidRootPart.Train.CFrame = CFrame.new(Vector3.new(positionX, Constants.SeaLevel, positionZ))
				humanoidRootPart.CFrame = humanoidRootPart.Train.CFrame
			else
				local cities = TableUtil.Shuffle(TableUtil.Keys(Cities.cityToPosition))
				local cityCoord = nil
				local positionX, positionZ = nil, nil

				local startCity = GameplayDataStoreService:GetDataFromCache(DBKeys.StartCity)
				if startCity then
					cityCoord = Cities:GetCityPosition(startCity)
				else
					local cityDict = GameplayDataStoreService:GetDataFromCache('City')
					if cityDict then
						for _, city in ipairs(cities) do
							local cityData = cityDict[city]
							if cityData and cityData['toll'] and cityData['toll'] > 0 then
								continue
							end
							cityCoord = Cities:GetCityPosition(city)
							break
						end
					end
				end

				if cityCoord == nil then
					cityCoord = Cities:GetCityPosition('27')
				end

				if Mode:IsDevelopment() then
					cityCoord = Cities:GetCityPosition('24')
				end
				positionX, positionZ = Utils.coordinateToPosition(cityCoord.X, cityCoord.Z)
				humanoidRootPart.Train.CFrame = CFrame.new(Vector3.new(positionX, Constants.SeaLevel, positionZ))
				humanoidRootPart.CFrame = humanoidRootPart.Train.CFrame
			end

			local entityId = world:spawn(
				Components.Train({
					playerId = player.UserId,
					frames = {humanoidRootPart.CFrame, humanoidRootPart.CFrame + Vector3.new(0, 100, 0), humanoidRootPart.CFrame + Vector3.new(0, 100, 0)}
				}),
				Components.TrainModel({
					model = humanoidRootPart,
				})
			)
			Trains:AddTrain(player.UserId, entityId)
		end
	end
end

return spawnTrain
