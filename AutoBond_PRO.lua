-- Dead Rail Pro Script with Anti-Detection, ESP, Auto Bond, Aimbot, FullBright, Noclip, GUI + Bond Counter

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
local camLoop = nil
local deathConn = nil
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

-- GUI Setup
local function createGUI()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "DeadRailProUI"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0.5, -150, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.2
    frame.Active = true
    frame.Draggable = true

    local function createToggle(name, posY, callback)
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1, -20, 0, 30)
        btn.Position = UDim2.new(0, 10, 0, posY)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        local state = false
        btn.Text = name .. " [OFF]"
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = name .. (state and " [ON]" or " [OFF]")
            callback(state)
        end)
    end

    createToggle("ESP", 10, function(v) ESPEnabled = v end)
    createToggle("Auto Teleport Bond", 50, function(v) AutoTeleportBond = v end)
    createToggle("Auto Loot", 90, function(v) autoLoot = v end)
    createToggle("Auto Sell", 130, function(v) autoSell = v end)
    createToggle("Auto Rejoin", 170, function(v) rejoinFlag = v end)
    createToggle("FullBright", 210, function(v)
        fullBrightEnabled = v
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Material = v and Enum.Material.SmoothPlastic or Enum.Material.Plastic
                part.Color = v and Color3.fromRGB(255,255,255) or part.Color
            end
        end
    end)
    createToggle("Noclip", 250, function(v) noclip = v end)
    createToggle("Auto Drive", 290, function(v) autoDrive = v end)
end

-- ESP Core
local function CreateESP()
    local box = Drawing.new("Square")
    box.Color = Color3.fromRGB(255, 0, 0)
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

-- Bond Counter UI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "BondCounter"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 70)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Draggable = true
Frame.Active = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0.4, 0)
Title.BackgroundTransparency = 1
Title.Text = "Bond Counter"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextScaled = true

local CountLabel = Instance.new("TextLabel", Frame)
CountLabel.Position = UDim2.new(0, 0, 0.4, 0)
CountLabel.Size = UDim2.new(1, 0, 0.6, 0)
CountLabel.BackgroundTransparency = 1
CountLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
CountLabel.Font = Enum.Font.SourceSans
CountLabel.TextScaled = true
CountLabel.Text = "Đang quét..."

local total = 0
local collected = 0
local found = {}

local function updateCounter()
    CountLabel.Text = "Đã nhặt: " .. collected .. "/" .. total
end

-- Scan and Collect Bonds
local function scanAndCollect()
    total = 0
    collected = 0
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

-- Start Collection
task.spawn(scanAndCollect)

-- Auto Teleport to Nearest Bond
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
