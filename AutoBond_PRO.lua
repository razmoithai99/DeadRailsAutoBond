-- Dead Rail PRO Script | 
-- Author: Kimizuka Kimiho

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

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
local autoDrive = true
local rejoinFlag = true
local modDetected = false

-- UI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "DeadRailProUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 380, 0, 320)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 36)
Title.BackgroundTransparency = 1
Title.Text = "Dead Rails | Pro UI"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

local Tabs = Instance.new("Frame", MainFrame)
Tabs.Size = UDim2.new(0, 110, 1, -36)
Tabs.Position = UDim2.new(0, 0, 0, 36)
Tabs.BackgroundColor3 = Color3.fromRGB(30, 30, 40)

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -110, 1, -36)
Content.Position = UDim2.new(0, 110, 0, 36)
Content.BackgroundColor3 = Color3.fromRGB(40, 40, 50)

local function createTabButton(name, order)
    local btn = Instance.new("TextButton", Tabs)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, (order - 1) * 30)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    return btn
end

local tabNames = {"Main", "Character", "Visual", "Combat", "Settings"}
local tabContent = {}
for i, name in ipairs(tabNames) do
    tabContent[name] = Instance.new("Frame", Content)
    tabContent[name].Size = UDim2.new(1, 0, 1, 0)
    tabContent[name].BackgroundTransparency = 1
    tabContent[name].Visible = (i == 1)

    local tabBtn = createTabButton(name, i)
    tabBtn.MouseButton1Click:Connect(function()
        for _, frame in pairs(tabContent) do frame.Visible = false end
        tabContent[name].Visible = true
    end)
end

-- UI Toggle Component
local function createToggle(parent, title, state, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, 0, 0, 30)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.Font = Enum.Font.Gotham
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggle = Instance.new("TextButton", container)
    toggle.Size = UDim2.new(0.25, 0, 0.6, 0)
    toggle.Position = UDim2.new(0.75, 0, 0.2, 0)
    toggle.BackgroundColor3 = state and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(80, 80, 80)
    toggle.Text = state and "ON" or "OFF"
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 12
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)

    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(80, 80, 80)
        toggle.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

-- Add toggles to Main tab
createToggle(tabContent["Main"], "ESP (Hiển thị Bond)", ESPEnabled, function(val) ESPEnabled = val end)
createToggle(tabContent["Main"], "Auto Bond (Tự nhặt Bond)", AutoTeleportBond, function(val) AutoTeleportBond = val end)
createToggle(tabContent["Visual"], "Full Bright", fullBrightEnabled, function(val)
    fullBrightEnabled = val
    for _, p in pairs(Workspace:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Material = val and Enum.Material.SmoothPlastic or Enum.Material.Plastic
            p.Color = val and Color3.new(1,1,1) or p.Color
        end
    end
end)
createToggle(tabContent["Character"], "Auto Loot", autoLoot, function(val) autoLoot = val end)
createToggle(tabContent["Character"], "Auto Sell", autoSell, function(val) autoSell = val end)
createToggle(tabContent["Settings"], "Auto Drive", autoDrive, function(val) autoDrive = val end)
createToggle(tabContent["Settings"], "Auto Rejoin", rejoinFlag, function(val) rejoinFlag = val end)

-- ESP Drawing
local espBoxes = {}
local function createESPBox()
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(0, 255, 0)
    box.Thickness = 2
    box.Filled = false
    return box
end

local function updateESP()
    for obj, box in pairs(espBoxes) do
        if not ESPEnabled or not obj or not obj:IsDescendantOf(Workspace) then
            box.Visible = false
        else
            local pos = obj.Position
            local screen, onScreen = camera:WorldToViewportPoint(pos)
            if onScreen then
                local size = math.clamp(3000 / (camera.CFrame.Position - pos).Magnitude, 20, 80)
                box.Size = Vector2.new(size, size * 1.5)
                box.Position = Vector2.new(screen.X - size / 2, screen.Y - size / 2)
                box.Visible = true
            else
                box.Visible = false
            end
        end
    end
end

-- Bond Collect
local bondList = {}
local collected = 0
local total = 0

local function scanBonds()
    table.clear(bondList)
    total = 0
    collected = 0
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("Part") and part.Name:lower():find("bond") and part:FindFirstChild("TouchInterest") then
            table.insert(bondList, part)
            if not espBoxes[part] then
                espBoxes[part] = createESPBox()
            end
            total += 1
        end
    end
end

local function collectBonds()
    for _, bond in ipairs(bondList) do
        if bond and bond:IsDescendantOf(Workspace) then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and AutoTeleportBond then
                hrp.CFrame = bond.CFrame + Vector3.new(0, 3, 0)
                wait(0.2)
                collected += 1
            end
        end
    end
end

-- Execution
scanBonds()
task.spawn(collectBonds)
RunService.RenderStepped:Connect(updateESP)
