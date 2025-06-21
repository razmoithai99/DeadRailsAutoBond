-- Dead Rail Pro Script 

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- Variables
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- States
local ESPEnabled = false
local AutoTeleportBond = false
local autoLoot = false
local autoSell = false
local rejoinFlag = false
local modDetected = false
local currentTarget = nil
local noclip = false
local fullBrightEnabled = false
local autoDrive = false

-- Storage
local espBoxes = {}
local objectsToTrack = {
    "Bond", "GoldBar", "Crucifix", "Book", "Statue", "Chair", "Torch",
    "Teapot", "SilverPocketWatch", "GoldStatue", "Vase", "SilverBar"
}

-- Notifications
local function notify(text)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Dead Rail Script",
            Text = text,
            Duration = 3
        })
    end)
end

-- Detect Moderator
local function detectMods()
    for _, p in ipairs(Players:GetPlayers()) do
        if p:GetRankInGroup(11867394) > 200 then
            modDetected = true
            notify("Moderator detected! Script disabled.")
            return true
        end
    end
    return false
end

-- ESP Core
local function CreateESP()
    local box = Drawing.new("Square")
    box.Color = Color3.fromRGB(0, 255, 0)
    box.Thickness = 2
    box.Filled = false
    box.Visible = false
    return box
end

local function UpdateESP()
    if not ESPEnabled then
        for _, box in pairs(espBoxes) do box.Visible = false end
        return
    end
    for obj, box in pairs(espBoxes) do
        if obj and obj.Parent then
            local pos = obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart.Position or obj.Position
            if pos then
                local screen, visible = Camera:WorldToViewportPoint(pos)
                if visible then
                    local dist = (Camera.CFrame.Position - pos).Magnitude
                    local size = math.clamp(3000 / dist, 20, 100)
                    box.Size = Vector2.new(size, size * 1.5)
                    box.Position = Vector2.new(screen.X - size / 2, screen.Y - size / 2)
                    box.Visible = true
                else
                    box.Visible = false
                end
            end
        else
            box.Visible = false
        end
    end
end

local function TrackObjects()
    local parent = Workspace:FindFirstChild("RuntimeItems")
    if parent then
        for _, name in ipairs(objectsToTrack) do
            for _, obj in ipairs(parent:GetChildren()) do
                if obj.Name == name and not espBoxes[obj] then
                    espBoxes[obj] = CreateESP()
                end
            end
        end
    end
end

-- UI
local ui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ui.Name = "DeadRailProUI"

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 100)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = ui
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.3, 0)
title.BackgroundTransparency = 1
title.Text = "Dead Rail Bond Counter"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = mainFrame

local bondLabel = Instance.new("TextLabel")
bondLabel.Position = UDim2.new(0, 0, 0.3, 0)
bondLabel.Size = UDim2.new(1, 0, 0.7, 0)
bondLabel.BackgroundTransparency = 1
bondLabel.Text = "Đang quét..."
bondLabel.Font = Enum.Font.Gotham
title.TextWrapped = true
bondLabel.TextSize = 14
bondLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
bondLabel.Parent = mainFrame

-- Counter logic
local total, collected, found = 0, 0, {}
local function updateCounter()
    bondLabel.Text = "Đã nhặt: " .. collected .. "/" .. total
end

local function scanAndCollect()
    total, collected = 0, 0
    table.clear(found)
    for _, bond in ipairs(Workspace:GetDescendants()) do
        if bond:IsA("Part") and bond.Name:lower():find("bond") and bond:FindFirstChild("TouchInterest") then
            table.insert(found, bond)
            total += 1
        end
    end
    updateCounter()

    for _, bond in ipairs(found) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = bond.CFrame + Vector3.new(0, 3, 0)
            wait(0.2)
            collected += 1
            updateCounter()
        end
    end
end

-- Bond Teleport
local function GetNearestBond()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local nearest, shortest = nil, math.huge
    local items = Workspace:FindFirstChild("RuntimeItems")
    if root and items then
        for _, obj in ipairs(items:GetChildren()) do
            if obj.Name == "Bond" and obj:IsA("Model") and obj.PrimaryPart then
                local dist = (root.Position - obj.PrimaryPart.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    nearest = obj
                end
            end
        end
    end
    return nearest
end

-- Start services
TrackObjects()
RunService.RenderStepped:Connect(UpdateESP)
task.spawn(scanAndCollect)

-- Toggle bridges
_G.ToggleESP = function(val)
    ESPEnabled = val
end

_G.ToggleAutoTeleportBond = function(val)
    AutoTeleportBond = val
end

_G.ToggleAutoLoot = function(val)
    autoLoot = val
end

_G.ToggleFullBright = function(val)
    fullBrightEnabled = val
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = val and Enum.Material.SmoothPlastic or Enum.Material.Plastic
            part.Color = val and Color3.fromRGB(255,255,255) or part.Color
        end
    end
end
