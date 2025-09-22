local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera


local AimPart = "Head"
local FieldOfView = 60
local Holding = false
local WallCheckEnabled = false
local fovCircleEnabled = true
local espEnabled = false
local espObjects = {}
local bunnyHopEnabled = false
local speedHackEnabled = false
local currentSpeed = 16
local flyEnabled = false
local flySpeed = 50
local fovChangerEnabled = false
local currentFOV = 70
local skyIndex = 1 
local charmsEnabled = false
local infiniteJumpEnabled = false


local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "SmileModMenu"
screenGui.ResetOnSpawn = false


local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 180, 0, 230)
frame.Position = UDim2.new(0.5, -90, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = false

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 12)


local aimSettingsFrame = Instance.new("Frame", screenGui)
aimSettingsFrame.Size = UDim2.new(0, 200, 0, 280)
aimSettingsFrame.Position = UDim2.new(0.5, 100, 0.3, 0)
aimSettingsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
aimSettingsFrame.BorderSizePixel = 0
aimSettingsFrame.Visible = false
aimSettingsFrame.Active = true

local aimSettingsCorner = Instance.new("UICorner", aimSettingsFrame)
aimSettingsCorner.CornerRadius = UDim.new(0, 12)


local aimSettingsTitle = Instance.new("TextLabel", aimSettingsFrame)
aimSettingsTitle.Size = UDim2.new(1, 0, 0, 30)
aimSettingsTitle.Position = UDim2.new(0, 0, 0, 0)
aimSettingsTitle.BackgroundTransparency = 1
aimSettingsTitle.Text = "AIM Settings"
aimSettingsTitle.Font = Enum.Font.SourceSansBold
aimSettingsTitle.TextSize = 16
aimSettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)


local aimCloseButton = Instance.new("TextButton", aimSettingsFrame)
aimCloseButton.Size = UDim2.new(0.9, 0, 0, 25)
aimCloseButton.Position = UDim2.new(0.05, 0, 1, -30)
aimCloseButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
aimCloseButton.TextColor3 = Color3.new(1,1,1)
aimCloseButton.Font = Enum.Font.SourceSansBold
aimCloseButton.TextSize = 14
aimCloseButton.Text = "Close Menu"

local aimCloseButtonCorner = Instance.new("UICorner", aimCloseButton)
aimCloseButtonCorner.CornerRadius = UDim.new(0, 6)


local fovCircleButton = Instance.new("TextButton", aimSettingsFrame)
fovCircleButton.Size = UDim2.new(0.9, 0, 0, 30)
fovCircleButton.Position = UDim2.new(0.05, 0, 0, 40)
fovCircleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
fovCircleButton.TextColor3 = Color3.new(1,1,1)
fovCircleButton.Font = Enum.Font.SourceSansBold
fovCircleButton.TextSize = 16
fovCircleButton.Text = "FOV Circle: ON"

local fovCircleButtonCorner = Instance.new("UICorner", fovCircleButton)
fovCircleButtonCorner.CornerRadius = UDim.new(0, 8)


local wallButton = Instance.new("TextButton", aimSettingsFrame)
wallButton.Size = UDim2.new(0.9, 0, 0, 30)
wallButton.Position = UDim2.new(0.05, 0, 0, 80)
wallButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
wallButton.TextColor3 = Color3.new(1,1,1)
wallButton.Font = Enum.Font.SourceSansBold
wallButton.TextSize = 16
wallButton.Text = "WallCheck: OFF"

local wallButtonCorner = Instance.new("UICorner", wallButton)
wallButtonCorner.CornerRadius = UDim.new(0, 8)


local aimFOVInputLabel = Instance.new("TextLabel", aimSettingsFrame)
aimFOVInputLabel.Size = UDim2.new(0.4, 0, 0, 25)
aimFOVInputLabel.Position = UDim2.new(0.05, 0, 0, 120)
aimFOVInputLabel.BackgroundTransparency = 1
aimFOVInputLabel.Text = "Aim FOV:"
aimFOVInputLabel.Font = Enum.Font.SourceSansBold
aimFOVInputLabel.TextSize = 14
aimFOVInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
aimFOVInputLabel.TextXAlignment = Enum.TextXAlignment.Left

local aimFOVInput = Instance.new("TextBox", aimSettingsFrame)
aimFOVInput.Size = UDim2.new(0.45, 0, 0, 25)
aimFOVInput.Position = UDim2.new(0.5, 0, 0, 120)
aimFOVInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
aimFOVInput.TextColor3 = Color3.new(1,1,1)
aimFOVInput.Font = Enum.Font.SourceSans
aimFOVInput.TextSize = 14
aimFOVInput.Text = "60"
aimFOVInput.PlaceholderText = "30-200"

local aimFOVInputCorner = Instance.new("UICorner", aimFOVInput)
aimFOVInputCorner.CornerRadius = UDim.new(0, 6)


local aimFOVSliderFrame = Instance.new("Frame", aimSettingsFrame)
aimFOVSliderFrame.Size = UDim2.new(0.9, 0, 0, 15)
aimFOVSliderFrame.Position = UDim2.new(0.05, 0, 0, 150)
aimFOVSliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
aimFOVSliderFrame.BorderSizePixel = 0

local aimFOVSliderCorner = Instance.new("UICorner", aimFOVSliderFrame)
aimFOVSliderCorner.CornerRadius = UDim.new(0, 8)

