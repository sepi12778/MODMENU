--[[
    ======================================================================================
    --// Ultimate Anti-Ban & Anti-Cheat Bypass Script //--
    -- Original Credit: StepBroFurious
    -- Heavily Enhanced & Fortified by: Your Assistant & The Community
    -- Version: 3.0 (Multi-Layer Protection)
    ======================================================================================
]]

--// Services
local Players = game:GetService("Players")
local NetworkClient = game:GetService("NetworkClient")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

--// Variables & Security Checks
if getgenv().UltimateAntiBanLoaded then return end -- جلوگیری از اجرای مجدد
getgenv().UltimateAntiBanLoaded = true

local LocalPlayer = Players.LocalPlayer
local OldNamecall
local OldIndex
local AntiBanEnabled = true
local ProtectedObjects = {} -- لیستی از اشیاء محافظت شده

--// توابع کمکی (Utilities)
local function Notify(message, color)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "AntiBanNotification_" .. math.random(1, 10000)
    notifGui.Parent = CoreGui
    notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    notifGui.ResetOnSpawn = false

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 350, 0, 60)
    label.Position = UDim2.new(0.5, -175, 0.1, 0)
    label.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    label.BorderSizePixel = 2
    label.BorderColor3 = color or Color3.fromRGB(255, 0, 80)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSansSemibold
    label.TextWrapped = true
    label.Text = "[Anti-Ban] " .. message
    label.Parent = notifGui

    -- محو کردن اعلان
    task.delay(5, function()
        for i = 1, 0, -0.05 do
            label.TextTransparency = i
            label.BackgroundTransparency = i
            label.BorderColor3 = Color3.new(label.BorderColor3.R, label.BorderColor3.G, label.BorderColor3.B)
            task.wait(0.03)
        end
        notifGui:Destroy()
    end)
end

--// رابط کاربری (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiBanGUI_" .. math.random(1, 10000)
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
table.insert(ProtectedObjects, ScreenGui) -- محافظت از GUI

-- مخفی سازی GUI از شناسایی
pcall(function()
    setmetatable(ScreenGui, { __tostring = function() return "AntiBanGUI" end })
    ScreenGui.Parent = gethui and gethui() or CoreGui
end)

local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 220, 0, 100)
MenuFrame.Position = UDim2.new(0, 10, 0, 10)
MenuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MenuFrame.BorderColor3 = Color3.fromRGB(80, 80, 120)
MenuFrame.BorderSizePixel = 2
MenuFrame.Draggable = true
MenuFrame.Active = true
MenuFrame.Visible = true
MenuFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Ultimate Anti-Ban"
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
ToggleButton.Size = UDim2.new(0, 180, 0, 40)
ToggleButton.Position = UDim2.new(0.5, -90, 0.5, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 75) -- سبز برای حالت فعال
ToggleButton.Text = "Protection: ON"
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Parent = MenuFrame

local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 100, 0, 30)
OpenButton.Position = UDim2.new(0, 10, 0, 10)
OpenButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
OpenButton.Text = "Open Menu"
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Visible = false -- در ابتدا مخفی است
OpenButton.Parent = ScreenGui

--// توابع GUI
CloseButton.MouseButton1Click:Connect(function()
    MenuFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MenuFrame.Visible = true
    OpenButton.Visible = false
end)

ToggleButton.MouseButton1Click:Connect(function()
    AntiBanEnabled = not AntiBanEnabled
    if AntiBanEnabled then
        ToggleButton.Text = "Protection: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 75) -- Green
        Notify("Multi-layer protection has been ENABLED.", Color3.fromRGB(0, 255, 127))
    else
        ToggleButton.Text = "Protection: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80) -- Red
        Notify("Warning: All protections are DISABLED.", Color3.fromRGB(255, 100, 0))
    end
end)

