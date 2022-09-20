local settings, Players = {}, game:GetService('Players')
settings.__index = settings

function settings.new(Player)

	return setmetatable({PlayersLoaded = {}}, settings)

end;

Players.PlayerAdded:Connect(function(Player)

	settings.PlayersLoaded[tostring(Player)] = {

		TeleportationDetection = true,
		CurrentPosition        = nil,
		NoclipDetection        = true

	}

end)

function settings:GetGlobalGameData()

	return self.PlayersLoaded;
    
end

return settings;