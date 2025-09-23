local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = Workspace.CurrentCamera
local CheatEnabled = {Speed=false,Jump=false,Noclip=false,Fly=false,ESP=false,Tracers=false,Boxes=false,Chams=false,PlayerHighlights=false,AutoClick=false,InfiniteStamina=false,AutoRespawn=false,AutoFarmCoins=false,InfiniteTools=false,ChatSpam=false,AntiVoid=false,Invisible=false,AutoHeal=false,TeleportToCoins=false,BunnyHop=false,GodMode=false,InfiniteHealth=false,TimeChange=false,GravityChange=false,AutoRejoin=false,AntiAfk=false,FpsBoost=false,AntiLag=false,RemoveTextures=false,AntiKick=false,Aimbot=false,AutoParkour=false,SpeedGlitch=false,Fullbright=false,NoFog=false,Xray=false,SpinBot=false}
local CheatSettings = {WalkSpeed=50,JumpPower=100,FlySpeed=50,TeleportX=0,TeleportY=0,TeleportZ=0,ESPColor=Color3.fromRGB(255,0,0),TracerColor=Color3.fromRGB(0,255,0),BoxColor=Color3.fromRGB(0,0,255),ChamsColor=Color3.fromRGB(255,255,0),ChatSpamMessage="Mr.Hekran Ultimate Menu!",ChatSpamDelay=1,SpinSpeed=10,GravityValue=196.2,TimeValue=14}

local ESPObjects,TracerObjects,BoxObjects,ChamsObjects,HighlightObjects={},{},{},{},{}
local Connections,PlayerList,PlayerDropdown={},{},{}
local BodyVelocity,BodyAngularVelocity,FrozenPlayers=nil,nil,{}
local function UpdatePlayerList()
PlayerList,PlayerDropdown={},{}
for _,player in pairs(Players:GetPlayers())do
if player~=LocalPlayer then table.insert(PlayerList,player)table.insert(PlayerDropdown,player.Name)end
end
end
local function GetClosestPlayer()
local closest,shortestDistance=nil,math.huge
for _,player in pairs(Players:GetPlayers())do
if player~=LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart")then
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")then
local distance=(LocalPlayer.Character.HumanoidRootPart.Position-player.Character.HumanoidRootPart.Position).Magnitude
if distance<shortestDistance then shortestDistance,closest=distance,player end
end
end
end
return closest,shortestDistance
end
local function TeleportTo(position)
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")then
LocalPlayer.Character.HumanoidRootPart.CFrame=CFrame.new(position)
end
end
local function TeleportToPlayer(player)
if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")then
TeleportTo(player.Character.HumanoidRootPart.Position)
end
end
local function TeleportBehindPlayer(player)
if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")then
local targetPosition=player.Character.HumanoidRootPart.Position-(player.Character.HumanoidRootPart.CFrame.LookVector*5)
TeleportTo(targetPosition)
end
end
local function SetSpeed()
if CheatEnabled.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")then
LocalPlayer.Character.Humanoid.WalkSpeed=CheatSettings.WalkSpeed
else
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")then
LocalPlayer.Character.Humanoid.WalkSpeed=16
end
end
end
local function SetJump()
if CheatEnabled.Jump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")then
LocalPlayer.Character.Humanoid.JumpPower=CheatSettings.JumpPower
else
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")then
LocalPlayer.Character.Humanoid.JumpPower=50
end
end
end
local function ToggleNoclip()
if CheatEnabled.Noclip then
if not Connections.Noclip then
Connections.Noclip=RunService.Stepped:Connect(function()
if LocalPlayer.Character then
for _,part in pairs(LocalPlayer.Character:GetDescendants())do
if part:IsA("BasePart")and part.CanCollide then part.CanCollide=false end
end
end
end)
end
else
if Connections.Noclip then
Connections.Noclip:Disconnect()
Connections.Noclip=nil
if LocalPlayer.Character then
for _,part in pairs(LocalPlayer.Character:GetDescendants())do
if part:IsA("BasePart")then part.CanCollide=true end
end
end
end
end
end
local function ToggleFly()
if CheatEnabled.Fly then
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")then
BodyVelocity=Instance.new("BodyVelocity")
BodyAngularVelocity=Instance.new("BodyAngularVelocity")
BodyVelocity.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
BodyVelocity.Velocity=Vector3.new(0,0,0)
BodyVelocity.Parent=LocalPlayer.Character.HumanoidRootPart
BodyAngularVelocity.MaxTorque=Vector3.new(math.huge,math.huge,math.huge)
BodyAngularVelocity.AngularVelocity=Vector3.new(0,0,0)
BodyAngularVelocity.Parent=LocalPlayer.Character.HumanoidRootPart
if not Connections.Fly then
Connections.Fly=RunService.Heartbeat:Connect(function()
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")then
local moveVector=Vector3.new(0,0,0)
if UserInputService:IsKeyDown(Enum.KeyCode.W)then moveVector=moveVector+Camera.CFrame.LookVector end
if UserInputService:IsKeyDown(Enum.KeyCode.S)then moveVector=moveVector-Camera.CFrame.LookVector end
if UserInputService:IsKeyDown(Enum.KeyCode.A)then moveVector=moveVector-Camera.CFrame.RightVector end
if UserInputService:IsKeyDown(Enum.KeyCode.D)then moveVector=moveVector+Camera.CFrame.RightVector end
if UserInputService:IsKeyDown(Enum.KeyCode.Space)then moveVector=moveVector+Vector3.new(0,1,0)end
if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)then moveVector=moveVector-Vector3.new(0,1,0)end
if BodyVelocity then BodyVelocity.Velocity=moveVector*CheatSettings.FlySpeed end
end
end)
end
end
else
if Connections.Fly then Connections.Fly:Disconnect()Connections.Fly=nil end
if BodyVelocity then BodyVelocity:Destroy()BodyVelocity=nil end
if BodyAngularVelocity then BodyAngularVelocity:Destroy()BodyAngularVelocity=nil end
end
end

