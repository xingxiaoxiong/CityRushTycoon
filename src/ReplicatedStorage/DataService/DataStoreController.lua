local RS = game:GetService("ReplicatedStorage")
local Red = require(RS.Packages.Red)

local Signal = require(RS.Packages.Signal)


local DataStoreController = {}
DataStoreController.__index = DataStoreController

function DataStoreController.new(name)
	local instance = {}
	instance.name = name
	instance.Net = Red.Client(name)
	instance.cache = {}
	instance.dataUpdated = Signal.new()
	instance.Net:On('DataUpdated', function(key, data)
		instance.cache[key] = data
		instance.dataUpdated:Fire(key, data)
	end)
	return setmetatable(instance, DataStoreController)
end

function DataStoreController:_fetch(key)
	self.Net:Call("Comm", "GetData", key):Then(function(data)
		self.cache[key] = data
		self.dataUpdated:Fire(key, data)
	end):Catch(function()
		warn("Error Fetching " .. key)
	end)
end

function DataStoreController:GetData(key)
	if not self.cache[key] then
		self:_fetch(key)
	end
	return self.cache[key]
end


return DataStoreController
