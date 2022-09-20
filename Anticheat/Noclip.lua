--> Supports R6, R15

local Noclip, Players, RunService = {}, game:GetService('Players'), game:GetService('RunService')

Noclip.__index=Noclip

function Noclip.new(Player)

	local Character, KillLoop = Player.Character, false

	Player.Character.Humanoid.Died:Connect(function()

		KillLoop = true

	end)

	local settings = require(script.Parent):GetGlobalGameData() -->Reference to Settings Module.

	task.spawn(function()

		pcall(function()

			while RunService.Stepped:wait()do 

				if not Player or KillLoop then break end

				local RigType = Player.Character.Humanoid.RigType
				local CharacterPart = (RigType == Enum.HumanoidRigType.R15 and Player.Character.PrimaryPart) or Player.Character.Head
				local LastVec=CharacterPart.Position

				task.wait()

				local RY = Ray.new(LastVec, CharacterPart.Position - LastVec)
				local Hit, Position=workspace:FindPartOnRayWithIgnoreList(RY, {Character})

				if Player.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Swimming and rawget(settings[tostring(Player)],'NoclipDetection') and Hit and Character.Humanoid.SeatPart == nil and CharacterPart:CanCollideWith(Hit) and Character:IsDescendantOf(workspace) and not Players:GetPlayerFromCharacter(Hit.Parent) and not Players:GetPlayerFromCharacter(Hit.Parent.Parent) then
					
                    Player.Character:SetPrimaryPartCFrame(rawget(settings[tostring(Player)], 'CurrentPosition'))

				end

			end

		end)

	end)

	return setmetatable({}, Noclip)
end

return Noclip