local function CreateESP(player)
if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart")then return end
local billboard=Instance.new("BillboardGui")
local textLabel=Instance.new("TextLabel")
billboard.Adornee=player.Character.HumanoidRootPart
billboard.Size=UDim2.new(0,100,0,50)
billboard.StudsOffset=Vector3.new(0,2,0)
billboard.Parent=game.CoreGui
textLabel.Size=UDim2.new(1,0,1,0)
textLabel.BackgroundTransparency=1
textLabel.Text=player.Name
textLabel.TextColor3=CheatSettings.ESPColor
textLabel.TextStrokeTransparency=0
textLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)
textLabel.Font=Enum.Font.SourceSansBold
textLabel.TextSize=14
textLabel.Parent=billboard
ESPObjects[player]=billboard
end
local function RemoveESP(player)
if ESPObjects[player]then ESPObjects[player]:Destroy()ESPObjects[player]=nil end
end
local function ToggleESP()
if CheatEnabled.ESP then
for _,player in pairs(Players:GetPlayers())do
if player~=LocalPlayer then CreateESP(player)end
end
if not Connections.ESP then
Connections.ESP=Players.PlayerAdded:Connect(function(player)
player.CharacterAdded:Connect(function()wait(1)if CheatEnabled.ESP then CreateESP(player)end end)
end)
end
else
for player,_ in pairs(ESPObjects)do RemoveESP(player)end
if Connections.ESP then Connections.ESP:Disconnect()Connections.ESP=nil end
end
end
local function CreateTracer(player)
if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart")then return end
local line=Drawing.new("Line")
line.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)
line.Color=CheatSettings.TracerColor
line.Thickness=2
line.Transparency=1
line.Visible=true
TracerObjects[player]={Line=line,Connection=RunService.RenderStepped:Connect(function()
if player.Character and player.Character:FindFirstChild("HumanoidRootPart")then
local vector,onScreen=Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
if onScreen then line.To=Vector2.new(vector.X,vector.Y)line.Visible=true else line.Visible=false end
else line.Visible=false end
end)}
end
local function RemoveTracer(player)
if TracerObjects[player]then TracerObjects[player].Line:Remove()TracerObjects[player].Connection:Disconnect()TracerObjects[player]=nil end
end
local function ToggleTracers()
if CheatEnabled.Tracers then
for _,player in pairs(Players:GetPlayers())do
if player~=LocalPlayer then CreateTracer(player)end
end
if not Connections.Tracers then
Connections.Tracers=Players.PlayerAdded:Connect(function(player)
player.CharacterAdded:Connect(function()wait(1)if CheatEnabled.Tracers then CreateTracer(player)end end)
end)
end
else
for player,_ in pairs(TracerObjects)do RemoveTracer(player)end
if Connections.Tracers then Connections.Tracers:Disconnect()Connections.Tracers=nil end
end
end

