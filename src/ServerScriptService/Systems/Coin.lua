local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Components = require(RS.Source.Components)
local Matter = require(RS.Packages.matter)
local Utils = require(RS.Source.Utils.Utils)
local Constants = require(RS.Source.Constants.Constants)
local DataService = require(RS.Source.DataService:WaitForChild('DataService'))
local CoinModel = RS:WaitForChild('Assets'):WaitForChild('Coin')
local railFolder = workspace:WaitForChild("Tiled"):WaitForChild("Rail")
local coinFolder = workspace:WaitForChild("Coins")
local DBKeys = require(RS.Source.Constants.DatabaseKeys)
local Net = require(RS.Packages.Net)
local coinSound = RS:WaitForChild('Assets'):WaitForChild('Sounds'):WaitForChild('Coin')
local playSoundEvent = Net:RemoteEvent("PlaySound")
local GameplayDataStoreService = require(RS.Source.DataService:WaitForChild('GameplayDataStoreService'))
local Signals = require(RS.Source.Utils:WaitForChild('Signals'))

local Coin = {
	count = 0,
	coinMap = {},
}
Coin.__index = Coin

function Coin:Add(coordX, coordZ)
	local coinInstance = CoinModel:Clone()
	coinInstance.Parent = coinFolder
	local x, z = Utils.coordinateToPosition(coordX, coordZ)
	coinInstance.Position = Vector3.new(x, Constants.SeaLevel + 1, z)
	self.coinMap[Utils.generateRailsKey(coordX, coordZ)] = coinInstance
	self.count = self.count + 1
end

function Coin:Get(coordX, coordZ)
	return self.coinMap[Utils.generateRailsKey(coordX, coordZ)]
end

function Coin:Remove(coordX, coordZ)
	local coinInstance = self.coinMap[Utils.generateRailsKey(coordX, coordZ)]
	if coinInstance then
		coinInstance:Destroy()
		self.coinMap[Utils.generateRailsKey(coordX, coordZ)] = nil
		self.count = self.count - 1
	end
end

local function coin(world)
	local railInstances = railFolder:GetChildren()
	if #railInstances > 0 then
		while Coin.count < math.min(GameplayDataStoreService:GetDataFromCache(DBKeys.CoinCount) or 10, #railInstances) do
			local sample = math.random(#railInstances)
			local railPosition = railInstances[sample].Position
			local coordX, coordZ = Utils.positionToCoordinate(railPosition.X, railPosition.Z)
			if not Coin:Get(coordX, coordZ) then
				Coin:Add(coordX, coordZ)
			end
		end
	end

	for _, train, trainModel in world:query(Components.Train, Components.TrainModel) do
		local headPos = train.frames[1].Position
		local coordX, coordZ = Utils.positionToCoordinate(headPos.X, headPos.Z)
		local touchedCoin = Coin:Get(coordX, coordZ)
		if touchedCoin then
			Coin:Remove(coordX, coordZ)
			local player = Players:GetPlayerByUserId(train.playerId)
			local coinValue = GameplayDataStoreService:GetDataFromCache(DBKeys.CoinValue) or 1
			Signals.IncrementCoin:Fire(player.UserId, coinValue)
			playSoundEvent:FireClient(player, coinSound)
		end
	end
end

return coin
