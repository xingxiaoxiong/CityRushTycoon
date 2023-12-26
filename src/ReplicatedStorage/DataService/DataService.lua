-- SERVICES --
local RS = game:GetService("ReplicatedStorage")
local CS = game:GetService("CollectionService")
local Players = game:GetService("Players")
local DBKeys = require(RS.Source.Constants:WaitForChild('DatabaseKeys'))

-- MODULES --
local Profile_Service = require(script.Parent.ProfileService)
local Save_Structure = require(script.Parent.SaveStructure)

-- RESOURCES --
local Signal = require(RS.Packages.Signal)
local Red = require(RS.Packages.Red)

-- NET --
local Net = Red.Server("DataService", { "Changed", "DataUpdated", "Comm" })

-- MAIN --
local Service = {
	Changed = Signal.new(),
	Profiles = {},

	Initialized = false,
}

-- SETUP THE SERVICE --
local Profile_Store = Profile_Service.GetProfileStore(DBKeys:GetPlayerDSName(), Save_Structure)
-- // --

-- LISTEN TO DATA CHANGES --
Service.Changed:Connect(function(Player : Player, Player_data : {}, Data_Name : string)
	Net:FireAll("Changed", Player, Player_data[Data_Name], Data_Name)
end)
-- // --

-- AUXILIARY FUNCTIONS --
function isPlayerValid(Player : Player) : boolean
	if not Player then return false end
	if not Player:IsDescendantOf(Players) then return false end
	if not CS:HasTag(Player, "Data_Loaded") then return false end
	if Service.Profiles[Player.UserId] == nil or Service.Profiles[Player.UserId] == true then warn(Player.Name, "'s Profile was not initialized / found.") return false end

	return true
end

function errorWarning(Type : string, Message : string)
	warn("DataService -- [" .. Type .. "] Error: " .. Message)
end
-- // --

-- INIT THE PLAYER --
function Service:Init_Player(Player : Player)
	if Service.Profiles[Player.UserId] ~= nil then return end
	Service.Profiles[Player.UserId] = true

	-- MAKE A THREAD FOR EACH PLAYER
	task.spawn(function()
		local Start_Tick = tick()

		local Player_Profile = Profile_Store:LoadProfileAsync("Player_" .. Player.UserId)

		-- IF THE PROFILE COULD NOT BE LOADED --
		if Player_Profile == nil then
			Player:Kick("Data could not be loaded, try again shortly. If the issue persists, please contact the support!")
			return
		end
		-- // --

		-- PROFILE LOADED SUCCESSFULLY
		Player_Profile:AddUserId(Player.UserId)
		Player_Profile:Reconcile()

		-- PLAYER JOINED ANOTHER SESSTION
		Player_Profile:ListenToRelease(function()
			Service.Profiles[Player.UserId] = nil
			Player:Kick("Data has been loaded on another session, please rejoin. If the issue persists, please contact the support!")
		end)

		if Player:IsDescendantOf(Players) then -- In case the player left before getting to this stage, so we check to make sure.
			Service.Profiles[Player.UserId] = Player_Profile
		else -- If he left, we release his profile.
			Player_Profile:Release()
		end

		-- INIT CLIENT AFTER DATA LOADED --
		warn(Player, " | Data Service Loaded - Load Time: ", string.sub(tostring(tick() - Start_Tick), 1, 6), Player_Profile.Data) -- Comment this out if you don't need it, it's only visible to developers anyway
		CS:AddTag(Player, "Data_Loaded") -- This way you can check on both client and server if the player data has been loaded already, you can use attributes if prefered.
		Net:FireAll("Init", Player_Profile.Data, Player.UserId) -- Replicate the new player data to all players

		-- REPLICATE THE DATA OF PREVIOUS PLAYERS TO THE JOINING PLAYER
		task.spawn(function()
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr == Player then continue end
				if Service.Profiles[plr.UserId] == true or Service.Profiles[plr.UserId] == nil then continue end
				Net:Fire(Player, "Init", Service.Profiles[plr.UserId].Data, plr.UserId)
			end
		end)
	end)
end
-- // --

-- MAIN FUNCTIONS --
function Service:Add(Player : Player, DataName : string, Value : number)
	if not DataName or not Value then errorWarning("Add", "DataName or Value are nil.") return end
	if typeof(DataName) ~= 'string' then errorWarning("General", "DataName must be a STRING.") return end
	if typeof(Value) ~= 'number' then errorWarning("Add", "Value must be a NUMBER.") return end
	if not isPlayerValid(Player) then errorWarning("General", "Invalid Player.") return end

	local Player_Data = Service.Profiles[Player.UserId].Data
	if not Player_Data then errorWarning("General", "Player_Data is nil.") return end

	if not Player_Data[DataName] then errorWarning("General", "Invalid DataName.") return end
	if typeof(Player_Data[DataName]) ~= 'number' then errorWarning("Add", "PlayerData.DataName must be a NUMBER.") return end

	Player_Data[DataName] += Value
	Service.Changed:Fire(Player, Player_Data, DataName)

	return Player_Data[DataName]
