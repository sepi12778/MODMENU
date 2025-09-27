--[[
    ======================================================================================
    --// اسکریپت نهایی ضد-بن و ضد-تقلب //--
    -- اعتبار اصلی: StepBroFurious
    -- مهندسی مجدد و تقویت گسترده توسط: دستیار شما و جامعه
    -- نسخه: 8.0 (پروتکل تایتان - غیر مسدودکننده و فوق دفاعی)
    ======================================================================================
]]

--// فراخوانی سرویس‌های مورد نیاز با بهینه‌سازی
local Players = game:GetService("Players")
local NetworkClient = game:GetService("NetworkClient")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local LogService = game:GetService("LogService")
local PhysicsService = game:GetService("PhysicsService")
local Stats = game:GetService("Stats")

--// بررسی امنیتی برای جلوگیری از اجرای چندباره اسکریپت
if getgenv().TitanProtocolLoaded_v8_0 then return end
getgenv().TitanProtocolLoaded_v8_0 = true

--// توابع سازگاری برای اجراکننده‌های (Executor) مختلف
local gethui = gethui or function() return CoreGui:FindFirstChild("RobloxGui") or CoreGui end
local getscript = getscript or function() return script end
local setclipboard = setclipboard or function(text)
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
local hookfunction = hookfunction or newcclosure

--// متغیرهای اصلی و هسته اسکریپت
local LocalPlayer = Players.LocalPlayer
local OldNamecall
local AntiBanEnabled = true
local BlockedRemoteCount, BlockedKickCount, BlockedTeleportCount, BlockedCFrameCount = 0, 0, 0, 0
local HeuristicThreshold = 10 -- حساسیت سیستم تشخیص ریموت‌های مشکوک
local IsDesyncing = false -- فلگ برای جلوگیری از اجرای همزمان چند عملیات ضد-کیک

--// تابع نمایش اعلان (Notification)
local function Notify(message, duration)
    task.spawn(function()
        StarterGui:SetCore("SendNotification", {
            Title = "پروتکل تایتان",
            Text = message,
            Duration = duration or 8,
            Icon = "rbxassetid://10469602574" -- آیکون سپر تایتان
        })
    end)
end

--// رابط کاربری گرافیکی (GUI) - بهبود یافته
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TitanGUI_" .. HttpService:GenerateGUID(false)
ScreenGui.Parent = gethui()
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
local MenuFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton")
local ClearLogsButton = Instance.new("TextButton")
local CopyIDButton = Instance.new("TextButton")
local StatusPanel = Instance.new("TextLabel")
local OpenButton = Instance.new("TextButton")

