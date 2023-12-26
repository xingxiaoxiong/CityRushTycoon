local DSS = game:GetService("DataStoreService")
local RS = game:GetService("ReplicatedStorage")
local Red = require(RS.Packages.Red)
local Utils = require(RS.Source.Utils.Utils)

local debug = false

local DataStoreService = {}
DataStoreService.__index = DataStoreService

function DataStoreService.new(name)
	local instance = {}
	instance.name = name
	instance.Net = Red.Server(name, { "DataUpdated", "Comm" })
	instance.cache = {}
	instance.store = DSS:GetDataStore(instance.name)
	instance.Net:On("Comm", function(_, action, ...)
		local args = {...}
		if action == "GetData" then
			local key = args[1]
			if not key then
				return instance.cache
			end
			return instance:GetData(key)
		end
	end)
	return setmetatable(instance, DataStoreService)
end

function DataStoreService:SetData(key, value)
	local success, data = pcall(function()
		return self.store:SetAsync(key, value)
	end)
	if success then
		if not debug then
			self:SyncData(key) -- Do compare and fire event in case of difference
		end
	else
		warn('DataStoreService:SetData ' .. data)
	end
end

function DataStoreService:RemoveData(key)
	local success, errorMessage = pcall(function()
		return self.store:RemoveAsync(key)
	end)
	if not success then
		warn('DataStoreService:RemoveData ' .. errorMessage)
	end
end

function DataStoreService:SyncData(key)
	local success, data = pcall(function()
		return self.store:GetAsync(key)
	end)
	if success then
		if not Utils.CompareTable(self.cache[key], data) then
			self.Net:FireAll('DataUpdated', key, data)
		end
		self.cache[key] = data
	else
		warn('DataStoreService:SyncData ' .. data)
	end
	return self.cache[key]
end

function DataStoreService:GetData(key)
	if not self.cache[key] then
		return self:SyncData(key)
	end
	return self.cache[key]
end

function DataStoreService:GetDataFromCache(key)
	return self.cache[key]
end

function DataStoreService:UpdateData(key, value)
	local success, data = pcall(function()
		return self.store:UpdateAsync(key, function(_)
			return value
		end)
	end)
	if success then
		if not debug then
			if not Utils.CompareTable(self.cache[key], data) then
				self.Net:FireAll('DataUpdated', key, data)
			end
			self.cache[key] = data
		end
	else
		warn('DataStoreService:UpdateData ' .. data)
	end
	return success
end

return DataStoreService
