-- Dead Rail PRO Script | Fully Functional  + Bond System + ESP + Utility Tools
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
local fullBrightEnabled = true
local noclip = true
local AimbotEnabled = true

-- UI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local uiFrame = Instance.new("Frame")
uiFrame.Parent = gui
uiFrame.Size = UDim2.new(0, 240, 0, 140)
uiFrame.Position = UDim2.new(0, 20, 0, 20)
uiFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
uiFrame.BorderSizePixel = 0
uiFrame.Active = true
uiFrame.Draggable = true

local title = Instance.new("TextLabel", uiFrame)
title.Size = UDim2.new(1, 0, 0.2, 0)
title.Text = "Dead Rail PRO UI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.TextScaled = true

local bondStatus = Instance.new("TextLabel", uiFrame)
bondStatus.Position = UDim2.new(0, 0, 0.2, 0)
bondStatus.Size = UDim2.new(1, 0, 0.3, 0)
bondStatus.Text = "Đã nhặt: 0 / 0"
bondStatus.TextColor3 = Color3.fromRGB(180, 255, 180)
bondStatus.Font = Enum.Font.SourceSansBold
bondStatus.BackgroundTransparency = 1
bondStatus.TextScaled = true

-- ESP
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

-- Bond Collection Logic
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
        if bond and bond:IsDescendantOf(Workspace) and AutoTeleportBond then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = bond.CFrame + Vector3.new(0, 3, 0)
                wait(0.2)
                collected += 1
                bondStatus.Text = "Đã nhặt: " .. collected .. " / " .. total
            end
        end
    end
end

-- FullBright
if fullBrightEnabled then
    for _, p in pairs(Workspace:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Material = Enum.Material.SmoothPlastic
            p.Color = Color3.new(1, 1, 1)
        end
    end
end

-- Noclip
RunService.Stepped:Connect(function()
    if noclip then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- Aimbot Lock to NPC
local function getNearestTarget()
    local closestDist = math.huge
    local closestTarget = nil
    for _, npc in pairs(Workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
            local dist = (hrp.Position - npc.HumanoidRootPart.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestTarget = npc
            end
        end
    end
    return closestTarget
end

RunService.RenderStepped:Connect(function()
    updateESP()
    if AimbotEnabled then
        local target = getNearestTarget()
        if target then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.HumanoidRootPart.Position)
        end
    end
end)

-- Runtime
scanBonds()
task.spawn(collectBonds)

-- Feature Toggle APIs (for external GUI interaction)
_G.ToggleESP = function(state) ESPEnabled = state end
_G.ToggleAutoBond = function(state) AutoTeleportBond = state end
_G.ToggleFullBright = function(state)
    fullBrightEnabled = state
    for _, p in pairs(Workspace:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Material = state and Enum.Material.SmoothPlastic or Enum.Material.Plastic
            p.Color = state and Color3.new(1,1,1) or p.Color
        end
    end
end