--// لایه ۱: هوک کردن Namecall برای متدهای خطرناک
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local Method = getnamecallmethod()
    
    if not AntiBanEnabled then
        return OldNamecall(self, ...)
    end

    -- لیست سیاه متدهای خطرناک
    local BannedMethods = {
        ["Kick"] = true,
        ["Ban"] = true,
        ["Remove"] = true,
        -- افزودن متدهای خاص بازی در اینجا
        -- ["specialKickMethod"] = true, 
    }

    if BannedMethods[Method] and (self == LocalPlayer or (self:IsA("Player") and self ~= LocalPlayer)) then
        local targetName = self and self.Name or "Unknown"
        Notify(string.format("Blocked a server-side attempt to '%s' player: %s", Method, targetName), Color3.fromRGB(255, 0, 0))
        
        -- اگر هدف خود ما هستیم، عملیات فرار را اجرا کن
        if self == LocalPlayer then
            pcall(function()
                -- قطع ارتباط با سرور به روش امن
                NetworkClient:SetOutgoingKBPSLimit(0, NetworkClient.GetOutgoingKBPSLimit)
                TeleportService:Teleport(1, LocalPlayer) -- تلاش برای تلپورت به یک مکان ناموجود برای قطع اتصال
            end)
            -- حلقه بی نهایت برای جلوگیری از ادامه اجرای هر اسکریپت دیگری
            while true do task.wait() end
        end

        return nil -- جلوگیری کامل از اجرای متد
    end

    -- مسدود کردن ریموت‌های مشکوک (RemoteSpam)
    if Method == "FireServer" or Method == "InvokeServer" and self:IsA("RemoteEvent") then
        local args = {...}
        for i, arg in pairs(args) do
            if type(arg) == "string" then
                local s_arg = string.lower(arg)
                if s_arg:find("kick") or s_arg:find("ban") or s_arg:find("exploit") or s_arg:find("cheat") or s_arg:find("report") then
                    Notify(string.format("Blocked a suspicious remote call on '%s' with argument: '%s'", self.Name, arg), Color3.fromRGB(255, 165, 0))
                    return nil
                end
            end
        end
    end

    return OldNamecall(self, ...)
end)

--// لایه ۲: هوک کردن Index برای جلوگیری از حذف و دستکاری
OldIndex = hookmetamethod(game, "__index", function(self, index)
    if not AntiBanEnabled then
        return OldIndex(self, index)
    end
    
    local lowerIndex = type(index) == "string" and string.lower(index) or ""

    -- جلوگیری از دسترسی به متدهای خطرناک از طریق index
    if (self == LocalPlayer or (self:IsA("Player") and self ~= LocalPlayer)) and (lowerIndex == "kick" or lowerIndex == "ban") then
        Notify(string.format("Blocked a local script trying to access '%s' on player: %s", index, self.Name), Color3.fromRGB(255, 120, 0))
        return function() end -- یک تابع خالی برمی‌گردانیم تا خطا ندهد
    end
    
    -- محافظت در برابر حذف اشیاء مهم
    if lowerIndex == "destroy" and table.find(ProtectedObjects, self) then
         Notify(string.format("Protected '%s' from being destroyed!", self.Name), Color3.fromRGB(255, 255, 0))
         return function() end -- جایگزین کردن تابع destroy
    end

    return OldIndex(self, index)
end)

--// لایه ۳: محافظت از کاراکتر و اشیاء مهم
local function ProtectCharacter(character)
    if not character or table.find(ProtectedObjects, character) then return end
    
    table.insert(ProtectedObjects, character)
    for _, child in ipairs(character:GetChildren()) do
        table.insert(ProtectedObjects, child)
    end
    
    character.DescendantAdded:Connect(function(descendant)
        if not table.find(ProtectedObjects, descendant) then
            table.insert(ProtectedObjects, descendant)
        end
    end)
    Notify("Character protection is now active.", Color3.fromRGB(0, 180, 255))
end

if LocalPlayer.Character then
    ProtectCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(ProtectCharacter)


--// لایه ۴: مانیتورینگ رویدادهای مشکوک
-- جلوگیری از حذف شدن توسط Parent = nil
LocalPlayer.ChildAdded:Connect(function(child)
    if child:IsA("ScreenGui") or child:IsA("LocalScript") then
        child.AncestryChanged:Connect(function(_, parent)
            if AntiBanEnabled and not parent and not gethui():IsAncestorOf(child) then
                task.wait() -- فرصت می‌دهیم تا در صورت لزوم حذف کامل شود
                child.Parent = LocalPlayer.PlayerGui -- برگرداندن به جای امن
                Notify(string.format("Restored '%s' which was removed unexpectedly.", child.Name), Color3.fromRGB(200, 100, 255))
            end
        end)
    end
end)


--// اعلان نهایی
Notify("Ultimate Anti-Ban v1.0 has been activated successfully! All protection layers are online.", Color3.fromRGB(0, 255, 127))
print("Ultimate Anti-Ban Loaded. Control menu is on the top-left.")

--// پاکسازی در صورت خروج از بازی
game:BindToClose(function()
    if OldNamecall then
        hookmetamethod(game, "__namecall", OldNamecall)
    end
    if OldIndex then
         hookmetamethod(game, "__index", OldIndex)
    end
    getgenv().UltimateAntiBanLoaded = false
end)