local aimFOVSliderButton = Instance.new("Frame", aimFOVSliderFrame)
aimFOVSliderButton.Size = UDim2.new(0, 20, 0, 20)
aimFOVSliderButton.Position = UDim2.new(0.18, -10, 0, -2.5)
aimFOVSliderButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
aimFOVSliderButton.BorderSizePixel = 0

local aimFOVSliderButtonCorner = Instance.new("UICorner", aimFOVSliderButton)
aimFOVSliderButtonCorner.CornerRadius = UDim.new(1, 0)


local teleportFrame = Instance.new("Frame", screenGui)
teleportFrame.Size = UDim2.new(0, 200, 0, 300)
teleportFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
teleportFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
teleportFrame.BorderSizePixel = 0
teleportFrame.Visible = false
teleportFrame.Active = true

local teleportFrameCorner = Instance.new("UICorner", teleportFrame)
teleportFrameCorner.CornerRadius = UDim.new(0, 12)

local teleportTitle = Instance.new("TextLabel", teleportFrame)
teleportTitle.Size = UDim2.new(1, 0, 0, 30)
teleportTitle.Position = UDim2.new(0, 0, 0, 0)
teleportTitle.BackgroundTransparency = 1
teleportTitle.Text = "Teleport to players"
teleportTitle.Font = Enum.Font.SourceSansBold
teleportTitle.TextSize = 16
teleportTitle.TextColor3 = Color3.fromRGB(255, 255, 255)

local backButton = Instance.new("TextButton", teleportFrame)
backButton.Size = UDim2.new(0.9, 0, 0, 25)
backButton.Position = UDim2.new(0.05, 0, 1, -30)
backButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
backButton.TextColor3 = Color3.new(1,1,1)
backButton.Font = Enum.Font.SourceSansBold
backButton.TextSize = 14
backButton.Text = "← Back"

local backButtonCorner = Instance.new("UICorner", backButton)
backButtonCorner.CornerRadius = UDim.new(0, 6)

local teleportScroll = Instance.new("ScrollingFrame", teleportFrame)
teleportScroll.Size = UDim2.new(1, 0, 1, -65)
teleportScroll.Position = UDim2.new(0, 0, 0, 35)
teleportScroll.BackgroundTransparency = 1
teleportScroll.ScrollBarThickness = 6
teleportScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
teleportScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
teleportScroll.ScrollingDirection = Enum.ScrollingDirection.Y


local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1, 0, 1, -60)
scrollFrame.Position = UDim2.new(0, 0, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 700) 
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y

local titleLabel = Instance.new("TextLabel", frame)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Mr.Hekran v[2.690.721]"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)


local teleportButton = Instance.new("TextButton", scrollFrame)
teleportButton.Size = UDim2.new(0.9, 0, 0, 30)
teleportButton.Position = UDim2.new(0.05, 0, 0, 10)
teleportButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
teleportButton.TextColor3 = Color3.new(1,1,1)
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.TextSize = 16
teleportButton.Text = "Teleport"

local teleportButtonCorner = Instance.new("UICorner", teleportButton)
teleportButtonCorner.CornerRadius = UDim.new(0, 8)

local aimButton = Instance.new("TextButton", scrollFrame)
aimButton.Size = UDim2.new(0.75, -5, 0, 30) 
aimButton.Position = UDim2.new(0.05, 0, 0, 50)
aimButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
aimButton.TextColor3 = Color3.new(1,1,1)
aimButton.Font = Enum.Font.SourceSansBold
aimButton.TextSize = 16
aimButton.Text = "AIM: OFF"

local aimButtonCorner = Instance.new("UICorner", aimButton)
aimButtonCorner.CornerRadius = UDim.new(0, 8)


local aimSettingsOpenButton = Instance.new("TextButton", scrollFrame)
aimSettingsOpenButton.Size = UDim2.new(0.15, -5, 0, 30) 
aimSettingsOpenButton.Position = UDim2.new(0.8, 0, 0, 50) 
aimSettingsOpenButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
aimSettingsOpenButton.TextColor3 = Color3.new(1,1,1)
aimSettingsOpenButton.Font = Enum.Font.SourceSansBold
aimSettingsOpenButton.TextSize = 18
aimSettingsOpenButton.Text = "+"

local aimSettingsOpenButtonCorner = Instance.new("UICorner", aimSettingsOpenButton)
aimSettingsOpenButtonCorner.CornerRadius = UDim.new(0, 8)

local espButton = Instance.new("TextButton", scrollFrame)
espButton.Size = UDim2.new(0.9, 0, 0, 30)
espButton.Position = UDim2.new(0.05, 0, 0, 90)
espButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
espButton.TextColor3 = Color3.new(1,1,1)
espButton.Font = Enum.Font.SourceSansBold
espButton.TextSize = 16
espButton.Text = "ESP: OFF"

local espButtonCorner = Instance.new("UICorner", espButton)
espButtonCorner.CornerRadius = UDim.new(0, 8)

local charmsButton = Instance.new("TextButton", scrollFrame)
charmsButton.Size = UDim2.new(0.9, 0, 0, 30)
charmsButton.Position = UDim2.new(0.05, 0, 0, 130)
charmsButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
charmsButton.TextColor3 = Color3.new(1,1,1)
charmsButton.Font = Enum.Font.SourceSansBold
charmsButton.TextSize = 16
charmsButton.Text = "Charms: OFF"

local charmsButtonCorner = Instance.new("UICorner", charmsButton)
charmsButtonCorner.CornerRadius = UDim.new(0, 8)

