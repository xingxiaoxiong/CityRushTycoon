
local RS = game:GetService("ReplicatedStorage")
local GameplayDataStoreController = require(RS.Source.DataService:WaitForChild('GameplayDataStoreController'))
local Players = game:GetService("Players")
local CityConfig = require(RS.Source.Configs.CityConfig)
local tiledFolder = workspace:WaitForChild("Tiled")
local cityFolder = tiledFolder:WaitForChild("City")
local Net = require(RS.Packages:WaitForChild('Net'))


GameplayDataStoreController.dataUpdated:Connect(function(key, value)
	if key == 'City' then
		local cityDict = value
		if cityDict then
			for _, cityPart in pairs(cityFolder:GetChildren()) do
				local cityData = cityDict[cityPart.Name]
				if cityData then
					if cityData['toll'] and cityData['owner'] ~= Players.LocalPlayer.UserId then
						local cityNameLabel = cityPart:FindFirstChild('CityNameLabel', true)
						if cityNameLabel then
							cityNameLabel.Text = CityConfig[cityPart.Name].Name .. '\n' .. '<font color="rgb(255,255,0)">Toll ' .. cityData['toll'] .. '</font>'
						end
					end
					if cityData['owner'] then
						local playerImage = Players:GetUserThumbnailAsync(cityData['owner'], Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100);
						local decal = cityPart:FindFirstChild('decal')
						if decal == nil then
							decal = Instance.new('Decal')
						end
						decal.Texture = playerImage
						decal.Face = Enum.NormalId.Top
						decal.Parent = cityPart
					end
				end
			end
		end
	end
end)

local playSoundEvent = Net:RemoteEvent('PlaySound')
playSoundEvent.OnClientEvent:Connect(function(sound)
	if sound then
		sound:Play()
	end
end)