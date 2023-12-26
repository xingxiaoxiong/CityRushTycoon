
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local UIScheme = require(RS.Source.Constants.UIScheme)
local e = Roact.createElement
local CityConfig = require(RS.Source.Configs.CityConfig)
local CardConfig = require(RS.Source.Configs.CardConfig)
local selectItem = require(script.Parent.Parent.Actions:WaitForChild("selectItem"))
local PlayerGui = Players.LocalPlayer.PlayerGui

local function Modal(props)

	return Roact.createElement(Roact.Portal, {
        target = PlayerGui
    }, {
        Modal = Roact.createElement("ScreenGui", {}, {
			Frame = e("Frame", {
				BackgroundColor3 = UIScheme.Dark,
				BorderColor3 = UIScheme.White,
				BorderSizePixel = 5,
				Size = UDim2.new(0.3, 0, 0.2, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
			}, {
				e('UIAspectRatioConstraint', {
					AspectRatio = 1.6,
					AspectType = Enum.AspectType.FitWithinMaxSize,
					DominantAxis = Enum.DominantAxis.Width,
				}),
				e('TextLabel', {
					BackgroundTransparency = 1,
					Font = UIScheme.Font,
					TextColor3 = UIScheme.FrontColor1,
					Text = props.text,
					AnchorPoint = Vector2.new(0.5, 0),
					Position = UDim2.new(0.5, 0, 0, 0),
					Size = UDim2.new(1, 0, 0.75, 0),
					TextXAlignment = Enum.TextXAlignment.Center,
					TextScaled = true,
				}),
				Roact.createElement("TextButton", {
					BorderSizePixel = 0,
					BackgroundColor3 = UIScheme.Orange,
					Font = UIScheme.Font,
					TextColor3 = UIScheme.White,
					AnchorPoint = Vector2.new(0.5, 1),
					Position = UDim2.new(0.5, 0, 0.97, 0),
					Size = UDim2.new(0.5, 0, 0.25, 0),
					Text = "OK",
					TextScaled = true,
					[Roact.Event.Activated] = function()
						props.onClose()
					end
				}),
			}),
        })
    })
end

return Modal