local infiniteJumpButton = Instance.new("TextButton", scrollFrame)
infiniteJumpButton.Size = UDim2.new(0.9, 0, 0, 30)
infiniteJumpButton.Position = UDim2.new(0.05, 0, 0, 170)
infiniteJumpButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
infiniteJumpButton.TextColor3 = Color3.new(1,1,1)
infiniteJumpButton.Font = Enum.Font.SourceSansBold
infiniteJumpButton.TextSize = 16
infiniteJumpButton.Text = "Infinite Jump: OFF"

local infiniteJumpButtonCorner = Instance.new("UICorner", infiniteJumpButton)
infiniteJumpButtonCorner.CornerRadius = UDim.new(0, 8)

local noclipButton = Instance.new("TextButton", scrollFrame)
noclipButton.Size = UDim2.new(0.9, 0, 0, 30)
noclipButton.Position = UDim2.new(0.05, 0, 0, 210)
noclipButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
noclipButton.TextColor3 = Color3.new(1,1,1)
noclipButton.Font = Enum.Font.SourceSansBold
noclipButton.TextSize = 16
noclipButton.Text = "Noclip: OFF"

local noclipButtonCorner = Instance.new("UICorner", noclipButton)
noclipButtonCorner.CornerRadius = UDim.new(0, 8)

local bunnyHopButton = Instance.new("TextButton", scrollFrame)
bunnyHopButton.Size = UDim2.new(0.9, 0, 0, 30)
bunnyHopButton.Position = UDim2.new(0.05, 0, 0, 250)
bunnyHopButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
bunnyHopButton.TextColor3 = Color3.new(1,1,1)
bunnyHopButton.Font = Enum.Font.SourceSansBold
bunnyHopButton.TextSize = 16
bunnyHopButton.Text = "BunnyHop: OFF"

local bunnyHopButtonCorner = Instance.new("UICorner", bunnyHopButton)
bunnyHopButtonCorner.CornerRadius = UDim.new(0, 8)

local skyButton = Instance.new("TextButton", scrollFrame)
skyButton.Size = UDim2.new(0.9, 0, 0, 30)
skyButton.Position = UDim2.new(0.05, 0, 0, 290)
skyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
skyButton.TextColor3 = Color3.new(1,1,1)
skyButton.Font = Enum.Font.SourceSansBold
skyButton.TextSize = 16
skyButton.Text = "Sky: Default"

local skyButtonCorner = Instance.new("UICorner", skyButton)
skyButtonCorner.CornerRadius = UDim.new(0, 8)


local flyInputLabel = Instance.new("TextLabel", scrollFrame)
flyInputLabel.Size = UDim2.new(0.4, 0, 0, 25)
flyInputLabel.Position = UDim2.new(0.05, 0, 0, 330)
flyInputLabel.BackgroundTransparency = 1
flyInputLabel.Text = "Fly Speed:"
flyInputLabel.Font = Enum.Font.SourceSansBold
flyInputLabel.TextSize = 14
flyInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flyInputLabel.TextXAlignment = Enum.TextXAlignment.Left

local flyInput = Instance.new("TextBox", scrollFrame)
flyInput.Size = UDim2.new(0.45, 0, 0, 25)
flyInput.Position = UDim2.new(0.5, 0, 0, 330)
flyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyInput.TextColor3 = Color3.new(1,1,1)
flyInput.Font = Enum.Font.SourceSans
flyInput.TextSize = 14
flyInput.Text = "50"
flyInput.PlaceholderText = "10-150"

local flyInputCorner = Instance.new("UICorner", flyInput)
flyInputCorner.CornerRadius = UDim.new(0, 6)

local flyButton = Instance.new("TextButton", scrollFrame)
flyButton.Size = UDim2.new(0.9, 0, 0, 30)
flyButton.Position = UDim2.new(0.05, 0, 0, 360)
flyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.Font = Enum.Font.SourceSansBold
flyButton.TextSize = 16
flyButton.Text = "Fly: OFF"

local flyButtonCorner = Instance.new("UICorner", flyButton)
flyButtonCorner.CornerRadius = UDim.new(0, 8)


local speedInputLabel = Instance.new("TextLabel", scrollFrame)
speedInputLabel.Size = UDim2.new(0.4, 0, 0, 25)
speedInputLabel.Position = UDim2.new(0.05, 0, 0, 400)
speedInputLabel.BackgroundTransparency = 1
speedInputLabel.Text = "Speed:"
speedInputLabel.Font = Enum.Font.SourceSansBold
speedInputLabel.TextSize = 14
speedInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInputLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedInput = Instance.new("TextBox", scrollFrame)
speedInput.Size = UDim2.new(0.45, 0, 0, 25)
speedInput.Position = UDim2.new(0.5, 0, 0, 400)
speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedInput.TextColor3 = Color3.new(1,1,1)
speedInput.Font = Enum.Font.SourceSans
speedInput.TextSize = 14
speedInput.Text = "16"
speedInput.PlaceholderText = "16-400"

local speedInputCorner = Instance.new("UICorner", speedInput)
speedInputCorner.CornerRadius = UDim.new(0, 6)

local sliderFrame = Instance.new("Frame", scrollFrame)
sliderFrame.Size = UDim2.new(0.9, 0, 0, 15)
sliderFrame.Position = UDim2.new(0.05, 0, 0, 430)
sliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
sliderFrame.BorderSizePixel = 0

local sliderCorner = Instance.new("UICorner", sliderFrame)
sliderCorner.CornerRadius = UDim.new(0, 8)

local sliderButton = Instance.new("Frame", sliderFrame)
sliderButton.Size = UDim2.new(0, 20, 0, 20)
sliderButton.Position = UDim2.new(0, -2, 0, -2.5)
sliderButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
sliderButton.BorderSizePixel = 0

