local Constants = {}

Constants.GridSize = 5;
Constants.GroundLevel = 0.5;
Constants.SeaLevel = 3.5;

Constants.DirectionDelta = {
	{
		deltaX = 1,
		deltaZ = 0,
	},
	{
		deltaX = 0,
		deltaZ = 1,
	},{
		deltaX = -1,
		deltaZ = 0,
	},
	{
		deltaX = 0,
		deltaZ = -1,
	}
}

Constants.OneDay = 24 * 60 * 60;
Constants.OneHour = 60 * 60;
Constants.OneMinute = 60;

Constants.BuyCoin1ProductID = 1627339935;
Constants.BuyCoin2ProductID = 1627372595;

Constants.BuyCoinAmount = {
	[Constants.BuyCoin1ProductID] = 1000,
	[Constants.BuyCoin2ProductID] = 10000,
}

Constants.BuyCoinProductID = {
	[1000] = Constants.BuyCoin1ProductID,
	[10000] = Constants.BuyCoin2ProductID,
}

return Constants
