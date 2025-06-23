-- Dead Rail PRO Script |
-- Author: Kimizuka Kimiho

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Variables
local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local hrp = player.Character and player.Character:WaitForChild("HumanoidRootPart") or player.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")

-- States
local ESPEnabled = true
local AutoTeleportBond = true
local autoLoot = true
local autoSell = true
local fullBrightEnabled = true
local autoRejoin = true

-- UI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "DeadRailProUI"
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 400, 0, 320)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Name = "MainFrame"

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "NatHub | Dead Rails Pro UI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0, 10, 0, 0)

-- Tab Setup
local tabs = {"Main", "Character", "Visual", "Combat", "Settings"}
local tabFrames = {}
local activeTab = nil

local tabButtonContainer = Instance.new("Frame", mainFrame)
tabButtonContainer.Size = UDim2.new(0, 100, 1, -40)
tabButtonContainer.Position = UDim2.new(0, 0, 0, 40)
tabButtonContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton", tabButtonContainer)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 40)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14

    local content = Instance.new("Frame", mainFrame)
    content.Size = UDim2.new(1, -110, 1, -50)
    content.Position = UDim2.new(0, 110, 0, 45)
    content.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    content.Visible = false
    tabFrames[name] = content

    btn.MouseButton1Click:Connect(function()
        for _, frame in pairs(tabFrames) do frame.Visible = false end
        content.Visible = true
    end)

    if not activeTab then
        activeTab = content
        content.Visible = true
    end
end

-- Utility Function
local function createToggle(parent, text, default, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -20, 0, 40)
    container.Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 45 - 50)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggle = Instance.new("TextButton", container)
    toggle.Size = UDim2.new(0.3, 0, 0.7, 0)
    toggle.Position = UDim2.new(0.65, 0, 0.15, 0)
    toggle.Text = default and "ON" or "OFF"
    toggle.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(150, 0, 0)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 13

    toggle.MouseButton1Click:Connect(function()
        default = not default
        toggle.Text = default and "ON" or "OFF"
        toggle.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(150, 0, 0)
        callback(default)
    end)
end

-- Tab: Main
createToggle(tabFrames.Main, "Auto Bond", AutoTeleportBond, function(v) AutoTeleportBond = v end)
createToggle(tabFrames.Main, "ESP", ESPEnabled, function(v) ESPEnabled = v end)
createToggle(tabFrames.Main, "Full Bright", fullBrightEnabled, function(v)
    fullBrightEnabled = v
    for _, p in pairs(Workspace:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Material = v and Enum.Material.SmoothPlastic or Enum.Material.Plastic
            p.Color = v and Color3.new(1,1,1) or p.Color
        end
    end
end)

-- Tab: Character
createToggle(tabFrames.Character, "Auto Loot", autoLoot, function(v) autoLoot = v end)
createToggle(tabFrames.Character, "Auto Sell", autoSell, function(v) autoSell = v end)

-- Tab: Settings
createToggle(tabFrames.Settings, "Auto Rejoin", autoRejoin, function(v) autoRejoin = v end)

-- ESP and Bond logic (simplified for demo)
local function scanBonds()
    local found = {}
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("Part") and part.Name:lower():find("bond") and part:FindFirstChild("TouchInterest") then
            table.insert(found, part)
        end
    end
    return found
end

RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, part in ipairs(scanBonds()) do
            local pos, visible = camera:WorldToViewportPoint(part.Position)
            if visible then
                local b = Drawing.new("Text")
                b.Text = "Bond"
                b.Size = 13
                b.Position = Vector2.new(pos.X, pos.Y)
                b.Color = Color3.fromRGB(0, 255, 0)
                b.Center = true
                b.Outline = true
                task.delay(0.1, function() b:Remove() end)
            end
        end
    end
end)

-- Auto Bond Logic
local function autoCollect()
    while true do
        if AutoTeleportBond then
            for _, bond in ipairs(scanBonds()) do
                if bond:IsDescendantOf(Workspace) then
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = bond.CFrame + Vector3.new(0, 3, 0)
                        wait(0.2)
                    end
                end
            end
        end
        task.wait(1)
    end
end

spawn(autoCollect)
