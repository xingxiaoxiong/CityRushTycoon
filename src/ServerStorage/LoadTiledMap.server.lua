local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")
local CollectionService = game:GetService("CollectionService")
local TextService = game:GetService("TextService")

local SS = game:GetService("ServerStorage")
local RS = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Tag = require(RS.Source.Constants.Tag)
local Constants = require(RS.Source.Constants.Constants)
local gridSize = Constants.GridSize
local CityNameBoardTemplate = RS.Assets.CityNameBoard
local CityConfig = require(RS.Source.Configs.CityConfig)

local tiledFolder = workspace:WaitForChild("Tiled")
local railFolder = tiledFolder:WaitForChild("Rail")
local cityFolder = tiledFolder:WaitForChild("City")
local assetFolder = RS:WaitForChild("Assets"):WaitForChild("Map")

-- Create a new toolbar section titled "Custom Script Tools"
local toolbar = plugin:CreateToolbar("Custom Script Tools")

-- Add a toolbar button named "Create Empty Script"
local newScriptButton = toolbar:CreateButton("Create Empty Script", "Create an empty script", "rbxassetid://4458901886")

-- Make button clickable even if 3D viewport is hidden
newScriptButton.ClickableWhenViewportHidden = true

local function _findParentFolder(layerId)
	if layerId == 1 then
		return railFolder
	elseif layerId == 2 then
		return cityFolder
	end
	return tiledFolder
end

local function _findLevel(layerId)
	if layerId == 1 then
		return Constants.GroundLevel
	elseif layerId == 2 then
		return Constants.GroundLevel
	end
	return tiledFolder
end

local function _findAsset(layerId, n)
	if n == 0 then return nil end
	if layerId == 1 then
		return assetFolder:FindFirstChild(n)
	elseif layerId == 2 then
		return assetFolder:FindFirstChild('21')
	end
	return nil
end

local function _cleanupTiled()
	for _, object in pairs(tiledFolder:GetChildren()) do
		if object:IsA('Folder') then
			object:ClearAllChildren()
		else
			object:Destroy()
		end
	end
end

local function _generateRailLayer(layer)
	local width = layer.width
	for i, n in ipairs(layer.data) do
		local x = ((i - 1) % width) * gridSize
		local z = math.floor((i - 1) / width) * gridSize
		local model = n ~= 0 and assetFolder:FindFirstChild(n) or nil
		local y = Constants.GroundLevel
		if model then
			local clone = model:Clone()
			clone.Parent = railFolder
			clone.Anchored = true
			clone.Position = Vector3.new(x, y, z)
			clone.CollisionGroup = 'World'
			CollectionService:AddTag(clone, Tag.RailSegment)
		end
	end
end

local function _generateCityLayer(layer)
	local width = layer.width
	for i, n in ipairs(layer.data) do
		local x = ((i - 1) % width) * gridSize
		local z = math.floor((i - 1) / width) * gridSize
		local model = n ~= 0 and assetFolder:FindFirstChild('21') or nil
		local y = Constants.GroundLevel
		if model then
			local clone = model:Clone()
			clone.Parent = _findParentFolder(layer.id)
			clone.Anchored = true
			clone.Position = Vector3.new(x, y, z)
			clone.CollisionGroup = 'World'
			clone.Name = n
			local board = CityNameBoardTemplate:Clone()
			local surfaceGui = board:FindFirstChild('SurfaceGui')
			local cityNameLabel = surfaceGui:FindFirstChild('CityNameLabel')
			cityNameLabel.Text = CityConfig[tostring(n)] and CityConfig[tostring(n)].Name or n
			cityNameLabel.TextSize = 100
			cityNameLabel.TextScaled = true
			cityNameLabel.Size = UDim2.fromScale(1, 1)
			cityNameLabel.RichText = true
			local bounds = TextService:GetTextSize(cityNameLabel.Text, 100, "SourceSans", Vector2.new(10000, 10000))
			board.CFrame = clone.CFrame * CFrame.new(Vector3.new(0, 5, 5)) * CFrame.Angles(math.rad(30), 0, 0)
			board.Size = Vector3.new(bounds.X/20, bounds.Y/20 * 1.5, 0.2)
			board.Parent = clone
		end
	end
end

local function onNewScriptButtonClicked()
	local mapData = require(SS.MapData1)

	_cleanupTiled()
	for _, layer in mapData.layers do
		if layer.id == 1 then
			_generateRailLayer(layer)
		elseif layer.id == 2 then
			_generateCityLayer(layer)
		end
	end

	ChangeHistoryService:SetWaypoint("Create map")
end

newScriptButton.Click:Connect(onNewScriptButtonClicked)
