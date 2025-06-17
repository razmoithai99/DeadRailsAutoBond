-- Dead Rails Ultimate Hack (Mobile & PC)
-- Features: Auto Bond, Auto Farm, Auto Win, ESP, Teleport, GUI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local localPlayer = Players.LocalPlayer
local hrp = localPlayer.Character and localPlayer.Character:WaitForChild("HumanoidRootPart")

-- GUI INIT --
local ScreenGui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "DeadRailsUltimateGUI"
local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0.02, 0, 0.1, 0)
Frame.Size = UDim2.new(0, 200, 0, 300)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0

local function createToggle(name, y, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Size = UDim2.new(0, 180, 0, 30)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(function()
        callback()
    end)
    return btn
end

-- States --
local autoBond = false
local autoFarm = false
local autoWin = false
local espOn = false
local teleportToEnd = false

-- AUTO BOND
local function doAutoBond()
    while autoBond and task.wait(0.2) do
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v.Name == "RuntimeItem" and v:IsA("Model") and v:FindFirstChild("Activate") then
                fireproximityprompt(v.Activate)
            end
        end
    end
end

-- AUTO FARM BOND
local function doAutoFarm()
    while autoFarm and task.wait(0.3) do
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v.Name == "RuntimeItem" and v:IsA("Model") and v:FindFirstChild("Activate") then
                hrp.CFrame = v.CFrame + Vector3.new(0,3,0)
                task.wait(0.2)
                fireproximityprompt(v.Activate)
            end
        end
    end
end

-- AUTO WIN
local function doAutoWin()
    while autoWin and task.wait(1) do
        ReplicatedStorage.RemoteEvent:FireServer({"CompleteRaceClient"})
    end
end

-- TELEPORT TO END
local function doTeleportToEnd()
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v.Name == "EndPart" then
            hrp.CFrame = v.CFrame + Vector3.new(0,5,0)
            break
        end
    end
end

-- ESP
local function toggleESP()
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v.Name == "RuntimeItem" and not v:FindFirstChild("BillboardGui") then
            local bb = Instance.new("BillboardGui", v)
            bb.Size = UDim2.new(0,100,0,50)
            bb.Adornee = v
            bb.AlwaysOnTop = true
            local lbl = Instance.new("TextLabel", bb)
            lbl.Size = UDim2.new(1,0,1,0)
            lbl.Text = "BOND"
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Color3.new(1,1,0)
            lbl.TextScaled = true
        end
    end
end

-- GUI BUTTONS
createToggle("Auto Bond", 10, function()
    autoBond = not autoBond
    doAutoBond()
end)

createToggle("Auto Farm Bond", 50, function()
    autoFarm = not autoFarm
    doAutoFarm()
end)

createToggle("Auto Win", 90, function()
    autoWin = not autoWin
    doAutoWin()
end)

createToggle("Teleport to End", 130, function()
    doTeleportToEnd()
end)

createToggle("ESP Bonds", 170, function()
    espOn = not espOn
    if espOn then toggleESP() end
end)

-- READY
print("[+] Dead Rails Ultimate Loaded")
