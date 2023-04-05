local RepStore,RunService,UIS,Players,Lighting,ScriptContext,PerformanceStats,TeleportService,HttpService,MarketplaceService,VirtualUser,VirtualInputManager,CoreGui=game:GetService'ReplicatedStorage',game:GetService'RunService',game:GetService'UserInputService',game:GetService'Players',game:GetService'Lighting',game:GetService'ScriptContext',game:GetService'Stats'.PerformanceStats,game:GetService'TeleportService',game:GetService'HttpService',game:GetService'MarketplaceService',game:GetService'VirtualUser',game:GetService'VirtualInputManager',game.CoreGui;
local LP,StarterGui=Players.LocalPlayer,game.StarterGui;
local PlayerUI,Config=LP.PlayerGui
local C_R,C_C,R_Module,hook_func,fwait,tdelay,lstring,Mouse,Stepped,cframe,vector3,wrkspc,gs,tstring,xp_call,p_call,instance,Heartbeat,Character,MFloor,gc,setthreadidentity,Camera=coroutine.resume,coroutine.create,require,hookfunction,task.wait,task.delay,loadstring,LP:GetMouse(),RunService.Stepped,CFrame,Vector3,workspace,getsenv,tostring,xpcall,pcall,Instance,RunService.Heartbeat,LP.Character,math.floor,getconnections,set_thread_identity or setidentity or setthreadcontext or syn.set_thread_identity,workspace.CurrentCamera;
local Intellect,Intellect_Loaded={},false;
local Args={...};
local ConfigName,ConfigType=Args[1]:split('.')[1],Args[1]:split('.')[2];

setmetatable(Intellect,{
    __index=function(_,Index)
        Intellect[Index]={};
        return Intellect[Index];
    end;
});

--> Game Modules
getgenv().TS=require(RepStore.TS)();
TS.Timer:UnbindFromStep'CharacterAnimate';

getgenv().GUISettings={Rounds={Borders=false},Enemies={HitboxSize=2,HitboxExtender=false,HitboxVisibility=false,Radar=false,ESP=false,},Settings={ToggleUIKey='RightShift',AutoSaveConfiguration=false},Character={AntiAim=false,Noclip=false,InfiniteJump=false,CurrentWalkSpeed=24,SprintSpeed=14,JumpPower=36},Gore={GibEnabled=false,BloodEnabled=false},Weapons={NoSpread=false,KillAll=false,KnifeAura=false,RequireKnife=false,NoRecoil=false,AllWeaponsAuto=false,InfiniteAmmo=false,NoBulletDrop=false,RapidAim=false,RapidFire=false,Aimbot={TriggerBot=false},SilentAim={Enabled=false,Type='Distance',AimPart='Head'}}}
getgenv().Connections={};


-->Load Settings
if not isfolder(ConfigName)then
    makefolder(ConfigName);
    makefolder(ConfigName..'/Settings');
end;
local File=ConfigName..'/Settings/'..ConfigName..'Settings.'..ConfigType;
if not p_call(function()readfile(File)end)then
    writefile(File,HttpService:JSONEncode(GUISettings));
end;
GUISettings=HttpService:JSONDecode(readfile(File));

Intellect.GameVersion=MarketplaceService:GetProductInfo(game.PlaceId).Name:split(' ')[5];
Intellect.Weapons.OldBulletDrop={};


--> Renames Modules
local RepStoreChildren=RepStore:GetChildren();
for i=1,#RepStoreChildren do
    local Module=RepStoreChildren[i];
    if Module.Name==' 'and#Module:GetChildren()>3 then 
        Module.Name='Modules';
    end;
end;


