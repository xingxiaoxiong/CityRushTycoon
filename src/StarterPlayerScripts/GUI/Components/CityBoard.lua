
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local e = Roact.createElement
local Inventory = require(script.Parent:WaitForChild("Inventory"))
local cityFolder = workspace:WaitForChild("Tiled"):WaitForChild("City")
local CityInfo = require(script.Parent:WaitForChild('CityInfo'))


local function CityBoard(props)
	if props.display.city then
		local cityPart = cityFolder:FindFirstChild(props.display.city)
		if cityPart then
			return e(Roact.Portal, {
				target = Players.LocalPlayer.PlayerGui
			}, {
				CityBoard = e("BillboardGui", {
					Adornee = cityPart,
					Size = UDim2.new(16, 0, 20, 0),
					StudsOffset = Vector3.new(0, 15, 0),
					Active = true,
					AlwaysOnTop = true,
				}, {
					CityInfo = e(CityInfo)
				})
			})
		end
	end
	return nil
end

CityBoard = RoactRodux.connect(
    function(state, props)
        return state
    end,
    function(dispatch)
        return {
        }
    end
)(CityBoard)

return CityBoard
