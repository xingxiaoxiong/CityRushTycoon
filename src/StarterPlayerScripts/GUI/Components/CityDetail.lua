
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

local setTollEvent = Net:RemoteEvent("SetToll")
local startAuctionEvent = Net:RemoteEvent("StartAuction")

local CityDetail = Roact.Component:extend("CityDetail")

function CityDetail:init()
    self.textBoxRef = Roact.createRef()
	self.auctionBasePriceBoxRef = Roact.createRef()
	self.modalOpen, self.updateModalOpen = Roact.createBinding(false)
	self.modalText = ''
end

function CityDetail:render()
	local grandChildren = {}
	if self.props.itemSelection then
		local selection = self.props.itemSelection
		if CityConfig[selection] then
			grandChildren.Name = e('TextLabel', {
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
			grandChildren.Description = e('TextLabel', {
				BackgroundTransparency = 1,
				Font = UIScheme.Font,
				TextColor3 = UIScheme.FrontColor1,
				Text = CityConfig[selection].Description or '',
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0.1, 0),
				Size = UDim2.new(1, 0, 0.4, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextScaled = true,
			})

			local auction = self.props.auction[selection]
			if auction and auction['EndTime'] - os.time() > 0 then
				grandChildren.auctionNotice = e('TextLabel', {
					BackgroundTransparency = 1,
					Font = UIScheme.Font,
					TextColor3 = UIScheme.FrontColor1,
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.new(0.05, 0, 0.80, 0),
					Size = UDim2.new(0.9, 0, 0.22, 0),
					Text = 'Auction ends in ' .. Utils.timeLeftString(auction['EndTime']) .. '<br />At the end of the auction, you (the seller) will receive 95% of the winning bid.',
					RichText = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextScaled = true,
					[Roact.Ref] = self.auctionBasePriceBoxRef,
				});
			else
				grandChildren.auctionBasePriceTextBox = e('TextBox', {
					BackgroundColor3 = UIScheme.White,
					Font = UIScheme.Font,
					TextColor3 = UIScheme.Dark,
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.new(0.02, 0, 0.80, 0),
					Size = UDim2.new(0.55, 0, 0.12, 0),
					Text = 'Enter a base price',
					TextXAlignment = Enum.TextXAlignment.Center,
					TextScaled = true,
					[Roact.Ref] = self.auctionBasePriceBoxRef,
				});
				grandChildren.startAuctionButton = e('TextButton', {
					BackgroundColor3 = UIScheme.FrontColor2,
					Font = UIScheme.Font,
					TextColor3 = UIScheme.White,
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.new(0.59, 0, 0.80, 0),
					Size = UDim2.new(0.39, 0, 0.12, 0),
					Text = 'Start Auction',
					TextXAlignment = Enum.TextXAlignment.Center,
					TextScaled = true,
					[Roact.Event.Activated] = function()
						local auctionBasePrice = tonumber(self.auctionBasePriceBoxRef:getValue().Text)
						if auctionBasePrice == nil then
							self.modalText = 'Please input a number!'
							self.updateModalOpen(true)
						else
							startAuctionEvent:FireServer(selection, auctionBasePrice)
						end
					end,
				})
			end

			grandChildren.tollTextBox = e('TextBox', {
				BackgroundColor3 = UIScheme.White,
				Font = UIScheme.Font,
				TextColor3 = UIScheme.Dark,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0.02, 0, 0.95, 0),
				Size = UDim2.new(0.55, 0, 0.12, 0),
				Text = 'Current toll: ' .. (self.props.toll[selection] and self.props.toll[selection]['toll'] or 0),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextScaled = true,
				[Roact.Ref] = self.textBoxRef,
			});
			grandChildren.setTollButton = e('TextButton', {
				BackgroundColor3 = UIScheme.FrontColor2,
				Font = UIScheme.Font,
				TextColor3 = UIScheme.White,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0.59, 0, 0.95, 0),
				Size = UDim2.new(0.39, 0, 0.12, 0),
				Text = 'Update Toll',
				TextXAlignment = Enum.TextXAlignment.Center,
				TextScaled = true,
				[Roact.Event.Activated] = function()
					local toll = tonumber(self.textBoxRef:getValue().Text)
					if toll == nil then
						self.modalText = 'Please input a number!'
						self.updateModalOpen(true)
					else
						setTollEvent:FireServer(selection, toll)
						self.textBoxRef:getValue().Text = 'Current toll: ' .. (self.props.toll[selection] and self.props.toll[selection]['toll'] or 0)
					end
				end,
			})
		end
	else
		grandChildren[1] = e('TextLabel', {
			BackgroundTransparency = 1,
			Font = UIScheme.Font,
			TextColor3 = UIScheme.FrontColor1,
			Text = [[Choose a city to set its toll fee or sell it with auction.
			]],
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, 0, 0.5, 0),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextScaled = true,
			RichText = true,
		})
	end

	if self.modalOpen:getValue() then
		grandChildren.Modal = e(Modal, {
			onClose = function()
                self.updateModalOpen(false)
            end,
			text = self.modalText,
		})
	else
		grandChildren.Modal = nil
	end

	return e('Frame', {
		Size = UDim2.new(1, 0, 0.88, 0),
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = UIScheme.Dark,
		BorderSizePixel = 0,
	}, grandChildren)
end

CityDetail = RoactRodux.connect(
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
)(CityDetail)

return CityDetail