Connections['Infinite-Jump']=UIS.InputBegan:Connect(function(Key,Processed)
    if Key.KeyCode==Enum.KeyCode.Space and not Processed and TS.Characters:GetCharacter(LP)then
        local Character=TS.Characters:GetCharacter(LP);
        if Debounce then return end;
        if GUISettings.Character.InfiniteJump then
            Debounce=true;
            repeat task.wait()Character.Root.Velocity=Vector3.new(Character.Root.Velocity.X,GUISettings.Character.JumpPower,Character.Root.Velocity.Z);until not UIS:IsKeyDown(Enum.KeyCode.Space)
            Debounce=false;
        end;
    end;
end);

local gc=getgc();
for i=1,#gc do
    if type(gc[i])=='function'and getinfo(gc[i]).name=='WalkingForward'then
        Intellect.Character.WalkFunction=gc[i];
    end;
end;

local Modules=RepStore.Modules:GetChildren();
for i=1,#Modules do 
    local ModuleScript=Modules[i];
    local Module=require(ModuleScript);
    if Module.CastGeometryAndEnemies then ModuleScript.Name='Raycast'end;
    if Module.FireAll then ModuleScript.Name='Network'end;
    if Module.Lerper then ModuleScript.Name='Math'end;
    if Module.Modal then ModuleScript.Name='Input'end;
    if Module.Schedule then ModuleScript.Name='Timer'end;
    if Module.GetTeams then ModuleScript.Name='Teams'end;
    if Module.DamageCharacter then ModuleScript.Name='Damage'end;
    if Module.LoadCharacter then ModuleScript.Name='Characters'end;
    if Module.Recoil then ModuleScript.Name='Camera'end;
    if Module.AddProjectile then ModuleScript.Name='Projectiles'end;
    if Module.Effect then ModuleScript.Name='Effects'end;
    if Module.Sounds then ModuleScript.Name='UI'end;
    if Module.CurrentWeapon then ModuleScript.Name='Menu'end;
    if Module.MaxLevel then ModuleScript.Name='Levels'end;
    if Module.MoveInput then ModuleScript.Name='Mobile'end;
    if Module.Paint then ModuleScript.Name='Skins'end;
    if Module.GivePlayerLoadout then ModuleScript.Name='Items'end;
    if Module.Attach then ModuleScript.Name='Charms'end;
    if Module.GetFrame then ModuleScript.Name='Profiles'end;
    if Module.Apply then ModuleScript.Name='Stickers'end;
    if Module.Stages then ModuleScript.Name='Skybox?'end;
    if Module.EquipArms then ModuleScript.Name='Clothing'end;
    if Module.NameDisplayMode then ModuleScript.Name='Players'end;
end;
lstring([[
hookfunction(getrenv().PluginManager,function()
    return nil;
end);]])();
getconnections(workspace.Geometry.DescendantRemoving)[1]:Disable();

task.delay(2,function()
    lstring([[
    local Args={...};
    local Intellect,TS,GUISettings=Args[1],Args[2],Args[3];
    Intellect.UI.Loaded=true;
    repeat task.wait()
        if TS.Characters:GetCharacter(game.Players.LocalPlayer)and TS.Characters:GetCharacter(game.Players.LocalPlayer):FindFirstChild'Root'then
            local Character=TS.Characters:GetCharacter(game.Players.LocalPlayer)
            local WalkSpeed=Character.Root.CFrame.lookVector;
            local walkSpeedPower=0;
            if game:GetService'UserInputService':IsKeyDown(Enum.KeyCode.LeftShift)then
                walkSpeedPower=GUISettings.Character.CurrentWalkSpeed+GUISettings.Character.SprintSpeed;
            else
                walkSpeedPower=GUISettings.Character.CurrentWalkSpeed;
            end;
            if walkSpeedPower>200 then
                walkSpeedPower=150;
            end;
            if not Intellect.Character:IsWalking()then
                    Character.State.Stance.Value='Stand'
                    setupvalue(Intellect.Character.WalkFunction,3,Vector3.new(0,0,0));
                elseif Intellect.Character:IsWalking()then
                if Intellect.Character:IsWalking()==Enum.KeyCode.W then
                    setupvalue(Intellect.Character.WalkFunction,3,WalkSpeed*walkSpeedPower);
                elseif Intellect.Character:IsWalking()==Enum.KeyCode.S then
                    setupvalue(Intellect.Character.WalkFunction,3,-WalkSpeed*walkSpeedPower);
                end;
            end;
        end;
    until not Intellect.UI.Loaded;]])(Intellect,TS,GUISettings);
end);

