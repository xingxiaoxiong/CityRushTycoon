local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Components = require(RS.Source.Components)
local Matter = require(RS.Packages.matter)
local Utils = require(RS.Source.Utils.Utils)
local Constants = require(RS.Source.Constants.Constants)
local Net = require(RS.Packages.Net)
local World = require(script.Parent.World)
local Rails= require(script.Parent.Rails)
local DataService = require(RS.Source.DataService.DataService)
local GameplayDataStoreService = require(RS.Source.DataService:WaitForChild('GameplayDataStoreService'))
local AuctionDataStoreService = require(RS.Source.DataService:WaitForChild('AuctionDataStoreService'))
local CoinDataStoreService = require(RS.Source.DataService:WaitForChild('CoinDataStoreService'))
local Card = require(RS.Source.Constants:WaitForChild("Card"))
local DBKeys = require(RS.Source.Constants.DatabaseKeys)
local Constants = require(RS.Source.Constants.Constants)
local TableUtil = require(RS.Packages.TableUtil)
local HttpService = game:GetService('HttpService')
local RunService = game:GetService("RunService")
local Mode = require(RS.Source.Constants.Mode)
local Signals = require(RS.Source.Utils:WaitForChild('Signals'))
local Trains = require(RS.Source:WaitForChild('Trains'))

local bidEvent = Net:RemoteEvent("Bid")
bidEvent.OnServerEvent:Connect(function(player, city, bidPrice)
	bidPrice = math.ceil(bidPrice) -- only integer is allowed, pretect from hacking
	local auction = AuctionDataStoreService:GetData(city)
	if not auction then return end
	local bidFee = Utils.calcBidFee(auction.BasePrice)
	local bidderBalance = CoinDataStoreService:SyncData(tostring(player.UserId))
	if bidderBalance >= bidPrice and os.time() <= auction.EndTime then
		AuctionDataStoreService:UpdateBid(city, player.UserId, bidPrice)
		Signals.IncrementCoin:Fire(player.UserId, -bidFee)
	end
end)

local setTollEvent = Net:RemoteEvent("SetToll")
setTollEvent.OnServerEvent:Connect(function(player, city, toll)
	local cityDict = TableUtil.Copy(GameplayDataStoreService:GetData('City'), true)
	if cityDict[city]['owner'] == player.UserId then
		cityDict[city]['toll'] = toll
		GameplayDataStoreService:SetData('City', cityDict)
	end
end)

local startAuctionEvent = Net:RemoteEvent("StartAuction")
startAuctionEvent.OnServerEvent:Connect(function(player, city, basePrice)
	local currentAuction = AuctionDataStoreService:GetData(city)
	print('currentauction', currentAuction, city)
	local cityDict = GameplayDataStoreService:GetData('City')
	if cityDict[city]['owner'] == player.UserId and (currentAuction == nil or currentAuction['Status'] == 'Close') then
		if AuctionDataStoreService:InsertActiveAuctionID(city) then
			AuctionDataStoreService:SetData(city, {
				['Bids']={},
				['StartTime']=os.time(),
				['EndTime']=os.time() + (Mode:IsDevelopment() and 60 or Constants.OneDay),
				['BasePrice']=basePrice,
				['Status']='Open',
				['Seller']=player.UserId,
			})
		end
	end
end)

local moveTrainEvent = Net:RemoteEvent("MoveTrain")
moveTrainEvent.OnServerEvent:Connect(function(player, part, cFrame, index)
	local world = World:GetWorld()
	if not world then return end

	local entityId = Trains:GetEntityId(player.UserId)
	if entityId then
		local trainComp = world:get(entityId, Components.Train)
		if not trainComp then return end

		local frames = trainComp.frames
		frames[index] = cFrame

		trainComp = trainComp:patch({
			frames = frames,
		})
		world:insert(entityId, trainComp)
	end
end)

local useBreakRailCardEvent = Net:RemoteEvent("UseBreakRailCard")
useBreakRailCardEvent.OnServerEvent:Connect(function(player)
	local world = World:GetWorld()

	local backpackData = DataService:GetData(player, DBKeys.Backpack)
	if backpackData[Card.DestroyRail] == nil or backpackData[Card.DestroyRail] <= 0 then return end

	for _, train, trainModel in world:query(Components.Train, Components.TrainModel) do
		if train.playerId == player.UserId then
			local head = trainModel.model.Train -- TODO: need to use train.frames
			if head then
				local body = head.Train
				if body then
					local tail = body.Train
					local bodyX, bodyZ = Utils.positionToCoordinate(body.Position.X, body.Position.Z)
					local tailX, tailZ = Utils.positionToCoordinate(tail.Position.X, tail.Position.Z)
					local x = tailX - (bodyX - tailX)
					local z = tailZ - (bodyZ - tailZ)
					local railSegmentId = Rails:FindComp(x, z)
					if railSegmentId then
						world:insert(
							railSegmentId,
							Components.DamagedRailSegment()
						)

						backpackData[Card.DestroyRail] = backpackData[Card.DestroyRail] - 1
						DataService:Edit(player, DBKeys.Backpack, backpackData)
					end
				end
			end
			break
		end
	end
end)

local buyCardEvent = Net:RemoteEvent("BuyCard")
buyCardEvent.OnServerEvent:Connect(function(player, cardName)
	local backpackData = DataService:GetData(player, DBKeys.Backpack)
	backpackData[cardName] = (backpackData[cardName] or 0) + 1
	DataService:Edit(player, DBKeys.Backpack, backpackData)
end)