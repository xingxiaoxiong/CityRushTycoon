local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Components = require(RS.Source.Components)
local Matter = require(RS.Packages.matter)
local Utils = require(RS.Source.Utils.Utils)
local Constants = require(RS.Source.Constants.Constants)
local ContestEntity = require(script.Parent.Parent.Entities:WaitForChild('ContestEntity'))
local CityConfig = require(RS.Source.Configs.CityConfig)
local TableUtil = require(RS.Packages.TableUtil)
local Cities = require(RS.Source:WaitForChild('Cities'))
local DataService = require(RS.Source.DataService.DataService)
local GameplayDataStoreService = require(RS.Source.DataService:WaitForChild('GameplayDataStoreService'))
local DBKeys = require(RS.Source.Constants.DatabaseKeys)
local GameplayDataStoreService = require(RS.Source.DataService:WaitForChild('GameplayDataStoreService'))
local Signals = require(RS.Source.Utils:WaitForChild('Signals'))
local Mode = require(RS.Source.Constants.Mode)

local arrivedPlayers = {}

local function _numberOfArrivedPlayers()
	return #TableUtil.Keys(arrivedPlayers)
end

local function _checkOverlap(world, coord)
	local initialReward = GameplayDataStoreService:GetDataFromCache(DBKeys.ArriveReward) or 10
	for _, train, trainModel in world:query(Components.Train, Components.TrainModel) do
		local headPos = train.frames[1].Position
		local coordX, coordZ = Utils.positionToCoordinate(headPos.X, headPos.Z)
		if coordX == coord.X and coordZ == coord.Z then
			if not arrivedPlayers[train.playerId] then
				arrivedPlayers[train.playerId] = os.time()
				local reward = math.ceil(initialReward / _numberOfArrivedPlayers())
				Signals.IncrementCoin:Fire(train.playerId, reward)
			end
		end
	end
end

local function _lastArrivedPlayer()
	local sortedResult = {}
	for k, v in pairs(arrivedPlayers) do
		table.insert(sortedResult, {k, v})
	end

	table.sort(sortedResult, function(a,b)
		return a[2] > b[2]
	end)

	return #sortedResult > 0 and sortedResult[1][1] or Matter.None
end

local function _summarizeResult()
	local sortedResult = {}
	for k, v in pairs(arrivedPlayers) do
		table.insert(sortedResult, {k, v})
	end

	table.sort(sortedResult, function(a,b)
		return a[2] > b[2]
	end)

	-- WON't use this logic anymore
	-- for i, result in ipairs(sortedResult) do
	-- 	if i == #sortedResult and i ~= 1 then
	-- 		DataService:Sub(Players:GetPlayerByUserId(result[1]), DBKeys.Coin, 10)
	-- 	else
	-- 		DataService:Add(Players:GetPlayerByUserId(result[1]), DBKeys.Coin, 10)
	-- 	end
	-- end
	arrivedPlayers = {}
end

local function _setDestination(world, contestComp)
	local cities = TableUtil.Keys(CityConfig)
	local shuffled = TableUtil.Shuffle(cities)
	local destination = shuffled[1]
	if Mode:IsDevelopment() then
		destination = '43'
	end
	contestComp = contestComp:patch({
		destination = destination
	})
	world:insert(ContestEntity:GetId(), contestComp)
end

local function checkContestWinner(world)
	local contestComp = ContestEntity:GetComponent()
	if not contestComp then return end

	if contestComp.mode == 'Contest' then
		if os.time() >= contestComp.endContest then
			_summarizeResult()
			contestComp = contestComp:patch({
				mode = 'Break',
				endBreak = os.time() + (GameplayDataStoreService:GetDataFromCache(DBKeys.BreakTime) or 15),
			})
			world:insert(ContestEntity:GetId(), contestComp)
		end

		if contestComp.destination then
			contestComp = contestComp:patch({
				totalNumberOfPlayers = #game.Players:GetPlayers(),
				numberOfArrivedPlayers = _numberOfArrivedPlayers(),
				lastArrivedPlayer = _lastArrivedPlayer(),
				firstArrivalReward = GameplayDataStoreService:GetDataFromCache(DBKeys.ArriveReward) or 10,
			})
			world:insert(ContestEntity:GetId(), contestComp)
			local coord = Cities:GetCityPosition(contestComp.destination)
			_checkOverlap(world, coord)
		end
	elseif contestComp.mode == 'Break' then
		if contestComp.endBreak == nil then -- just in case
			contestComp = contestComp:patch({
				endBreak = os.time() + (GameplayDataStoreService:GetDataFromCache(DBKeys.BreakTime) or 15),
			})
			world:insert(ContestEntity:GetId(), contestComp)
		end
		if os.time() >= contestComp.endBreak then
			contestComp = contestComp:patch({
				mode = 'Contest',
				endContest = os.time() + (GameplayDataStoreService:GetDataFromCache(DBKeys.ContestTime) or 20),
			})
			_setDestination(world, contestComp)
		end
	end

end

return checkContestWinner