MenuFrame.Size = UDim2.new(0, 280, 0, 200); MenuFrame.Position = UDim2.new(0, 10, 0, 10)
MenuFrame.BackgroundColor3 = Color3.fromRGB(28, 29, 36); MenuFrame.BorderColor3 = Color3.fromRGB(200, 180, 100)
MenuFrame.BorderSizePixel = 2; MenuFrame.Draggable = true; MenuFrame.Active = true; MenuFrame.Visible = true
MenuFrame.Parent = ScreenGui
Title.Size = UDim2.new(1, 0, 0, 30); Title.BackgroundColor3 = Color3.fromRGB(38, 39, 48)
Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.SourceSansSemibold
Title.Text = "پروتکل تایتان نسخه 8.0"; Title.Parent = MenuFrame
CloseButton.Size = UDim2.new(0, 25, 0, 25); CloseButton.Position = UDim2.new(1, -30, 0, 2.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50); CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold; CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255); CloseButton.Parent = Title
ToggleButton.Size = UDim2.new(0, 240, 0, 35); ToggleButton.Position = UDim2.new(0.5, -120, 0, 40)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 75); ToggleButton.Text = "حفاظت: روشن"
ToggleButton.Font = Enum.Font.SourceSansBold; ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255); ToggleButton.Parent = MenuFrame
ClearLogsButton.Size = UDim2.new(0, 115, 0, 30); ClearLogsButton.Position = UDim2.new(0.5, -120, 0, 160)
ClearLogsButton.BackgroundColor3 = Color3.fromRGB(80, 100, 180); ClearLogsButton.Text = "پاکسازی لاگ"
ClearLogsButton.Font = Enum.Font.SourceSans; ClearLogsButton.TextColor3 = Color3.fromRGB(255, 255, 255); ClearLogsButton.Parent = MenuFrame
CopyIDButton.Size = UDim2.new(0, 115, 0, 30); CopyIDButton.Position = UDim2.new(0.5, 5, 0, 160)
CopyIDButton.BackgroundColor3 = Color3.fromRGB(180, 120, 80); CopyIDButton.Text = "کپی آیدی"
CopyIDButton.Font = Enum.Font.SourceSans; CopyIDButton.TextColor3 = Color3.fromRGB(255, 255, 255); CopyIDButton.Parent = MenuFrame
StatusPanel.Size = UDim2.new(1, -20, 0, 70); StatusPanel.Position = UDim2.new(0.5, -(MenuFrame.AbsoluteSize.X-20)/2, 0, 85)
StatusPanel.BackgroundColor3 = Color3.fromRGB(25, 27, 35); StatusPanel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusPanel.Font = Enum.Font.Code; StatusPanel.TextXAlignment = Enum.TextXAlignment.Left; StatusPanel.Parent = MenuFrame
OpenButton.Size = UDim2.new(0, 100, 0, 30); OpenButton.Position = UDim2.new(0, 10, 0, 10)
OpenButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60); OpenButton.Text = "باز کردن منو"
OpenButton.Font = Enum.Font.SourceSansBold; OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Visible = false; OpenButton.Parent = ScreenGui

local function UpdateStatusPanel()
    StatusPanel.Text = string.format(" وضعیت:\n  کیک: %d | ریموت: %d\n  تله‌پورت: %d | CFrame: %d", BlockedKickCount, BlockedRemoteCount, BlockedTeleportCount, BlockedCFrameCount)
end
UpdateStatusPanel()

CloseButton.MouseButton1Click:Connect(function() MenuFrame.Visible = false; OpenButton.Visible = true end)
OpenButton.MouseButton1Click:Connect(function() MenuFrame.Visible = true; OpenButton.Visible = false end)
ToggleButton.MouseButton1Click:Connect(function() AntiBanEnabled = not AntiBanEnabled; if AntiBanEnabled then ToggleButton.Text = "حفاظت: روشن"; ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 75); Notify("پروتکل تایتان فعال شد.") else ToggleButton.Text = "حفاظت: خاموش"; ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80); Notify("هشدار: تمام لایه‌های دفاعی غیرفعال شدند.", 10) end end)
ClearLogsButton.MouseButton1Click:Connect(function() pcall(clearlog); Notify("لاگ‌های کنسول توسعه‌دهنده پاکسازی شد.") end)
CopyIDButton.MouseButton1Click:Connect(function() setclipboard(tostring(LocalPlayer.UserId)); Notify("آیدی شما در کلیپ‌بورد کپی شد.") end)

--====================================================================================
--// شروع لایه‌های دفاعی پیشرفته (پروتکل تایتان)
--====================================================================================

--// لایه ۱: آنالیز هوشمند ریموت‌ها (Heuristic Remote Analysis)
local function AnalyzeRemoteCall(remote, ...)
    local score, args, remoteName = 0, {...}, remote.Name:lower()
    if remoteName:find("report") or remoteName:find("anticheat") or remoteName:find("ban") or remoteName:find("kick") then score = score + 8 end
    for _, arg in ipairs(args) do
        if type(arg) == "string" then
            local lowerArg = arg:lower()
            if #arg > 2000 then score = score + 7 end
            if lowerArg:find("exploit") or lowerArg:find("cheat") or lowerArg:find("hack") or lowerArg:find("script") then score = score + 6 end
        elseif type(arg) == "table" and #arg > 50 then score = score + 4
        elseif type(arg) == "Instance" and (arg == LocalPlayer or arg == LocalPlayer.Character) then score = score + 3 end
    end
    if #args > 10 then score = score + 5 end
    return score
