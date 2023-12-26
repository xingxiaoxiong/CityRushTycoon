
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local e = Roact.createElement
local UIScheme = require(RS.Source.Constants.UIScheme)
local DBKeys = require(RS.Source.Constants.DatabaseKeys)


local function Top(props)

	return e('Frame', {
		BackgroundTransparency = 1,
		Size = UDim2.new(0.2, 0, 0.2, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
	}, {
		e("TextLabel", {
			BackgroundTransparency = 1,
			Font = UIScheme.Font,
			TextColor3 = UIScheme.Orange,
			Size = UDim2.new(1, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Text = props.display.mode == 'Contest' and 'Next Destination' or 'Break',
			TextScaled = true,
		}, {
			e('UIStroke', {
				Color = UIScheme.Dark,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
				Thickness = 2,
			}),
		}),
		e("TextLabel", {
			Font = UIScheme.Font,
			Size = UDim2.new(0.7, 0, 0.2, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0.51, 0),
			BackgroundColor3 = UIScheme.Orange,
			TextColor3 = UIScheme.White,
			Text = props.display.destination,
			TextXAlignment = Enum.TextXAlignment.Center,
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
				PaddingLeft = UDim.new(0.1),
				PaddingRight = UDim.new(0.1),
			}),
		}),
		e("TextLabel", {
			Font = UIScheme.Font,
			Size = UDim2.new(0.7, 0, 0.2, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0.75, 0),
			BackgroundTransparency = 1,
			TextColor3 = UIScheme.Yellow,
			Text = '1st Arrival Bonus: ' .. (props.gameState.firstArrivalReward or 10),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextScaled = true,
		}, {
			e('UIStroke', {
				Color = UIScheme.Dark,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
				Thickness = 2,
			}),
		})
	})
end

Top = RoactRodux.connect(
    function(state, props)
        return state
    end,
    function(dispatch)
        return {
        }
    end
)(Top)

return Top
