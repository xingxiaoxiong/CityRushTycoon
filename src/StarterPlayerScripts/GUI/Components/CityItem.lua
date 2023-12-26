
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local UIScheme = require(RS.Source.Constants.UIScheme)
local e = Roact.createElement
local CityConfig = require(RS.Source.Configs.CityConfig)
local selectItem = require(script.Parent.Parent.Actions:WaitForChild("selectItem"))
local Utils = require(RS.Source.Utils.Utils)

local function CityItem(props)
	if props.value['owner'] ~= Players.LocalPlayer.UserId then
		return
	end
	return e("Frame", {
		BackgroundColor3 = UIScheme.Orange,
		BorderSizePixel = 0,
		LayoutOrder = props.index,
		BackgroundTransparency = props.itemSelection ~= props.key and 1 or 0
	}, {
		Name = e('TextLabel', {
			BorderSizePixel = 0,
			BackgroundColor3 = UIScheme.SkyBlue,
			Font = UIScheme.Font,
			TextColor3 = UIScheme.White,
			Size = UDim2.new(0.95, 0, 0.2, 0),
			Position = UDim2.fromScale(0.5, 0.025),
			AnchorPoint = Vector2.new(0.5, 0),
			TextScaled = true,
			Text = CityConfig[props.key] and CityConfig[props.key].Name,
		}),
		Icon = e('ImageLabel', {
			BorderSizePixel = 0,
			Size = UDim2.new(0.95, 0, 0.6, 0),
			Position = UDim2.fromScale(0.5, 0.225),
			AnchorPoint = Vector2.new(0.5, 0),
			Image = CityConfig[props.key] and CityConfig[props.key].Image,
		}, {
			e('UIAspectRatioConstraint', {
				AspectRatio = 1,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Width,
			}),
		}),
		TransparentButton = e('TextButton', {
			Text = '',
			TextTransparency = 1,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0, 0),
			AnchorPoint = Vector2.new(0, 0),
			[Roact.Event.Activated] = function()
				if props.itemSelection == props.key then
					props.selectItem(nil)
				else
					props.selectItem(props.key)
				end
			end,
		})
	})
end

CityItem = RoactRodux.connect(
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
)(CityItem)

return CityItem
