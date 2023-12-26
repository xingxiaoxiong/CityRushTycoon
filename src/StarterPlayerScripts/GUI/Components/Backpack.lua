
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local e = Roact.createElement
local Inventory = require(script.Parent:WaitForChild("Inventory"))
local Detail = require(script.Parent:WaitForChild("Detail"))
local UIScheme = require(RS.Source.Constants.UIScheme)
local MenuFrame = require(script.Parent.MenuFrame)
local ContentFrame = require(script.Parent.ContentFrame)
local toggleBackpack = require(script.Parent.Parent.Actions:WaitForChild('toggleBackpack'))
local CityItem = require(script.Parent.CityItem)
local CityDetail = require(script.Parent.CityDetail)
local DetailFrame = require(script.Parent.DetailFrame)


local function Backpack(props)

	if props.display.showBackpack then
		return e(MenuFrame, {
			title = 'Backpack',
			close = function()
				props.close()
			end,
			content = e(ContentFrame, {
				content = props.cities,
				cell = CityItem,
			}),
			detail = e(DetailFrame, {
				detail = e(CityDetail),
			}),
		})
	else
		return nil
	end
end

Backpack = RoactRodux.connect(
    function(state)
        return {
			cities = state.toll,
			display = state.display,
		}
    end,
    function(dispatch)
        return {
			close = function()
				return dispatch(toggleBackpack())
			end,
        }
    end
)(Backpack)

return Backpack
