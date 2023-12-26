local RS = game:GetService("ReplicatedStorage")
local CS = game:GetService("CollectionService")
local Tag = require(RS.Source.Constants.Tag)
local Net = require(RS.Packages.Net)
local Components = require(RS.Source.Components)
local Utils = require(RS.Source.Utils.Utils)
local cityFolder = workspace:WaitForChild("Tiled"):WaitForChild("City")


local Cities = {}
Cities.positionToCity = {}
Cities.cityToPosition = {}

function Cities:generateKey(x, y)
	return x .. ',' .. y
end

function Cities:Init()
	for _, cityModel in pairs(cityFolder:GetChildren()) do
		local coordX, coordZ = Utils.positionToCoordinate(cityModel.Position.X, cityModel.Position.Z)
		self.positionToCity[self:generateKey(coordX, coordZ)] = cityModel.Name
		self.cityToPosition[cityModel.Name] = {X=coordX, Z=coordZ}
	end
end

function Cities:FindCity(coordX, coordZ)
	return self.positionToCity[self:generateKey(coordX, coordZ)]
end

function Cities:GetCityPosition(city)
	return self.cityToPosition[city]
end

return Cities