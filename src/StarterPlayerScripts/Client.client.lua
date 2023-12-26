local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Player = game:GetService('Players')
local Components = require(ReplicatedStorage.Source.Components)
local Mode = require(ReplicatedStorage.Source.Constants.Mode)
local World = require(script.Parent:WaitForChild("ClientWorld"))
local DataController = require(ReplicatedStorage.Source.DataService.DataController)
local Cities = require(ReplicatedStorage.Source:WaitForChild('Cities'))
local Net = require(ReplicatedStorage.Packages:WaitForChild('Net'))
local PlayerCamera = require(script.Parent.Camera)
local UIS = game:GetService("UserInputService")

DataController:Init()
World:Init()
local world = World:GetWorld()
world:spawn(
	Components.Mode({
		mode = Mode.NoClick
	})
)

local GUI = require(script.Parent:WaitForChild("GUI"))
GUI:Init()

Cities:Init()

local players = game:GetService('Players')

task.spawn(function()
	if UIS.TouchEnabled and players.LocalPlayer:WaitForChild('PlayerGui'):FindFirstChild('TouchGui') then
		players.LocalPlayer.PlayerGui.TouchGui:WaitForChild('TouchControlFrame'):WaitForChild('JumpButton').ImageTransparency = 1
	end
end)
PlayerCamera:Init()
