local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Components = require(RS.Source.Components)
local Matter = require(RS.Packages.matter)
local Utils = require(RS.Source.Utils.Utils)
local Constants = require(RS.Source.Constants.Constants)
local CityConfigs = require(RS.Source.Configs.CityConfig)
local UIS = game:GetService("UserInputService")
local Net = require(RS.Packages.Net)
local Cities = require(RS.Source:WaitForChild("Cities"))
local GUI = require(script.Parent.Parent:WaitForChild("GUI"))
local updateDestination = require(script.Parent.Parent.GUI.Actions:WaitForChild("updateDestination"))
local updateMode = require(script.Parent.Parent.GUI.Actions:WaitForChild("updateMode"))
local updateTime = require(script.Parent.Parent.GUI.Actions:WaitForChild("updateTime"))
local updateGameState = require(script.Parent.Parent.GUI.Actions:WaitForChild("updateGameState"))

local player = Players.LocalPlayer


local function syncContest(world)
	local store = GUI:GetStore()
	for _, contestComp in world:query(Components.Contest) do
		if contestComp.mode == 'Contest' then
			if contestComp.destination then
				local cityName = CityConfigs[contestComp.destination].Name
				store:dispatch(updateDestination(cityName .. '\t' .. tostring(math.ceil(contestComp.endContest - os.time()))))
				store:dispatch(updateGameState({
					totalNumberOfPlayers = contestComp.totalNumberOfPlayers,
					numberOfArrivedPlayers = contestComp.numberOfArrivedPlayers,
					lastArrivedPlayer = contestComp.lastArrivedPlayer,
					firstArrivalReward = contestComp.firstArrivalReward,
				}))
			end
		elseif contestComp.mode == 'Break' then
			store:dispatch(updateDestination(tostring(math.ceil(contestComp.endBreak - os.time()))))
		end
		store:dispatch(updateMode(contestComp.mode))
	end
end

return syncContest
