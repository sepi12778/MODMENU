--[[
    ======================================================================================
    --// Ultimate Anti-Ban & Anti-Cheat Bypass Script //--
    -- Original Credit: StepBroFurious
    -- Heavily Enhanced & Fortified by: Your Assistant & The Community
    -- Version: 5.0 (Citadel Edition - Proactive Defense System)
    ======================================================================================
]]

--// Services
local Players = game:GetService("Players")
local NetworkClient = game:GetService("NetworkClient")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

--// Variables & Security Checks
if getgenv().UltimateAntiBanLoaded_v5 then return end
getgenv().UltimateAntiBanLoaded_v5 = true

--// اطمینان از وجود توابع مهم (برای سازگاری با اکسپلویت‌های مختلف)
local gethui = gethui or function() return CoreGui end
local getscript = getscript or function() return script end

local LocalPlayer = Players.LocalPlayer
local OldNamecall, OldIndex, OldNewIndex
local AntiBanEnabled = true
local ProtectedObjects = {}
local BlockedRemoteCount = 0
local BlockedKickCount = 0
local HeuristicThreshold = 10 -- آستانه امتیاز برای بلاک کردن ریموت

--// توابع کمکی (Utilities)
local function Notify(message)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Anti-Ban Citadel",
            Text = message,
            Duration = 8,
            Icon = "rbxassetid://6034226923" -- آیکون جدید
        })
    end)
end

--// رابط کاربری (GUI) - بهبود یافته با پنل وضعیت
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiBanGUI_" .. HttpService:GenerateGUID(false)
ScreenGui.Parent = gethui()
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
table.insert(ProtectedObjects, ScreenGui)

local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 250, 0, 150) -- افزایش اندازه برای پنل وضعیت
MenuFrame.Position = UDim2.new(0, 10, 0, 10)
MenuFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
MenuFrame.BorderColor3 = Color3.fromRGB(120, 120, 180)
MenuFrame.BorderSizePixel = 2
MenuFrame.Draggable = true
MenuFrame.Active = true
MenuFrame.Visible = true
MenuFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 42, 50)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Citadel Anti-Ban v5"
Title.Parent = MenuFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 2.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Parent = Title

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 210, 0, 40)
ToggleButton.Position = UDim2.new(0.5, -105, 0, 40)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
ToggleButton.Text = "Protection: ON"
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Parent = MenuFrame

local StatusPanel = Instance.new("TextLabel")
StatusPanel.Size = UDim2.new(1, -20, 0, 50)
StatusPanel.Position = UDim2.new(0.5, -((MenuFrame.AbsoluteSize.X-20)/2), 0, 90)
StatusPanel.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
StatusPanel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusPanel.Font = Enum.Font.Code
StatusPanel.TextXAlignment = Enum.TextXAlignment.Left
StatusPanel.Text = " Status:\n  Kicks Blocked: 0\n  Remotes Blocked: 0"
StatusPanel.Parent = MenuFrame

local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 100, 0, 30)
OpenButton.Position = UDim2.new(0, 10, 0, 10)
OpenButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
OpenButton.Text = "Open Menu"
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local function UpdateStatusPanel()
    StatusPanel.Text = string.format(" Status:\n  Kicks Blocked: %d\n  Remotes Blocked: %d", BlockedKickCount, BlockedRemoteCount)
end

CloseButton.MouseButton1Click:Connect(function() MenuFrame.Visible = false; OpenButton.Visible = true end)
OpenButton.MouseButton1Click:Connect(function() MenuFrame.Visible = true; OpenButton.Visible = false end)
ToggleButton.MouseButton1Click:Connect(function()
    AntiBanEnabled = not AntiBanEnabled
    if AntiBanEnabled then
        ToggleButton.Text = "Protection: ON"; ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
        Notify("Proactive defense system has been ENABLED.")
    else
        ToggleButton.Text = "Protection: OFF"; ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
        Notify("Warning: All protections are DISABLED.")
    end
end)

--====================================================================================
--// شروع لایه های دفاعی پیشرفته (Proactive Defense Layers)
--====================================================================================

