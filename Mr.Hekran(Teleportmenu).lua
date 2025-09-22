local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
    Name = "Mr.Hekran (Teleport menu) v[2.690.721]",
    LoadingTitle = "در حال بارگذاری...",
    LoadingSubtitle = "لطفاً صبر کنید",
    Theme = "Dark",
    EnableUI = true
})

local MainTab = Window:CreateTab("Teleport Menu", 4483362458)

local SelectedPlayer = nil

local PlayerDropdown = MainTab:CreateDropdown({
    Name = "Select Player",
    Options = {},
    CurrentOption = "",
    Flag = "PlayerDropdown",
    Callback = function(option)
        SelectedPlayer = option
    end
})

local function refreshPlayerList()
    local list = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            table.insert(list, plr.Name)
        end
    end
    PlayerDropdown:Refresh(list, true)
end

refreshPlayerList()
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

MainTab:CreateButton({
    Name = "Teleport to selected player",
    Callback = function()
        local target = SelectedPlayer and Players:FindFirstChild(SelectedPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
        end
    end
})

local XInput = MainTab:CreateInput({Name = "X", PlaceholderText = "0", RemoveTextAfterFocusLost = false, Callback = function() end})
local YInput = MainTab:CreateInput({Name = "Y", PlaceholderText = "10", RemoveTextAfterFocusLost = false, Callback = function() end})
local ZInput = MainTab:CreateInput({Name = "Z", PlaceholderText = "0", RemoveTextAfterFocusLost = false, Callback = function() end})

MainTab:CreateButton({
    Name = "Teleport to coordinates",
    Callback = function()
        local x = tonumber(XInput:__GetText()) or 0
        local y = tonumber(YInput:__GetText()) or 10
        local z = tonumber(ZInput:__GetText()) or 0
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(x,y,z)
        end
    end
})

MainTab:CreateButton({
    Name = "Teleport behind closest player",
    Callback = function()
        local closestDist = math.huge
        local closestPlayer = nil
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closestPlayer = plr
                end
            end
        end
        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local offset = -3 * closestPlayer.Character.HumanoidRootPart.CFrame.LookVector
            player.Character.HumanoidRootPart.CFrame = CFrame.new(closestPlayer.Character.HumanoidRootPart.Position + offset, closestPlayer.Character.HumanoidRootPart.Position)
        end
    end
})

Rayfield:LoadConfiguration()
