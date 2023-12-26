local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Components = require(RS.Source.Components)
local Matter = require(RS.Packages.matter)
local Utils = require(RS.Source.Utils.Utils)
local Constants = require(RS.Source.Constants.Constants)
local CityConfigs = require(RS.Source.Configs.CityConfig)
local Net = require(RS.Packages:WaitForChild('Net'))
local Cities = require(RS.Source:WaitForChild("Cities"))
local GameplayDataStoreService = require(RS.Source.DataService:WaitForChild('GameplayDataStoreService'))
local CoinDataStoreService = require(RS.Source.DataService:WaitForChild('CoinDataStoreService'))
local DataService = require(RS.Source.DataService.DataService)
local DBKeys = require(RS.Source.Constants.DatabaseKeys)
local Signals = require(RS.Source.Utils.Signals)


Signals.IncrementCoin:Connect(function(userId, amount)
	CoinDataStoreService:Increment(tostring(userId), amount)
end)


local tollCharges = {}

local function detectCollision(world)
	local cityDict = GameplayDataStoreService:GetDataFromCache('City')
	if cityDict then
		for _, train, trainModel in world:query(Components.Train, Components.TrainModel) do
			local headPos = train.frames[1].Position
			local coordX, coordZ = Utils.positionToCoordinate(headPos.X, headPos.Z)
			local touchedCity = Cities:FindCity(coordX, coordZ)
			if touchedCity then
				local cityData = cityDict[touchedCity]
				if cityData and cityData['owner'] ~= train.playerId and cityData['toll'] and cityData['toll'] > 0 then
					local playerId = train.playerId
					local previousCharge = tollCharges[playerId]
					if previousCharge == nil
						or previousCharge['city'] ~= touchedCity
						or previousCharge['city'] == touchedCity and os.time() - previousCharge['time'] > 5 then
							local player = Players:GetPlayerByUserId(playerId)
							Signals.IncrementCoin:Fire(player.UserId, -cityData['toll'])
							tollCharges[playerId] = {
								['city'] = touchedCity,
								['time'] = os.time(),
							}
							if cityData['owner'] then
								Signals.IncrementCoin:Fire(cityData['owner'], cityData['toll'])
							end
						end
				end
			end
		end
	end
end

return detectCollision
