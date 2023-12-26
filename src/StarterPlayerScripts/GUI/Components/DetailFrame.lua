
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local UIScheme = require(RS.Source.Constants.UIScheme)
local e = Roact.createElement
local CityConfig = require(RS.Source.Configs.CityConfig)
local CardConfig = require(RS.Source.Configs.CardConfig)


local function DetailFrame(props)

	local children = {}
	children.Title = e('TextLabel', {
		BorderSizePixel = 0,
		BackgroundColor3 = UIScheme.BrighterGrey,
		Font = UIScheme.Font,
		TextColor3 = UIScheme.White,
		Size = UDim2.new(1, 0, 0.1, 0),
		Position = UDim2.fromScale(0, 0),
		AnchorPoint = Vector2.new(0, 0),
		TextScaled = true,
		Text = 'Detail',
	})
	children.Info = props.detail

	return e("Frame", {
		BackgroundColor3 = UIScheme.Grey,
		Size = UDim2.new(0.31, 0, 0.96, 0),
		Position = UDim2.new(0.99, 0, 0.02, 0),
		AnchorPoint = Vector2.new(1, 0),
		BorderSizePixel = 0,
	}, children)

end


return DetailFrame