local sliderButtonCorner = Instance.new("UICorner", sliderButton)
sliderButtonCorner.CornerRadius = UDim.new(1, 0)

local speedButton = Instance.new("TextButton", scrollFrame)
speedButton.Size = UDim2.new(0.9, 0, 0, 30)
speedButton.Position = UDim2.new(0.05, 0, 0, 460)
speedButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedButton.TextColor3 = Color3.new(1,1,1)
speedButton.Font = Enum.Font.SourceSansBold
speedButton.TextSize = 16
speedButton.Text = "Speed: OFF"

local speedButtonCorner = Instance.new("UICorner", speedButton)
speedButtonCorner.CornerRadius = UDim.new(0, 8)


local fovInputLabel = Instance.new("TextLabel", scrollFrame)
fovInputLabel.Size = UDim2.new(0.4, 0, 0, 25)
fovInputLabel.Position = UDim2.new(0.05, 0, 0, 500)
fovInputLabel.BackgroundTransparency = 1
fovInputLabel.Text = "FOV:"
fovInputLabel.Font = Enum.Font.SourceSansBold
fovInputLabel.TextSize = 14
fovInputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fovInputLabel.TextXAlignment = Enum.TextXAlignment.Left

local fovInput = Instance.new("TextBox", scrollFrame)
fovInput.Size = UDim2.new(0.45, 0, 0, 25)
fovInput.Position = UDim2.new(0.5, 0, 0, 500)
fovInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fovInput.TextColor3 = Color3.new(1,1,1)
fovInput.Font = Enum.Font.SourceSans
fovInput.TextSize = 14
fovInput.Text = "70"
fovInput.PlaceholderText = "30-120"

local fovInputCorner = Instance.new("UICorner", fovInput)
fovInputCorner.CornerRadius = UDim.new(0, 6)

local fovSliderFrame = Instance.new("Frame", scrollFrame)
fovSliderFrame.Size = UDim2.new(0.9, 0, 0, 15)
fovSliderFrame.Position = UDim2.new(0.05, 0, 0, 530)
fovSliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
fovSliderFrame.BorderSizePixel = 0

local fovSliderCorner = Instance.new("UICorner", fovSliderFrame)
fovSliderCorner.CornerRadius = UDim.new(0, 8)

local fovSliderButton = Instance.new("Frame", fovSliderFrame)
fovSliderButton.Size = UDim2.new(0, 20, 0, 20)
fovSliderButton.Position = UDim2.new(0.44, -10, 0, -2.5)
fovSliderButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
fovSliderButton.BorderSizePixel = 0

local fovSliderButtonCorner = Instance.new("UICorner", fovSliderButton)
fovSliderButtonCorner.CornerRadius = UDim.new(1, 0)

local fovButton = Instance.new("TextButton", scrollFrame)
fovButton.Size = UDim2.new(0.9, 0, 0, 30)
fovButton.Position = UDim2.new(0.05, 0, 0, 560)
fovButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
fovButton.TextColor3 = Color3.new(1,1,1)
fovButton.Font = Enum.Font.SourceSansBold
fovButton.TextSize = 16
fovButton.Text = "FOV: OFF"

local fovButtonCorner = Instance.new("UICorner", fovButton)
fovButtonCorner.CornerRadius = UDim.new(0, 8)


local minimizeButton = Instance.new("TextButton", frame)
minimizeButton.Size = UDim2.new(0.9, 0, 0, 25)
minimizeButton.Position = UDim2.new(0.05, 0, 1, -30)
minimizeButton.Text = "Minimize menu"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minimizeButton.BorderSizePixel = 0
minimizeButton.ZIndex = 10
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 14

local minimizeButtonCorner = Instance.new("UICorner", minimizeButton)
minimizeButtonCorner.CornerRadius = UDim.new(0, 8)


local minimizedCircle = Instance.new("TextButton", screenGui)
minimizedCircle.Size = UDim2.new(0, 30, 0, 30)
minimizedCircle.Position = UDim2.new(0, 300, 0, 200)
minimizedCircle.Text = ""
minimizedCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
minimizedCircle.BorderSizePixel = 0
minimizedCircle.Visible = false
minimizedCircle.AutoButtonColor = false
minimizedCircle.ZIndex = 10
minimizedCircle.AnchorPoint = Vector2.new(0.5, 0.5)

local corner = Instance.new("UICorner", minimizedCircle)
corner.CornerRadius = UDim.new(1, 0)


local flyConnection
local speedHackConnection
local fovChangerConnection
local noclipConnection
local bunnyHopConnection
local infiniteJumpConnection
local bodyVelocity
local bodyAngularVelocity
local flyUpPressed = false
local flyDownPressed = false


local lastClickTime = 0
local clickDelay = 0.1 


local function canClick()
    local currentTime = tick()
    if currentTime - lastClickTime < clickDelay then
        return false
    end
    lastClickTime = currentTime
    return true
end


local hue = 0
RunService.RenderStepped:Connect(function(dt)
	hue = (hue + dt * 0.5) % 1
	titleLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
end)


local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(0, 255, 0)
circle.Thickness = 1
circle.Radius = FieldOfView
circle.Filled = false
circle.Visible = true

local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)


local function teleportToPlayer(targetPlayer)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
	   targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
	end
end


