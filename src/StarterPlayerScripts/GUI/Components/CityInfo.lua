
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local e = Roact.createElement
local Inventory = require(script.Parent:WaitForChild("Inventory"))
local cityFolder = workspace:WaitForChild("Tiled"):WaitForChild("City")
local CityConfig = require(RS.Source.Configs:WaitForChild('CityConfig'))
local tiledFolder = workspace:WaitForChild("Tiled")
local cityFolder = tiledFolder:WaitForChild("City")
local buyCardThunk = require(script.Parent.Parent.Thunks:WaitForChild("buyCard"))
local UIScheme = require(RS.Source.Constants.UIScheme)


local function CityInfo(props)
	local config = CityConfig[props.display.city]
	local cityPart = cityFolder:FindFirstChild(props.display.city)
	if config then

		local children = {}
		children[1] = e('TextLabel', {
			BackgroundColor3 = UIScheme.BGColor3,
			Font = UIScheme.Font,
			TextColor3 = UIScheme.FrontColor3,
			Text = config.Name,
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.new(0.7, 0, 0.1, 0),
			Position = UDim2.fromScale(0.5, -0.05),
			TextSize = 25,
			TextScaled = true,
		})
		children[2] = e('TextLabel', {
			BackgroundTransparency = 1,
			Font = UIScheme.Font,
			TextColor3 = UIScheme.FrontColor2,
			Text = cityPart:GetAttribute('owner') and ('Owner: ' .. cityPart:GetAttribute('owner')) or 'No owner yet',
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.1, 0),
			Size = UDim2.new(0.95, 0, 0.07, 0),
			TextScaled = true,
		})
		children[3] = e('TextLabel', {
			BackgroundTransparency = 1,
			Font = UIScheme.Font,
			TextColor3 = UIScheme.FrontColor2,
			Text = config.Description or 'No description',
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0.15, 0),
			Size = UDim2.new(0.95, 0, 0.4, 0),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextScaled = true,
		})
		local cardGroup = {}
		cardGroup.Layout = e("UIGridLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			StartCorner = Enum.StartCorner.TopLeft,
			CellSize = UDim2.new(0.45, 0, 0.45, 0),
			CellPadding = UDim2.new(0.1, 0, 0.05, 0),
		})
		cardGroup.Padding = e("UIPadding", {
			PaddingBottom = UDim.new(0.05, 0),
			PaddingLeft = UDim.new(0.05, 0),
			PaddingRight = UDim.new(0.05, 0),
			PaddingTop = UDim.new(0.3, 0),
		})
		if config.Cards then
			for i, card in ipairs(config.Cards) do
				cardGroup[i] = e('TextButton', {
					BackgroundColor3 = UIScheme.BGColor1,
					Font = UIScheme.Font,
					TextColor3 = UIScheme.FrontColor1,
					Text = card,
					AnchorPoint = Vector2.new(0.5, 0.5),
					TextScaled = true,
					LayoutOrder = i,
					[Roact.Event.Activated] = function()
						props.buyCard(card)
					end,
				}, {
					e('UICorner', {
						CornerRadius = UDim.new(0.2, 0),
					}),
				})
			end
		end
		children[5] = e('Frame', {
			BackgroundColor3 = UIScheme.Frame,
			Size = UDim2.new(0.95, 0, 0.38, 0),
			Position = UDim2.new(0.5, 0, 0.6, 0),
			AnchorPoint = Vector2.new(0.5, 0),
		}, cardGroup)
		children[6] = e('TextLabel', {
			Font = UIScheme.Font,
			TextColor3 = UIScheme.FrontColor1,
			BackgroundTransparency = 1,
			Text = 'Local Specialty',
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0.6, 0),
			Size = UDim2.new(1, 0, 0.1, 0),
			TextScaled = true,
		})

		return e('Frame', {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = UIScheme.Frame,
			BorderSizePixel = 5,
			Size = UDim2.new(0.95, 0, 1, 0),
		}, children)
	end
	return nil
end

CityInfo = RoactRodux.connect(
    function(state, props)
        return state
    end,
    function(dispatch)
        return {
			buyCard = function(cardName)
				dispatch(buyCardThunk(cardName))
			end,
        }
    end
)(CityInfo)

return CityInfo
