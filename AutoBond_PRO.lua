-- Dead Rails Mobile Ultimate Script 🛠️
-- Chạy trên Arceus X / Hydrogen / Delta...

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Đợi nhân vật load
local lp = Players.LocalPlayer
repeat task.wait() until lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
local hrp = lp.Character.HumanoidRootPart

-- GUI cơ bản
local gui = Instance.new("ScreenGui")
gui.Name = "DRMobileGui"
gui.Parent = lp:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,260)
frame.Position = UDim2.new(0.02,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0

local UIList = Instance.new("UIListLayout", frame)
UIList.Padding = UDim.new(0,6)

-- Nút tạo tiện
local function createBtn(text, cb)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-10,0,35)
    b.Text = text
    b.Font = Enum.Font.SourceSansBold
    b.TextScaled = true
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.MouseButton1Click:Connect(cb)
end

-- Trạng thái
local autoBond, autoFarm, autoWin, espOn = false, false, false, false

-- Core functions
local function autoBondFunc()
    while autoBond do
        task.wait(0.25)
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Activate") then
                pcall(function()
                    fireproximityprompt(v:FindFirstChild("Activate"))
                end)
            end
        end
    end
end

local function autoFarmFunc()
    while autoFarm do
        task.wait(0.35)
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Activate") then
                pcall(function()
                    hrp.CFrame = v:GetModelCFrame() + Vector3.new(0,3,0)
                    task.wait(0.1)
                    fireproximityprompt(v:FindFirstChild("Activate"))
                end)
            end
        end
    end
end

local function autoWinFunc()
    while autoWin do
        task.wait(1)
        pcall(function()
            ReplicatedStorage.RemoteEvent:FireServer({"CompleteRaceClient"})
        end)
    end
end

local function teleportToEnd()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v.Name == "EndPart" then
            hrp.CFrame = v.CFrame + Vector3.new(0,5,0)
            break
        end
    end
end

local function toggleESP()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Activate") and not v:FindFirstChild("BondESP") then
            local bb = Instance.new("BillboardGui", v)
            bb.Name = "BondESP"
            bb.Size = UDim2.new(0,100,0,40)
            bb.AlwaysOnTop = true
            bb.Adornee = v
            local txt = Instance.new("TextLabel", bb)
            txt.Size = UDim2.new(1,0,1,0)
            txt.BackgroundTransparency = 1
            txt.Text = "BOND"
            txt.TextColor3 = Color3.fromRGB(255,255,0)
            txt.TextScaled = true
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

print("[✅] DeadRails Mobile Ultimate Loaded!")
