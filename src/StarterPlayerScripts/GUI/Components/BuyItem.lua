
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local e = Roact.createElement
local CityConfig = require(RS.Source.Configs:WaitForChild('CityConfig'))


local function BuyItem(props)
	local item = props.item

	return e("Frame", {
		BackgroundColor3 = Color3.new(0.6588235294117647, 0.9882352941176471, 0.35294117647058826),
	}, {
		e('TextLabel', {
			Text = item['Name'],
			Size = UDim2.fromScale(0.95, 0.95),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
		}),
		e('TextButton', {
			Text = 'Buy',
			Size = UDim2.fromScale(0.5, 0.3),
			Position = UDim2.fromScale(0.95, 0.95),
			AnchorPoint = Vector2.new(1, 1),
		}),
	})
end

return BuyItem