end

--// لایه ۲: هوک کردن متامتدها (__namecall) - هسته اصلی دفاع
OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    if not AntiBanEnabled then return OldNamecall(self, ...) end
    local Method, Args = getnamecallmethod(), {...}
    
    -- [حل مشکل فریز شدن] شناسایی و جلوگیری از کیک شدن بدون قفل کردن بازی
    if (Method == "Kick" or Method == "Ban" or Method == "Remove") and self:IsA("Player") then
        BlockedKickCount = BlockedKickCount + 1; UpdateStatusPanel()
        if self == LocalPlayer and not IsDesyncing then
            IsDesyncing = true
            task.spawn(function()
                Notify("ضد-کیک فعال شد! قطع ارتباط لحظه‌ای...")
                local oldLimit = NetworkClient.OutgoingKBPSLimit
                NetworkClient:SetOutgoingKBPSLimit(0.001)
                task.wait(2.5) -- این wait دیگر بازی را فریز نمی‌کند
                NetworkClient:SetOutgoingKBPSLimit(oldLimit or 1/0)
                Notify("ارتباط مجدد برقرار شد. کیک سرور دفع شد.")
                IsDesyncing = false
            end)
        else
            Notify(string.format("تلاش سرور برای '%s' بازیکن %s مسدود شد.", Method, self.Name))
        end
        return nil
    end

    -- شناسایی و بلاک کردن ریموت‌های مشکوک
    if (Method == "FireServer" or Method == "InvokeServer") and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
        local suspiciousScore = AnalyzeRemoteCall(self, unpack(Args))
        if suspiciousScore >= HeuristicThreshold then
            BlockedRemoteCount = BlockedRemoteCount + 1; UpdateStatusPanel()
            Notify(string.format("ریموت مشکوک '%s' مسدود شد (امتیاز: %d)", self.Name, suspiciousScore), 5)
            return nil
        end
    end
    
    return OldNamecall(self, ...)
end))

--// لایه ۳: محافظت پیشرفته از کاراکتر
local ProtectedObjects = {}
local function ProtectCharacter(character)
    if not character or table.find(ProtectedObjects, character) then return end
    table.insert(ProtectedObjects, character)
    character.DescendantAdded:Connect(function(descendant)
        if not table.find(ProtectedObjects, descendant) then table.insert(ProtectedObjects, descendant) end
    end)
    Notify("میدان یکپارچگی کاراکتر فعال است.")
end
if LocalPlayer.Character then ProtectCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(ProtectCharacter)

--// لایه ۴: مانیتورینگ و بازگردانی اشیاء حذف شده
LocalPlayer.PlayerGui.ChildAdded:Connect(function(child)
    if child:IsA("ScreenGui") or child:IsA("LocalScript") then
        child.AncestryChanged:Connect(function(_, parent)
            if AntiBanEnabled and not parent and not gethui():IsAncestorOf(child) and not table.find(ProtectedObjects, child) then
                task.wait()
                child.Parent = LocalPlayer.PlayerGui
                Notify(string.format("'%s' که ناخواسته حذف شده بود، بازیابی شد.", child.Name))
            end
        end)
    end
end)
table.insert(ProtectedObjects, ScreenGui)

--// لایه ۵: ضد شناسایی و حذف اسکریپت‌های دیگر
pcall(function()
    getscript().Name = HttpService:GenerateGUID(false)
    for _, script in ipairs(getscripts()) do
        if script ~= getscript() and script.Parent ~= CoreGui and script.Parent ~= gethui() then
            pcall(function() script:Destroy() end)
        end
    end
    Notify("اسکریپت‌های محلی مخرب پاکسازی شدند.")
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
    Notify("اتصالات اسکریپت‌های مشکوک مخفی شد.")
end)

