
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RoactRodux = require(RS.Libs.RoactRodux)
local Roact = require(RS.Libs.Roact)
local e = Roact.createElement
local toggleMessageBox = require(script.Parent.Parent.Actions:WaitForChild('toggleMessageBox'))
local toggleBackpack = require(script.Parent.Parent.Actions:WaitForChild('toggleBackpack'))
local toggleAuction = require(script.Parent.Parent.Actions:WaitForChild('toggleAuction'))
local CityConfig = require(RS.Source.Configs:WaitForChild('CityConfig'))
local UIScheme = require(RS.Source.Constants.UIScheme)


local function Right(props)
	local activeAuctionCount = 0;
	local currentTime = os.time()
	if props.auction then
		for _, auction in props.auction do
			if currentTime <= auction['EndTime'] then
				activeAuctionCount = activeAuctionCount + 1
			end
		end
	end

	local ownedCityCount = 0;
	if props.toll then
		for _, city in props.toll do
			if city['owner'] == Players.LocalPlayer.UserId then
				ownedCityCount = ownedCityCount + 1
			end
		end
	end

	local messageCount = 0;
	if props.messages then
		messageCount = #props.messages
	end

	local children = {}
	children[1] = e("ImageButton", {
		BackgroundColor3 = UIScheme.White,
		Size = UDim2.new(0.2, 0, 0.3, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		Image = 'rbxassetid://14490300229',
		[Roact.Event.Activated] = function()
			props.toggleMessageBox()
		end,
	}, {
		e('UICorner', {
			CornerRadius = UDim.new(1, 0),
		}),
		e('UIStroke', {
			Color = UIScheme.White,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Thickness = 4,
		}),
		e('UIAspectRatioConstraint', {
			AspectRatio = 1,
			AspectType = Enum.AspectType.ScaleWithParentSize,
			DominantAxis = Enum.DominantAxis.Height,
		}),
		messageCount > 0 and e("TextLabel", {
			Font = UIScheme.Font,
			Size = UDim2.new(0.4, 0, 0.4, 0),
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1.2, 0, -0.05, 0),
			BackgroundColor3 = UIScheme.Dark,
			TextColor3 = UIScheme.White,
			Text = messageCount,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextScaled = true,
		}, {
			e('UIAspectRatioConstraint', {
				AspectRatio = 1,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Height,
			}),
			e('UICorner', {
				CornerRadius = UDim.new(0.5, 0),
			}),
			e('UIStroke', {
				Color = UIScheme.White,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = 2,
			}),
		}),
	})
	children[2] = e("ImageButton", {
		BackgroundColor3 = UIScheme.White,
		Size = UDim2.new(0.2, 0, 0.3, 0),
		Position = UDim2.new(0.5, 0, 0.4, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		Image = 'rbxassetid://14490463727',
		[Roact.Event.Activated] = function()
			props.toggleBackpack()
		end,
	}, {
		e('UICorner', {
			CornerRadius = UDim.new(1, 0),
		}),
		e('UIStroke', {
			Color = UIScheme.White,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Thickness = 4,
		}),
		e('UIAspectRatioConstraint', {
			AspectRatio = 1,
			AspectType = Enum.AspectType.ScaleWithParentSize,
			DominantAxis = Enum.DominantAxis.Height,
		}),
		ownedCityCount > 0 and e("TextLabel", {
			Font = UIScheme.Font,
			Size = UDim2.new(0.4, 0, 0.4, 0),
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1.2, 0, -0.05, 0),
			BackgroundColor3 = UIScheme.Purple,
			TextColor3 = UIScheme.White,
			Text = ownedCityCount,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextScaled = true,
		}, {
			e('UIAspectRatioConstraint', {
				AspectRatio = 1,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Height,
			}),
			e('UICorner', {
				CornerRadius = UDim.new(0.5, 0),
			}),
			e('UIStroke', {
				Color = UIScheme.White,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = 2,
			}),
		}),
	})
	children[3] = e("ImageButton", {
		BackgroundColor3 = UIScheme.White,
		Size = UDim2.new(0.2, 0, 0.3, 0),
		Position = UDim2.new(0.5, 0, 0.8, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		Image = 'rbxassetid://14490463092',
		[Roact.Event.Activated] = function()
			props.toggleAuction()
		end,
	}, {
		e('UICorner', {
			CornerRadius = UDim.new(1, 0),
		}),
		e('UIStroke', {
			Color = UIScheme.White,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Thickness = 4,
		}),
		e('UIAspectRatioConstraint', {
			AspectRatio = 1,
			AspectType = Enum.AspectType.ScaleWithParentSize,
			DominantAxis = Enum.DominantAxis.Height,
		}),
		activeAuctionCount > 0 and e("TextLabel", {
			Font = UIScheme.Font,
			Size = UDim2.new(0.4, 0, 0.4, 0),
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1.2, 0, -0.05, 0),
			BackgroundColor3 = UIScheme.Red,
			TextColor3 = UIScheme.White,
			Text = activeAuctionCount,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextScaled = true,
		}, {
			e('UIAspectRatioConstraint', {
				AspectRatio = 1,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Height,
			}),
			e('UICorner', {
				CornerRadius = UDim.new(0.5, 0),
			}),
			e('UIStroke', {
				Color = UIScheme.White,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = 2,
			}),
		}),
	})

	return Roact.createElement("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(0.1, 0, 0.3, 0),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(0.95, 0, 0.4, 0),
		BackgroundTransparency = 1,
	}, children)
end

Right = RoactRodux.connect(
    function(state, props)
        return state
    end,
    function(dispatch)
        return {
			toggleMessageBox = function()
				return dispatch(toggleMessageBox())
			end,
			toggleBackpack = function()
				return dispatch(toggleBackpack())
			end,
			toggleAuction = function()
				return dispatch(toggleAuction())
			end,
        }
    end
)(Right)

return Right