local function updateTeleportList()
	for _, child in pairs(teleportScroll:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	
	local yPos = 5
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local playerButton = Instance.new("TextButton", teleportScroll)
			playerButton.Size = UDim2.new(0.9, 0, 0, 30)
			playerButton.Position = UDim2.new(0.05, 0, 0, yPos)
			playerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			playerButton.TextColor3 = Color3.new(1,1,1)
			playerButton.Font = Enum.Font.SourceSans
			playerButton.TextSize = 14
			playerButton.Text = player.Name
			
			local playerButtonCorner = Instance.new("UICorner", playerButton)
			playerButtonCorner.CornerRadius = UDim.new(0, 6)
			
			playerButton.MouseButton1Click:Connect(function()
				if canClick() then
					teleportToPlayer(player)
				end
			end)
			
			yPos = yPos + 35
		end
	end
	
	teleportScroll.CanvasSize = UDim2.new(0, 0, 0, yPos)
end


local function changeSky()
	local sky = Lighting:FindFirstChildOfClass("Sky")
	
	if skyIndex == 1 then
		if not sky then
			sky = Instance.new("Sky", Lighting)
		end
		sky.SkyboxBk = "rbxassetid://159454299"
		sky.SkyboxDn = "rbxassetid://159454296"
		sky.SkyboxFt = "rbxassetid://159454293"
		sky.SkyboxLf = "rbxassetid://159454286"
		sky.SkyboxRt = "rbxassetid://159454300"
		sky.SkyboxUp = "rbxassetid://159454288"
		skyButton.Text = "Sky: Space"
		skyIndex = 2
	elseif skyIndex == 2 then
		if sky then
			sky:Destroy()
		end
		skyButton.Text = "Sky: Default"
		skyIndex = 1
	end
end


local function IsVisible(part)
	if not WallCheckEnabled then return true end
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
	rayParams.FilterType = Enum.RaycastFilterType.Blacklist
	local direction = (part.Position - Camera.CFrame.Position).Unit * 500
	local result = workspace:Raycast(Camera.CFrame.Position, direction, rayParams)
	return not (result and result.Instance and not result.Instance:IsDescendantOf(part.Parent))
end


local function GetClosestPlayer()
	local closestPlayer, shortestDistance
	shortestDistance = FieldOfView
	for _, v in pairs(Players:GetPlayers()) do
		if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(AimPart) then
			local part = v.Character[AimPart]
			local vector, onScreen = Camera:WorldToViewportPoint(part.Position)
			if onScreen and IsVisible(part) then
				local dist = (Vector2.new(vector.X, vector.Y) - screenCenter).Magnitude
				if dist < shortestDistance then
					closestPlayer, shortestDistance = v, dist
				end
			end
		end
	end
	return closestPlayer
end


RunService.RenderStepped:Connect(function()
	if Holding then
		local target = GetClosestPlayer()
		if target and target.Character and target.Character:FindFirstChild(AimPart) then
			local camPos = Camera.CFrame.Position
			local headPos = target.Character[AimPart].Position
			local lookVector = (headPos - camPos).Unit
			Camera.CFrame = CFrame.new(camPos, camPos + lookVector)
		end
	end
end)


RunService.RenderStepped:Connect(function()
	local target = GetClosestPlayer()
	if WallCheckEnabled and target and target.Character and target.Character:FindFirstChild(AimPart) then
		local part = target.Character[AimPart]
		circle.Color = IsVisible(part) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
	else
		circle.Color = Color3.fromRGB(0, 255, 0)
	end
	circle.Position = screenCenter
	circle.Visible = fovCircleEnabled
end)


local function clearESP()
	for _, esp in pairs(espObjects) do
		for _, obj in pairs(esp) do
			if obj and obj.Remove then obj:Remove() end
		end
	end
	espObjects = {}
end

local function removePlayerESP(player)
	if espObjects[player] then
		for _, obj in pairs(espObjects[player]) do
			if obj and obj.Remove then obj:Remove() end
		end
		espObjects[player] = nil
	end
end

local function createESP(p)
	if p == LocalPlayer then return end
	local box = Drawing.new("Square")
	box.Thickness = 1
	box.Color = Color3.fromRGB(0, 255, 0)
	box.Filled = false
	box.Transparency = 1
	box.Visible = false

	local name = Drawing.new("Text")
	name.Size = 14
	name.Center = true
	name.Outline = true
	name.Color = Color3.fromRGB(0, 255, 255)
	name.Visible = false

	local health = Drawing.new("Text")
	health.Size = 13
	health.Center = true
	health.Outline = true
	health.Color = Color3.fromRGB(0, 255, 0)
	health.Visible = false

	local distance = Drawing.new("Text")
	distance.Size = 13
	distance.Center = true
	distance.Outline = true
	distance.Color = Color3.fromRGB(255, 255, 0)
	distance.Visible = false

	local tracer = Drawing.new("Line")
	tracer.Thickness = 1
	tracer.Color = Color3.fromRGB(255, 255, 255)
	tracer.Transparency = 0.8
	tracer.Visible = false

	espObjects[p] = {Box = box, Name = name, Health = health, Distance = distance, Tracer = tracer}
end


local charmsObjects = {}

local function clearCharms()
	for _, charm in pairs(charmsObjects) do
		if charm and charm.Destroy then charm:Destroy() end
	end
	charmsObjects = {}
end

local function removePlayerCharms(player)
	if charmsObjects[player] then
		if charmsObjects[player].Destroy then charmsObjects[player]:Destroy() end
		charmsObjects[player] = nil
	end
end

local function createCharms(p)
	if p == LocalPlayer then return end
	if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
		local highlight = Instance.new("Highlight")
		highlight.Parent = p.Character
		highlight.FillColor = Color3.fromRGB(0, 255, 0)
		highlight.FillTransparency = 0.5
		highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
		highlight.OutlineTransparency = 0
		charmsObjects[p] = highlight
	end
end


for _, p in pairs(game.Players:GetPlayers()) do createESP(p) end

game.Players.PlayerAdded:Connect(createESP)
game.Players.PlayerRemoving:Connect(removePlayerESP)
game.Players.PlayerRemoving:Connect(removePlayerCharms)

RunService.RenderStepped:Connect(function()
	if not espEnabled then 
		for _, esp in pairs(espObjects) do
			for _, obj in pairs(esp) do
				if obj then obj.Visible = false end
			end
		end
		return 
	end
	
	for player, esp in pairs(espObjects) do
		if not Players:FindFirstChild(player.Name) then
			removePlayerESP(player)
		end
	end
	
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local esp = espObjects[p]
			if not esp then 
				createESP(p) 
				esp = espObjects[p] 
			end
			
			if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
				local root = p.Character.HumanoidRootPart
				local hum = p.Character:FindFirstChildOfClass("Humanoid")
				
				if hum.Health > 0 then
					local pos, visible = Camera:WorldToViewportPoint(root.Position)
					if visible and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
						local dist = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
						local scale = math.clamp(3000 / dist, 100, 300)
						local width, height = scale / 2, scale

						esp.Box.Size = Vector2.new(width, height)
						esp.Box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 1.5)
						esp.Box.Visible = true

						esp.Name.Position = Vector2.new(pos.X, pos.Y - height / 1.5 - 15)
						esp.Name.Text = p.Name
						esp.Name.Visible = true

						esp.Health.Position = Vector2.new(pos.X, pos.Y - height / 1.5)
						esp.Health.Text = "HP: " .. math.floor(hum.Health)
						esp.Health.Visible = true

						esp.Distance.Position = Vector2.new(pos.X, pos.Y + height / 2 + 5)
						esp.Distance.Text = "Dist: " .. math.floor(dist)
						esp.Distance.Visible = true

						local screenBottom = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
						esp.Tracer.From = screenBottom
						esp.Tracer.To = Vector2.new(pos.X, pos.Y)
						esp.Tracer.Visible = true
					else
						for _, v in pairs(esp) do v.Visible = false end
					end
				else
					for _, v in pairs(esp) do v.Visible = false end
				end
			else
				for _, v in pairs(esp) do v.Visible = false end
			end
		end
	end
end)


