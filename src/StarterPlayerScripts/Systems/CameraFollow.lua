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

local function cameraFollow(world)
	if workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable then
		local currentCamera = workspace.CurrentCamera
		for _, train, trainModel in world:query(Components.Train, Components.TrainModel) do
			if train.playerId == player.UserId then
				local head = trainModel.model.Train
				local targetCFrame = CFrame.new(head.position) * CFrame.new(Vector3.new(0, 40, 40)) * CFrame.Angles(math.rad(-45), 0, 0)
				currentCamera.CFrame = currentCamera.CFrame:Lerp(targetCFrame, 0.1)
			end
		end
	end
end

return {
	system = cameraFollow,
	event = "RenderStepped",
}