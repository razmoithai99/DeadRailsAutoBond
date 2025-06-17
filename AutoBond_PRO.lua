-- Dead Rails Ultimate Mobile Edition
-- Features: Auto Bond, Auto Farm, Auto Win, Teleport, ESP (Optimized for Mobile)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local hrp = localPlayer.Character and localPlayer.Character:WaitForChild("HumanoidRootPart")

-- GUI INIT
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeadRailsMobileGUI"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 240)
Frame.Position = UDim2.new(0.02, 0, 0.5, -120)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

function createToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.Parent = Frame
    btn.MouseButton1Click:Connect(callback)
end

-- Toggles
local autoBond = false
local autoFarm = false
local autoWin = false
local espOn = false

-- Auto Bond
function autoBondFunc()
    while autoBond and task.wait(0.3) do
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v.Name == "RuntimeItem" and v:IsA("Model") and v:FindFirstChild("Activate") then
                fireproximityprompt(v.Activate)
            end
        end
    end
end

-- Auto Farm Bond
function autoFarmFunc()
    while autoFarm and task.wait(0.4) do
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v.Name == "RuntimeItem" and v:IsA("Model") and v:FindFirstChild("Activate") then
                hrp.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                task.wait(0.2)
                fireproximityprompt(v.Activate)
            end
        end
    end
end

-- Auto Win
function autoWinFunc()
    while autoWin and task.wait(1.2) do
        ReplicatedStorage.RemoteEvent:FireServer({"CompleteRaceClient"})
    end
end

-- Teleport to End
function teleportEnd()
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v.Name == "EndPart" then
            hrp.CFrame = v.CFrame + Vector3.new(0, 4, 0)
            break
        end
    end
end

-- ESP for Bonds
function toggleESP()
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v.Name == "RuntimeItem" and not v:FindFirstChild("BondESP") then
            local bb = Instance.new("BillboardGui", v)
            bb.Name = "BondESP"
            bb.Size = UDim2.new(0, 100, 0, 40)
            bb.AlwaysOnTop = true
            bb.Adornee = v
            local lbl = Instance.new("TextLabel", bb)
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "BOND"
            lbl.TextColor3 = Color3.fromRGB(255, 255, 0)
            lbl.TextScaled = true
        end
    end
end

-- UI Buttons
createToggle("Auto Bond", function()
    autoBond = not autoBond
    if autoBond then autoBondFunc() end
end)

createToggle("Auto Farm Bond", function()
    autoFarm = not autoFarm
    if autoFarm then autoFarmFunc() end
end)

createToggle("Auto Win", function()
    autoWin = not autoWin
    if autoWin then autoWinFunc() end
end)

createToggle("Teleport to End", function()
    teleportEnd()
end)

createToggle("ESP Bond", function()
    espOn = not espOn
    if espOn then toggleESP() end
end)

print("[+] Dead Rails Mobile Script Loaded")
