local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Libs = RS:WaitForChild("Libs")
local Roact = require(Libs.Roact)
local Rodux = require(Libs.Rodux)
local RoactRodux = require(Libs.RoactRodux)
local player = game:GetService("Players").LocalPlayer
local DataController = require(RS.Source.DataService.DataController)
local DBKeys = require(RS.Source.Constants.DatabaseKeys)
local Card = require(RS.Source:WaitForChild("Constants"):WaitForChild("Card"))
local CityConfig = require(RS.Source.Configs.CityConfig)

local rds = require(script:WaitForChild("Reducers"))

local Top = require(script.Components:WaitForChild("Top"))
local TopRight = require(script.Components:WaitForChild("TopRight"))
local Right = require(script.Components:WaitForChild("Right"))
local MessageBox = require(script.Components:WaitForChild("MessageBox"))
local Backpack = require(script.Components:WaitForChild("Backpack"))
local Auction = require(script.Components:WaitForChild("Auction"))
local CityBoard = require(script.Components:WaitForChild("CityBoard"))
local Shop = require(script.Components:WaitForChild("Shop"))
local BuyCoinButtonGroup = require(script.Components:WaitForChild("BuyCoinButtonGroup"))
local GameState = require(script.Components:WaitForChild("GameState"))

local updateTime = require(script.Actions:WaitForChild("updateTime"))
local toggleMessageBox = require(script.Actions:WaitForChild("toggleMessageBox"))
local toggleBackpack = require(script.Actions:WaitForChild("toggleBackpack"))
local toggleAuction = require(script.Actions:WaitForChild("toggleAuction"))
local updateDestination = require(script.Actions:WaitForChild("updateDestination"))
local addMessage = require(script.Actions:WaitForChild("addMessage"))
local setMessages = require(script.Actions:WaitForChild("setMessages"))
local addToBackpack = require(script.Actions:WaitForChild("addToBackpack"))
local updateShop = require(script.Actions:WaitForChild("updateShop"))
local enterCity = require(script.Actions:WaitForChild('enterCity'))
local updateToll = require(script.Actions:WaitForChild('updateToll'))
local updateAuction = require(script.Actions:WaitForChild('updateAuction'))
local updateCoin = require(script.Actions:WaitForChild('updateCoin'))

local GameplayDataStoreController = require(RS.Source.DataService:WaitForChild('GameplayDataStoreController'))
local AuctionDataStoreController = require(RS.Source.DataService:WaitForChild('AuctionDataStoreController'))
local CoinDataStoreController = require(RS.Source.DataService:WaitForChild('CoinDataStoreController'))
local MessageMemoryStoreController = require(RS.Source.DataService:WaitForChild('MessageMemoryStoreController'))

local function _formatMessage(message)
	local winnerName = message.winnerId and Players:GetNameFromUserIdAsync(message.winnerId) or 'Someone'
	local bidPrice = message.bidPrice or 'some money'
	local cityName = CityConfig[message.city] and CityConfig[message.city].Name or 'a city'
	local time = message.time and os.date("%Y-%m-%d", message.time) or 'some day'
	return '<font color="rgb(255,0,0)">' .. winnerName .. '</font> won the auction for <font color="rgb(255,0,0)">' .. cityName .. '</font> with a bid of <font color="rgb(255,0,0)">$' .. bidPrice .. '</font> on ' .. time
end

local GUI = {}

function GUI:_populateDataFromProfile(profile)
	if profile then
		local backpackData = profile[DBKeys.Backpack]
		if backpackData then
			for cardName, count in pairs(backpackData) do
				self.store:dispatch(addToBackpack(cardName, count))
			end
		end
	end
end

function GUI:Init()
	local LocalPlayer = Players.LocalPlayer
	local reducers = Rodux.combineReducers(rds)
	local initialState = {}
	self.store = Rodux.Store.new(reducers, initialState, {
		Rodux.thunkMiddleware,
	})

	local profile = DataController:WaitForProfile(player)
	self:_populateDataFromProfile(profile)

	DataController.ProfileAdded:Connect(function(profile, userID)
		if userID ~= player.UserId then return end
		self:_populateDataFromProfile(profile)
	end)

	DataController.Changed:Connect(function(profile, dataName)
		if dataName == DBKeys.Backpack then
			local backpackData = profile[DBKeys.Backpack]
			if backpackData then
				for cardName, count in pairs(backpackData) do
					self.store:dispatch(addToBackpack(cardName, count))
				end
			end
		end
	end)

	MessageMemoryStoreController.dataUpdated:Connect(function(data)
		local messages = {}
		if data and data[DBKeys.Auction] then
			for _, msg in data[DBKeys.Auction] do
				table.insert(messages, _formatMessage(msg))
			end
			self.store:dispatch(setMessages(messages))
		end
	end)
	MessageMemoryStoreController:GetData()

	CoinDataStoreController.dataUpdated:Connect(function(key, value)
		if key == tostring(LocalPlayer.UserId) then
			self.store:dispatch(updateCoin(value))
		end
	end)
	local coin = CoinDataStoreController:GetData(tostring(LocalPlayer.UserId))
	self.store:dispatch(updateCoin(coin))

	local shop = GameplayDataStoreController:GetData('Shop')
	self.store:dispatch(updateShop(shop))

	local cityData = GameplayDataStoreController:GetData('City')
	self.store:dispatch(updateToll(cityData))

	AuctionDataStoreController.dataUpdated:Connect(function(data)
		self.store:dispatch(updateAuction(data))
	end)
	local auction = AuctionDataStoreController:GetData()
	self.store:dispatch(updateAuction(auction))

	GameplayDataStoreController.dataUpdated:Connect(function(key, value)
		if key == 'Shop' then
			self.store:dispatch(updateShop(value))
		elseif key == 'City' then
			self.store:dispatch(updateToll(value))
		end
	end)

	self.store:dispatch(updateTime(''))
	self.store:dispatch(updateDestination('Peking'))
	-- self.store:dispatch(addMessage('You have logged in'))
	-- self.store:dispatch(addMessage('1Welcome to the game'))
	-- self.store:dispatch(addMessage('2Welcome to the game'))
	-- self.store:dispatch(addMessage('3Welcome to the game'))
	-- self.store:dispatch(addMessage('4Welcome to the game'))
	-- self.store:dispatch(addMessage('5Welcome to the game'))
	-- self.store:dispatch(addMessage('6Welcome to the game'))
	-- self.store:dispatch(addMessage('7Welcome to the game'))
	-- self.store:dispatch(addMessage('8Welcome to the game'))
	-- self.store:dispatch(addMessage('9Welcome to the game'))
	-- self.store:dispatch(addMessage('10Welcome to the game'))
	-- self.store:dispatch(toggleAuction())
	self.store:dispatch(enterCity('12'))

	local hud = Roact.mount(Roact.createElement(RoactRodux.StoreProvider, {
		store = self.store,
	}, {
		Roact.createElement("ScreenGui", {}, {
			Top = Roact.createElement(Top),
			TopRight = Roact.createElement(TopRight),
			Right = Roact.createElement(Right),
			MessageBox = Roact.createElement(MessageBox),
			Backpack = Roact.createElement(Backpack),
			Auction = Roact.createElement(Auction),
			CityBoard = Roact.createElement(CityBoard),
			BuyCoinButtonGroup = Roact.createElement(BuyCoinButtonGroup),
			GameState = Roact.createElement(GameState),
			-- Shop = Roact.createElement(Shop),
		}),
	}), LocalPlayer.PlayerGui, "HUD")
end

function GUI:GetStore()
	return self.store
end

return GUI