--// لایه ۱: آنالیز هوشمند ریموت‌ها (Heuristic Remote Analysis)
local function AnalyzeRemoteCall(remote, ...)
    local score = 0
    local args = {...}
    local remoteName = remote.Name:lower()

    -- امتیاز بر اساس نام
    if remoteName:find("report") or remoteName:find("anticheat") or remoteName:find("ban") then
        score = score + 8
    end

    -- امتیاز بر اساس آرگومان‌ها
    for _, arg in ipairs(args) do
        if type(arg) == "string" then
            local lowerArg = arg:lower()
            if #arg > 5000 then score = score + 7 end -- رشته‌های بسیار طولانی مشکوک هستند
            if lowerArg:find("exploit") or lowerArg:find("cheat") or lowerArg:find("hack") then
                score = score + 6
            end
        elseif type(arg) == "table" and #arg > 50 then
            score = score + 4 -- جداول بزرگ می‌توانند برای ارسال لاگ استفاده شوند
        elseif type(arg) == "Instance" and arg == LocalPlayer then
             score = score + 3 -- ارسال مستقیم آبجکت پلیر
        end
    end

    -- امتیاز بر اساس تعداد آرگومان‌ها
    if #args > 10 then
        score = score + 5
    end

    return score
end

--// لایه ۲: هوک کردن متامتدها (__namecall, __index, __newindex)
OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    if not AntiBanEnabled then return OldNamecall(self, ...) end

    local Method = getnamecallmethod()
    local Args = {...}

    -- جلوگیری از کیک/بن/حذف
    if (Method == "Kick" or Method == "Ban" or Method == "Remove") and self:IsA("Player") then
        BlockedKickCount = BlockedKickCount + 1
        UpdateStatusPanel()
        Notify(string.format("Blocked server attempt to '%s' player: %s", Method, self.Name))
        if self == LocalPlayer then
            pcall(function()
                NetworkClient:SetOutgoingKBPSLimit(1)
                task.wait(0.2)
                TeleportService:Teleport(1, LocalPlayer)
            end)
            while true do task.wait(1) end
        end
        return nil
    end

    -- تحلیل هوشمند فایرهای ریموت
    if (Method == "FireServer" or Method == "InvokeServer") and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
        local suspiciousScore = AnalyzeRemoteCall(self, unpack(Args))
        if suspiciousScore >= HeuristicThreshold then
            BlockedRemoteCount = BlockedRemoteCount + 1
            UpdateStatusPanel()
            Notify(string.format("Blocked highly suspicious remote call on '%s' (Score: %d)", self.Name, suspiciousScore))
            return nil
        end
    end
    
    -- [جدید] ایزوله‌سازی CFrame
    if self == LocalPlayer.Character and Method == "SetPrimaryPartCFrame" then
        local currentPos = LocalPlayer.Character:GetPrimaryPartCFrame().Position
        local targetPos = Args[1].Position
        if (currentPos - targetPos).Magnitude > 200 then -- جلوگیری از تلپورت‌های ناخواسته توسط سرور
            Notify("Blocked a suspicious CFrame manipulation attempt.")
            return
        end
    end

    return OldNamecall(self, ...)
end))

OldIndex = hookmetamethod(game, "__index", newcclosure(function(self, index)
    if not AntiBanEnabled then return OldIndex(self, index) end
    
    local lowerIndex = type(index) == "string" and index:lower() or ""

    if (self == LocalPlayer or self:IsA("Player")) and (lowerIndex == "kick" or lowerIndex == "ban") then
        Notify(string.format("Blocked access to '%s' on player: %s", index, self.Name))
        return function() end
    end
    
    if lowerIndex == "destroy" and table.find(ProtectedObjects, self) then
         Notify(string.format("Protected '%s' from destruction.", self.Name))
         return function() end
    end
    
    if (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) and (lowerIndex == "onclientevent" or lowerIndex == "onclientinvoke") then
        Notify("Blocked potential RemoteSpy on: " .. self:GetFullName())
        return nil
    end

    -- [جدید] محافظت از __tostring
    if lowerIndex == "tostring" and self:IsA("Instance") then
        local success, obj_type = pcall(function() return self.ClassName end)
        if success then
            return function() return obj_type end -- برگرداندن نام کلاس به جای اطلاعات حساس
        end
    end

    return OldIndex(self, index)
end))

OldNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(self, index, value)
    if not AntiBanEnabled then return OldNewIndex(self, index, value) end
    
    if self == LocalPlayer.Character and (index == "WalkSpeed" or index == "JumpPower") and value > 100 then
        Notify(string.format("Capped unsafe %s change at 100.", index))
        return OldNewIndex(self, index, 100)
    end

    if index == "Parent" and value == nil and table.find(ProtectedObjects, self) then
        Notify(string.format("Protected '%s' from being de-parented.", self.Name))
        return
    end

    return OldNewIndex(self, index, value)
end))

--// لایه ۳: محافظت پیشرفته از کاراکتر
local function ProtectCharacter(character)
    if not character or table.find(ProtectedObjects, character) then return end
    table.insert(ProtectedObjects, character)
    
    for _, child in ipairs(character:GetDescendants()) do
        if not table.find(ProtectedObjects, child) then
            table.insert(ProtectedObjects, child)
        end
    end
    
    character.DescendantAdded:Connect(function(descendant)
        if not table.find(ProtectedObjects, descendant) then
            table.insert(ProtectedObjects, descendant)
        end
    end)
    Notify("Character integrity field is active.")
