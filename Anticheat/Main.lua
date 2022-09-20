local API, Players, Modules, RunService = game:GetService('Players'), script:GetDescendants(), game:GetService('RunService')

for i = 1, #Modules do

	API[tostring(Modules[i])] = require(Modules[i]) --> API Dictionary Stores all subclass modules.

end

Players.PlayerAdded:Connect(function(Player)

	Player.CharacterAdded:Connect(function(Character)

		repeat RunService.Stepped:wait()until Character:FindFirstChild('HumanoidRootPart')

		for _, Module in next, API do

			Module.new(Player);

		end

	end)

end)