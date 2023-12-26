local RS = game:GetService("ReplicatedStorage")
local World = require(script.Parent.Parent.World)
local Components = require(RS.Source.Components)

local ContestEntity = {
	id = nil
}

function ContestEntity:Spawn()
	local world = World:GetWorld()
	self.id = world:spawn(
		Components.Contest({
			winner = nil,
			destination = nil,
			mode = 'Break',
			endContest = os.time() + 5,
			endBreak = nil,
			firstArrivalReward = 10,
		})
	)
	return self.id
end

function ContestEntity:GetId()
	return self.id
end

function ContestEntity:GetComponent()
	local world = World:GetWorld()
	return world:get(self.id, Components.Contest)
end

return ContestEntity
