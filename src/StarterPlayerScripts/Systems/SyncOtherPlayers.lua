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
local updateDestination = require(script.Parent.Parent.GUI.Actions:WaitForChild("updateDestination"))
local updateMode = require(script.Parent.Parent.GUI.Actions:WaitForChild("updateMode"))
local updateTime = require(script.Parent.Parent.GUI.Actions:WaitForChild("updateTime"))
local updateGameState = require(script.Parent.Parent.GUI.Actions:WaitForChild("updateGameState"))

local localPlayer = Players.LocalPlayer


local function syncOtherPlayers(world)
	for _, train, trainModel in world:query(Components.Train, Components.TrainModel) do
		if train.playerId ~= localPlayer.UserId then
			local frames = train.frames
			local head = trainModel.model.Train
			if head and #frames == 3 then
				head.CFrame = frames[1]
				local child1 = head:FindFirstChild('Train')
				child1.CFrame = frames[2]
				local child2 = child1:FindFirstChild('Train')
				child2.CFrame = frames[3]
			end
		end
	end
end

return syncOtherPlayers
