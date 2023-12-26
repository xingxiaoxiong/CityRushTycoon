
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
local toggleAuction = require(script.Parent.Parent.Actions:WaitForChild('toggleAuction'))
local AuctionItem = require(script.Parent.AuctionItem)
local AuctionDetail = require(script.Parent.AuctionDetail)
local DetailFrame = require(script.Parent.DetailFrame)

local function Auction(props)

	if props.display.showAuction then
		return e(MenuFrame, {
			title = 'Auction',
			close = function()
				props.close()
			end,
			content = e(ContentFrame, {
				content = props.auction,
				cell = AuctionItem,
			}),
			detail = e(DetailFrame, {
				detail = e(AuctionDetail),
			}),
		})
	else
		return nil
	end
end

Auction = RoactRodux.connect(
    function(state)
        return {
			auction = state.auction,
			display = state.display,
		}
    end,
    function(dispatch)
        return {
			close = function()
				return dispatch(toggleAuction())
			end,
        }
    end
)(Auction)

return Auction
