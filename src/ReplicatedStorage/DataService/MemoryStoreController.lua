local RS = game:GetService("ReplicatedStorage")
local Red = require(RS.Packages.Red)

local Signal = require(RS.Packages.Signal)


local MemoryStoreController = {}
MemoryStoreController.__index = MemoryStoreController

function MemoryStoreController.new(name)
	local instance = {}
	instance.name = name
	instance.Net = Red.Client(name)
	instance.dataUpdated = Signal.new()
	instance.Net:On('DataUpdated', function(data)
		instance.cache = data
		instance.dataUpdated:Fire(data)
	end)
	return setmetatable(instance, MemoryStoreController)
end

function MemoryStoreController:_fetch()
	self.Net:Call("Comm", "GetData"):Then(function(data)
		self.cache = data
		self.dataUpdated:Fire(data)
	end):Catch(function()
		warn("Error Fetching data")
	end)
end

function MemoryStoreController:GetData()
	if self.cache == nil then
		self:_fetch()
	end
	return self.cache
end


return MemoryStoreController