RunService.RenderStepped:Connect(function()
	if charmsEnabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and not charmsObjects[p] then
				createCharms(p)
			end
		end
	else
		clearCharms()
	end
end)


local function updateSpeed()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = currentSpeed
	end
end

local function updateSlider()
	local percentage = (currentSpeed - 16) / (400 - 16)
	sliderButton.Position = UDim2.new(percentage, -10, 0, -2.5)
	speedInput.Text = tostring(currentSpeed)
end

local function updateFOV()
	if LocalPlayer.Character and Camera then
		Camera.FieldOfView = currentFOV
	end
end

local function updateFOVSlider()
	local percentage = (currentFOV - 30) / (120 - 30)
	fovSliderButton.Position = UDim2.new(percentage, -10, 0, -2.5)
	fovInput.Text = tostring(currentFOV)
end


local function updateAimFOVSlider()
	local percentage = (FieldOfView - 30) / (200 - 30)
	aimFOVSliderButton.Position = UDim2.new(percentage, -10, 0, -2.5)
	aimFOVInput.Text = tostring(FieldOfView)
	circle.Radius = FieldOfView
end


local function startFly()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local root = char.HumanoidRootPart
		
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		bodyVelocity.Parent = root
		
		bodyAngularVelocity = Instance.new("BodyAngularVelocity")
		bodyAngularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
		bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
		bodyAngularVelocity.Parent = root
		
		flyConnection = RunService.RenderStepped:Connect(function()
			local char = LocalPlayer.Character
			if char and char:FindFirstChild("HumanoidRootPart") and bodyVelocity then
				local root = char.HumanoidRootPart
				local camera = workspace.CurrentCamera
				local moveVector = Vector3.new(0, 0, 0)
				
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then
					moveVector = moveVector + camera.CFrame.LookVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then
					moveVector = moveVector - camera.CFrame.LookVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then
					moveVector = moveVector - camera.CFrame.RightVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then
					moveVector = moveVector + camera.CFrame.RightVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
					moveVector = moveVector + Vector3.new(0, 1, 0)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
					moveVector = moveVector + Vector3.new(0, -1, 0)
				end
				
				if moveVector.Magnitude == 0 and UserInputService.TouchEnabled then
					moveVector = camera.CFrame.LookVector
				end
				
				if moveVector.Magnitude > 0 then
					bodyVelocity.Velocity = moveVector.Unit * flySpeed
				else
					bodyVelocity.Velocity = Vector3.new(0, 0, 0)
				end
			end
		end)
	end
end

local function stopFly()
	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end
	if bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end
	if bodyAngularVelocity then
		bodyAngularVelocity:Destroy()
		bodyAngularVelocity = nil
	end
end


local function handleSliderInput()
	local mouse = UserInputService:GetMouseLocation()
	local sliderPos = sliderFrame.AbsolutePosition
	local sliderSize = sliderFrame.AbsoluteSize
	
	if mouse.X >= sliderPos.X and mouse.X <= sliderPos.X + sliderSize.X then
		local relativeX = math.clamp(mouse.X - sliderPos.X, 0, sliderSize.X)
		local percentage = relativeX / sliderSize.X
		currentSpeed = math.floor(16 + (400 - 16) * percentage + 0.5)
		currentSpeed = math.clamp(currentSpeed, 16, 400)
		updateSlider()
		if speedHackEnabled then updateSpeed() end
	end