lstring([[
local Args={...}
local TS,GUISettings,Intellect=Args[1],Args[2],Args[3];
local SilentAim;
SilentAim=hookmetamethod(game,'__namecall',function(...)
    local Method=getnamecallmethod();
    local argss={...};
    if Method=='FireServer'and tostring(...)=='Projectiles'and Intellect.Character:GetLocalCharacter()and GUISettings.Weapons.SilentAim.Enabled then 
        local Character,Player=(GUISettings.Weapons.SilentAim.Type=='Mouse'and Intellect.Enemies:FindNearestTargetToMouse())or Intellect.Enemies:FindNearestTarget();
        print(GUISettings.Weapons.SilentAim.Type)
        if Character then
            local Part=(GUISettings.Weapons.SilentAim.AimPart=='Random'and Intellect.Aimbot:GetRandomPart(Character.Hitbox))or Character.Hitbox:FindFirstChild(tostring(GUISettings.Weapons.SilentAim.AimPart));
            task.spawn(function()
                pcall(function()
                    local Health=Character.Health.Value;
                    task.wait(.2);
                    if Character.Health.Value<Health then
                        TS.UI.Events.Hitmarker:Fire(Part);
                    end;
                end);
            end);
            rawset(argss,4,Part.CFrame.p);
            rawset(argss,5,Part);
            rawset(argss,6,Vector3.new());
            rawset(argss,7,Player);
        end;
    end;setnamecallmethod(Method);
    return SilentAim(unpack(argss));
end)]])(TS,GUISettings,Intellect);

Connections['ImpactPoints']=workspace.Effects.ChildAdded:Connect(function(Part)
    if tostring(Part)=='BulletHole'or tostring(Part)=='CharacterHole'then
        if GUISettings.Weapons.ImpactPoints then
            Intellect.Weapons:ImpactPoint(Part);
        end;
    end;
end);

Connections['HitboxExtender']=workspace.Characters.ChildAdded:Connect(function(Character)
    repeat RunService.Stepped:wait()until Character:FindFirstChild'Root';
    Intellect.Enemies:HitboxExtender();
    Intellect.Enemies:HitboxVisibility()
end);

function Intellect.Codes:RedeemAllCodes()
    local Codes=game:HttpGetAsync'https://roblox-bad-business.fandom.com/wiki/Codes';
    for Code in Codes:gmatch'<td>([%w\n_]*)</td>'do
        TS.Network:Invoke('Codes', 'Redeem', Code:gsub('\n',''));
        firesignal(LP.PlayerGui.MenuGui.ClaimedFrame.CloseButton.MouseButton1Click);
    end;
end;

getgenv().Shooting=false;
function Intellect.Weapons:FullAuto()
    if Shooting then return end
    Shooting=true;
    while RunService.RenderStepped:wait()do 
        if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)or not Intellect.Character:GetLocalCharacter()then
            break;
        end;
        Intellect.Weapons:Shoot(true);
    end;
    Intellect.Weapons:Shoot(false);
    Shooting=false
end;

function Intellect.Character:Deploy()
    firesignal(PlayerUI.MenuGui.Menu.Tiles.DeployButton.MouseButton1Click);
end;

function Intellect.Network:Fire(CMD)
    local ChatBar=LP.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar;
    ChatBar.Text='/e '..CMD;
    getconnections(ChatBar.FocusLost)[1].Function(true);
end;

function Intellect.Character:GetLocalCharacter()
    return TS.Characters:GetCharacter(LP)or false;