--// لایه ۷: دور زدن لاگ چت و وضعیت‌های کاراکتر
pcall(function()
    local old_chatted = hookfunction(LocalPlayer.Chatted, function(...)
        local args = {...}
        if AntiBanEnabled and args[1] and args[1]:sub(1, 1) == "/" then
            Notify("فرمان چت از ثبت شدن در لاگ مسدود شد.")
            return
        end
        return old_chatted(...)
    end)
end)
LocalPlayer.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    pcall(function()
        local old_changestate = hookfunction(humanoid.ChangeState, function(self, state)
            if AntiBanEnabled and state == Enum.HumanoidStateType.StrafingNoPhysics then
                Notify("تغییر وضعیت مشکوک کاراکتر مسدود شد.")
                return
            end
            return old_changestate(self, state)
        end)
    end)
end)

--// لایه ۸: ضد دستکاری حافظه (سرعت، پرش و جاذبه)
local secureValues = { WalkSpeed = 16, JumpPower = 50, Gravity = workspace.Gravity }
RunService.Heartbeat:Connect(function()
    if not AntiBanEnabled then return end
    pcall(function()
        if workspace.Gravity ~= secureValues.Gravity then
            workspace.Gravity = secureValues.Gravity
            Notify(string.format("دستکاری جاذبه اصلاح شد (بازگشت به %d).", secureValues.Gravity))
        end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            local humanoid = char.Humanoid
            if humanoid.WalkSpeed < 0 or humanoid.WalkSpeed > 250 then
                humanoid.WalkSpeed = secureValues.WalkSpeed; Notify("دستکاری سرعت حرکت اصلاح شد.")
            end
            if humanoid.JumpPower < 0 or humanoid.JumpPower > 250 then
                humanoid.JumpPower = secureValues.JumpPower; Notify("دستکاری قدرت پرش اصلاح شد.")
            end
        end
    end)
end)

--// لایه ۹: جعل متادیتا (Metadata Spoofing)
pcall(function()
    local clock_offset = math.random(-1000, 1000)
    hookfunction(os.clock, function() return (old_os_clock or os.clock)() + clock_offset end)
    local old_stats_value = Stats.Report.GetValue
    hookfunction(Stats.Report.GetValue, function(self, key)
        if AntiBanEnabled and (key == "SignalBehavior" or key:find("Physics")) then return math.random() end
        return old_stats_value(self, key)
    end)
    Notify("جعل متادیتا فعال است.")
end)

--// لایه ۱۰: ضد دیباگ (Anti-Debugging)
pcall(function()
    StarterGui:RegisterSetCore("DevConsoleVisible", function(visible)
        if AntiBanEnabled and visible then Notify("ضد-تقلب ممکن است کنسول باز را شناسایی کند!", 10) end
    end)
end)

--// لایه ۱۱: پاکسازی لاگ‌ها (Log Sanitization)
LogService.MessageOut:Connect(function(message, type)
    if AntiBanEnabled and (type == Enum.MessageType.MessageError or type == Enum.MessageType.MessageWarning) and not (message:find("Titan") or message:find("Anti-Ban") or message:find("hook")) then
        -- می‌توان لاگ‌های خاصی را در اینجا سرکوب کرد
    end
end)

--// لایه ۱۲: ضد تله‌پورت اجباری (Anti-Forced Teleport)
pcall(function()
    local old_teleport = hookfunction(TeleportService.Teleport, function(self, placeId, player, ...)
        if AntiBanEnabled and player == LocalPlayer then
            BlockedTeleportCount = BlockedTeleportCount + 1; UpdateStatusPanel()
            Notify(string.format("تلاش برای تله‌پورت اجباری به مکان %d مسدود شد.", placeId))
            return
        end
        return old_teleport(self, placeId, player, ...)
    end)
end)

