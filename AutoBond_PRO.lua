
-- Dead Rail PRO Script | Full NatHub UI + ESP + AutoBond + FullBright + Noclip + SpeedHack + Icon Minimize
-- Author: Kimizuka Kimiho

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

-- Variables
local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local hrp = player.Character and player.Character:WaitForChild("HumanoidRootPart") or player.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")

-- States
local state = {
    FullBright = false,
    ESP = false,
    AutoBond = false,
    Noclip = false,
    SpeedHack = false
}

-- UI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
gui.Name = "DeadRailProUI"

local uiFrame = Instance.new("Frame")
uiFrame.Parent = gui
uiFrame.Size = UDim2.new(0, 280, 0, 260)
uiFrame.Position = UDim2.new(0.02, 0, 0.15, 0)
uiFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 174)
uiFrame.BackgroundTransparency = 0.15
uiFrame.BorderSizePixel = 0
uiFrame.ClipsDescendants = true
uiFrame.AnchorPoint = Vector2.new(0, 0)
uiFrame.Visible = true
uiFrame.Active = true
uiFrame.Draggable = true
uiFrame.Name = "MainMenu"
uiFrame.ZIndex = 5

local UICorner = Instance.new("UICorner", uiFrame)
UICorner.CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel", uiFrame)
title.Size = UDim2.new(1, 0, 0.15, 0)
title.Text = "Dead Rail PRO UI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.TextScaled = true

local buttons = {
    {name = "ESP", flag = "ESP"},
    {name = "FullBright", flag = "FullBright"},
    {name = "Auto Bond", flag = "AutoBond"},
    {name = "Noclip", flag = "Noclip"},
    {name = "Speed Hack", flag = "SpeedHack"},
}

for i, btn in ipairs(buttons) do
    local b = Instance.new("TextButton", uiFrame)
    b.Size = UDim2.new(0.9, 0, 0.12, 0)
    b.Position = UDim2.new(0.05, 0, 0.15 + (i * 0.13), 0)
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.Gotham
    b.TextScaled = true
    b.Text = btn.name .. ": TẮT"
    b.Name = btn.flag

    local corner = Instance.new("UICorner", b)
    corner.CornerRadius = UDim.new(0, 8)

    b.MouseButton1Click:Connect(function()
        state[btn.flag] = not state[btn.flag]
        b.Text = btn.name .. ": " .. (state[btn.flag] and "BẬT" or "TẮT")
    end)
end

-- Minimize Icon
local icon = Instance.new("ImageButton", gui)
icon.Size = UDim2.new(0, 42, 0, 42)
icon.Position = UDim2.new(0, 10, 1, -52)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://17930893743" -- Replace with your icon if needed
icon.Visible = false

local close = Instance.new("TextButton", uiFrame)
close.Size = UDim2.new(0, 28, 0, 28)
close.Position = UDim2.new(1, -32, 0, 4)
close.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
close.Text = "-"
close.Font = Enum.Font.GothamBold
close.TextColor3 = Color3.new(1,1,1)
close.TextScaled = true

local closeCorner = Instance.new("UICorner", close)
closeCorner.CornerRadius = UDim.new(1, 0)

close.MouseButton1Click:Connect(function()
    uiFrame.Visible = false
    icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
    uiFrame.Visible = true
    icon.Visible = false
end)

-- FullBright Logic
RunService.Stepped:Connect(function()
    if state.FullBright then
        for _, p in pairs(Workspace:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Material = Enum.Material.SmoothPlastic
                p.Color = Color3.new(1, 1, 1)
            end
        end
    end
end)

-- ESP Logic
local espObjects = {}
local function updateESP()
    if not state.ESP then
        for _, box in pairs(espObjects) do box.Visible = false end
        return
    end

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name:lower():find("bond") then
            if not espObjects[obj] then
                local box = Drawing.new("Square")
                box.Color = Color3.fromRGB(0, 255, 0)
                box.Thickness = 2
                box.Filled = false
                espObjects[obj] = box
            end

            local screen, visible = camera:WorldToViewportPoint(obj.Position)
            if visible then
                local size = math.clamp(3000 / (camera.CFrame.Position - obj.Position).Magnitude, 20, 80)
                espObjects[obj].Size = Vector2.new(size, size * 1.5)
                espObjects[obj].Position = Vector2.new(screen.X - size/2, screen.Y - size/2)
                espObjects[obj].Visible = true
            else
                espObjects[obj].Visible = false
            end
        end
    end
end
RunService.RenderStepped:Connect(updateESP)

-- Auto Bond Logic
coroutine.wrap(function()
    while true do
        if state.AutoBond then
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("Part") and part.Name:lower():find("bond") and part:FindFirstChild("TouchInterest") then
                    hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                    wait(0.3)
                end
            end
        end
        wait(2)
    end
end)()

-- Speed Hack + Noclip
local speed = 75
RunService.RenderStepped:Connect(function()
    if state.Noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end

    if state.SpeedHack and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
    else
        player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)

print("✅ Dead Rail PRO | NatHub Style Loaded")