end;

function Intellect.Character:GetCharacter(Player)
    return TS.Characters:GetCharacter(Player)or false;
end;

function Intellect.Players:GetLoadedCharacters()
    local Players,Characters=Players:GetPlayers(),{};
    for i=1,#Players do 
        local Player=Players[i];
        Characters[#Characters+1]={Player=Player,Character=TS.Characters:GetCharacter(Player),IsPlayerFriendly=TS.Teams:ArePlayersFriendly(Player,LP)};
    end;
    return Characters;
end;


function Intellect.Enemies:GetCharacters()
    local Characters={};
    local Players=Intellect.Players:GetLoadedCharacters()
    for i=1,#Players do 
        local Player=Players[i];
        if not Player.IsPlayerFriendly and Player.Character then
            Characters[#Characters+1]=Player.Character;
        end;
    end;
    return Characters;
end;

function Intellect.ESP:Apply()
    p_call(function()
        local Players=Intellect.Players:GetLoadedCharacters()
        for i=1,#Players do 
            local Player=Players[i];
            if not Player.IsPlayerFriendly and Player.Character then
                local Parts=Player.Character.Body:GetChildren();
                if Player.Character.Body:FindFirstChild'Head'and not Player.Character.Body.Head:FindFirstChild'ESP'then
                    for i=1,#Parts do 
                        local Part=Parts[i];
                        Intellect.ESP:ApplyBox(Part,Color3.fromRGB(255,0,0));
                    end;
                end;
            end;
        end;
    end);
end;

function Intellect.Enemies:HitboxVisibility()
    local Players=Intellect.Enemies:GetCharacters();
    for i=1,#Players do 
        local Character=Players[i];
        if Character then 
            repeat RunService.Stepped:wait()until Character:FindFirstChild'Hitbox'and #Character:FindFirstChild'Hitbox':GetChildren()==17;
            local Hitbox=Character.Hitbox:GetChildren()
            for i=1,#Hitbox do 
                Hitbox[i].Transparency=(GUISettings.Enemies.HitboxVisibility and .2)or 1;
                Hitbox[i].BrickColor=BrickColor.new'Really blue';
            end;
        end;
    end;
end;

function Intellect.Enemies:HitboxExtenderToggle()
    local Players=Intellect.Enemies:GetCharacters();
    local OriginalHitbox={Abdomen=Vector3.new(1.6,1.4,1.3),Chest=Vector3.new(1.9,1,1.6),Head=Vector3.new(1.5,1.6,1.5),Hips=Vector3.new(1.8,0.8,1.4),LeftArm=Vector3.new(1.05,1.9,1.05),LeftFoot=Vector3.new(1.1,0.9,1.6),LeftForearm=Vector3.new(1,1.9,1),LeftForeleg=Vector3.new(1.1,2.4,1.1),LeftHand=Vector3.new(1,1.1,1),LeftLeg=Vector3.new(1.2,2.4,1.2),Neck=Vector3.new(1,0.8,1),RightArm=Vector3.new(1.05,1.9,1.05),RightFoot=Vector3.new(1.1,0.9,1.6),RightForearm=Vector3.new(1,1.9,1),RightForeleg=Vector3.new(1.1,2.4,1.1),RightHand=Vector3.new(1,1.1,1),RightLeg=Vector3.new(1.2,2.4,1.2)};
    for i=1,#Players do 
        local Character=Players[i];
        if Character then 
            repeat RunService.Stepped:wait()until Character:FindFirstChild'Hitbox'and #Character:FindFirstChild'Hitbox':GetChildren()==17;
            local Hitbox=Character.Hitbox:GetChildren();
            for i=1,#Hitbox do 
                Hitbox[i].Size=OriginalHitbox[tostring(Hitbox[i])];
            end;
        end;
    end;
end;

function Intellect.Enemies:HitboxExtender()
    p_call(function()
        local Players=Intellect.Enemies:GetCharacters();
        for i=1,#Players do 
            local Character=Players[i];
            if Character then 
                repeat RunService.Stepped:wait()until Character:FindFirstChild'Hitbox'and #Character:FindFirstChild'Hitbox':GetChildren()==17;
                if Character.Hitbox.Head.Size.X==1.5 then 
                    local Hitbox=Character.Hitbox:GetChildren();
                    if GUISettings.Enemies.HitboxExtender then 
                        for i=1,#Hitbox do 
                            Hitbox[i].Size=Hitbox[i].Size*GUISettings.Enemies.HitboxSize;
                        end;
                    end;
                end;
            end;
        end;
    end);
end;

function Intellect.Aimbot:GetRandomPart(Character)
    local Character=Character:GetChildren()
    return Character[math.random(1,#Character)];
end;

function Intellect.Game:RejoinExperience()
    TeleportService:Teleport(game.PlaceId,LP);
end;

function Intellect.Character:NoClip()
    local Character=Intellect.Character:GetLocalCharacter();
    if Character and Character:FindFirstChild'Root'then 
        Character.Root.CanCollide=false;
    end;
end;

function Intellect.Character:IsWalking()
    local Keys={Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.Space};
    for _,Key in next,Keys do
        if UIS:IsKeyDown(Key)then
            return Key;
        end;
    end;
    return false;
end;

function Intellect.Settings:SaveConfiguration()
    writefile(File,HttpService:JSONEncode(GUISettings));
end;

function Intellect.ESP:ApplyBox(Instance1,Colour)
    local ESP=Instance.new('BoxHandleAdornment',Instance1);
    ESP.Name='ESP';
    ESP.Size=Instance1.Size;
    ESP.Adornee=Instance1;
    ESP.ZIndex=5;
    ESP.AlwaysOnTop=true;
    ESP.Color3=Colour;
    ESP.Transparency=.3;
end;

TS.Damage.CharacterKilled:Connect(function(Player)
    local PlayerChildren=Player.Body:GetChildren();
    for i=1,#PlayerChildren do 
        if PlayerChildren[i]:FindFirstChild'ESP'then 
            PlayerChildren[i].ESP:Destroy();
        end;
    end;
end);

function Intellect.ESP:Apply()
    p_call(function()
        local Players=Intellect.Players:GetLoadedCharacters()
        for i=1,#Players do 
            local Player=Players[i];
            if not Player.IsPlayerFriendly and Player.Character then
                local Parts=Player.Character.Body:GetChildren();
                if Player.Character.Body:FindFirstChild'Head'and not Player.Character.Body.Head:FindFirstChild'ESP'then
                    for i=1,#Parts do 
                        local Part=Parts[i];
                        Intellect.ESP:ApplyBox(Part,Color3.fromRGB(255,0,0));
                    end;
                end;
            end;
        end;
    end);
end;

function Intellect.ESP:Remove()
    p_call(function()
        local Players=Intellect.Players:GetLoadedCharacters()
        for i=1,#Players do 
            local Player=Players[i];
            if not Player.IsPlayerFriendly and Player.Character then
                local Parts=Player.Character.Body:GetChildren();
                if Player.Character.Body:FindFirstChild'Head'then
                    for i=1,#Parts do 
                        local Part=Parts[i];
                        if Part:FindFirstChild'ESP'then
                            Part.ESP:Destroy();
                        end;
                    end;
                end;
            end;
        end;
    end);
    Intellect:Disconnect'ESP';
end;


function Intellect.Challenges:RedeemAllChallenges()
    local Challenges=LP.PlayerGui.MenuGui.Menu.Challenges:GetChildren()
    for i=1,#Challenges do 
        local Challenge=Challenges[i];
        if Challenge:IsA'Frame'then firesignal(Challenge.ClaimButton.MouseButton1Click);end;
    end;
end;

local ApplicableTypes={'Primary','Secondary'};
function Intellect.Weapons:GetEquippedWeapon()
    local Character=Intellect.Character:GetLocalCharacter();
    if Character and Character:FindFirstChild'Backpack'then 
        local Equipped=Character.Backpack.Equipped.Value;
        if Equipped then
            for i=1,#ApplicableTypes do
                local Type=ApplicableTypes[i]
                if Character.Backpack[Type].Value==Equipped then
                    return Character.Backpack.Items[Equipped.Name];
                end;
            end;
        end;
    end;
    return false;
end;

function Intellect.Character:AntiAim()
    local Pose=math.random(-1,1)
    TS.Network:Fire('Character','State','Lean',Pose)
end;

function Intellect.Weapons:NoBulletDrop(State)
    local gc,Index=getgc(true),0;
    for i=1,#gc do 
        local Weapon=gc[i];
        if type(Weapon)=='table'and rawget(Weapon,'Gravity')and rawget(Weapon,'Speed')then
            if #Intellect.Weapons.OldBulletDrop~=12 then 
                Intellect.Weapons.OldBulletDrop[#Intellect.Weapons.OldBulletDrop+1]=Weapon.Gravity;
            end;
            Index+=1;Weapon.Gravity=(State and Intellect.Weapons.OldBulletDrop[Index])or 0;
        end;
    end;
end;

function Intellect.Weapons:InfiniteAmmo()
    local Weapon=Intellect.Weapons:GetEquippedWeapon();
    if Weapon and Weapon:FindFirstChild'Events'and not Weapon.Events:FindFirstChild'Stab'then
        if Weapon.State.Ammo.Value==3 then 
            TS.Network:Fire('Item_Paintball','Reload',Weapon);
            Weapon.State.Ammo.Value=RepStore.Items.Base:FindFirstChild(tstring(Weapon)).State.Ammo.Value;
        end;
    end;
end;

function Intellect.Enemies:Radar()
    p_call(function()
        local Players,Min=Intellect.Players:GetLoadedCharacters(),9e9;
        for i=1,#Players do 
            local Player=Players[i];
            if not Player.IsPlayerFriendly and Player.Character and Intellect.Character:GetLocalCharacter()then
                TS.UI.Events.RadarEnemy:Fire(tick(),Player.Character.Body.Head.CFrame.p);
            end;
        end;
    end);
end;

function Intellect.Enemies:FindNearestTargetToMouse()
    local Players,Min=Intellect.Enemies:GetCharacters(),9e9;
    for i=1,#Players do 
        local Character=Players[i];
        if Character and Character.Root:FindFirstChild'ShieldEmitter'and not Character.Root.ShieldEmitter.Enabled and Intellect.Character:GetLocalCharacter()then
            if Character and Character.Health.Value>0 then
                local HeadPosition,OnScreen=Camera:WorldToViewportPoint(Character.Hitbox.Head.Position);
                if OnScreen then 
                    local MouseDistanceFromPlayer=(Vector2.new(HeadPosition.X,HeadPosition.Y)-UIS:GetMouseLocation()).Magnitude;
                    if MouseDistanceFromPlayer<Min then
                        Min=MouseDistanceFromPlayer;
                        NearestCharacter=Character;
                    end
                end
            end;
        end;
        return NearestCharacter;
    end
end;

function Intellect.Enemies:FindNearestTarget()
    local _,NearestCharacter,NearestPlayer,Distance=p_call(function()
        local Players,Min=Intellect.Players:GetLoadedCharacters(),9e9;
        for i=1,#Players do 
            local Player=Players[i];
            if not Player.IsPlayerFriendly and Player.Character and not Player.Character.Root:FindFirstChild'ParticleEmitter'and tstring(Player.Character.Parent)=='Characters'and Intellect.Character:GetLocalCharacter()then
                if(Player.Character.Body.Head.CFrame.p-Intellect.Character:GetLocalCharacter().Body.Head.CFrame.p).Magnitude<Min then 
                    Min=(Player.Character.Body.Head.CFrame.p-Intellect.Character:GetLocalCharacter().Body.Head.CFrame.p).Magnitude;
                    NearestCharacter,NearestPlayer=Player.Character,Player.Player;
                end;
            end;
        end;
        return NearestCharacter,NearestPlayer,MFloor(Min);
    end);
    return NearestCharacter,NearestPlayer,Distance;
end;

function Intellect.Weapons:Shoot(Bool)
    if Bool then
        TS.Input:AutomateBegan'Shoot'
    else
        TS.Input:AutomateEnded'Shoot';
    end;
end;

function Intellect.Weapons:GetGunModel()
    local Items=workspace:GetChildren();
    for i=1,#Items do 
        local Item=Items[i];
        if Item:IsA'Model'and tstring(Item)~='Arms'and Item:FindFirstChild'RightHand'then
            return Item;
        end;
    end;
    return false;
end;

function Intellect.Character:Jump(Amount)
    local Character=Intellect.Character:GetLocalCharacter();
    if Character and Character:FindFirstChild'Root'then
        local Amount=Amount or GUISettings.Character.JumpPower;
        Character.Root.Velocity=Vector3.new(Character.Root.Velocity.X,Amount,Character.Root.Velocity.Z);
        VirtualInputManager:SendKeyEvent(true,'Space',false,game)
        fwait()
        VirtualInputManager:SendKeyEvent(false,'Space',false,game)
	end;
end;

function Intellect.Character:Teleport(CF,Jump)
    local Character=Intellect.Character:GetLocalCharacter();
    if Jump then
        Intellect.Character:Jump(200);
    end;
    if Character and Character:FindFirstChild'Root'then
        Character.Root.CFrame=CF;
    end;
end;

function Intellect.Weapons:Equip(Weapon)
    TS.Network:Fire('Item','Equip',Weapon);
end;

function Intellect.Enemies:KillAll()
    return'Not Finished';
end;

function Intellect.Weapons:ImpactPoint(Part)
    local ImpactPoint=Instance.new('Part',Part);
    pcall(function()Part.Decal:Destroy()end)
    ImpactPoint.BrickColor=BrickColor.new('Really red');
    ImpactPoint.Size=Part.Size/2;
    ImpactPoint.CFrame=Part.CFrame;
    ImpactPoint.Material=Enum.Material.Neon
    ImpactPoint.Anchored=true;
end;

function Intellect.Weapons:TriggerBot()
    p_call(function()
        local Players=Intellect.Enemies:GetCharacters();
        Mouse.TargetFilter=Intellect.Weapons:GetGunModel();
        for i=1,#Players do 
            local Character=Players[i];
            if Character and Mouse.Target and Mouse.Target:IsDescendantOf(Character)and not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)and Intellect.Weapons:GetEquippedWeapon()then
                Intellect.Weapons:Shoot(true);
                Intellect.Weapons:Shoot(false);
            end;
        end;
    end);
end;

function Intellect.Weapons:GetMelee()
    local Character=Intellect.Character:GetLocalCharacter()
    if Character then 
        local Weapons=Character.Backpack.Items:GetChildren()
        for i=1,#Weapons do 
            local Melee=Weapons[i];
            if Melee.Events:FindFirstChild'Stab'then 
                return Melee;
            end;
        end;
    end;
    return false;
end;

function Intellect:Loop(Name,Function)
    Connections[Name]=RunService.RenderStepped:Connect(Function);
end;

function Intellect.Rounds:RemoveBorders()
    local Borders=workspace.NonProjectileGeometry:GetChildren()
    for i=1,#Borders do 
        Borders[i]:Destroy();
    end;
end;

function Intellect.Weapons:GetGrenade()
    local Character=Intellect.Character:GetLocalCharacter()
    if Character then 
        local Weapons=Character.Backpack.Items:GetChildren()
        for i=1,#Weapons do 
            local Grenade=Weapons[i];
            if Grenade.State:FindFirstChild'Cooking'then 
                return Grenade;
            end;
        end;
    end;
    return false;
end;

function Intellect.Character:IsMeleeEquipped()
    local Melee=Intellect.Weapons:GetMelee()
    local Character=Intellect.Character:GetLocalCharacter();
    if Character then
        return(tstring(Melee)==tstring(Character.Backpack.Equipped.Value));
    end;
end;

function Intellect.Character:IsGrenadeEquipped()
    local Grenade=Intellect.Weapons:GetGrenade()
    local Character=Intellect.Character:GetLocalCharacter();
    if Character then
        return(tstring(Grenade)==tstring(Character.Backpack.Equipped.Value));
    end;
end;

function Intellect:Disconnect(Name)
    Connections[Name]:Disconnect();
end;

function Intellect.Weapons:NoSpread()
    -- local Character=Intellect.Character:GetLocalCharacter();
    -- if Character and Character:FindFirstChild'Root'and not Intellect.Character:IsMeleeEquipped()and not Intellect.Character:IsGrenadeEquipped()then
    --     Character.State.Aiming.Value=true;
    -- end;
end;

function Intellect.Weapons:KnifeTarget(Player)
    local NearestCharacter,NearestPlayer,Distance,OldWeapon=Intellect.Enemies:FindNearestTarget();
    if Player or NearestCharacter and Distance and Distance<28 and Intellect.Character:GetLocalCharacter()then 
        NearestCharacter=NearestCharacter or Player;
        local Health=NearestCharacter.Health.Value;
        TS.Network:Fire('Item_Melee','StabBegin',Intellect.Weapons:GetMelee());
        fwait(.2);
        TS.Network:Fire('Item_Melee','Stab',Intellect.Weapons:GetMelee(),NearestCharacter.Hitbox.Head,Vector3.new(),Vector3.new());
        fwait(.2);
        if NearestCharacter.Health.Value~=Health then
            TS.UI.Events.Hitmarker:Fire(NearestCharacter.Body.Head);
        end;
    end;
end;

function Intellect.Character:ResetCharacter()
    Intellect.Character:Teleport(CFrame.new(0,-497,0))
end;

function Intellect.Weapons:ApplyWeaponModification(Tbl,Index,Value)
    local Items=RepStore.Items.Base:GetChildren();  
    for i=1,#Items do 
        if Items[i]:FindFirstChild'Config'then
            local Module=require(Items[i].Config);
            if typeof(Module.Recoil)=='table'and Module.Recoil.Default and Module.Aim and Module then
                if Module.Slot and Module.Slot=='Primary'or Module.Slot=='Secondary'then
                    if Tbl=='self'then 
                        if typeof(Module.Recoil)=='table'and Module.Recoil.Default and Module.Aim and Module then
                            local Type=Module.FireModes.Auto and'Auto'or Module.FireModes.Ramp and'Ramp'or Module.FireModes.Burst and'Burst'or 'Semi'
                            rawset(Module.FireModes,'Auto',{FireRate=Module.FireModes[Type].FireRate})
                            rawset(Module,'FireModeList',{'Auto'})
                        end;
                    elseif Tbl=='Recoil'then 
                        for Index,Weapon in next,Module.Recoil.Default do
                            rawset(Module.Recoil.Default,Index,(typeof(Weapon)=='Vector3'and Vector3.new()or typeof(Weapon)=='Vector2'and Vector2.new())or 0);
                        end;
                    else
                        local Operator=string.find(Value,'x');
                        local Key=(Operator and'x')or'/';
                        rawset(Module[Tbl],Index,(Operator and Module[Tbl][Index]*tonumber(Value:split(Key)[2]))or not Operator and Module[Tbl][Index]/tonumber(Value:split(Key)[2])or Value);
                    end;
                end;
            end;
        end;
    end;
end;
return Intellect;
