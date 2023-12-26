local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Components = require(RS.Source.Components)
local Matter = require(RS.Packages.matter)
local Utils = require(RS.Source.Utils.Utils)
local Constants = require(RS.Source.Constants.Constants)
local UIS = game:GetService("UserInputService")
local Net = require(RS.Packages.Net)
local GameplayDataStoreController = require(RS.Source.DataService.GameplayDataStoreController)
local CoinDataStoreController = require(RS.Source.DataService.CoinDataStoreController)
local DataController = require(RS.Source.DataService.DataController)
local Cities = require(RS.Source:WaitForChild('Cities'))
local DBKeys = require(RS.Source.Constants.DatabaseKeys)
local UI = require(RS.Source.Utils:WaitForChild('UI'))

local moveTrainEvent = Net:RemoteEvent("MoveTrain")

local _debounce = false
local function _showBalanceInsufficientWarning()
	if _debounce then return end
	_debounce = true
	task.delay(4, function()
		_debounce = false
	end)
	UI:ShowBalanceUpdate('Insufficient Balance')
end

local function _move(train, pos, index)
	local currentPos = train.Position

	local lookVector = Vector3.new(pos.X - currentPos.X, 0, pos.Z - currentPos.Z).Unit
	local rot = lookVector.Z == 1 and 90 or lookVector.Z == -1 and -90 or lookVector.X == 1 and 180 or 0

	train.Position = pos
	train.Rotation = Vector3.new(0, rot, 0)

	moveTrainEvent:FireServer(train, train.CFrame, index)
	local child = train:FindFirstChild('Train')
	if child then
		_move(child, currentPos, index + 1)
	end
end

local moveX, moveY = 0, 0
local joystickCenter = nil
local Workspace = game:GetService("Workspace")
local screenSize = Workspace.CurrentCamera.ViewportSize
UIS.InputBegan:Connect(function(input, processed)
    if processed then
        return
    end

    if input.UserInputType == Enum.UserInputType.Touch and input.Position.X < (screenSize.X / 2) then
        joystickCenter = input.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and joystickCenter then
        local offset = input.Position - joystickCenter
        local direction = offset.Unit
		if math.abs(direction.X) > math.abs(direction.Y) then
			if direction.X > 0 then
				moveX = 1
			else
				moveX = -1
			end
			moveY = 0
		elseif math.abs(direction.X) < math.abs(direction.Y) then
			if direction.Y > 0 then
				moveY = 1
			else
				moveY = -1
			end
			moveX = 0
		end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        joystickCenter = nil
    end
	moveX = 0
	moveY = 0
end)

local function moveTrain(world)

	if Matter.useThrottle(0.2) then
		if UIS:IsKeyDown(Enum.KeyCode.A) or UIS:IsKeyDown(Enum.KeyCode.Left) then
			moveX = -1
		elseif UIS:IsKeyDown(Enum.KeyCode.D) or UIS:IsKeyDown(Enum.KeyCode.Right)  then
			moveX = 1
		end

		if UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.Up) then
			moveY = -1
		elseif UIS:IsKeyDown(Enum.KeyCode.S) or UIS:IsKeyDown(Enum.KeyCode.Down) then
			moveY = 1
		end

		local rails = nil
		for _, railsComp in world:query(Components.Rail) do
			rails = railsComp.rails
		end
		if not rails then
			return
		end

		for _, train, trainModel in world:query(Components.Train, Components.TrainModel) do
			if train.playerId == Players.LocalPlayer.UserId then
				if math.abs(moveX) + math.abs(moveY) == 0 then
					break
				end
				local pos = trainModel.model.Train.Position
				local childPos = trainModel.model.Train.Train.Position

				local headX, headZ = Utils.positionToCoordinate(pos.X, pos.Z)
				local childX, childZ = Utils.positionToCoordinate(childPos.X, childPos.Z)

				local deltaX = headX - childX
				deltaX = Utils.normalized(deltaX)
				local deltaZ = headZ - childZ
				deltaZ = Utils.normalized(deltaZ)
				local directions = {
					{deltaX, deltaZ}
				}
				if math.abs(moveX) + math.abs(moveY) == 1 then
					table.insert(directions, 1, {moveX, moveY})
				end
				if math.ceil(deltaX) ~= 0 then
					table.insert(directions, {0, deltaX})
					table.insert(directions, {0, -deltaX})
				elseif math.ceil(deltaZ) ~= 0 then
					table.insert(directions, {-deltaZ, 0})
					table.insert(directions, {deltaZ, -0})
				end

				local coin = CoinDataStoreController:GetData(tostring(Players.LocalPlayer.UserId))

				for _, delta in pairs(directions) do
					local nextCoordX = headX + delta[1]
					local nextCoordZ = headZ + delta[2]
					if rails[Utils.generateRailsKey(nextCoordX, nextCoordZ)] ~= nil then
						local city = Cities:FindCity(nextCoordX, nextCoordZ)
						local cityDict = GameplayDataStoreController:GetData('City')
						if city and cityDict then
							local cityData = cityDict[city]
							if cityData and cityData['owner'] ~= Players.LocalPlayer.UserId and coin and cityData['toll'] and cityData['toll'] > coin then
								_showBalanceInsufficientWarning()
								continue
							end
						end

						local nextX, nextZ = Utils.coordinateToPosition(nextCoordX, nextCoordZ)
						local nextPosition = Vector3.new(nextX, pos.Y, nextZ)
						trainModel.model.Position = nextPosition
						trainModel.model.Rotation = Vector3.new(0, 0, 90)
						moveTrainEvent:FireServer(trainModel.model, trainModel.model.CFrame, 1)
						_move(trainModel.model.Train, nextPosition, 1)
						break
					end
				end
				break
			end
		end
	end
end

return moveTrain
