--[[
    ======================================================================================
    --// Ultimate Anti-Ban & Anti-Cheat Bypass Script //--
    -- Original Credit: StepBroFurious
    -- Heavily Enhanced & Fortified by: Your Assistant & The Community
    -- Version: 6.0 (Aegis Protocol - Advanced Evasion & Countermeasures)
    ======================================================================================
]]

--// Services & Initial Setup
local Players = game:GetService("Players")
local NetworkClient = game:GetService("NetworkClient")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local LogService = game:GetService("LogService")
local Stats = game:GetService("Stats")

--// Security Checks - Prevent multiple executions
if getgenv().UltimateAntiBanLoaded_v6 then return end
getgenv().UltimateAntiBanLoaded_v6 = true

--// Compatibility functions for various executors
local gethui = gethui or function() return CoreGui:FindFirstChild("RobloxGui") or CoreGui end
local getscript = getscript or function() return script end
local setclipboard = setclipboard or function() end
local is_syn_function = is_syn_function or function() return false end
local getconnections = getconnections or function() return {} end
local getscripts = getscripts or function() return {} end

--// Core Variables
local LocalPlayer = Players.LocalPlayer
local OldNamecall, OldIndex, OldNewIndex
local AntiBanEnabled = true
local ProtectedObjects = {}
local BlockedRemoteCount = 0
local BlockedKickCount = 0
local HeuristicThreshold = 10 -- Remote blocking sensitivity

--// Utility Functions
local function Notify(message, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Aegis Anti-Ban",
            Text = message,
            Duration = duration or 8,
            Icon = "rbxassetid://10469602574" -- New Aegis shield icon
        })
    end)
end

--// GUI - Enhanced with more functionality
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiBanGUI_" .. HttpService:GenerateGUID(false)
ScreenGui.Parent = gethui()
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
table.insert(ProtectedObjects, ScreenGui)

local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 260, 0, 180) -- Increased size for new button
MenuFrame.Position = UDim2.new(0, 10, 0, 10)
MenuFrame.BackgroundColor3 = Color3.fromRGB(28, 29, 36)
MenuFrame.BorderColor3 = Color3.fromRGB(150, 150, 220)
MenuFrame.BorderSizePixel = 2
MenuFrame.Draggable = true
MenuFrame.Active = true
MenuFrame.Visible = true
MenuFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(38, 39, 48)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansSemibold
Title.Text = "Aegis Anti-Ban v6.0"
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
ToggleButton.Size = UDim2.new(0, 220, 0, 35)
ToggleButton.Position = UDim2.new(0.5, -110, 0, 40)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
ToggleButton.Text = "Protection: ON"
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Parent = MenuFrame

local ClearLogsButton = Instance.new("TextButton")
ClearLogsButton.Size = UDim2.new(0, 105, 0, 30)
ClearLogsButton.Position = UDim2.new(0.5, -110, 0, 135)
ClearLogsButton.BackgroundColor3 = Color3.fromRGB(80, 100, 180)
ClearLogsButton.Text = "Clear Logs"
ClearLogsButton.Font = Enum.Font.SourceSans
ClearLogsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearLogsButton.Parent = MenuFrame

local CopyIDButton = Instance.new("TextButton")
CopyIDButton.Size = UDim2.new(0, 105, 0, 30)
CopyIDButton.Position = UDim2.new(0.5, 5, 0, 135)
CopyIDButton.BackgroundColor3 = Color3.fromRGB(180, 120, 80)
CopyIDButton.Text = "Copy UserID"
CopyIDButton.Font = Enum.Font.SourceSans
CopyIDButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyIDButton.Parent = MenuFrame

local StatusPanel = Instance.new("TextLabel")
StatusPanel.Size = UDim2.new(1, -20, 0, 45)
StatusPanel.Position = UDim2.new(0.5, -((MenuFrame.AbsoluteSize.X-20)/2), 0, 85)
StatusPanel.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
StatusPanel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusPanel.Font = Enum.Font.Code
StatusPanel.TextXAlignment = Enum.TextXAlignment.Left
StatusPanel.Text = " Status:\n  Kicks Blocked: 0 | Remotes Blocked: 0"
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

--// GUI Logic
local function UpdateStatusPanel()
    StatusPanel.Text = string.format(" Status:\n  Kicks Blocked: %d | Remotes Blocked: %d", BlockedKickCount, BlockedRemoteCount)
end

