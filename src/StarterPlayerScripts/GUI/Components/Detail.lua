
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UIScheme = require(RS.Source.Constants.UIScheme)
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local e = Roact.createElement
local CityConfig = require(RS.Source.Configs.CityConfig)
local CardConfig = require(RS.Source.Configs.CardConfig)
local useCardThunk = require(script.Parent.Parent.Thunks:WaitForChild("useCard"))

local Detail = Roact.Component:extend("Detail")

function Detail:init()
    self.textBoxRef = Roact.createRef()
end

function Detail:render()

	local children = {}
	if self.props.backpackSelection then
		local selection = self.props.backpackSelection
		if CityConfig[selection] then
			children[1] = e('TextLabel', {
				BackgroundTransparency = 1,
				Font = UIScheme.Font,
				TextColor3 = UIScheme.FrontColor3,
				Text = CityConfig[selection].Description or 'No description',
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0.15, 0),
				Size = UDim2.new(0.95, 0, 0.4, 0),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextScaled = true,
			})
			children[2] = e('TextLabel', {
				BackgroundTransparency = 1,
				Font = UIScheme.Font,
				TextColor3 = UIScheme.FrontColor3,
				Text = 'Current Toll Fee: ' .. (self.props.toll[selection] and self.props.toll[selection]['toll'] or 0),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0.55, 0),
				Size = UDim2.new(0.95, 0, 0.2, 0),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextScaled = true,
			})
			children[3] = e('TextBox', {
				BackgroundColor3 = UIScheme.BGColor2,
				Font = UIScheme.Font,
				TextColor3 = UIScheme.FrontColor2,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0.05, 0, 0.95, 0),
				Size = UDim2.new(0.55, 0, 0.12, 0),
				Text = (self.props.toll[selection] and self.props.toll[selection]['toll'] or 0),
				TextXAlignment = Enum.TextXAlignment.Right,
				TextScaled = true,
				[Roact.Ref] = self.textBoxRef,
			});
			children[4] = e('TextButton', {
				BackgroundColor3 = UIScheme.BGColor3,
				Font = UIScheme.Font,
				TextColor3 = UIScheme.FrontColor3,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0.65, 0, 0.95, 0),
				Size = UDim2.new(0.3, 0, 0.12, 0),
				Text = 'Update',
				TextXAlignment = Enum.TextXAlignment.Center,
				TextScaled = true,
				[Roact.Event.Activated] = function()
					print(self.textBoxRef:getValue().Text)
				end,
			}, {
				e('UICorner', {
					CornerRadius = UDim.new(0.2, 0),
				}),
			})
		elseif CardConfig[selection] then
			children[1] = e('TextLabel', {
				BackgroundTransparency = 1,
				Font = UIScheme.Font,
				TextColor3 = UIScheme.FrontColor3,
				Text = CardConfig[selection].Description or 'No description',
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0.3, 0),
				Size = UDim2.new(0.9, 0, 0.3, 0),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextScaled = true,
			})
			children[2] = e('TextButton', {
				BackgroundColor3 = UIScheme.BGColor1,
				Font = UIScheme.Font,
				TextColor3 = UIScheme.FrontColor1,
				Text = 'Use',
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 0, 0.8, 0),
				Size = UDim2.new(0.5, 0, 0.1, 0),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextScaled = true,
				[Roact.Event.Activated] = function()
					self.props.useCard(selection)
				end,
			})
		end
	end

	return e("Frame", {
		Size = UDim2.new(0.28, 0, 0.8, 0),
		Position = UDim2.new(0.7, 0, 0.1, 0),
		AnchorPoint = Vector2.new(0, 0),
		BackgroundColor3 = UIScheme.Frame,
	}, children)
end

Detail = RoactRodux.connect(
    function(state)
        return state
    end,
    function(dispatch)
        return {
			useCard = function(...)
				dispatch(useCardThunk(...))
			end,
			updateToll = function(...)
				dispatch(useCardThunk(...))
			end,
        }
    end
)(Detail)

return Detail
