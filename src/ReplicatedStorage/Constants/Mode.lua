local DBKeys = require(script.Parent.DatabaseKeys)

local Mode = {}

Mode.NoClick = 'NoClick';
Mode.Teleport = 'Teleport';

function Mode:IsDevelopment()
	return DBKeys.ENVIRONMENT == 'DEVELOPMENT'
end

return Mode