end

local function handleFOVSliderInput()
	local mouse = UserInputService:GetMouseLocation()
	local sliderPos = fovSliderFrame.AbsolutePosition
	local sliderSize = fovSliderFrame.AbsoluteSize
	
	if mouse.X >= sliderPos.X and mouse.X <= sliderPos.X + sliderSize.X then
		local relativeX = math.clamp(mouse.X - sliderPos.X, 0, sliderSize.X)
		local percentage = relativeX / sliderSize.X
		currentFOV = math.floor(30 + (120 - 30) * percentage + 0.5)
		currentFOV = math.clamp(currentFOV, 30, 120)
		updateFOVSlider()
		if fovChangerEnabled then updateFOV() end
	end
end


local function handleAimFOVSliderInput()
	local mouse = UserInputService:GetMouseLocation()
	local sliderPos = aimFOVSliderFrame.AbsolutePosition
	local sliderSize = aimFOVSliderFrame.AbsoluteSize
	
	if mouse.X >= sliderPos.X and mouse.X <= sliderPos.X + sliderSize.X then
		local relativeX = math.clamp(mouse.X - sliderPos.X, 0, sliderSize.X)
		local percentage = relativeX / sliderSize.X
		FieldOfView = math.floor(30 + (200 - 30) * percentage + 0.5)
		FieldOfView = math.clamp(FieldOfView, 30, 200)
		updateAimFOVSlider()
	end
end


local draggingSlider = false
local draggingFOVSlider = false
local draggingAimFOVSlider = false


local function preventDragWhileSliding(inputObject, sliderFrame)
	
	inputObject.Changed:Connect(function()
		if inputObject.UserInputState == Enum.UserInputState.End then
			
		end
	end)
end

sliderFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = true
		handleSliderInput()
		
		preventDragWhileSliding(input, sliderFrame)
	end
end)

fovSliderFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingFOVSlider = true
		handleFOVSliderInput()
		preventDragWhileSliding(input, fovSliderFrame)
	end
end)


aimFOVSliderFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingAimFOVSlider = true
		handleAimFOVSliderInput()
		preventDragWhileSliding(input, aimFOVSliderFrame)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = false
		draggingFOVSlider = false
		draggingAimFOVSlider = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		handleSliderInput()
	elseif draggingFOVSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		handleFOVSliderInput()
	elseif draggingAimFOVSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		handleAimFOVSliderInput()
	end
end)


speedInput.FocusLost:Connect(function()
	local inputSpeed = tonumber(speedInput.Text)
	if inputSpeed and inputSpeed >= 16 and inputSpeed <= 400 then
		currentSpeed = inputSpeed
		updateSlider()
		if speedHackEnabled then updateSpeed() end
	else
		speedInput.Text = tostring(currentSpeed)
	end
end)

flyInput.FocusLost:Connect(function()
	local inputSpeed = tonumber(flyInput.Text)
	if inputSpeed and inputSpeed >= 10 and inputSpeed <= 150 then
		flySpeed = inputSpeed
	else
		flyInput.Text = tostring(flySpeed)
	end
end)

fovInput.FocusLost:Connect(function()
	local inputFOV = tonumber(fovInput.Text)
	if inputFOV and inputFOV >= 30 and inputFOV <= 120 then
		currentFOV = inputFOV
		updateFOVSlider()
		if fovChangerEnabled then updateFOV() end
	else
		fovInput.Text = tostring(currentFOV)
	end
end)

aimFOVInput.FocusLost:Connect(function()
	local inputFOV = tonumber(aimFOVInput.Text)
	if inputFOV and inputFOV >= 30 and inputFOV <= 200 then
		FieldOfView = inputFOV
		updateAimFOVSlider()
	else
		aimFOVInput.Text = tostring(FieldOfView)
	end
end)


teleportButton.MouseButton1Click:Connect(function()
	if canClick() then
		frame.Visible = false
		aimSettingsFrame.Visible = false
		teleportFrame.Visible = true
		updateTeleportList()
	end
end)

backButton.MouseButton1Click:Connect(function()
	if canClick() then
		teleportFrame.Visible = false
		frame.Visible = true
	end
end)

aimSettingsOpenButton.MouseButton1Click:Connect(function()
	if canClick() then
		aimSettingsFrame.Visible = not aimSettingsFrame.Visible
	end
end)

aimCloseButton.MouseButton1Click:Connect(function()
	if canClick() then
		aimSettingsFrame.Visible = false
	end
end)

aimButton.MouseButton1Click:Connect(function()
	if canClick() then
		Holding = not Holding
		aimButton.Text = Holding and "AIM: ON" or "AIM: OFF"
	end
end)

fovCircleButton.MouseButton1Click:Connect(function()
	if canClick() then
		fovCircleEnabled = not fovCircleEnabled
		fovCircleButton.Text = fovCircleEnabled and "FOV Circle: ON" or "FOV Circle: OFF"
	end
end)

wallButton.MouseButton1Click:Connect(function()
	if canClick() then
		WallCheckEnabled = not WallCheckEnabled
		wallButton.Text = WallCheckEnabled and "WallCheck: ON" or "WallCheck: OFF"
	end
end)

espButton.MouseButton1Click:Connect(function()
	if canClick() then
		espEnabled = not espEnabled
		espButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
		if not espEnabled then clearESP() end
	end
end)


