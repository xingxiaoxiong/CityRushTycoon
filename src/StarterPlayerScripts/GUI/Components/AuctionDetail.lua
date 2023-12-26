
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UIScheme = require(RS.Source.Constants.UIScheme)
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local e = Roact.createElement
local CityConfig = require(RS.Source.Configs.CityConfig)
local CardConfig = require(RS.Source.Configs.CardConfig)
local Modal = require(script.Parent:WaitForChild('Modal'))
local useCardThunk = require(script.Parent.Parent.Thunks:WaitForChild("useCard"))
local player = Players.LocalPlayer
local Utils = require(RS.Source.Utils.Utils)
local Net = require(RS.Packages.Net)

local bidEvent = Net:RemoteEvent("Bid")

local AuctionDetail = Roact.Component:extend("AuctionDetail")

function AuctionDetail:init()
    self.textBoxRef = Roact.createRef()
	self.modalOpen, self.updateModalOpen = Roact.createBinding(false)
	self.modalText = ''
end

function AuctionDetail:render()
	local children = {}
	if self.props.itemSelection then
		local selection = self.props.itemSelection
		local auction = self.props.auction[selection]
		if auction then
			local bids = auction.Bids
			local currentHighestBid = #bids > 0 and bids[#bids]['BidPrice'] or auction['BasePrice']
			local currentHighestBidder = #bids > 0 and Players:GetPlayerByUserId(bids[#bids]['PlayerId'])
			local bidderDisplayName = nil
			if currentHighestBidder then
				if bids[#bids]['PlayerId'] == player.UserId then
					bidderDisplayName = 'You'
				else
					bidderDisplayName = currentHighestBidder.DisplayName
				end
			end
			if CityConfig[selection] then
				children.Name = e('TextLabel', {
					BackgroundTransparency = 1,
					Font = UIScheme.Font,
					TextColor3 = UIScheme.FrontColor1,
					Text = CityConfig[selection].Name,
					AnchorPoint = Vector2.new(0.5, 0),
					Position = UDim2.new(0.5, 0, 0, 0),
					Size = UDim2.new(1, 0, 0.1, 0),
					TextXAlignment = Enum.TextXAlignment.Center,
					TextScaled = true,
				})
				children.Description = e('TextLabel', {
					BackgroundTransparency = 1,
					Font = UIScheme.Font,
					TextColor3 = UIScheme.FrontColor1,
					Text = CityConfig[selection].Description or '',
					AnchorPoint = Vector2.new(0.5, 0),
					Position = UDim2.new(0.5, 0, 0.1, 0),
					Size = UDim2.new(1, 0, 0.3, 0),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextScaled = true,
				})
				children.LastBid = e('TextLabel', {
					BackgroundTransparency = 1,
					Font = UIScheme.Font,
					TextColor3 = UIScheme.FrontColor1,
					AnchorPoint = Vector2.new(0.5, 0),
					Position = UDim2.new(0.5, 0, 0.4, 0),
					Size = UDim2.new(1, 0, 0.4, 0),
					Text = ('Current highest bid:<br /><font color="rgb(255,0,0)">' .. currentHighestBid .. '</font>' .. (bidderDisplayName and ('<br />by <font color="rgb(255,0,0)">' .. bidderDisplayName .. '</font>') or '')) ..
						"<br />Pay $" .. Utils.calcBidFee(auction.BasePrice) .. " to bid",
					TextXAlignment = Enum.TextXAlignment.Left,
					TextScaled = true,
					RichText = true,
				});
				children.Bid = e('TextBox', {
					BackgroundColor3 = UIScheme.White,
					Font = UIScheme.Font,
					TextColor3 = UIScheme.Dark,
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.new(0.02, 0, 0.95, 0),
					Size = UDim2.new(0.55, 0, 0.12, 0),
					Text = 'Enter Bid Price',
					TextXAlignment = Enum.TextXAlignment.Center,
					TextScaled = true,
					[Roact.Ref] = self.textBoxRef,
				});
				children.BidButton = e('TextButton', {
					BackgroundColor3 = UIScheme.FrontColor2,
					Font = UIScheme.Font,
					TextColor3 = UIScheme.White,
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.new(0.59, 0, 0.95, 0),
					Size = UDim2.new(0.39, 0, 0.12, 0),
					Text = 'Bid',
					TextXAlignment = Enum.TextXAlignment.Center,
					TextScaled = true,
					[Roact.Event.Activated] = function()
						local bidAmount = tonumber(self.textBoxRef:getValue().Text)
						if bidAmount == nil or bidAmount <= auction.BasePrice or currentHighestBid and bidAmount <= currentHighestBid then
							self.modalText = 'Please input a number greater than ' .. (currentHighestBid or auction.BasePrice) .. ' !'
							self.updateModalOpen(true)
							return
						end
						if bidAmount > self.props.display.coin then
							self.modalText = 'You cannot bid more than you have!'
							self.updateModalOpen(true)
						end
						bidEvent:FireServer(selection, bidAmount)
						self.textBoxRef:getValue().Text = 'Enter Bid Price'
					end,
				})
			end
		end
	else
		children[1] = e('TextLabel', {
			BackgroundTransparency = 1,
			Font = UIScheme.Font,
			TextColor3 = UIScheme.FrontColor1,
			Text = [[Each bid costs 1% of the item's base price. <br />
After the 24-hour period is up, the person with the highest bid wins the item.
			]],
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, 0, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextScaled = true,
			RichText = true,
		})
	end

	if self.modalOpen:getValue() then
		children.Modal = e(Modal, {
			onClose = function()
                self.updateModalOpen(false)
            end,
			text = self.modalText,
		})
	else
		children.Modal = nil
	end

	return e("Frame", {
		Size = UDim2.new(1, 0, 0.88, 0),
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = UIScheme.Dark,
		BorderSizePixel = 0,
	}, children)
end

AuctionDetail = RoactRodux.connect(
    function(state)
        return state
    end,
    function(dispatch)
        return {
			useCard = function(...)
				dispatch(useCardThunk(...))
			end,
        }
    end
)(AuctionDetail)

return AuctionDetail