end

if LocalPlayer.Character then ProtectCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(ProtectCharacter)

--// لایه ۴: مانیتورینگ و بازگردانی اشیاء حذف شده
LocalPlayer.ChildAdded:Connect(function(child)
    if child:IsA("ScreenGui") or child:IsA("LocalScript") then
        child.AncestryChanged:Connect(function(_, parent)
            if AntiBanEnabled and not parent and not gethui():IsAncestorOf(child) then
                task.wait()
                child.Parent = LocalPlayer.PlayerGui
                Notify(string.format("Restored '%s' which was unexpectedly removed.", child.Name))
            end
        end)
    end
end)

--// لایه ۵: ضد شناسایی و حذف اسکریپت‌های دیگر
pcall(function()
    if getscripts then
        for _, script in ipairs(getscripts()) do
            if script ~= getscript() and script.Parent ~= CoreGui then
                script:Destroy()
            end
        end
        Notify("Cleared potentially malicious local scripts.")
    end
    -- [جدید] جعل نام اسکریپت
    getscript().Name = "CameraScript"
end)

--// لایه ۶: مخفی‌سازی اتصالات (Connection Spoofing)
pcall(function()
    if getconnections then
        local signals_to_spoof = {
            RunService.Heartbeat, RunService.RenderStepped, RunService.Stepped, LocalPlayer.Idled
        }
        for _, signal in ipairs(signals_to_spoof) do
            for _, connection in ipairs(getconnections(signal)) do
                if connection.Function and not is_syn_function(connection.Function) then
                    connection:Disable()
                end
            end
        end
        Notify("Cloaked suspicious script connections.")
    end
end)

--// لایه ۷: دور زدن لاگ چت و وضعیت‌های کاراکتر
pcall(function()
    local old_chatted = LocalPlayer.Chatted
    hookfunction(old_chatted, newcclosure(function(...)
        local args = {...}
        if AntiBanEnabled and args[1]:sub(1, 1) == "/" then
            Notify("Blocked a chat command from being logged.")
            return
        end
        return old_chatted(...)
    end))
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    pcall(function()
        local old_changestate = humanoid.ChangeState
        hookfunction(old_changestate, newcclosure(function(self, state)
            if AntiBanEnabled and state == Enum.HumanoidStateType.StrafingNoPhysics then
                Notify("Blocked a suspicious humanoid state change.")
                return
            end
            return old_changestate(self, state)
        end))
    end)
end)

--// لایه ۸: [جدید] ضد دستکاری حافظه (Anti-Memory Tampering)
local secureValues = { WalkSpeed = 16, JumpPower = 50 }
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
    secureValues.WalkSpeed = LocalPlayer.Character.Humanoid.WalkSpeed
    secureValues.JumpPower = LocalPlayer.Character.Humanoid.JumpPower
end

local integrityCheck = Instance.new("BindableEvent")
integrityCheck.Event:Connect(function()
    while AntiBanEnabled and task.wait(1.5) do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            local humanoid = char.Humanoid
            if humanoid.WalkSpeed ~= secureValues.WalkSpeed and not (humanoid:GetState() == Enum.HumanoidStateType.Running) then
                humanoid.WalkSpeed = secureValues.WalkSpeed
                Notify(string.format("Corrected external WalkSpeed tampering (restored to %d).", secureValues.WalkSpeed))
            end
            if humanoid.JumpPower ~= secureValues.JumpPower then
                humanoid.JumpPower = secureValues.JumpPower
                Notify(string.format("Corrected external JumpPower tampering (restored to %d).", secureValues.JumpPower))
            end
        end
    end
end)
integrityCheck:Fire()
Notify("Memory integrity monitoring is now active.")

--// اعلان نهایی و پاکسازی
Notify("Ultimate Anti-Ban v5.0 (Citadel Edition) is now fully operational!")
print("Anti-Ban Citadel Loaded. Control menu is on the top-left.")

game:BindToClose(function()
    if OldNamecall then hookmetamethod(game, "__namecall", OldNamecall) end
    if OldIndex then hookmetamethod(game, "__index", OldIndex) end
    if OldNewIndex then hookmetamethod(game, "__newindex", OldNewIndex) end
    getgenv().UltimateAntiBanLoaded_v5 = false
    ScreenGui:Destroy()
    print("Anti-Ban Citadel has been safely unloaded.")
end)