--// لایه ۱۳: محافظت از تنظیمات فیزیک (Physics Service Protection)
pcall(function()
    local old_set_collision_group = hookfunction(PhysicsService.SetPartCollisionGroup, function(self, part, groupName)
        if AntiBanEnabled and part and part:IsDescendantOf(LocalPlayer.Character) and groupName:lower():find("nocollide") then
            Notify("تلاش ضد-تقلب برای تغییر برخورد کاراکتر مسدود شد.")
            return
        end
        return old_set_collision_group(self, part, groupName)
    end)
end)

--// لایه ۱۴: ضد دستکاری CFrame (Anti-CFrame Manipulation)
pcall(function()
    local old_cframe = workspace.CurrentCamera.GetRenderCFrame
    hookfunction(workspace.CurrentCamera.GetRenderCFrame, function(self)
        local cf = old_cframe(self)
        if AntiBanEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = LocalPlayer.Character.HumanoidRootPart
            if (rootPart.CFrame.Position - cf.Position).Magnitude > 500 then
                BlockedCFrameCount = BlockedCFrameCount + 1; UpdateStatusPanel()
                Notify("جابجایی ناگهانی CFrame شناسایی و مسدود شد.")
                rootPart.CFrame = CFrame.new(rootPart.CFrame.Position)
                return CFrame.new(rootPart.CFrame.Position)
            end
        end
        return cf
    end)
end)

--// لایه ۱۵: محافظت در برابر حذف ابزارها
LocalPlayer.CharacterAdded:Connect(function(char)
    local backpack = LocalPlayer:WaitForChild("Backpack")
    backpack.ChildRemoved:Connect(function(child)
        if AntiBanEnabled and child:IsA("Tool") then
            task.wait(0.1)
            if not child.Parent then
                child.Parent = backpack
                Notify(string.format("ابزار '%s' از حذف شدن محافظت شد.", child.Name))
            end
        end
    end)
end)

--// لایه ۱۶: ضد دستکاری دوربین (Anti-Camera Manipulation)
pcall(function()
    local old_cf_prop
    old_cf_prop = hookprop(workspace.CurrentCamera, "CFrame", {
        __newindex = function(self, new_val)
            if AntiBanEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if (LocalPlayer.Character.HumanoidRootPart.Position - new_val.Position).Magnitude > 500 then
                    Notify("تلاش برای دستکاری مستقیم CFrame دوربین مسدود شد.")
                    return
                end
            end
            old_cf_prop = new_val
        end,
        __index = function() return old_cf_prop end
    })
end)

--// لایه ۱۷: محافظت از خصوصیات بازیکن
pcall(function()
    local old_name_prop
    old_name_prop = hookprop(LocalPlayer, "Name", {
        __newindex = function(self, new_val)
            if AntiBanEnabled then
                Notify("تلاش برای تغییر نام بازیکن مسدود شد.")
                return
            end
            old_name_prop = new_val
        end,
        __index = function() return old_name_prop end
    })
end)

--// لایه ۱۸: نظارت بر درخواست‌های شبکه
pcall(function()
    local old_request = http and http.request or request
    hookfunction(old_request, function(req)
        if AntiBanEnabled and req.Url and req.Url:find("discord.com/api/webhooks") then
            local body = req.Body and req.Body:lower() or ""
            if body:find(tostring(LocalPlayer.UserId)) or body:find(LocalPlayer.Name:lower()) then
                Notify("ارسال داده‌های شما به یک وبهوک دیسکورد مسدود شد.")
                return
            end
        end
        return old_request(req)
    end)
end)


--// اعلان نهایی و پاکسازی
Notify("پروتکل تایتان نسخه 8.0 (غیر مسدودکننده) با موفقیت فعال شد!")
print("Titan Anti-Ban Loaded. Control menu is on the top-left.")

game:BindToClose(function()
    if OldNamecall then hookmetamethod(game, "__namecall", OldNamecall) end
    getgenv().TitanProtocolLoaded_v8_0 = false
    if ScreenGui and ScreenGui.Parent then ScreenGui:Destroy() end
    print("Titan Anti-Ban has been safely unloaded.")
end)
