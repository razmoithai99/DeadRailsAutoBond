-- Dead Rails Mobile Ultimate Script
-- AutoBond, AutoFarm, AutoWin, Teleport End & ESP

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer
repeat task.wait() until lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
local hrp = lp.Character.HumanoidRootPart

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DeadRailsMobileGui"
gui.Parent = lp.PlayerGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,260); frame.Position = UDim2.new(0.02,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30); frame.BorderSizePixel = 0

local UIList = Instance.new("UIListLayout", frame); UIList.Padding = UDim.new(0,6)

-- Buttons
local function createBtn(text,func)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-10,0,35)
    b.Text = text; b.Font = Enum.Font.SourceSansBold; b.TextScaled=true
    b.TextColor3=Color3.new(1,1,1); b.BackgroundColor3=Color3.fromRGB(50,50,50)
    b.MouseButton1Click:Connect(func)
end

-- States
local autoBond, autoFarm, autoWin, espOn = false,false,false,false

-- Functions
local function autoBondFunc()
    while autoBond and task.wait(0.25) do
        for _,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Activate") then
                fireproximityprompt(v.Activate)
            end
        end
    end
end

local function autoFarmFunc()
    while autoFarm and task.wait(0.35) do
        for _,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Activate") then
                hrp.CFrame = v:GetModelCFrame() + Vector3.new(0,3,0)
                task.wait(0.1)
                fireproximityprompt(v.Activate)
            end
        end
    end
end

local function autoWinFunc()
    while autoWin and task.wait(1.2) do
        ReplicatedStorage.RemoteEvent:FireServer({"CompleteRaceClient"})
    end
end

local function teleportToEnd()
    for _,v in pairs(Workspace:GetDescendants()) do
        if v.Name=="EndPart" then
            hrp.CFrame = v.CFrame + Vector3.new(0,5,0)
            break
        end
    end
end

local function toggleESP()
    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Activate") and not v:FindFirstChild("BondESP") then
            local bb = Instance.new("BillboardGui", v)
            bb.Name = "BondESP"
            bb.Size = UDim2.new(0,100,0,40); bb.AlwaysOnTop=true; bb.Adornee=v
            local lbl = Instance.new("TextLabel", bb)
            lbl.Size = UDim2.new(1,0,1,0)
            lbl.Text="BOND"; lbl.TextScaled=true; lbl.BackgroundTransparency=1
            lbl.TextColor3=Color3.fromRGB(255,255,0)
        end
    end
end

-- GUI Buttons
createBtn("Auto Bond", function()
    autoBond = not autoBond
    if autoBond then task.spawn(autoBondFunc) end
end)
createBtn("Auto Farm", function()
    autoFarm = not autoFarm
    if autoFarm then task.spawn(autoFarmFunc) end
end)
createBtn("Auto Win", function()
    autoWin = not autoWin
    if autoWin then task.spawn(autoWinFunc) end
end)
createBtn("Teleport to End", teleportToEnd)
createBtn("ESP Bond", function()
    espOn = not espOn
    if espOn then toggleESP() end
end)

print("[✅] Dead Rails Mobile Ultimate Loaded")
