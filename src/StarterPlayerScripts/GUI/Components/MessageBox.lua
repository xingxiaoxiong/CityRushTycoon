
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local e = Roact.createElement
local MenuFrame = require(script.Parent.MenuFrame)
local toggleMessageBox = require(script.Parent.Parent.Actions:WaitForChild('toggleMessageBox'))
local UIScheme = require(RS.Source.Constants.UIScheme)


local function MessageBox(props)

	if props.display.showMessageBox then
		local children = {}
		children.Layout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
		for index, message in ipairs(props.messages) do
			local slot = e('TextLabel', {
				Text = message,
				BackgroundColor3 = UIScheme.Grey,
				Size = UDim2.new(0.95, 0, 0.15, 0),
				LayoutOrder = index,
				Font = UIScheme.Font,
				TextColor3 = UIScheme.FrontColor1,
				TextScaled = true,
				RichText = true,
			})
			children[index] = slot
		end

		return e(MenuFrame, {
			title = 'Message',
			close = function()
				props.close()
			end,
			content = e("ScrollingFrame", {
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = UIScheme.Dark,
				BorderSizePixel = 0,
				BackgroundTransparency = 0.5,
				AutomaticCanvasSize = Enum.AutomaticSize.Y
			}, children)
		})
	else
		return nil
	end
end

MessageBox = RoactRodux.connect(
    function(state, props)
        return state
    end,
    function(dispatch)
        return {
			close = function()
				return dispatch(toggleMessageBox())
			end,
        }
    end
)(MessageBox)

return MessageBox