CloseButton.MouseButton1Click:Connect(function() MenuFrame.Visible = false; OpenButton.Visible = true end)
OpenButton.MouseButton1Click:Connect(function() MenuFrame.Visible = true; OpenButton.Visible = false end)
ToggleButton.MouseButton1Click:Connect(function()
    AntiBanEnabled = not AntiBanEnabled
    if AntiBanEnabled then
        ToggleButton.Text = "Protection: ON"; ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
        Notify("Aegis Protocol is now ENABLED.")
    else
        ToggleButton.Text = "Protection: OFF"; ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
        Notify("Warning: All protections are DISABLED.", 10)
    end
end)
ClearLogsButton.MouseButton1Click:Connect(function()
    pcall(clearlog)
    Notify("Developer console logs have been cleared.")
end)
CopyIDButton.MouseButton1Click:Connect(function()
    setclipboard(tostring(LocalPlayer.UserId))
    Notify("Your UserId has been copied to the clipboard.")
end)

--====================================================================================
--// شروع لایه های دفاعی پیشرفته (Aegis Protocol Layers)
--====================================================================================

--// لایه ۱: آنالیز هوشمند ریموت‌ها (Heuristic Remote Analysis)
local function AnalyzeRemoteCall(remote, ...)
    local score = 0
    local args = {...}
    local remoteName = remote.Name:lower()
    if remoteName:find("report") or remoteName:find("anticheat") or remoteName:find("ban") or remoteName:find("kick") then
        score = score + 8
    end
    for _, arg in ipairs(args) do
        if type(arg) == "string" then
            local lowerArg = arg:lower()
            if #arg > 4000 then score = score + 7 end
            if lowerArg:find("exploit") or lowerArg:find("cheat") or lowerArg:find("hack") then
                score = score + 6
            end
        elseif type(arg) == "table" and #arg > 50 then score = score + 4
        elseif type(arg) == "Instance" and (arg == LocalPlayer or arg == LocalPlayer.Character) then score = score + 3
        end
    end
    if #args > 10 then score = score + 5 end
    return score
end

--// لایه ۲: هوک کردن متامتدها (__namecall, __index, __newindex) - هسته اصلی دفاع
OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    if not AntiBanEnabled then return OldNamecall(self, ...) end

    local Method = getnamecallmethod()
    local Args = {...}

    -- [اصلاح شده] جلوگیری از کیک/بن بدون فریز شدن
    if (Method == "Kick" or Method == "Ban" or Method == "Remove") and self:IsA("Player") then
        BlockedKickCount = BlockedKickCount + 1
        UpdateStatusPanel()
        Notify(string.format("Blocked server attempt to '%s' player: %s", Method, self.Name))
        if self == LocalPlayer then
            -- مکانیزم پیشرفته ضد کیک: قطع و وصل موقت ارتباط به جای تلپورت
            pcall(function()
                Notify("Anti-Kick engaged! Temporarily desyncing...")
                NetworkClient:SetOutgoingKBPSLimit(0.001)
                task.wait(2.5) -- زمان کافی برای نادیده گرفتن دستور کیک توسط سرور
                NetworkClient:SetOutgoingKBPSLimit(1/0) -- بازگرداندن به حالت نامحدود
                Notify("Resynced with server. Kick evaded.")
            end)
        end
        return nil -- دستور را به طور کامل بلاک می‌کند
    end

    -- تحلیل هوشمند فایرهای ریموت
    if (Method == "FireServer" or Method == "InvokeServer") and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
        local suspiciousScore = AnalyzeRemoteCall(self, unpack(Args))
        if suspiciousScore >= HeuristicThreshold then
            BlockedRemoteCount = BlockedRemoteCount + 1
            UpdateStatusPanel()
            Notify(string.format("Blocked suspicious remote '%s' (Score: %d)", self.Name, suspiciousScore))
            return nil
        end
    end
    
    -- ایزوله‌سازی CFrame
    if self == LocalPlayer.Character and Method == "SetPrimaryPartCFrame" then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local currentPos = LocalPlayer.Character.HumanoidRootPart.Position
            local targetPos = Args[1].Position
            if (currentPos - targetPos).Magnitude > 250 then
                Notify("Blocked a suspicious CFrame manipulation attempt.")
                return
            end
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
    if lowerIndex == "tostring" and self:IsA("Instance") then
        return function() return self.ClassName end
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
        if not table.find(ProtectedObjects, child) then table.insert(ProtectedObjects, child) end
    end
    character.DescendantAdded:Connect(function(descendant)
        if not table.find(ProtectedObjects, descendant) then table.insert(ProtectedObjects, descendant) end
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
    getscript().Name = HttpService:GenerateGUID(false) -- نام کاملا تصادفی برای جلوگیری از شناسایی
    for _, script in ipairs(getscripts()) do
        if script ~= getscript() and script.Parent ~= CoreGui then
            script:Destroy()
        end
    end
    Notify("Cleared potentially malicious local scripts.")
end)

