
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local e = Roact.createElement
local BuyWindow = require(script.Parent.BuyWindow)


local function Shop(state)
	return e("Frame", {
		Size = UDim2.new(0.8, 0, 0.6, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.new(0, 1, 1),
	}, {
		BuyWindow = e(BuyWindow)
	})
end

Shop = RoactRodux.connect(
    function(state, props)
        return state
    end,
    function(dispatch)
        return {
        }
    end
)(Shop)

return Shop
