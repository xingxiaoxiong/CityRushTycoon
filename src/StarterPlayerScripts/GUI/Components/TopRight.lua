
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local e = Roact.createElement
local UIScheme = require(RS.Source.Constants.UIScheme)



local function TopRight(props)

	return e("TextLabel", {
		Font = UIScheme.Font,
		Size = UDim2.new(0.14, 0, 0.04, 0),
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.new(0.1, 0, 0.1, 0),
		BackgroundColor3 = UIScheme.Yellow,
		TextColor3 = UIScheme.FrontColor1,
		Text = props.display.coin,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextScaled = true,
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
			PaddingLeft = UDim.new(0.02),
			PaddingRight = UDim.new(0.1),
		}),
		e("TextLabel", {
			Font = UIScheme.Font,
			Size = UDim2.new(0.01, 0, 0.9, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			BackgroundColor3 = UIScheme.White,
			TextColor3 = UIScheme.Yellow,
			Text = '$',
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

TopRight = RoactRodux.connect(
    function(state)
        return state
    end,
    function(dispatch)
        return {
        }
    end
)(TopRight)

return TopRight