local function CreateBox(player)
if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart")then return end
local box={}
for i=1,8 do box[i]=Drawing.new("Line")box[i].Color=CheatSettings.BoxColor box[i].Thickness=2 box[i].Transparency=1 end
BoxObjects[player]={Box=box,Connection=RunService.RenderStepped:Connect(function()
if player.Character and player.Character:FindFirstChild("HumanoidRootPart")and player.Character:FindFirstChild("Humanoid")then
local rootPart,humanoid=player.Character.HumanoidRootPart,player.Character.Humanoid
local vector,onScreen=Camera:WorldToViewportPoint(rootPart.Position)
local topVector=Camera:WorldToViewportPoint((rootPart.CFrame*CFrame.new(0,humanoid.HipHeight+2,0)).Position)
local bottomVector=Camera:WorldToViewportPoint((rootPart.CFrame*CFrame.new(0,-humanoid.HipHeight-2,0)).Position)
if onScreen then
local distance=(Camera.CFrame.Position-rootPart.Position).Magnitude
local factor=1/(distance/10+1)
local width=math.clamp(factor*100,4,1000)
local height=math.abs(topVector.Y-bottomVector.Y)
local x1,x2,y1,y2=vector.X-width/2,vector.X+width/2,topVector.Y,bottomVector.Y
box[1].From,box[1].To=Vector2.new(x1,y1),Vector2.new(x1+width*0.25,y1)
box[2].From,box[2].To=Vector2.new(x2-width*0.25,y1),Vector2.new(x2,y1)
box[3].From,box[3].To=Vector2.new(x1,y2),Vector2.new(x1+width*0.25,y2)
box[4].From,box[4].To=Vector2.new(x2-width*0.25,y2),Vector2.new(x2,y2)
box[5].From,box[5].To=Vector2.new(x1,y1),Vector2.new(x1,y1+height*0.25)
box[6].From,box[6].To=Vector2.new(x2,y1),Vector2.new(x2,y1+height*0.25)
box[7].From,box[7].To=Vector2.new(x1,y2-height*0.25),Vector2.new(x1,y2)
box[8].From,box[8].To=Vector2.new(x2,y2-height*0.25),Vector2.new(x2,y2)
for _,line in pairs(box)do line.Visible=true end
else
for _,line in pairs(box)do line.Visible=false end
end
else
for _,line in pairs(box)do line.Visible=false end
end
end)}
end
local function RemoveBox(player)
if BoxObjects[player]then
for _,line in pairs(BoxObjects[player].Box)do line:Remove()end
BoxObjects[player].Connection:Disconnect()
BoxObjects[player]=nil
end
end
local function ToggleBoxes()
if CheatEnabled.Boxes then
for _,player in pairs(Players:GetPlayers())do
if player~=LocalPlayer then CreateBox(player)end
end
if not Connections.Boxes then
Connections.Boxes=Players.PlayerAdded:Connect(function(player)
player.CharacterAdded:Connect(function()wait(1)if CheatEnabled.Boxes then CreateBox(player)end end)
end)
end
else
for player,_ in pairs(BoxObjects)do RemoveBox(player)end
if Connections.Boxes then Connections.Boxes:Disconnect()Connections.Boxes=nil end
end
end
local function CreateChams(player)
if not player.Character then return end
for _,part in pairs(player.Character:GetChildren())do
if part:IsA("BasePart")and part.Name~="HumanoidRootPart"then
local highlight=Instance.new("Highlight")
highlight.FillColor=CheatSettings.ChamsColor
highlight.FillTransparency=0.5
highlight.OutlineColor=Color3.fromRGB(255,255,255)
highlight.OutlineTransparency=0
highlight.Parent=part
if not ChamsObjects[player]then ChamsObjects[player]={}end
table.insert(ChamsObjects[player],highlight)
end
end
end
local function RemoveChams(player)
if ChamsObjects[player]then
for _,highlight in pairs(ChamsObjects[player])do highlight:Destroy()end
ChamsObjects[player]=nil
end
end
local function ToggleChams()
if CheatEnabled.Chams then
for _,player in pairs(Players:GetPlayers())do
if player~=LocalPlayer then CreateChams(player)end
end
if not Connections.Chams then
Connections.Chams=Players.PlayerAdded:Connect(function(player)
player.CharacterAdded:Connect(function()wait(1)if CheatEnabled.Chams then CreateChams(player)end end)
end)
end
else
for player,_ in pairs(ChamsObjects)do RemoveChams(player)end
if Connections.Chams then Connections.Chams:Disconnect()Connections.Chams=nil end
end
end
local function CreateHighlight(player)
if not player.Character then return end
local highlight=Instance.new("Highlight")
highlight.FillColor=Color3.fromRGB(255,0,0)
highlight.FillTransparency=0.8
highlight.OutlineColor=Color3.fromRGB(255,255,255)
highlight.OutlineTransparency=0
highlight.Parent=player.Character
HighlightObjects[player]=highlight
end
local function RemoveHighlight(player)
if HighlightObjects[player]then HighlightObjects[player]:Destroy()HighlightObjects[player]=nil end
end
local function TogglePlayerHighlights()
if CheatEnabled.PlayerHighlights then
for _,player in pairs(Players:GetPlayers())do
if player~=LocalPlayer then CreateHighlight(player)end
end
if not Connections.PlayerHighlights then
Connections.PlayerHighlights=Players.PlayerAdded:Connect(function(player)
player.CharacterAdded:Connect(function()wait(1)if CheatEnabled.PlayerHighlights then CreateHighlight(player)end end)
end)
end
else
for player,_ in pairs(HighlightObjects)do RemoveHighlight(player)end
if Connections.PlayerHighlights then Connections.PlayerHighlights:Disconnect()Connections.PlayerHighlights=nil end
end
end

