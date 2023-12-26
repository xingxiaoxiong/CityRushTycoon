local MSS = game:GetService("MemoryStoreService")
local RS = game:GetService("ReplicatedStorage")
local Red = require(RS.Packages.Red)
local Utils = require(RS.Source.Utils.Utils)


local MemoryStoreService = {}
MemoryStoreService.__index = MemoryStoreService

function MemoryStoreService.new(name)
	local instance = {}
	instance.name = name
	instance.Net = Red.Server(name, { "DataUpdated", "Comm" })
	instance.cache = {}
	instance.store = MSS:GetSortedMap(instance.name)
	instance.Net:On("Comm", function(_, action)
		if action == "GetData" then
			return instance.cache
		end
	end)
	return setmetatable(instance, MemoryStoreService)
end

function MemoryStoreService:SetData(key, value)
	local success, errorMessage = pcall(function()
		return self.store:SetAsync(key, value, 3000000)
	end)
	if not success then
		warn('MemoryStoreService:SetData ' .. errorMessage)
	end
end

function MemoryStoreService:RemoveData(key)
	local success, errorMessage = pcall(function()
		return self.store:RemoveAsync(key)
	end)
	if not success then
		warn('MemoryStoreService:RemoveData ' .. errorMessage)
	end
end

function MemoryStoreService:SyncData(key)
	local success, data = pcall(function()
		return self.store:GetAsync(key)
	end)
	if success then
		self.cache[key] = data
		self.Net:FireAll('DataUpdated', self.cache)
	else
		warn('MemoryStoreService:SyncData ' .. data)
	end
	return self.cache[key]
end

function MemoryStoreService:SyncAllData()
	local success, data = pcall(function()
		return self.store:GetRangeAsync(Enum.SortDirection.Ascending, 200)
	end)
	if success then
		for _, item in ipairs(data) do
			self.cache[item.key] = item.value
		end
		self.Net:FireAll('DataUpdated', self.cache) -- Since SyncAllData is called every half an hour, we can fire DataUpdated directly
	else
		warn('MemoryStoreService:SyncAllData ' .. data)
	end

	return self.cache
end

function MemoryStoreService:GetAllData()
	if self.cache == nil then
		return self:SyncAllData()
	end
	return self.cache
end

return MemoryStoreService