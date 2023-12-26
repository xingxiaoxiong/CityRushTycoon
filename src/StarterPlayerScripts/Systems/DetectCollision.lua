local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Components = require(RS.Source.Components)
local Matter = require(RS.Packages.matter)
local Utils = require(RS.Source.Utils.Utils)
local Constants = require(RS.Source.Constants.Constants)
local CityConfigs = require(RS.Source.Configs.CityConfig)
local UIS = game:GetService("UserInputService")
local Net = require(RS.Packages.Net)
local Cities = require(RS.Source:WaitForChild("Cities"))
local GUI = require(script.Parent.Parent:WaitForChild("GUI"))
local enterCity = require(script.Parent.Parent.GUI.Actions:WaitForChild("enterCity"))

local player = Players.LocalPlayer

local lastTouchedCity = nil

local function detectCollision(world)
	-- for _, train, trainModel in world:query(Components.Train, Components.TrainModel) do
	-- 	if train.playerId == player.UserId then
	-- 		local headPos = trainModel.model.Train.Position
	-- 		local coordX, coordZ = Utils.positionToCoordinate(headPos.X, headPos.Z)
	-- 		local touchedCity = Cities:FindCity(coordX, coordZ)
	-- 		if touchedCity ~= lastTouchedCity then
	-- 			local store = GUI:GetStore()
	-- 			store:dispatch(enterCity(touchedCity)) -- TODO: need to fix if dispatch yields
	-- 			lastTouchedCity = touchedCity
	-- 		end
	-- 	end
	-- end
end

return detectCollision
