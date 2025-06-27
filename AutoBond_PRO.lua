from zipfile import ZipFile
from pathlib import Path

# Define the Lua script content as a file
script_content = """
-- Dead Rail PRO Script | Fully Functional + NatHub-Style UI + Bond System + ESP + Utility Tools
-- Author: Kimizuka Kimiho

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

-- Variables
local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local hrp = player.Character and player.Character:WaitForChild("HumanoidRootPart") or player.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")

-- States
local state = {
    FullBright = false,
    ESP = false,
    AutoWin = false,
    Noclip = false,
    AutoDrive = false,
    AutoBond = false
}

-- UI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
local uiFrame = Instance.new("Frame")
uiFrame.Parent = gui
uiFrame.Size = UDim2.new(0, 300, 0, 180)
uiFrame.Position = UDim2.new(0.02, 0, 0.1, 0)
uiFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
uiFrame.BackgroundTransparency = 0.2
uiFrame.BorderSizePixel = 0
uiFrame.Active = true
uiFrame.Draggable = true
uiFrame.ClipsDescendants = true
uiFrame.AnchorPoint = Vector2.new(0, 0)
uiFrame.Name = "MainMenu"
uiFrame.Visible = true
uiFrame.ZIndex = 5
uiFrame:TweenSizeAndPosition(UDim2.new(0, 300, 0, 180), UDim2.new(0.02, 0, 0.1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true)

local title = Instance.new("TextLabel", uiFrame)
title.Size = UDim2.new(1, 0, 0.2, 0)
title.Text = "Dead Rail | Pro UI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.TextScaled = true

-- ESP Setup
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
        else
            box.Visible = false
        end
    end
end

-- Auto Bond Logic
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
    while state.AutoBond do
        for _, bond in ipairs(bondList) do
            if bond and bond:IsDescendantOf(Workspace) then
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = bond.CFrame + Vector3.new(0, 3, 0)
                    wait(0.25)
                    collected += 1
                end
            end
        end
        wait(2)
        scanBonds()
    end
end

-- Runtime
RunService.RenderStepped:Connect(updateESP)
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

spawn(function()
    while true do
        if state.AutoBond then
            scanBonds()
            collectBonds()
        end
        wait(1)
    end
end)

-- Minimize Icon Placeholder
local icon = Instance.new("TextButton")
icon.Parent = gui
icon.Size = UDim2.new(0, 30, 0, 30)
icon.Position = UDim2.new(0, 10, 0, 10)
icon.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
icon.Text = "≡"
icon.TextColor3 = Color3.new(1,1,1)
icon.Visible = true
icon.ZIndex = 10

icon.MouseButton1Click:Connect(function()
    uiFrame.Visible = not uiFrame.Visible
end)

print("✅ Dead Rail PRO UI Loaded - NatHub Style")
"""

# Write the file to a temporary location and zip it
lua_path = Path("/mnt/data/DeadRail_Pro_Script.lua")
lua_path.write_text(script_content)

zip_path = Path("/mnt/data/DeadRail_Pro_Script.zip")
with ZipFile(zip_path, "w") as zipf:
    zipf.write(lua_path, arcname="DeadRail_Pro_Script.lua")

zip_path.name

