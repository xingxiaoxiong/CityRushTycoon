
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local UIScheme = require(RS.Source.Constants.UIScheme)
local e = Roact.createElement
local CityConfig = require(RS.Source.Configs.CityConfig)
local CardConfig = require(RS.Source.Configs.CardConfig)

local selectBackpackItem = require(script.Parent.Parent.Actions:WaitForChild("selectBackpackItem"))

local function Inventory(props)

	local children = {}
	children.Layout = e("UIGridLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		StartCorner = Enum.StartCorner.TopLeft,
		CellSize = UDim2.new(0.32, 0, 0.4, 0),
		CellPadding = UDim2.new(0.01, 0, 0.03, 0),
	})
	children.Padding = e("UIPadding", {
		PaddingBottom = UDim.new(0.01, 0),
		PaddingLeft = UDim.new(0.01, 0),
		PaddingRight = UDim.new(0.01, 0),
		PaddingTop = UDim.new(0.01, 0),
	})
	local index = 1
	for cardName, count in pairs(props.backpack) do
		if count > 0 then
			local cardShowName = CityConfig[cardName] and CityConfig[cardName].Name or CardConfig[cardName] and CardConfig[cardName].Name or cardName
			local slot = e('TextButton', {
				Text = cardShowName,
				BackgroundColor3 = UIScheme.BGColor1,
				Font = UIScheme.Font,
				TextColor3 = UIScheme.FrontColor1,
				LayoutOrder = index,
				TextScaled = true,
				[Roact.Event.Activated] = function()
					props.selectCard(cardName)
				end,
			}, {
				e('UICorner', {
					CornerRadius = UDim.new(0.1, 0),
				}),
				e('TextLabel', {
					BackgroundTransparency = 1,
					Font = UIScheme.Font,
					TextColor3 = UIScheme.FrontColor1,
					TextScaled = true,
					Size = UDim2.new(0.5, 0, 0.2, 0),
					Position = UDim2.new(1, 0, 1, 0),
					AnchorPoint = Vector2.new(1, 1),
					Text = CityConfig[cardName] and '' or 'x' .. tostring(count),
					TextXAlignment = Enum.TextXAlignment.Right,
				}),
			})
			children[index] = slot
			index = index + 1
		end
	end

	return e("Frame", {
		Size = UDim2.new(0.68, 0, 0.8, 0),
		Position = UDim2.new(0.7, 0, 0.1, 0),
		AnchorPoint = Vector2.new(1, 0),
		BackgroundColor3 = UIScheme.Frame,
		BorderSizePixel = 0,
	}, children)
end

Inventory = RoactRodux.connect(
    function(state, props)
        return state
    end,
    function(dispatch)
        return {
			selectCard = function(...)
				dispatch(selectBackpackItem(...))
			end,
        }
    end
)(Inventory)

return Inventory
