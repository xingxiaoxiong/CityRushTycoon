local DatabaseKeys = {
	ENVIRONMENT = "DEVELOPMENT",
}

DatabaseKeys.Coin = 'Coin';
DatabaseKeys.ArriveReward = 'ArriveReward';
DatabaseKeys.CoinValue = 'CoinValue';
DatabaseKeys.BreakTime = 'BreakTime';
DatabaseKeys.ContestTime = 'ContestTime';
DatabaseKeys.CoinCount = 'CoinCount';
DatabaseKeys.Backpack = 'Backpack';
DatabaseKeys.StartCity = 'StartCity';
DatabaseKeys.AuctionDSNames = {
	PRODUCTION = "Auction",
    DEVELOPMENT = "AuctionDev"
}
DatabaseKeys.PlayerDSNames = {
	PRODUCTION = "Player",
    DEVELOPMENT = "PlayerDev"
}
DatabaseKeys.GameplayDSNames = {
	PRODUCTION = "Gameplay",
    DEVELOPMENT = "GameplayDev"
}
DatabaseKeys.CoinDSNames = {
	PRODUCTION = "Coin",
    DEVELOPMENT = "CoinDev"
}
DatabaseKeys.MessageMSNames = {
	PRODUCTION = "Message",
    DEVELOPMENT = "MessageDev"
}
DatabaseKeys.ActiveAuctions = 'ActiveAuctions';
DatabaseKeys.Auction = 'Auction'; -- used by MessageMemoryStore

function DatabaseKeys:GetPlayerDSName()
	return self.PlayerDSNames[self.ENVIRONMENT]
end

function DatabaseKeys:GetAuctionDSName()
	return self.AuctionDSNames[self.ENVIRONMENT]
end

function DatabaseKeys:GetGameplayDSName()
	return self.GameplayDSNames[self.ENVIRONMENT]
end

function DatabaseKeys:GetCoinDSName()
	return self.CoinDSNames[self.ENVIRONMENT]
end

function DatabaseKeys:GetMessageMSName()
	return self.MessageMSNames[self.ENVIRONMENT]
end

return DatabaseKeys