charmsButton.MouseButton1Click:Connect(function()
	if canClick() then
		charmsEnabled = not charmsEnabled
		charmsButton.Text = charmsEnabled and "Charms: ON" or "Charms: OFF"
		if not charmsEnabled then 
			clearCharms() 
		end
	end
end)

infiniteJumpButton.MouseButton1Click:Connect(function()
	if canClick() then
		infiniteJumpEnabled = not infiniteJumpEnabled
		infiniteJumpButton.Text = infiniteJumpEnabled and "Infinite Jump: ON" or "Infinite Jump: OFF"

		if infiniteJumpEnabled then
			infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
				if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
					LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
				end
			end)
		else
			if infiniteJumpConnection then
				infiniteJumpConnection:Disconnect()
				infiniteJumpConnection = nil
			end
		end
	end
end)

noclipButton.MouseButton1Click:Connect(function()
	if canClick() then
		local noclipEnabled = not (noclipConnection ~= nil)
		noclipButton.Text = noclipEnabled and "Noclip: ON" or "Noclip: OFF"

		if noclipEnabled then
			noclipConnection = RunService.Stepped:Connect(function()
				if LocalPlayer.Character then
					for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CanCollide = false
						end
					end
				end
			end)
		else
			if noclipConnection then
				noclipConnection:Disconnect()
				noclipConnection = nil
			end
			if LocalPlayer.Character then
				for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = true
					end
				end
			end
		end
	end
end)

bunnyHopButton.MouseButton1Click:Connect(function()
	if canClick() then
		bunnyHopEnabled = not bunnyHopEnabled
		bunnyHopButton.Text = bunnyHopEnabled and "BunnyHop: ON" or "BunnyHop: OFF"

		if bunnyHopEnabled then
			bunnyHopConnection = RunService.RenderStepped:Connect(function()
				local char = LocalPlayer.Character
				if char and char:FindFirstChildOfClass("Humanoid") then
					local hum = char:FindFirstChildOfClass("Humanoid")
					hum.WalkSpeed = 100
					hum.JumpPower = 35
					if hum.FloorMaterial ~= Enum.Material.Air then
						hum:ChangeState("Jumping")
					end
				end
			end)
		else
			if bunnyHopConnection then
				bunnyHopConnection:Disconnect()
				bunnyHopConnection = nil
			end
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
				LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedHackEnabled and currentSpeed or 16
				LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
			end
		end
	end
end)

skyButton.MouseButton1Click:Connect(function()
	if canClick() then
		changeSky()
	end
end)

flyButton.MouseButton1Click:Connect(function()
	if canClick() then
		flyEnabled = not flyEnabled
		flyButton.Text = flyEnabled and "Fly: ON" or "Fly: OFF"

		if flyEnabled then
			startFly()
		else
			stopFly()
		end
	end
end)

speedButton.MouseButton1Click:Connect(function()
	if canClick() then
		speedHackEnabled = not speedHackEnabled
		speedButton.Text = speedHackEnabled and "Speed: ON" or "Speed: OFF"

		if speedHackEnabled then
			speedHackConnection = RunService.RenderStepped:Connect(function()
				updateSpeed()
			end)
		else
			if speedHackConnection then
				speedHackConnection:Disconnect()
				speedHackConnection = nil
			end
			if not bunnyHopEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
				LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
			end
		end
	end
end)

fovButton.MouseButton1Click:Connect(function()
	if canClick() then
		fovChangerEnabled = not fovChangerEnabled
		fovButton.Text = fovChangerEnabled and "FOV: ON" or "FOV: OFF"

		if fovChangerEnabled then
			fovChangerConnection = RunService.RenderStepped:Connect(function()
				updateFOV()
			end)
		else
			if fovChangerConnection then
				fovChangerConnection:Disconnect()
				fovChangerConnection = nil
			end
			if Camera then
				Camera.FieldOfView = 70
			end
		end
	end
end)


updateSlider()
updateFOVSlider()
updateAimFOVSlider()


task.spawn(function()
	while true do
		if minimizedCircle.Visible then
			local t = tick()
			local r = 0.5 + 0.5 * math.sin(t)
			local g = 0.5 + 0.5 * math.sin(t + 2)
			local b = 0.5 + 0.5 * math.sin(t + 4)
			minimizedCircle.BackgroundColor3 = Color3.new(r, g, b)
		end
		task.wait(0.05)
	end
end)


minimizeButton.MouseButton1Click:Connect(function()
	if canClick() then
		frame.Visible = false
		teleportFrame.Visible = false
		aimSettingsFrame.Visible = false
		minimizedCircle.Visible = true
	end
end)

minimizedCircle.MouseButton1Click:Connect(function()
	if canClick() then
		frame.Visible = true
		minimizedCircle.Visible = false
	end
end)


local function makeDraggable(frame, dragHandle)
	local dragging = false
	local dragStart = nil
	local startPos = nil
	local dragConnection = nil

	local function endDragging()
		dragging = false
		if dragConnection then
			dragConnection:Disconnect()
			dragConnection = nil
		end
	end

	
	local handle = dragHandle or frame
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			
			if not draggingSlider and not draggingFOVSlider and not draggingAimFOVSlider then
				dragging = true
				dragStart = input.Position
				startPos = frame.Position
				
				dragConnection = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						endDragging()
					end
				end)
			end
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			endDragging()
		end
	end)
end


makeDraggable(frame, titleLabel)
makeDraggable(teleportFrame, teleportTitle)
makeDraggable(minimizedCircle)
makeDraggable(aimSettingsFrame, aimSettingsTitle)