end

function Service:Sub(Player : Player, DataName : string, Value : number)
	if not DataName or not Value then errorWarning("Sub", "DataName or Value are nil.") return end
	if typeof(DataName) ~= 'string' then errorWarning("General", "DataName must be a STRING.") return end
	if typeof(Value) ~= 'number' then errorWarning("Sub", "Value must be a NUMBER.") return end
	if not isPlayerValid(Player) then errorWarning("General", "Invalid Player.") return end

	local Player_Data = Service.Profiles[Player.UserId].Data
	if not Player_Data then errorWarning("General", "Player_Data is nil.") return end

	if not Player_Data[DataName] then errorWarning("General", "Invalid DataName.") return end
	if typeof(Player_Data[DataName]) ~= 'number' then errorWarning("Sub", "PlayerData.DataName must be a NUMBER.") return end

	Player_Data[DataName] -= Value
	Service.Changed:Fire(Player, Player_Data, DataName)

	return Player_Data[DataName]
end

function Service:Edit(Player : Player, DataName : string, Value : any)
	if not DataName or not Value then errorWarning("Edit", "DataName or Value are nil.") return end
	if typeof(DataName) ~= 'string' then errorWarning("General", "DataName must be a STRING.") return end
	if not isPlayerValid(Player) then errorWarning("General", "Invalid Player.") return end

	local Player_Data = Service.Profiles[Player.UserId].Data
	if not Player_Data then errorWarning("General", "Player_Data is nil.") return end

	if not Player_Data[DataName] then errorWarning("General", "Invalid DataName.") return end

	Player_Data[DataName] = Value
	Service.Changed:Fire(Player, Player_Data, DataName)

	return Player_Data[DataName]
end

function Service:Overwrite(Player : Player, DataName : string, Value : any)
	if not DataName or not Value then errorWarning("Edit", "DataName or Value are nil.") return end
	if typeof(DataName) ~= 'string' then errorWarning("General", "DataName must be a STRING.") return end
	if not isPlayerValid(Player) then errorWarning("General", "Invalid Player.") return end

	local Player_Data = Service.Profiles[Player.UserId].Data
	if not Player_Data then errorWarning("General", "Player_Data is nil.") return end

	Player_Data[DataName] = Value
	Service.Changed:Fire(Player, Player_Data, DataName)

	return Player_Data[DataName]
end

function Service:TableAdd(Player : Player, DataName : string, Value : string | number)
	if not DataName or not Value then errorWarning("TableAdd", "DataName or Value are nil.") return end
	if typeof(DataName) ~= 'string' then errorWarning("General", "DataName must be a STRING.") return end
	if typeof(Value) ~= 'string' and typeof(Value) ~= 'number' then errorWarning("TableAdd", "Value must be a STRING or a NUMBER.") return end
	if not isPlayerValid(Player) then errorWarning("General", "Invalid Player.") return end

	local Player_Data = Service.Profiles[Player.UserId].Data
	if not Player_Data then errorWarning("General", "Player_Data is nil.") return end

	if not Player_Data[DataName] then errorWarning("General", "Invalid DataName.") return end
	if typeof(Player_Data[DataName]) ~= 'table' then errorWarning("TableAdd", "PlayerData.DataName must be a TABLE.") return end

	table.insert(Player_Data[DataName], Value)
	Service.Changed:Fire(Player, Player_Data, DataName)

	return Player_Data[DataName]
end

function Service:TableRemove(Player : Player, DataName : string, Value : string | number)
	if not DataName or not Value then errorWarning("TableRemove", "DataName or Value are nil.") return end
	if typeof(DataName) ~= 'string' then errorWarning("General", "DataName must be a STRING.") return end
	if typeof(Value) ~= 'string' and typeof(Value) ~= 'number' then errorWarning("TableRemove", "Value must be a STRING or a NUMBER.") return end
	if not isPlayerValid(Player) then errorWarning("General", "Invalid Player.") return end

	local Player_Data = Service.Profiles[Player.UserId].Data
	if not Player_Data then errorWarning("General", "Player_Data is nil.") return end

	if not Player_Data[DataName] then errorWarning("General", "Invalid DataName.") return end
	if typeof(Player_Data[DataName]) ~= 'table' then errorWarning("TableRemove", "PlayerData.DataName must be a TABLE.") return end

	local Index = table.find(Player_Data[DataName], Value)
	if not Index then errorWarning("TableRemove", "VALUE was not found in the given DATANAME.") return end

	table.remove(Player_Data[DataName], Index)
	Service.Changed:Fire(Player, Player_Data, DataName)

	return Player_Data[DataName]
