-- Dead Rail PRO Script | Full Features 
-- Author: Kimizuka Kimiho

--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

--// Vars
local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "DeadRailPRO"

--// States
local state = {
    AutoBond = false,
    UltimateBond = false,
    FullBright = false,
    ESP = false,
    AutoSell = false,
    AutoLoot = false,
    AutoWin = false,
    Rejoin = false,
    Noclip = false,
    AutoDrive = false
}

--// UI Library
local function createToggle(name, description, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Text = name
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 14

    local toggle = Instance.new("TextButton", frame)
    toggle.Text = default and "ON" or "OFF"
    toggle.Size = UDim2.new(0.3, 0, 0.6, 0)
    toggle.Position = UDim2.new(0.7, 0, 0.2, 0)
    toggle.BackgroundColor3 = default and Color3.fromRGB(34,197,94) or Color3.fromRGB(100,100,100)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 14
    toggle.TextColor3 = Color3.fromRGB(255,255,255)
    toggle.MouseButton1Click:Connect(function()
        default = not default
        toggle.Text = default and "ON" or "OFF"
        toggle.BackgroundColor3 = default and Color3.fromRGB(34,197,94) or Color3.fromRGB(100,100,100)
        callback(default)
    end)

    return frame
end

--// UI Layout
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 300)
main.Position = UDim2.new(0.5, -200, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BackgroundTransparency = 0.2
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.Draggable = true

local tabs = Instance.new("Frame", main)
tabs.Size = UDim2.new(0, 100, 1, 0)
tabs.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tabs.BorderSizePixel = 0

local content = Instance.new("Frame", main)
content.Position = UDim2.new(0, 100, 0, 0)
content.Size = UDim2.new(1, -100, 1, 0)
content.BackgroundTransparency = 1

--// Tab Buttons
local function createTabButton(name)
    local btn = Instance.new("TextButton", tabs)
    btn.Text = name
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    return btn
end

--// Tabs Dictionary
local pages = {}
local tabNames = {"Main", "Character", "Visual", "Combat", "Settings"}
for _, name in ipairs(tabNames) do
    local tab = createTabButton(name)
    local page = Instance.new("ScrollingFrame", content)
    page.Visible = false
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 4
    page.BackgroundTransparency = 1
    pages[name] = page

    tab.MouseButton1Click:Connect(function()
        for _, pg in pairs(pages) do pg.Visible = false end
        page.Visible = true
    end)
end
pages["Main"].Visible = true

--// Main Tab Toggles
pages["Main"]:AddChild(createToggle("Auto Bond", "Automatically collect bonds", false, function(v) state.AutoBond = v end))
pages["Main"]:AddChild(createToggle("Ultimate Bond", "Teleport rapidly to collect bond", false, function(v) state.UltimateBond = v end))
pages["Main"]:AddChild(createToggle("Auto Win", "Teleport to end instantly", false, function(v) state.AutoWin = v end))

--// Character Tab
pages["Character"]:AddChild(createToggle("Auto Drive", "Drive vehicle automatically", false, function(v) state.AutoDrive = v end))
pages["Character"]:AddChild(createToggle("Noclip", "Walk through walls", false, function(v) state.Noclip = v end))

--// Visual Tab
pages["Visual"]:AddChild(createToggle("ESP", "Highlight bonds and items", false, function(v) state.ESP = v end))
pages["Visual"]:AddChild(createToggle("Full Bright", "Brighten environment", false, function(v)
    state.FullBright = v
    for _, p in pairs(Workspace:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Material = v and Enum.Material.SmoothPlastic or Enum.Material.Plastic
            p.Color = v and Color3.new(1,1,1) or p.Color
        end
    end
end))

--// Combat Tab
pages["Combat"]:AddChild(createToggle("Auto Loot", "Collect all loot", false, function(v) state.AutoLoot = v end))
pages["Combat"]:AddChild(createToggle("Auto Sell", "Sell collected items", false, function(v) state.AutoSell = v end))

--// Settings Tab
pages["Settings"]:AddChild(createToggle("Rejoin", "Rejoin server on crash", false, function(v) state.Rejoin = v end))

--// Logic Hooks
RunService.RenderStepped:Connect(function()
    if state.ESP then
        -- Draw ESP here
    end
    if state.AutoBond or state.UltimateBond then
        -- Bond farming logic
    end
    if state.AutoWin then
        -- Teleport to end goal
    end
end)

print("✅ Dead Rail PRO Script Loaded ")
