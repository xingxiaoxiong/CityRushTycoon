
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local e = Roact.createElement
local CityConfig = require(RS.Source.Configs:WaitForChild('CityConfig'))
local BuyItem = require(script.Parent:WaitForChild('BuyItem'))


local function BuyWindow(props)
	local children = {}
	children[1] = e('TextLabel', {
		Text = 'Buy',
		Size = UDim2.fromScale(0.4, 0.2),
		Position = UDim2.fromScale(0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0),
	})

	local goods = {}
	goods.Layout = e("UIGridLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		StartCorner = Enum.StartCorner.TopLeft,
		CellSize = UDim2.new(0.32, 0, 0.4, 0),
		CellPadding = UDim2.new(0.01, 0, 0.03, 0),
	})
	local index = 1
	for key, value in pairs(props.shop) do
		local conf = CityConfig[key]
		if not conf then continue end
		goods[key] = e(BuyItem, {
			key = key,
			item = conf,
			-- [Roact.Event.Activated] = function()
			-- 	props.buyCard(card)
			-- end,
		})
		index = index + 1
	end

	children[2] = e("Frame", {
		Size = UDim2.new(1, 0, 0.8, 0),
		Position = UDim2.new(0.5, 0, 0.2, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Color3.new(0.8666666666666667, 0.25098039215686274, 0.16862745098039217),
	}, goods)

	return e("Frame", {
		Size = UDim2.new(0.5, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		AnchorPoint = Vector2.new(0, 0),
		BackgroundColor3 = Color3.new(0.6588235294117647, 0.9882352941176471, 0.35294117647058826),
		BackgroundTransparency = 0.9,
	}, children)
end


BuyWindow = RoactRodux.connect(
    function(state, props)
        return state
    end,
    function(dispatch)
        return {
        }
    end
)(BuyWindow)

return BuyWindow