end

function Service:DictionaryAdd(Player : Player, DataName : string, Value : string | number | {}, Index : string | number)
	if not DataName or not Value or not Index then errorWarning("DictionaryAdd", "DataName, Index, or Value are nil.") return end
	if typeof(DataName) ~= 'string' then errorWarning("General", "DataName must be a STRING.") return end
	if typeof(Value) ~= 'string' and typeof(Value) ~= 'number' and typeof(Value) ~= 'table' then errorWarning("DictionaryAdd", "Value must be a STRING, a TABLE, or a NUMBER.") return end
	if typeof(Index) ~= 'string' and typeof(Index) ~= 'number' then errorWarning("DictionaryAdd", "Index must be a STRING, or a NUMBER.") return end
	if not isPlayerValid(Player) then errorWarning("General", "Invalid Player.") return end

	local Player_Data = Service.Profiles[Player.UserId].Data
	if not Player_Data then errorWarning("General", "Player_Data is nil.") return end

	if not Player_Data[DataName] then errorWarning("General", "Invalid DataName.") return end
	if typeof(Player_Data[DataName]) ~= 'table' then errorWarning("DictionaryAdd", "PlayerData.DataName must be a TABLE.") return end

	Player_Data[DataName][Index] = Value
	Service.Changed:Fire(Player, Player_Data, DataName)

	return Player_Data[DataName], Player_Data[DataName][Index]
end

function Service:DictionaryRemove(Player : Player, DataName : string, Index : string | number)
	if not DataName or not Index then errorWarning("DictionaryRemove", "DataName, or Index are nil.") return end
	if typeof(DataName) ~= 'string' then errorWarning("General", "DataName must be a STRING.") return end
	if typeof(Index) ~= 'string' and typeof(Index) ~= 'number' then errorWarning("DictionaryRemove", "Index must be a STRING, or a NUMBER.") return end
	if not isPlayerValid(Player) then errorWarning("General", "Invalid Player.") return end

	local Player_Data = Service.Profiles[Player.UserId].Data
	if not Player_Data then errorWarning("General", "Player_Data is nil.") return end

	if not Player_Data[DataName] then errorWarning("General", "Invalid DataName.") return end
	if typeof(Player_Data[DataName]) ~= 'table' then errorWarning("DictionaryRemove", "PlayerData.DataName must be a TABLE.") return end

	Player_Data[DataName][Index] = nil
	Service.Changed:Fire(Player, Player_Data, DataName)

	return Player_Data[DataName], Player_Data[DataName][Index]
end

function Service:GetData(Player : Player, DataName : string)
	if not DataName then errorWarning("GetData", "DataName is nil.") return end
	if typeof(DataName) ~= 'string' then errorWarning("General", "DataName must be a STRING.") return end
	if not isPlayerValid(Player) then errorWarning("General", "Invalid Player.") return end

	local Player_Data = Service.Profiles[Player.UserId].Data
	if not Player_Data then errorWarning("General", "Player_Data is nil.") return end
	if not Player_Data[DataName] then errorWarning("General", "Invalid DataName.") return end

	return Player_Data[DataName]
end

function Service:GetProfile(Player : Player)
	if not isPlayerValid(Player) then errorWarning("General", "Invalid Player.") return end

	local Player_Data = Service.Profiles[Player.UserId].Data
	if not Player_Data then errorWarning("General", "Player_Data is nil.") return end

	return Player_Data
end
-- // --

-- SERVICE INITIALIZATION --
function Service:Init()
	-- FETCH EXISTING PLAYERS, IF ANY --
	for _, Player : Player in ipairs(Players:GetPlayers()) do
		self:Init_Player(Player)
	end

	-- LISTEN FOR NEW PLAYERS --
	Players.PlayerAdded:Connect(function(Player : Player)
		self:Init_Player(Player)
	end)

	-- CLEAR REMOVING PLAYERS DATA --
	Players.PlayerRemoving:Connect(function(Player : Player)
		if self.Profiles[Player.UserId] == nil or self.Profiles[Player.UserId] == true then return end
		self.Profiles[Player.UserId]:Release()
	end)

	-- FINISH --
	Service.Initialized = true
end
-- // --

-- CLIENT ACCESS --
Net:On("Comm", function(Player : Player, Action : string, ...)
	local Args = {...}

	if Action == "GetProfile" then
		local Target : Player = Args[1]
		if not Target then return end

		return Service:GetProfile(Target)
	elseif Action == "GetData" then
		local Target : Player = Args[1]
		local DataName : string = Args[2]
		if not Target or not DataName then return end

		return Service:GetData(Target, DataName)
	end
end)
-- // --

return Service