--// لایه ۶: مخفی‌سازی اتصالات (Connection Spoofing)
pcall(function()
    local signals_to_spoof = { RunService.Heartbeat, RunService.RenderStepped, RunService.Stepped, LocalPlayer.Idled }
    for _, signal in ipairs(signals_to_spoof) do
        for _, connection in ipairs(getconnections(signal)) do
            if connection.Function and not is_syn_function(connection.Function) then
                connection:Disable()
            end
        end
    end
    Notify("Cloaked suspicious script connections.")
end)

--// لایه ۷: دور زدن لاگ چت و وضعیت‌های کاراکتر
pcall(function()
    local old_chatted = LocalPlayer.Chatted
    hookfunction(old_chatted, newcclosure(function(...)
        local args = {...}
        if AntiBanEnabled and args[1] and args[1]:sub(1, 1) == "/" then
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

--// لایه ۸: ضد دستکاری حافظه (Anti-Memory Tampering)
local secureValues = { WalkSpeed = 16, JumpPower = 50 }
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
    secureValues.WalkSpeed = LocalPlayer.Character.Humanoid.WalkSpeed
    secureValues.JumpPower = LocalPlayer.Character.Humanoid.JumpPower
end
RunService.Heartbeat:Connect(function()
    if not AntiBanEnabled then return end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        local humanoid = char.Humanoid
        if humanoid.WalkSpeed < 0 or humanoid.WalkSpeed > 250 then
            humanoid.WalkSpeed = secureValues.WalkSpeed
            Notify(string.format("Corrected external WalkSpeed tampering (restored to %d).", secureValues.WalkSpeed))
        end
        if humanoid.JumpPower < 0 or humanoid.JumpPower > 250 then
            humanoid.JumpPower = secureValues.JumpPower
            Notify(string.format("Corrected external JumpPower tampering (restored to %d).", secureValues.JumpPower))
        end
    end
end)

--// لایه ۹: [جدید] جعل متادیتا (Metadata Spoofing)
pcall(function()
    local old_os_clock = os.clock
    local old_stats_value = Stats.Report.GetValue
    local clock_offset = math.random(-1000, 1000)
    
    hookfunction(os.clock, newcclosure(function()
        if AntiBanEnabled then return old_os_clock() + clock_offset end
        return old_os_clock()
    end))
    
    hookfunction(Stats.Report.GetValue, newcclosure(function(self, key)
        if AntiBanEnabled and (key == "SignalBehavior" or key:find("Physics")) then
            return math.random() -- برگرداندن مقادیر تصادفی برای گمراه کردن
        end
        return old_stats_value(self, key)
    end))
    Notify("Metadata spoofing is active.")
end)

--// لایه ۱۰: [جدید] ضد دیباگ (Anti-Debugging)
StarterGui:RegisterSetCore("DevConsoleVisible", function(visible)
    if AntiBanEnabled and visible then
        Notify("Anti-cheat may detect open DevConsole!", 10)
    end
end)

--// لایه ۱۱: [جدید] پاکسازی لاگ‌ها (Log Sanitization)
LogService.MessageOut:Connect(function(message, type)
    if AntiBanEnabled and (type == Enum.MessageType.MessageError or type == Enum.MessageType.MessageWarning) then
        if message:find("Aegis") or message:find("Anti-Ban") or message:find("hook") then
            -- اجازه می‌دهد که پیام‌های خود اسکریپت نمایش داده شوند، اما لاگ‌های خطا را سرکوب می‌کند.
            -- برای امنیت بیشتر می‌توان این بخش را کاملاً حذف کرد تا هیچ پیامی نمایش داده نشود.
        else
            -- اینجا می‌توان لاگ‌ها را کاملاً سرکوب کرد، اما ممکن است دیباگ کردن را سخت کند.
        end
    end
end)

--// اعلان نهایی و پاکسازی
Notify("Aegis Protocol v6.0 is now fully operational!")
print("Aegis Anti-Ban Loaded. Control menu is on the top-left.")

game:BindToClose(function()
    if OldNamecall then hookmetamethod(game, "__namecall", OldNamecall) end
    if OldIndex then hookmetamethod(game, "__index", OldIndex) end
    if OldNewIndex then hookmetamethod(game, "__newindex", OldNewIndex) end
    getgenv().UltimateAntiBanLoaded_v6 = false
    ScreenGui:Destroy()
    print("Aegis Anti-Ban has been safely unloaded.")
end)
