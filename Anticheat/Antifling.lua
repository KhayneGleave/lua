local AntiFling, RunService = {}, game:GetService('RunService')
AntiFling.__index = AntiFling

function AntiFling.new(Player)

	local Character = Player.Character
	local Humanoid = Character.Humanoid
	local KillLoop = false

	Character.Humanoid.Died:Connect(function()

		KillLoop=true --> Ends Connection

	end)

	task.spawn(function()

		while RunService.Stepped:wait()do

			if not Player or KillLoop then break end

			if Character.PrimaryPart.RotVelocity.Y >= 90 then --> If player rotates too quickly then they die. Tested on max mouse sensivity with no false flags.

				Character:BreakJoints() --> Kills Player.

			end

		end

	end)

	return setmetatable({}, AntiFling)

end

return AntiFling
