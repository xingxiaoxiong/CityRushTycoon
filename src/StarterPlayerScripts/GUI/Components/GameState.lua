
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local e = Roact.createElement
local UIScheme = require(RS.Source.Constants.UIScheme)


local function GameState(props)
	if props.display.mode ~= 'Contest' then
		return
	end
	return e('Frame', {
		BackgroundTransparency = 1,
		Size = UDim2.new(0.2, 0, 0.15, 0),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(0.9, 0, 0.1, 0),
	}, {
		e("TextLabel", {
			BackgroundTransparency = 1,
			Font = UIScheme.Font,
			TextColor3 = UIScheme.SkyBlue,
			Size = UDim2.new(1, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Text = props.gameState.numberOfArrivedPlayers and props.gameState.totalNumberOfPlayers and (props.gameState.numberOfArrivedPlayers .. '/' .. props.gameState.totalNumberOfPlayers .. ' has arrived') or 'hello',
			TextXAlignment = Enum.TextXAlignment.Right,
			TextScaled = true,
		}, e('UIStroke', {
			Color = UIScheme.Dark,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
			Thickness = 2,
		})),
		e("TextLabel", {
			BackgroundTransparency = 1,
			Font = UIScheme.Font,
			Size = UDim2.new(1, 0, 0.3, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0.51, 0),
			TextColor3 = UIScheme.Red,
			Text = props.gameState.rank and '!You are the ' .. tostring(props.gameState.rank) ..' one arrived' or '',
			TextXAlignment = Enum.TextXAlignment.Right,
			TextScaled = true,
		}, e('UIStroke', {
			Color = UIScheme.Dark,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
			Thickness = 2,
		}))
	})
end

GameState = RoactRodux.connect(
    function(state, props)
        return state
    end,
    function(dispatch)
        return {
        }
    end
)(GameState)

return GameState
