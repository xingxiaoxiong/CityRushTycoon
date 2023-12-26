local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local Net = require(RS.Packages.Net)
local World = require(script.Parent:WaitForChild("ClientWorld"))
local Components = require(RS.Source.Components)
local Mode = require(RS.Source.Constants.Mode)
local Utils = require(RS.Source.Utils.Utils)
local Constants = require(RS.Source.Constants.Constants)
local player = game.Players.LocalPlayer

local useBreakRailCardEvent = Net:RemoteEvent("UseBreakRailCard")
local moveTrainEvent = Net:RemoteEvent("MoveTrain")


local camera = workspace.CurrentCamera

local params = RaycastParams.new()
params.FilterDescendantsInstances = {} -- anything you want, for example the player's character, the ray filters through these
params.FilterType = Enum.RaycastFilterType.Exclude -- choose exclude or include
local function rayResult(x, y)
    local unitRay = camera:ScreenPointToRay(x, y) -- :ViewportPointToRay() is another choice
    return workspace:Raycast(unitRay.Origin, unitRay.Direction * 500, params) -- 500 is how far to raycast
end


local function teleportTrain(train, parentCoordX, parentCoordZ)
	for _, delta in ipairs(Constants.DirectionDelta) do
		local newCoordX = parentCoordX + delta.deltaX
		local newCoordZ = parentCoordZ + delta.deltaZ
		local world = World:GetWorld()
		local rails = Utils.getRails(world)
		if Utils.isValidRail(rails, newCoordX, newCoordZ) then
			local nextX, nextZ = Utils.coordinateToPosition(newCoordX, newCoordZ)
			moveTrainEvent:FireServer(train, Vector3.new(nextX, train.Position.Y, nextZ))
			if train:FindFirstChild("Train") then
				teleportTrain(train.Train, newCoordX, newCoordZ)
			end
		end
	end
end

local function teleport(world, coordX, coordZ)
	for _, train, trainModel in world:query(Components.Train, Components.TrainModel) do
		if train.playerId == player.UserId then
			local nextX, nextZ = Utils.coordinateToPosition(coordX, coordZ)
			-- TODO: need to use train.frames
			moveTrainEvent:FireServer(trainModel.model.Train, Vector3.new(nextX, trainModel.model.Train.Position.Y, nextZ))
			teleportTrain(trainModel.model.Train.Train, coordX, coordZ)
		end
	end
end

UIS.InputEnded:Connect(function(input, gameProcessedEvent)
	local world = World:GetWorld()
	if input.KeyCode == Enum.KeyCode.Y then
		useBreakRailCardEvent:FireServer()
	elseif input.KeyCode == Enum.KeyCode.T then
		for id, modeComp in world:query(Components.Mode) do
			world:insert(id, modeComp:patch({
				mode = Mode.Teleport
			}))
		end
	end

	if not gameProcessedEvent then
		local inputType = input.UserInputType
        if inputType == Enum.UserInputType.Touch or inputType == Enum.UserInputType.MouseButton1 then
			local mode, modeId, modeComp
			for _modeId, _modeComp in world:query(Components.Mode) do
				mode = _modeComp.mode
				modeId = _modeId
				modeComp = _modeComp
			end
			if mode == Mode.Teleport then
				local result = rayResult(input.Position.X, input.Position.Y)
				if result then
					local coordX, coordZ = Utils.positionToCoordinate(result.Instance.Position.X, result.Instance.Position.Z)
					local rails = Utils.getRails(world)
					if Utils.isValidRail(rails, coordX, coordZ) then
						teleport(world, coordX, coordZ)
						world:insert(modeId, modeComp:patch({
							mode = Mode.NoClick
						}))
					end
				end
			end
        end
    end
end)

