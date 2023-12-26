-- SERVICES --
local RS = game:GetService("ReplicatedStorage")
local CS = game:GetService("CollectionService")
local Players = game:GetService("Players")

-- RESOURCES --
local Signal = require(RS.Packages.Signal)
local TableUtil = require(RS.Packages.TableUtil)
local Promise = require(RS.Packages.Promise)
local Red = require(RS.Packages.Red)

-- NET --
local Net = Red.Client("DataService")

local Controller = {
	Profiles = {},
	Changed = Signal.new(),
	ProfileAdded = Signal.new(),

	Initialized = false
}

function Controller:GetServerProfile(Player : Player)
	if not Controller.Profiles[Player.UserId] then
		Controller.Profiles[Player.UserId] = true

		local UserID = Player.UserId

		Net:Call("Comm", "GetProfile", Player):Then(function(Profile)
			if not Player or not Player:IsDescendantOf(Players) then Controller.Profiles[UserID] = nil return end
			Controller.Profiles[Player.UserId] = Profile
			Controller.ProfileAdded:Fire(Profile, Player.UserId)
		end):Catch(function()
			Controller.Profiles[Player.UserId] = nil
			warn("Error Fetching Profile for Player: ", Player)
		end)
	end
end

function Controller:WaitForProfile(Player : Player, Timeout : number?)
	if not Timeout then Timeout = 10 end

	if Controller.Profiles[Player.UserId] ~= nil and typeof(Controller.Profiles[Player.UserId]) == 'table' then
		return Controller.Profiles[Player.UserId]
	end

	local returnProfile = nil

	local signalEvent = Signal.new()
	local timeoutTask = task.delay(Timeout, function()
		signalEvent:Fire()
	end)

	local profileAdded = Controller.ProfileAdded:Connect(function(Profile : {}, UserID : number)
		if UserID ~= Player.UserId then return end
		returnProfile = Profile
		signalEvent:Fire()
	end)

	Controller:GetServerProfile(Player)

	signalEvent:Wait()
	signalEvent:Destroy()
	profileAdded:Disconnect()

	return returnProfile
end

function Controller:WaitForData(Player : Player, Data_Name : string, Timeout : number?)
	if not Timeout then Timeout = 10 end

	local Profile = Controller.Profiles[Player.UserId]
	if not Profile or typeof(Profile) ~= 'table' then
		Profile = Controller:WaitForProfile(Player, Timeout)
		if not Profile then warn(Player, " Profile could not be loaded!") return end
	end

	return Profile[Data_Name]
end

function Controller:GetProfile(Player : Player)
	if not Player then return end
	if Controller.Profiles[Player.UserId] == true then return end
	return Controller.Profiles[Player.UserId]
end

function Controller:GetData(Player : Player, Data_Name : string)
	if Controller.Profiles[Player.UserId] == nil then Controller:GetServerProfile(Player) warn("No profile for player: ", Player, Player.UserId, Controller.Profiles) return end
	if Controller.Profiles[Player.UserId] == true then return end

	return Controller.Profiles[Player.UserId][Data_Name]
end

function Controller:Init()

	Net:On("Init", function(Profile : {}, UserID : number)
		Controller.Profiles[UserID] = TableUtil.Copy(Profile, true)
		Controller.ProfileAdded:Fire(Controller.Profiles[UserID], UserID)
		print("[", UserID," Profile]: ", Controller.Profiles[UserID])
	end)

	Net:On("Changed", function(Player : Player, New_Value : any, Data_Name : string)
		if Controller.Profiles[Player.UserId] == nil then warn(Player, " has not been init in this client.") Controller:GetServerProfile(Player) return end
		if Controller.Profiles[Player.UserId] == true then return end
		if not Controller.Profiles[Player.UserId][Data_Name] then warn(Data_Name, " is not a valid client data.", Player) return end

		Controller.Profiles[Player.UserId][Data_Name] = New_Value

		if Player == Players.LocalPlayer then
			Controller.Changed:Fire(Controller.Profiles[Player.UserId], Data_Name)
		end

		print(Player, " | Data: ", Data_Name, " has been changed to: ", New_Value)
	end)

	Players.PlayerRemoving:Connect(function(Player : Player)
		if Controller.Profiles[Player.UserId] == nil then return end
		Controller.Profiles[Player.UserId] = nil
	end)

	Controller.Initialized = true
end

return Controller

