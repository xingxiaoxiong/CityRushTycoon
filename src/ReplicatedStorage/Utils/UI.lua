local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local UI = {}

function UI:ShowBalanceUpdate(updateAmount)
	local updateAmountNumber = tonumber(updateAmount)
	local BalanceUpdatedUI = RS.Assets:WaitForChild('BalanceUpdated'):Clone()
	BalanceUpdatedUI.Position = UDim2.fromScale(0.1, 0.07)
	BalanceUpdatedUI.Text = updateAmountNumber and (updateAmountNumber > 0 and '+' .. tostring(updateAmountNumber) or tostring(updateAmountNumber)) or updateAmount
	BalanceUpdatedUI.TextColor3 = updateAmountNumber and (updateAmountNumber > 0 and Color3.fromHex('#FFFF00') or Color3.fromHex('#FF0000')) or Color3.fromHex('#FF0000')
	BalanceUpdatedUI.Parent = Players.LocalPlayer.PlayerGui:WaitForChild("EffectsGui")
	local life = 4
	game:GetService("Debris"):AddItem(BalanceUpdatedUI, life);
	task.spawn(function()
		game.TweenService:Create(BalanceUpdatedUI, TweenInfo.new(life, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.1, 0)
		}):Play();
		game.TweenService:Create(BalanceUpdatedUI, TweenInfo.new(life, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			TextTransparency = 1
		}):Play();
		game.TweenService:Create(BalanceUpdatedUI.UIStroke, TweenInfo.new(life, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Transparency = 1
		}):Play();
	end)
end

return UI