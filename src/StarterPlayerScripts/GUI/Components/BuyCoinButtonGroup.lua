
local RS = game:GetService("ReplicatedStorage")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local UIScheme = require(RS.Source.Constants.UIScheme)
local e = Roact.createElement
local BuyCoinButton = require(script.Parent.BuyCoinButton)


local function BuyCoinButtonGroup(props)
	return e("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(0.07, 0.05 * 4),
		Position = UDim2.new(0.05, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
	}, {
		buy1000 = e(BuyCoinButton, {
			position = UDim2.fromScale(0, 0),
			amount = 1000
		}),
		buy10000 = e(BuyCoinButton, {
			position = UDim2.fromScale(0, 0.5),
			amount = 10000
		}),
		-- buy100000000 = e(BuyCoinButton, {
		-- 	position = UDim2.fromScale(0, 1),
		-- 	amount = 100000000
		-- }),
	})

end


return BuyCoinButtonGroup
