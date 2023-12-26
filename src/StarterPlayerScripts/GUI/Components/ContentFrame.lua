
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local UIScheme = require(RS.Source.Constants.UIScheme)
local e = Roact.createElement
local CityConfig = require(RS.Source.Configs.CityConfig)
local CardConfig = require(RS.Source.Configs.CardConfig)

local function ContentFrame(props)

	local children = {}
	children.Layout = e("UIGridLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		StartCorner = Enum.StartCorner.TopLeft,
		CellSize = UDim2.new(0.33, 0, 0.58, 0),
		CellPadding = UDim2.new(0, 0, 0.0, 0),
	})
	children.Scale = e('UIScale', {
		Scale = 1,
	})
	local index = 1
	for key, value in pairs(props.content) do
		local slot = e(props.cell, {
			key = key,
			value = value,
			index = index,
		})
		children[index] = slot
		index = index + 1
	end

	return e("Frame", {
		BackgroundColor3 = UIScheme.Grey,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(0.66, 0.96),
		Position = UDim2.new(0.01, 0, 0.02, 0),
		AnchorPoint = Vector2.new(0, 0),
	}, {
	Title = e('TextLabel', {
		BorderSizePixel = 0,
		BackgroundColor3 = UIScheme.Orange,
		Font = UIScheme.Font,
		TextColor3 = UIScheme.White,
		Size = UDim2.new(1, 0, 0.1, 0),
		Position = UDim2.fromScale(0, 0),
		AnchorPoint = Vector2.new(0, 0),
		TextScaled = true,
		Text = 'City List',
	}),
	ScrollingFrame = e("ScrollingFrame", {
		Size = UDim2.new(1, 0, 0.88, 0),
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = UIScheme.Dark,
		BorderSizePixel = 0,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.fromScale(0, 0),
		ScrollBarThickness = 8,
	}, children)})

end


return ContentFrame
