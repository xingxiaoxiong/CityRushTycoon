local RS = game:GetService('ReplicatedStorage')
local Constants = require(RS.Source.Constants.Constants)
local Components = require(RS.Source.Components)
local HttpService = game:GetService('HttpService')


local Utils = {}

function Utils.coordinateToPosition(x, z)
	return x * Constants.GridSize, z * Constants.GridSize
end

function Utils.positionToCoordinate(x, z)
	return math.ceil(x / Constants.GridSize), math.ceil(z / Constants.GridSize)
end

function Utils.generateRailsKey(x, y)
	return x .. ',' .. y
end

function Utils.getRails(world)
	local rails = nil
	for _, railsComp in world:query(Components.Rail) do
		rails = railsComp.rails
	end
	return rails
end

function Utils.isValidRail(rails, coordX, coordZ)
	return rails[Utils.generateRailsKey(coordX, coordZ)] ~= nil
end

function Utils.normalized(x)
	if x > 0 then
		return 1
	elseif x < 0 then
		return -1
	else
		return 0
	end
end

function Utils.numberToReadableString(number)
	if number > 1000000 then
		return number / 1000000 .. 'M'
	elseif number > 1000 then
		return number / 1000 .. 'K'
	else
		return number
	end
end

function Utils.timeLeftString(endTime)
	local diff = endTime - os.time()
	if diff <= 0 then
		return 'Ended'
	elseif diff > 86400 then
		return math.floor(diff / 86400) .. 'd'
	elseif diff > 3600 then
		return math.floor(diff / 3600) .. 'h'
	elseif diff > 60 then
		return math.floor(diff / 60) .. 'm'
	else
		return 'a minute'
	end
end

function Utils.CompareTable(tb1, tb2)
	return HttpService:JSONEncode(tb1) == HttpService:JSONEncode(tb2)
end

function Utils.calcBidFee(basePrice)
	return math.ceil(basePrice * 0.01)
end

return Utils