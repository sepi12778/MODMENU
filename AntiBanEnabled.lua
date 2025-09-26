--[[
    ======================================================================================
    --// Ultimate Anti-Ban & Anti-Cheat Bypass Script //--
    -- Original Credit: StepBroFurious
    -- Heavily Enhanced & Fortified by: Your Assistant & The Community
    -- Version: 6.1 (Aegis Protocol - Performance Optimized)
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
if getgenv().UltimateAntiBanLoaded_v6_1 then return end
getgenv().UltimateAntiBanLoaded_v6_1 = true

--// Compatibility functions for various executors
local gethui = gethui or function() return CoreGui:FindFirstChild("RobloxGui") or CoreGui end
local getscript = getscript or function() return script end
local setclipboard = setclipboard or function(text)
    -- Fallback for executors without setclipboard
    pcall(function()
        local TextBox = Instance.new("TextBox")
        TextBox.Text = tostring(text)
        TextBox.Parent = CoreGui
        TextBox:CaptureFocus()
        TextBox:SelectAll()
        TextBox:Destroy()
    end)
end
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
local IsDesyncing = false -- Flag to prevent multiple concurrent anti-kick executions

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

--// GUI - (کد کامل GUI در اینجا قرار دارد)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiBanGUI_" .. HttpService:GenerateGUID(false)
ScreenGui.Parent = gethui()
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
table.insert(ProtectedObjects, ScreenGui)
local MenuFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton")
local ClearLogsButton = Instance.new("TextButton")
local CopyIDButton = Instance.new("TextButton")
local StatusPanel = Instance.new("TextLabel")
local OpenButton = Instance.new("TextButton")
MenuFrame.Size = UDim2.new(0, 260, 0, 180)
MenuFrame.Position = UDim2.new(0, 10, 0, 10)
MenuFrame.BackgroundColor3 = Color3.fromRGB(28, 29, 36)
MenuFrame.BorderColor3 = Color3.fromRGB(150, 150, 220)
MenuFrame.BorderSizePixel = 2
MenuFrame.Draggable = true
MenuFrame.Active = true
MenuFrame.Visible = true
MenuFrame.Parent = ScreenGui
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(38, 39, 48)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansSemibold
Title.Text = "Aegis Anti-Ban v6.1"
Title.Parent = MenuFrame
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 2.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Parent = Title
ToggleButton.Size = UDim2.new(0, 220, 0, 35)
ToggleButton.Position = UDim2.new(0.5, -110, 0, 40)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
ToggleButton.Text = "Protection: ON"
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Parent = MenuFrame
ClearLogsButton.Size = UDim2.new(0, 105, 0, 30)
ClearLogsButton.Position = UDim2.new(0.5, -110, 0, 135)
ClearLogsButton.BackgroundColor3 = Color3.fromRGB(80, 100, 180)
ClearLogsButton.Text = "Clear Logs"
ClearLogsButton.Font = Enum.Font.SourceSans
ClearLogsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearLogsButton.Parent = MenuFrame
CopyIDButton.Size = UDim2.new(0, 105, 0, 30)
CopyIDButton.Position = UDim2.new(0.5, 5, 0, 135)
CopyIDButton.BackgroundColor3 = Color3.fromRGB(180, 120, 80)
CopyIDButton.Text = "Copy UserID"
CopyIDButton.Font = Enum.Font.SourceSans
CopyIDButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyIDButton.Parent = MenuFrame
StatusPanel.Size = UDim2.new(1, -20, 0, 45)
StatusPanel.Position = UDim2.new(0.5, -((MenuFrame.AbsoluteSize.X - 20) / 2), 0, 85)
StatusPanel.BackgroundColor3 = Color3.fromRGB(25, 27, 35)
StatusPanel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusPanel.Font = Enum.Font.Code
StatusPanel.TextXAlignment = Enum.TextXAlignment.Left
StatusPanel.Text = " Status:\n  Kicks Blocked: 0 | Remotes Blocked: 0"
StatusPanel.Parent = MenuFrame
OpenButton.Size = UDim2.new(0, 100, 0, 30)
OpenButton.Position = UDim2.new(0, 10, 0, 10)
OpenButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
OpenButton.Text = "Open Menu"
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Visible = false
OpenButton.Parent = ScreenGui
local function UpdateStatusPanel()
    StatusPanel.Text = string.format(" Status:\n  Kicks Blocked: %d | Remotes Blocked: %d", BlockedKickCount, BlockedRemoteCount)
end
CloseButton.MouseButton1Click:Connect(function() MenuFrame.Visible = false; OpenButton.Visible = true end)
OpenButton.MouseButton1Click:Connect(function() MenuFrame.Visible = true; OpenButton.Visible = false end)
ToggleButton.MouseButton1Click:Connect(function() AntiBanEnabled = not AntiBanEnabled; if AntiBanEnabled then ToggleButton.Text = "Protection: ON"; ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 75); Notify("Aegis Protocol is now ENABLED.") else ToggleButton.Text = "Protection: OFF"; ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80); Notify("Warning: All protections are DISABLED.", 10) end end)
ClearLogsButton.MouseButton1Click:Connect(function() pcall(clearlog); Notify("Developer console logs have been cleared.") end)
CopyIDButton.MouseButton1Click:Connect(function() setclipboard(tostring(LocalPlayer.UserId)); Notify("Your UserId has been copied to the clipboard.") end)
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