local function ToggleAutoClick()
if CheatEnabled.AutoClick then
if not Connections.AutoClick then
Connections.AutoClick=RunService.Heartbeat:Connect(function()
for _,obj in pairs(Workspace:GetDescendants())do
if obj:FindFirstChild("ClickDetector")then
fireclickdetector(obj.ClickDetector)
end
end
end)
end
else
if Connections.AutoClick then Connections.AutoClick:Disconnect()Connections.AutoClick=nil end
end
end
local function ToggleInfiniteStamina()
if CheatEnabled.InfiniteStamina then
if not Connections.InfiniteStamina then
Connections.InfiniteStamina=RunService.Heartbeat:Connect(function()
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")then
for _,obj in pairs(LocalPlayer.Character:GetDescendants())do
if obj:IsA("NumberValue")and(obj.Name:lower():find("stamina")or obj.Name:lower():find("energy"))then
obj.Value=100
end
end
end
end)
end
else
if Connections.InfiniteStamina then Connections.InfiniteStamina:Disconnect()Connections.InfiniteStamina=nil end
end
end
local function ToggleAutoRespawn()
if CheatEnabled.AutoRespawn then
if not Connections.AutoRespawn then
Connections.AutoRespawn=LocalPlayer.CharacterRemoving:Connect(function()wait(1)LocalPlayer:LoadCharacter()end)
end
else
if Connections.AutoRespawn then Connections.AutoRespawn:Disconnect()Connections.AutoRespawn=nil end
end
end
local function FreezePlayer(player)
if player.Character and player.Character:FindFirstChild("HumanoidRootPart")then
if not FrozenPlayers[player]then
local bodyPosition=Instance.new("BodyPosition")
bodyPosition.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
bodyPosition.Position=player.Character.HumanoidRootPart.Position
bodyPosition.Parent=player.Character.HumanoidRootPart
FrozenPlayers[player]=bodyPosition
end
end
end
local function ToggleAutoFarmCoins()
if CheatEnabled.AutoFarmCoins then
if not Connections.AutoFarmCoins then
Connections.AutoFarmCoins=RunService.Heartbeat:Connect(function()
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")then
for _,obj in pairs(Workspace:GetDescendants())do
if(obj.Name:lower():find("coin")or obj.Name=="Coin")and obj:IsA("BasePart")then
obj.CFrame=LocalPlayer.Character.HumanoidRootPart.CFrame
end
end
end
end)
end
else
if Connections.AutoFarmCoins then Connections.AutoFarmCoins:Disconnect()Connections.AutoFarmCoins=nil end
end
end
local function ToggleInfiniteTools()
if CheatEnabled.InfiniteTools then
if not Connections.InfiniteTools then
Connections.InfiniteTools=RunService.Heartbeat:Connect(function()
if LocalPlayer.Character then
for _,tool in pairs(LocalPlayer.Character:GetChildren())do
if tool:IsA("Tool")then tool.CanBeDropped=false end
end
end
end)
end
else
if Connections.InfiniteTools then Connections.InfiniteTools:Disconnect()Connections.InfiniteTools=nil end
end
end
local function ToggleChatSpam()
if CheatEnabled.ChatSpam then
if not Connections.ChatSpam then
Connections.ChatSpam=RunService.Heartbeat:Connect(function()
wait(CheatSettings.ChatSpamDelay)
pcall(function()game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(CheatSettings.ChatSpamMessage,"All")end)
end)
end
else
if Connections.ChatSpam then Connections.ChatSpam:Disconnect()Connections.ChatSpam=nil end
end
end
local function ToggleAntiVoid()
if CheatEnabled.AntiVoid then
if not Connections.AntiVoid then
Connections.AntiVoid=RunService.Heartbeat:Connect(function()
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")then
if LocalPlayer.Character.HumanoidRootPart.Position.Y<-100 then
LocalPlayer.Character.HumanoidRootPart.CFrame=CFrame.new(0,50,0)
end
end
end)
end
else
if Connections.AntiVoid then Connections.AntiVoid:Disconnect()Connections.AntiVoid=nil end
end
end
local function ToggleInvisible()
if CheatEnabled.Invisible and LocalPlayer.Character then
for _,part in pairs(LocalPlayer.Character:GetChildren())do
if part:IsA("BasePart")and part.Name~="HumanoidRootPart"then
part.Transparency=1
elseif part:IsA("Accessory")then
part.Handle.Transparency=1
end
end
if LocalPlayer.Character:FindFirstChild("Head")and LocalPlayer.Character.Head:FindFirstChild("face")then
LocalPlayer.Character.Head.face.Transparency=1
end
else
if LocalPlayer.Character then
for _,part in pairs(LocalPlayer.Character:GetChildren())do
if part:IsA("BasePart")and part.Name~="HumanoidRootPart"then
part.Transparency=0
elseif part:IsA("Accessory")then
part.Handle.Transparency=0
end
end
if LocalPlayer.Character:FindFirstChild("Head")and LocalPlayer.Character.Head:FindFirstChild("face")then
LocalPlayer.Character.Head.face.Transparency=0
end
end
end
end
local function ToggleAutoHeal()
if CheatEnabled.AutoHeal then
if not Connections.AutoHeal then
Connections.AutoHeal=RunService.Heartbeat:Connect(function()
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")then
if LocalPlayer.Character.Humanoid.Health<LocalPlayer.Character.Humanoid.MaxHealth then
LocalPlayer.Character.Humanoid.Health=LocalPlayer.Character.Humanoid.MaxHealth
end
end
end)
end
else
if Connections.AutoHeal then Connections.AutoHeal:Disconnect()Connections.AutoHeal=nil end
end
end
local function ToggleTeleportToCoins()
if CheatEnabled.TeleportToCoins then
if not Connections.TeleportToCoins then
Connections.TeleportToCoins=RunService.Heartbeat:Connect(function()
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")then
for _,obj in pairs(Workspace:GetDescendants())do
if obj.Name:lower():find("coin")and obj:IsA("BasePart")then
LocalPlayer.Character.HumanoidRootPart.CFrame=obj.CFrame
wait(0.1)
break
end
end
end
end)
end
else
if Connections.TeleportToCoins then Connections.TeleportToCoins:Disconnect()Connections.TeleportToCoins=nil end
end
end
local function ToggleBunnyHop()
if CheatEnabled.BunnyHop then
if not Connections.BunnyHop then
Connections.BunnyHop=RunService.Heartbeat:Connect(function()
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")then
if LocalPlayer.Character.Humanoid.MoveDirection.Magnitude>0 then
LocalPlayer.Character.Humanoid.Jump=true
end
end
end)
end
else
if Connections.BunnyHop then Connections.BunnyHop:Disconnect()Connections.BunnyHop=nil end
end
end
local function ToggleGodMode()
if CheatEnabled.GodMode then
if not Connections.GodMode then
Connections.GodMode=RunService.Heartbeat:Connect(function()
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")then
LocalPlayer.Character.Humanoid.MaxHealth=math.huge
LocalPlayer.Character.Humanoid.Health=math.huge
end
end)
end
else
if Connections.GodMode then Connections.GodMode:Disconnect()Connections.GodMode=nil end
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")then
LocalPlayer.Character.Humanoid.MaxHealth=100
LocalPlayer.Character.Humanoid.Health=100
end
end
end
local function ToggleInfiniteHealth()
if CheatEnabled.InfiniteHealth then
if not Connections.InfiniteHealth then
Connections.InfiniteHealth=RunService.Heartbeat:Connect(function()
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")then
LocalPlayer.Character.Humanoid.Health=LocalPlayer.Character.Humanoid.MaxHealth
end
end)
end
else
if Connections.InfiniteHealth then Connections.InfiniteHealth:Disconnect()Connections.InfiniteHealth=nil end
end
end
local function ToggleTimeChange()
if CheatEnabled.TimeChange then Lighting.ClockTime=CheatSettings.TimeValue else Lighting.ClockTime=14 end
end
local function ToggleGravityChange()
if CheatEnabled.GravityChange then Workspace.Gravity=CheatSettings.GravityValue else Workspace.Gravity=196.2 end
end
local function ToggleAutoRejoin()
if CheatEnabled.AutoRejoin then
if not Connections.AutoRejoin then
Connections.AutoRejoin=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
if child.Name=="ErrorPrompt"and child:FindFirstChild("MessageArea")and child.MessageArea:FindFirstChild("ErrorFrame")then
game:GetService("TeleportService"):Teleport(game.PlaceId)
end
end)
end
else
if Connections.AutoRejoin then Connections.AutoRejoin:Disconnect()Connections.AutoRejoin=nil end
end
end
local function ToggleAntiAfk()
if CheatEnabled.AntiAfk then
if not Connections.AntiAfk then
Connections.AntiAfk=RunService.Heartbeat:Connect(function()
game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
end)
end
else
if Connections.AntiAfk then Connections.AntiAfk:Disconnect()Connections.AntiAfk=nil end
end
end
local function ServerHop()
local servers={}
local req=syn.request({Url="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"})
local body=game:GetService("HttpService"):JSONDecode(req.Body)
for i,v in next,body.data do
if type(v)=="table"and v.maxPlayers>v.playing and v.id~=game.JobId then
table.insert(servers,v.id)
end
end
if #servers>0 then
game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,servers[math.random(1,#servers)])
end
end
local function ToggleFpsBoost()
if CheatEnabled.FpsBoost then
settings().Rendering.QualityLevel=1
for _,obj in pairs(Workspace:GetDescendants())do
if obj:IsA("ParticleEmitter")or obj:IsA("Trail")or obj:IsA("Smoke")or obj:IsA("Fire")or obj:IsA("Sparkles")then
obj.Enabled=false
end
end
else
settings().Rendering.QualityLevel=Enum.QualityLevel.Automatic
end
end
local function ToggleAntiLag()
if CheatEnabled.AntiLag then
for _,obj in pairs(Workspace:GetDescendants())do
if obj:IsA("ParticleEmitter")or obj:IsA("Trail")or obj:IsA("Beam")then
obj.Enabled=false
elseif obj:IsA("Explosion")then
obj:Destroy()
end
end
end
end
local function ToggleRemoveTextures()
if CheatEnabled.RemoveTextures then
for _,obj in pairs(Workspace:GetDescendants())do
if obj:IsA("Decal")or obj:IsA("Texture")then
obj.Transparency=1
elseif obj:IsA("BasePart")then
obj.Material=Enum.Material.Plastic
obj.Color=Color3.fromRGB(128,128,128)
end
end
end
end
local function ToggleAntiKick()
if CheatEnabled.AntiKick then
local mt=getrawmetatable(game)
local oldmt=mt.__namecall
setreadonly(mt,false)
mt.__namecall=newcclosure(function(self,...)
local method=getnamecallmethod()
if method=="Kick"then return end
return oldmt(self,...)
end)
end
end
local function ToggleAimbot()
if CheatEnabled.Aimbot then
if not Connections.Aimbot then
Connections.Aimbot=RunService.RenderStepped:Connect(function()
local target=GetClosestPlayer()
if target and target.Character and target.Character:FindFirstChild("Head")then
Camera.CFrame=CFrame.lookAt(Camera.CFrame.Position,target.Character.Head.Position)
end
end)
end
else
if Connections.Aimbot then Connections.Aimbot:Disconnect()Connections.Aimbot=nil end
end
end
local function ToggleAutoParkour()
if CheatEnabled.AutoParkour then
if not Connections.AutoParkour then
Connections.AutoParkour=RunService.Heartbeat:Connect(function()
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")then
local humanoid=LocalPlayer.Character.Humanoid
if humanoid.MoveDirection.Magnitude>0 then
if humanoid.FloorMaterial==Enum.Material.Air then
humanoid.Jump=true
end
end
end
end)
end
else
if Connections.AutoParkour then Connections.AutoParkour:Disconnect()Connections.AutoParkour=nil end
end
end
local function ToggleSpeedGlitch()
if CheatEnabled.SpeedGlitch then
if not Connections.SpeedGlitch then
Connections.SpeedGlitch=RunService.Heartbeat:Connect(function()
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")then
LocalPlayer.Character.HumanoidRootPart.Velocity=LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector*200
end
end)
end
else
if Connections.SpeedGlitch then Connections.SpeedGlitch:Disconnect()Connections.SpeedGlitch=nil end
end
end
local function ToggleFullbright()
if CheatEnabled.Fullbright then
Lighting.Brightness=2
Lighting.ClockTime=14
Lighting.FogEnd=math.huge
Lighting.GlobalShadows=false
Lighting.OutdoorAmbient=Color3.fromRGB(128,128,128)
else
Lighting.Brightness=1
Lighting.ClockTime=14
Lighting.FogEnd=100000
Lighting.GlobalShadows=true
Lighting.OutdoorAmbient=Color3.fromRGB(70,70,70)
end
end
local function ToggleNoFog()
if CheatEnabled.NoFog then
Lighting.FogEnd=math.huge
else
Lighting.FogEnd=100000
end
end
local function ToggleXray()
if CheatEnabled.Xray then
for _,obj in pairs(Workspace:GetDescendants())do
if obj:IsA("BasePart")then
obj.Transparency=0.5
end
end
else
for _,obj in pairs(Workspace:GetDescendants())do
if obj:IsA("BasePart")then
obj.Transparency=0
end
end
end
end
local function ToggleSpinBot()
if CheatEnabled.SpinBot then
if not Connections.SpinBot then
Connections.SpinBot=RunService.Heartbeat:Connect(function()
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")then
LocalPlayer.Character.HumanoidRootPart.CFrame=LocalPlayer.Character.HumanoidRootPart.CFrame*CFrame.Angles(0,math.rad(CheatSettings.SpinSpeed),0)
end
end)
end
else
if Connections.SpinBot then Connections.SpinBot:Disconnect()Connections.SpinBot=nil end
end
end
local function ToggleKillAura()
if CheatEnabled.KillAura then
if not Connections.KillAura then
Connections.KillAura=RunService.Heartbeat:Connect(function()
local target=GetClosestPlayer()
if target and target.Character and target.Character:FindFirstChild("Humanoid")then
target.Character.Humanoid.Health=0
end
end)
end
else
if Connections.KillAura then Connections.KillAura:Disconnect()Connections.KillAura=nil end
end
end
local function ToggleFreezeAll()
for _,player in pairs(Players:GetPlayers())do
if player~=LocalPlayer then FreezePlayer(player)end
end
end
local function TeleportAllPlayers()
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")then
for _,player in pairs(Players:GetPlayers())do
if player~=LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart")then
player.Character.HumanoidRootPart.CFrame=LocalPlayer.Character.HumanoidRootPart.CFrame
end
end
end
end
local function DeleteMap()
for _,obj in pairs(Workspace:GetChildren())do
if obj.Name~="Camera"and not obj:IsA("Terrain")and not Players:GetPlayerFromCharacter(obj)then
obj:Destroy()
end
end
end
local function CloneTools()
if LocalPlayer.Backpack then
for _,tool in pairs(LocalPlayer.Backpack:GetChildren())do
if tool:IsA("Tool")then
tool:Clone().Parent=LocalPlayer.Backpack
end
end
end
end
local function LoadInfiniteYield()
loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end
local Window=Rayfield:CreateWindow({Name="Mr.Hekran Ultimate Menu v[Infinity]",LoadingTitle="Ultimate Cheat Menu",LoadingSubtitle="by Mr.Hekran",ConfigurationSaving={Enabled=true,FolderName="MrHekranMenu",FileName="Ultimate"},Discord={Enabled=false,Invite="noinvitelink",RememberJoins=true},KeySystem=false})
local TeleportTab=Window:CreateTab("🚀 Teleportation",4483362458)
UpdatePlayerList()
local PlayerDropdownTeleport=TeleportTab:CreateDropdown({Name="Select Player",Options=PlayerDropdown,CurrentOption=PlayerDropdown[1]or"None",Callback=function(Option)local targetPlayer=Players:FindFirstChild(Option)if targetPlayer then TeleportToPlayer(targetPlayer)end end})
TeleportTab:CreateButton({Name="Teleport to Closest Player",Callback=function()local closest=GetClosestPlayer()if closest then TeleportToPlayer(closest)end end})
TeleportTab:CreateButton({Name="Teleport Behind Closest Player",Callback=function()local closest=GetClosestPlayer()if closest then TeleportBehindPlayer(closest)end end})
local TeleportXInput=TeleportTab:CreateInput({Name="X Position",PlaceholderText="Enter X coordinate",RemoveTextAfterFocusLost=false,Callback=function(Text)CheatSettings.TeleportX=tonumber(Text)or 0 end})
local TeleportYInput=TeleportTab:CreateInput({Name="Y Position",PlaceholderText="Enter Y coordinate",RemoveTextAfterFocusLost=false,Callback=function(Text)CheatSettings.TeleportY=tonumber(Text)or 0 end})
local TeleportZInput=TeleportTab:CreateInput({Name="Z Position",PlaceholderText="Enter Z coordinate",RemoveTextAfterFocusLost=false,Callback=function(Text)CheatSettings.TeleportZ=tonumber(Text)or 0 end})
TeleportTab:CreateButton({Name="Teleport to Coordinates",Callback=function()TeleportTo(Vector3.new(CheatSettings.TeleportX,CheatSettings.TeleportY,CheatSettings.TeleportZ))end})
local PlayerTab=Window:CreateTab("👤 Player Utils",4483362458)
local SpeedToggle=PlayerTab:CreateToggle({Name="Speed Hack",CurrentValue=false,Callback=function(Value)CheatEnabled.Speed=Value SetSpeed()end})
local SpeedSlider=PlayerTab:CreateSlider({Name="Walk Speed",Range={16,500},Increment=1,Suffix=" Speed",CurrentValue=50,Callback=function(Value)CheatSettings.WalkSpeed=Value if CheatEnabled.Speed then SetSpeed()end end})
local JumpToggle=PlayerTab:CreateToggle({Name="Jump Hack",CurrentValue=false,Callback=function(Value)CheatEnabled.Jump=Value SetJump()end})
local JumpSlider=PlayerTab:CreateSlider({Name="Jump Power",Range={50,500},Increment=1,Suffix=" Power",CurrentValue=100,Callback=function(Value)CheatSettings.JumpPower=Value if CheatEnabled.Jump then SetJump()end end})
local NoclipToggle=PlayerTab:CreateToggle({Name="Noclip",CurrentValue=false,Callback=function(Value)CheatEnabled.Noclip=Value ToggleNoclip()end})
local FlyToggle=PlayerTab:CreateToggle({Name="Fly",CurrentValue=false,Callback=function(Value)CheatEnabled.Fly=Value ToggleFly()end})
local FlySlider=PlayerTab:CreateSlider({Name="Fly Speed",Range={10,200},Increment=1,Suffix=" Speed",CurrentValue=50,Callback=function(Value)CheatSettings.FlySpeed=Value end})
local VisualTab=Window:CreateTab("👁️ Visuals",4483362458)
local ESPToggle=VisualTab:CreateToggle({Name="Player ESP",CurrentValue=false,Callback=function(Value)CheatEnabled.ESP=Value ToggleESP()end})
local TracersToggle=VisualTab:CreateToggle({Name="Player Tracers",CurrentValue=false,Callback=function(Value)CheatEnabled.Tracers=Value ToggleTracers()end})
local BoxesToggle=VisualTab:CreateToggle({Name="Player Boxes",CurrentValue=false,Callback=function(Value)CheatEnabled.Boxes=Value ToggleBoxes()end})
local ChamsToggle=VisualTab:CreateToggle({Name="Player Chams",CurrentValue=false,Callback=function(Value)CheatEnabled.Chams=Value ToggleChams()end})
local HighlightsToggle=VisualTab:CreateToggle({Name="Player Highlights",CurrentValue=false,Callback=function(Value)CheatEnabled.PlayerHighlights=Value TogglePlayerHighlights()end})
local CombatTab=Window:CreateTab("⚔️ Combat",4483362458)
local KillAuraToggle=CombatTab:CreateToggle({Name="Kill Aura",CurrentValue=false,Callback=function(Value)CheatEnabled.KillAura=Value ToggleKillAura()end})
local GodModeToggle=CombatTab:CreateToggle({Name="God Mode",CurrentValue=false,Callback=function(Value)CheatEnabled.GodMode=Value ToggleGodMode()end})
local InfiniteHealthToggle=CombatTab:CreateToggle({Name="Infinite Health",CurrentValue=false,Callback=function(Value)CheatEnabled.InfiniteHealth=Value ToggleInfiniteHealth()end})
local FarmTab=Window:CreateTab("🌾 Auto Farm",4483362458)
local AutoFarmCoinsToggle=FarmTab:CreateToggle({Name="Auto Farm Coins",CurrentValue=false,Callback=function(Value)CheatEnabled.AutoFarmCoins=Value ToggleAutoFarmCoins()end})
local AutoClickToggle=FarmTab:CreateToggle({Name="Auto Click All",CurrentValue=false,Callback=function(Value)CheatEnabled.AutoClick=Value ToggleAutoClick()end})
local MiscTab=Window:CreateTab("🔧 Misc",4483362458)
local InvisibleToggle=MiscTab:CreateToggle({Name="Invisible Character",CurrentValue=false,Callback=function(Value)CheatEnabled.Invisible=Value ToggleInvisible()end})
local AntiAfkToggle=MiscTab:CreateToggle({Name="Anti AFK",CurrentValue=false,Callback=function(Value)CheatEnabled.AntiAfk=Value ToggleAntiAfk()end})
local FpsBoostToggle=MiscTab:CreateToggle({Name="FPS Boost",CurrentValue=false,Callback=function(Value)CheatEnabled.FpsBoost=Value ToggleFpsBoost()end})
MiscTab:CreateButton({Name="Server Hop",Callback=function()ServerHop()end})
local SettingsTab=Window:CreateTab("⚙️ Settings",4483362458)
SettingsTab:CreateButton({Name="Refresh Player List",Callback=function()UpdatePlayerList()PlayerDropdownTeleport:Refresh(PlayerDropdown,PlayerDropdown[1]or"None")end})
local AdvancedTab=Window:CreateTab("🔬 Advanced",4483362458)
local AntiLagToggle=AdvancedTab:CreateToggle({Name="Anti Lag",CurrentValue=false,Callback=function(Value)CheatEnabled.AntiLag=Value ToggleAntiLag()end})
local RemoveTexturesToggle=AdvancedTab:CreateToggle({Name="Remove Textures",CurrentValue=false,Callback=function(Value)CheatEnabled.RemoveTextures=Value ToggleRemoveTextures()end})
local AntiKickToggle=AdvancedTab:CreateToggle({Name="Anti Kick",CurrentValue=false,Callback=function(Value)CheatEnabled.AntiKick=Value ToggleAntiKick()end})
local AimbotToggle=AdvancedTab:CreateToggle({Name="Aimbot",CurrentValue=false,Callback=function(Value)CheatEnabled.Aimbot=Value ToggleAimbot()end})
local ExploitsTab=Window:CreateTab("💥 Exploits",4483362458)
local AutoParkourToggle=ExploitsTab:CreateToggle({Name="Auto Parkour",CurrentValue=false,Callback=function(Value)CheatEnabled.AutoParkour=Value ToggleAutoParkour()end})
local SpeedGlitchToggle=ExploitsTab:CreateToggle({Name="Speed Glitch",CurrentValue=false,Callback=function(Value)CheatEnabled.SpeedGlitch=Value ToggleSpeedGlitch()end})
local ToolsTab=Window:CreateTab("🔧 Tools",4483362458)
local InfiniteToolsToggle=ToolsTab:CreateToggle({Name="Infinite Tools",CurrentValue=false,Callback=function(Value)CheatEnabled.InfiniteTools=Value ToggleInfiniteTools()end})
ToolsTab:CreateButton({Name="Clone All Tools",Callback=function()CloneTools()end})
local WorldTab=Window:CreateTab("🌍 World",4483362458)
local FullbrightToggle=WorldTab:CreateToggle({Name="Fullbright",CurrentValue=false,Callback=function(Value)CheatEnabled.Fullbright=Value ToggleFullbright()end})
local NoFogToggle=WorldTab:CreateToggle({Name="No Fog",CurrentValue=false,Callback=function(Value)CheatEnabled.NoFog=Value ToggleNoFog()end})
local XrayToggle=WorldTab:CreateToggle({Name="X-Ray Vision",CurrentValue=false,Callback=function(Value)CheatEnabled.Xray=Value ToggleXray()end})
local TimeSlider=WorldTab:CreateSlider({Name="Time of Day",Range={0,24},Increment=0.1,Suffix=" Hour",CurrentValue=14,Callback=function(Value)CheatSettings.TimeValue=Value Lighting.ClockTime=Value end})
local GravitySlider=WorldTab:CreateSlider({Name="Gravity",Range={0,500},Increment=1,Suffix=" Force",CurrentValue=196.2,Callback=function(Value)CheatSettings.GravityValue=Value Workspace.Gravity=Value end})
local MovementTab=Window:CreateTab("🏃 Movement",4483362458)
local BunnyHopToggle=MovementTab:CreateToggle({Name="Bunny Hop",CurrentValue=false,Callback=function(Value)CheatEnabled.BunnyHop=Value ToggleBunnyHop()end})
local AntiVoidToggle=MovementTab:CreateToggle({Name="Anti Void",CurrentValue=false,Callback=function(Value)CheatEnabled.AntiVoid=Value ToggleAntiVoid()end})
local SpinBotToggle=MovementTab:CreateToggle({Name="Spin Bot",CurrentValue=false,Callback=function(Value)CheatEnabled.SpinBot=Value ToggleSpinBot()end})
local SpinSpeedSlider=MovementTab:CreateSlider({Name="Spin Speed",Range={1,50},Increment=1,Suffix=" Speed",CurrentValue=10,Callback=function(Value)CheatSettings.SpinSpeed=Value end})
local EffectsTab=Window:CreateTab("✨ Effects",4483362458)
EffectsTab:CreateColorPicker({Name="ESP Color",Color=Color3.fromRGB(255,0,0),Callback=function(Value)CheatSettings.ESPColor=Value end})
EffectsTab:CreateColorPicker({Name="Tracer Color",Color=Color3.fromRGB(0,255,0),Callback=function(Value)CheatSettings.TracerColor=Value end})
EffectsTab:CreateColorPicker({Name="Box Color",Color=Color3.fromRGB(0,0,255),Callback=function(Value)CheatSettings.BoxColor=Value end})
local AdminTab=Window:CreateTab("👑 Admin",4483362458)
AdminTab:CreateButton({Name="Freeze All Players",Callback=function()ToggleFreezeAll()end})
AdminTab:CreateButton({Name="Teleport All to Me",Callback=function()TeleportAllPlayers()end})
AdminTab:CreateButton({Name="Delete Map",Callback=function()DeleteMap()end})
local UtilitiesTab=Window:CreateTab("🛠️ Utilities",4483362458)
local ChatSpamToggle=UtilitiesTab:CreateToggle({Name="Chat Spam",CurrentValue=false,Callback=function(Value)CheatEnabled.ChatSpam=Value ToggleChatSpam()end})
local ChatSpamInput=UtilitiesTab:CreateInput({Name="Spam Message",PlaceholderText="Enter message to spam",RemoveTextAfterFocusLost=false,Callback=function(Text)CheatSettings.ChatSpamMessage=Text end})
local InfiniteStaminaToggle=UtilitiesTab:CreateToggle({Name="Infinite Stamina",CurrentValue=false,Callback=function(Value)CheatEnabled.InfiniteStamina=Value ToggleInfiniteStamina()end})
UtilitiesTab:CreateButton({Name="Load Infinite Yield",Callback=function()LoadInfiniteYield()end})
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
LocalPlayer.CharacterAdded:Connect(function(character)
Character=character
Humanoid=character:WaitForChild("Humanoid")
RootPart=character:WaitForChild("HumanoidRootPart")
if CheatEnabled.Speed then SetSpeed()end
if CheatEnabled.Jump then SetJump()end
end)
print("Mr.Hekran Ultimate Menu v[Infinity] Loaded Successfully!")
print("by Farzadmnz&Sepehr")
print("Made by Mr.Hekran")
