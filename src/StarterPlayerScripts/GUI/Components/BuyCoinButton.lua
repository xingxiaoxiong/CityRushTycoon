
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local e = Roact.createElement
local UIScheme = require(RS.Source.Constants.UIScheme)
local Utils = require(RS.Source.Utils.Utils)
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer
local Constants = require(RS.Source.Constants.Constants)


local function BuyCoinButton(props)
	return e('Frame', {
		Size = UDim2.fromScale(1, 0.25),
		AnchorPoint = Vector2.new(0, 0),
		Position = props.position,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	},
	{
		e("TextButton", {
			Font = UIScheme.Font,
			Size = UDim2.fromScale(1, 1),
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.fromScale(0, 0),
			BackgroundColor3 = UIScheme.Yellow,
			TextColor3 = UIScheme.FrontColor1,
			Text = '$' .. Utils.numberToReadableString(props.amount),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextScaled = true,
			[Roact.Event.Activated] = function()
				MarketplaceService:PromptProductPurchase(player, Constants.BuyCoinProductID[props.amount])
			end,
		}, {
			e('UICorner', {
				CornerRadius = UDim.new(0.5, 0),
			}),
			e('UIStroke', {
				Color = UIScheme.White,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = 4,
			}),
			e('UIPadding', {
				PaddingBottom = UDim.new(0.05),
				PaddingTop = UDim.new(0.05),
				PaddingLeft = UDim.new(0.35),
				PaddingRight = UDim.new(0.1),
			}),
		}),
		e("TextLabel", {
			Font = UIScheme.Font,
			Size = UDim2.new(0.005, 0, 0.8, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0.03, 0, 0.5, 0),
			BackgroundColor3 = UIScheme.White,
			BackgroundTransparency = 1,
			TextColor3 = UIScheme.White,
			Text = '+',
			TextXAlignment = Enum.TextXAlignment.Center,
			TextScaled = true,
		}, {
			e('UIAspectRatioConstraint', {
				AspectRatio = 1,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Height,
			}),
			e('UICorner', {
				CornerRadius = UDim.new(0.5, 0),
			}),
		}),
	})
end

BuyCoinButton = RoactRodux.connect(
    function(state)
        return state
    end,
    function(dispatch)
        return {
        }
    end
)(BuyCoinButton)

return BuyCoinButton
