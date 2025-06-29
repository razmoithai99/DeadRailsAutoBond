
-- Dead Rail PRO Script | Fully Functional + NatHub-Style UI + Bond System + ESP + Utility Tools
-- Author: Kimizuka Kimiho

-- SERVICES
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local function waitForHRP()
    if player.Character then
        return player.Character:WaitForChild("HumanoidRootPart", 3)
    end
    player.CharacterAdded:Wait()
    return player.Character:WaitForChild("HumanoidRootPart", 3)
end

local hrp = waitForHRP()

local state = {
    FullBright = false,
    ESP = false,
    AutoBond = false,
    Noclip = false,
    SpeedHack = false
}

-- UI SETUP
local gui = Instance.new("ScreenGui")
gui.Name = "DeadRailProUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local iconButton = Instance.new("ImageButton")
iconButton.Name = "MinimizeIcon"
iconButton.Image = "rbxassetid://17786626191"
iconButton.Size = UDim2.new(0, 40, 0, 40)
iconButton.Position = UDim2.new(0, 20, 0, 20)
iconButton.BackgroundTransparency = 1
iconButton.Visible = false
iconButton.Parent = gui

local uiFrame = Instance.new("Frame")
uiFrame.Name = "MainUI"
uiFrame.Size = UDim2.new(0, 320, 0, 300)
uiFrame.Position = UDim2.new(0.02, 0, 0.1, 0)
uiFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 174)
uiFrame.BackgroundTransparency = 0.1
uiFrame.BorderSizePixel = 0
uiFrame.Active = true
uiFrame.Draggable = true
uiFrame.ClipsDescendants = true
uiFrame.Parent = gui

local uiCorner = Instance.new("UICorner", uiFrame)
uiCorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Text = "Dead Rail PRO UI"
title.Size = UDim2.new(1, 0, 0, 35)
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.TextScaled = true
title.Parent = uiFrame

local function createToggle(text, order, bind)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, 40 + order * 40)
    btn.Text = text .. ": TẮT"
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.Parent = uiFrame

    local round = Instance.new("UICorner", btn)
    round.CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        state[bind] = not state[bind]
        btn.Text = text .. ": " .. (state[bind] and "BẬT" or "TẮT")
    end)
end

createToggle("ESP", 0, "ESP")
createToggle("FullBright", 1, "FullBright")
createToggle("Auto Bond", 2, "AutoBond")
createToggle("Noclip", 3, "Noclip")
createToggle("Speed Hack", 4, "SpeedHack")

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -35, 0, 5)
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextScaled = true
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minimize.Parent = uiFrame

local closeCorner = Instance.new("UICorner", minimize)
closeCorner.CornerRadius = UDim.new(0, 8)

minimize.MouseButton1Click:Connect(function()
    uiFrame.Visible = false
    iconButton.Visible = true
end)

iconButton.MouseButton1Click:Connect(function()
    uiFrame.Visible = true
    iconButton.Visible = false
end)

-- ESP SYSTEM
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
    if not state.ESP then
        for _, box in pairs(espBoxes) do box.Visible = false end
        return
    end
    for obj, box in pairs(espBoxes) do
        if obj and obj:IsDescendantOf(Workspace) then
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

-- BOND COLLECTION
local function scanBonds()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("bond") and obj:FindFirstChild("TouchInterest") then
            if not espBoxes[obj] then
                espBoxes[obj] = createESPBox()
            end
        end
    end
end

local function collectBonds()
    scanBonds()
    for obj in pairs(espBoxes) do
        if hrp and obj and obj:IsDescendantOf(Workspace) then
            hrp.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
            task.wait(0.25)
        end
    end
end

-- FULLBRIGHT
local function toggleFullBright()
    if state.FullBright then
        Lighting.Brightness = 3
        Lighting.GlobalShadows = false
        for _, p in ipairs(Workspace:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Material = Enum.Material.SmoothPlastic
                p.Color = Color3.new(1, 1, 1)
            end
        end
    end
end

-- RUNTIME
RunService.RenderStepped:Connect(function()
    if state.ESP then updateESP() end
    if state.FullBright then toggleFullBright() end
    if state.AutoBond then collectBonds() end
end)

print("✅ Dead Rail PRO UI Loaded")
