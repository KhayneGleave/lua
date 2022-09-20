--> Calculates X,Y,Z Positions independantly. May need tweaking to ensure it works with your projects.

local Teleportation, RunService = {}, game:GetService('RunService')
Teleportation.__index=Teleportation

function Teleportation.new(Player)

	local settings = require(script.Parent):GetGlobalGameData()
	local Flags, KillLoop = {}, false

	rawset(settings[tostring(Player)], 'CurrentPosition', Player.Character.PrimaryPart.CFrame)

	Player.Character.Humanoid.Died:Connect(function()

		KillLoop=true

	end);
	task.spawn(function()

		pcall(function()

			while RunService.Stepped:wait()do

				if not Player or KillLoop then break end;

				local CurrentPos=rawget(settings[tostring(Player)],'CurrentPosition');
				local Distance=(Player.Character.Humanoid.SeatPart~=nil and 90)or 25;
				
                if(((CurrentPos.X - Player.Character.PrimaryPart.CFrame.X >= Distance or CurrentPos.X - Player.Character.PrimaryPart.CFrame.X < 0 and CurrentPos.X - Player.Character.PrimaryPart.CFrame.X <= - Distance)) or ((CurrentPos.Z - Player.Character.PrimaryPart.CFrame.Z >= Distance or CurrentPos.Z - Player.Character.PrimaryPart.CFrame.Z<0 and CurrentPos.Z-Player.Character.PrimaryPart.CFrame.Z<=-Distance))or(CurrentPos.Y-Player.Character.PrimaryPart.CFrame.Y<-60 and Player.Character.PrimaryPart.CFrame.Y>CurrentPos.Y))and rawget(settings[tostring(Player)],'TeleportationDetection')then
					
                    if Distance==25 then

						Player.Character:SetPrimaryPartCFrame(CurrentPos);

					elseif Distance==90 then

						Player.Character.Humanoid.SeatPart.Parent:SetPrimaryPartCFrame(CurrentPos);

					end

					Flags[#Flags + 1] = true

					task.spawn(function()

						task.wait(.4)
						table.remove(Flags, #Flags)

					end)

				end

			end

		end)

	end)
	task.spawn(function()

		pcall(function()

			while task.wait(1)do

				if not Player or KillLoop then break end;

				if not rawget(Flags,1)then

					rawset(settings[tostring(Player)],'CurrentPosition',Player.Character.PrimaryPart.CFrame)

				end

			end

		end)

	end)

	return setmetatable({},Teleportation)

end

return Teleportation
