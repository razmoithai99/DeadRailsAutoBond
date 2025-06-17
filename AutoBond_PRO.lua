-- Dead Rails Mobile Hack (Arceus X v3+)
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RepStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- GUI custom simple
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "DRailsHackGui"
local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0.02, 0, 0.1, 0)
Frame.Size = UDim2.new(0, 180, 0, 200)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0

local function createToggle(name, y)
    local btn = Instance.new("TextButton", Frame)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Size = UDim2.new(0, 160, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 18
    btn.Text = name..": OFF"
    btn.Active = true
    return btn
end

local btnBond = createToggle("Auto Bond", 10)
local btnWin = createToggle("Auto Win", 50)
local btnSpeed = createToggle("SpeedHack", 90)

local speedVal = 16
btnSpeed.Text = ("SpeedHack: %d"):format(speedVal)

-- States
local autoBond = false
local autoWin = false

-- Toggle events
btnBond.MouseButton1Click:Connect(function()
    autoBond = not autoBond
    btnBond.Text = "Auto Bond: " .. (autoBond and "ON" or "OFF")
    btnBond.BackgroundColor3 = autoBond and Color3.fromRGB(0,150,0) or Color3.fromRGB(60,60,60)
end)
btnWin.MouseButton1Click:Connect(function()
    autoWin = not autoWin
    btnWin.Text = "Auto Win: " .. (autoWin and "ON" or "OFF")
    btnWin.BackgroundColor3 = autoWin and Color3.fromRGB(0,150,0) or Color3.fromRGB(60,60,60)
end)
btnSpeed.MouseButton1Click:Connect(function()
    speedVal = speedVal >= 120 and 16 or speedVal + 16
    btnSpeed.Text = ("SpeedHack: %d"):format(speedVal)
end)

-- Core logic
task.spawn(function()
    while RunService.Heartbeat:Wait() do
        -- Apply speedhack
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = speedVal; hum.JumpPower = speedVal * 0.5 end
        end

        -- Auto Bond
        if autoBond and game.PlaceId == 70876832253163 then
            local items = Workspace:FindFirstChild("RuntimeItems")
            local fire = RepStorage:FindFirstChild("Packages")
                        and RepStorage.Packages:FindFirstChild("ActivateObjectClient")
            if items and fire then
                for _, item in pairs(items:GetChildren()) do
                    if item.Name == "Bond" and item:IsA("Model") and item.PrimaryPart then
                        local part = item.PrimaryPart
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            -- Di chuyển nhẹ nhàng từng bước để tránh phát hiện
                            hrp.CFrame = part.CFrame * CFrame.new(0,0.1,0)
                            fire:FireServer({object = item})
                            task.wait(0.1)
                        end
                    end
                end
            end
        end

        -- Auto Win
        if autoWin and game.PlaceId == 70876832253163 then
            local winEvent = RepStorage:FindFirstChild("Packages")
                            and RepStorage.Packages:FindFirstChild("CompleteRaceClient")
            if winEvent then
                winEvent:FireServer()
            end
        end
    end
end)
