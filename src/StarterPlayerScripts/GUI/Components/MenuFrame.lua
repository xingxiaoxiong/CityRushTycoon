
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local e = Roact.createElement
local Inventory = require(script.Parent:WaitForChild("Inventory"))
local Detail = require(script.Parent:WaitForChild("Detail"))
local UIScheme = require(RS.Source.Constants.UIScheme)
local selectItem = require(script.Parent.Parent.Actions:WaitForChild("selectItem"))


local MenuFrame = Roact.Component:extend("MenuFrame")

function MenuFrame:init()
    self.props.selectItem(nil)
end

function MenuFrame:render()
	return e("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderColor3 = UIScheme.White,
		BorderSizePixel = 5,
		Size = self.props.size or UDim2.new(0.4, 0, 0.6, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
	}, {
		e('UIAspectRatioConstraint', {
			AspectRatio = self.props.AspectRatio or 1.6,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width,
		}),
		e('TextLabel', {
			BorderColor3 = Color3.new(1, 1, 1),
			BackgroundColor3 = UIScheme.Orange,
			Font = UIScheme.Font,
			TextColor3 = UIScheme.White,
			Size = UDim2.new(0.925, 0, 0.1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0),
			TextScaled = true,
			Text = self.props.title,
		}),
		e('TextButton', {
			BackgroundColor3 = UIScheme.Orange,
			Font = UIScheme.Font,
			TextColor3 = UIScheme.White,
			BorderSizePixel = 0,
			Size = UDim2.new(0.07, 0, 0.1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			AnchorPoint = Vector2.new(1, 0),
			TextScaled = true,
			Text = 'X',
			[Roact.Event.Activated] = function()
				self.props.close()
			end,
		}),
		ContentFrame = e("Frame", {
			BackgroundColor3 = UIScheme.Grey,
			BorderColor3 = UIScheme.White,
			Size = UDim2.fromScale(1, 0.895),
			Position = UDim2.new(0.5, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 1),
		}, {
			ListFrame = self.props.content,
			DetailFrame = self.props.detail,
		}),
	})
end

MenuFrame = RoactRodux.connect(
    function(state)
        return state
    end,
    function(dispatch)
        return {
			selectItem = function(city)
				dispatch(selectItem(city))
			end,
        }
    end
)(MenuFrame)

return MenuFrame