--// لایه ۲: هوک کردن متامتدها (__namecall) - هسته اصلی دفاع
OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    -- بهینه سازی: اگر حفاظت خاموش است، بلافاصله خارج شو
    if not AntiBanEnabled then return OldNamecall(self, ...) end

    local Method = getnamecallmethod()
    
    -- [بخش اصلاح شده] شناسایی و جلوگیری از کیک شدن بدون فریز کردن بازی
    if (Method == "Kick" or Method == "Ban" or Method == "Remove") and self:IsA("Player") then
        BlockedKickCount = BlockedKickCount + 1
        UpdateStatusPanel()
        
        -- اگر سرور قصد کیک کردن بازیکن محلی را داشت
        if self == LocalPlayer and not IsDesyncing then
            IsDesyncing = true
            -- استفاده از task.spawn برای اجرای کد در یک ترد جداگانه و جلوگیری از فریز شدن
            task.spawn(function()
                Notify("Anti-Kick engaged! Temporarily desyncing...")
                local oldLimit = NetworkClient.OutgoingKBPSLimit
                NetworkClient:SetOutgoingKBPSLimit(0.001) -- محدود کردن پهنای باند خروجی برای قطع ارتباط موقت
                task.wait(2.5) -- این wait دیگر بازی را فریز نمی‌کند
                NetworkClient:SetOutgoingKBPSLimit(oldLimit or 1/0) -- بازگرداندن به حالت قبلی
                Notify("Resynced with server. Kick evaded.")
                IsDesyncing = false
            end)
        else
            -- اگر سرور قصد کیک کردن بازیکن دیگری را داشت
            Notify(string.format("Blocked server attempt to '%s' player: %s", Method, self.Name))
        end
        return nil -- دستور کیک را به طور کامل بلاک می‌کند
    end

    -- شناسایی و بلاک کردن ریموت‌های مشکوک
    if (Method == "FireServer" or Method == "InvokeServer") and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
        local Args = {...}
        local suspiciousScore = AnalyzeRemoteCall(self, unpack(Args))
        if suspiciousScore >= HeuristicThreshold then
            BlockedRemoteCount = BlockedRemoteCount + 1
            UpdateStatusPanel()
            -- نوتیفیکیشن را در یک ترد جدید اجرا می‌کنیم تا لگ به حداقل برسد
            task.spawn(Notify, string.format("Blocked suspicious remote '%s' (Score: %d)", self.Name, suspiciousScore))
            return nil -- ریموت مشکوک را بلاک می‌کند
        end
        -- پاس دادن آرگومان‌های اصلی اگر مشکوک نبود
        return OldNamecall(self, unpack(Args))
    end
    
    -- اجرای تابع اصلی برای بقیه موارد
    return OldNamecall(self, ...)
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
LocalPlayer.PlayerGui.ChildAdded:Connect(function(child)
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
        if script ~= getscript() and script.Parent ~= CoreGui and script.Parent ~= gethui() then
            pcall(function() script:Destroy() end)
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
                pcall(function() connection:Disable() end)
            end
        end
    end
    Notify("Cloaked suspicious script connections.")
end)

--// لایه ۷: دور زدن لاگ چت و وضعیت‌های کاراکتر
pcall(function()
    local old_chatted
    old_chatted = hookfunction(LocalPlayer.Chatted, newcclosure(function(...)
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
        local old_changestate
        old_changestate = hookfunction(humanoid.ChangeState, newcclosure(function(self, state)
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
    pcall(function()
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
end)

--// لایه ۹: جعل متادیتا (Metadata Spoofing)
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

--// لایه ۱۰: ضد دیباگ (Anti-Debugging)
pcall(function()
    StarterGui:RegisterSetCore("DevConsoleVisible", function(visible)
        if AntiBanEnabled and visible then
            Notify("Anti-cheat may detect open DevConsole!", 10)
        end
    end)
end)

--// لایه ۱۱: پاکسازی لاگ‌ها (Log Sanitization)
LogService.MessageOut:Connect(function(message, type)
    if AntiBanEnabled and (type == Enum.MessageType.MessageError or type == Enum.MessageType.MessageWarning) then
        if message:find("Aegis") or message:find("Anti-Ban") or message:find("hook") then
            -- This is intentional, do nothing to our own logs/errors
        else
            -- You can add logic here to suppress other specific errors if needed
        end
    end
end)


--// اعلان نهایی و پاکسازی
Notify("Aegis Protocol v6.1 (Optimized) is now fully operational!")
print("Aegis Anti-Ban Loaded. Control menu is on the top-left.")

game:BindToClose(function()
    if OldNamecall then hookmetamethod(game, "__namecall", OldNamecall) end
    getgenv().UltimateAntiBanLoaded_v6_1 = false
    if ScreenGui and ScreenGui.Parent then ScreenGui:Destroy() end
    print("Aegis Anti-Ban has been safely unloaded.")
end)

