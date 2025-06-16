

local p = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
gui.Name = "AutoBondUI_Pro"

-- Button bật/tắt
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0,160,0,40)
btn.Position = UDim2.new(0,10,0,10)
btn.Text = "Auto Bond: OFF"
btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
btn.TextColor3 = Color3.new(1,1,1)
btn.TextScaled = true
btn.Font = Enum.Font.Gotham
btn.BorderSizePixel = 0
btn.AutoButtonColor = false

-- Log trạng thái
local log = Instance.new("TextLabel", gui)
log.Size = UDim2.new(0,300,0,25)
log.Position = UDim2.new(0,10,0,55)
log.Text = "[Log] Ready"
log.TextColor3 = Color3.fromRGB(0,255,127)
log.BackgroundTransparency = 1
log.TextScaled = true
log.Font = Enum.Font.Gotham

-- Bộ đếm bond
local counter = Instance.new("TextLabel", gui)
counter.Size = UDim2.new(0,300,0,25)
counter.Position = UDim2.new(0,10,0,85)
counter.Text = "Bond Collected: 0"
counter.TextColor3 = Color3.fromRGB(255, 215, 0)
counter.BackgroundTransparency = 1
counter.TextScaled = true
counter.Font = Enum.Font.Gotham

local collectedCount = 0
local on = false

btn.MouseButton1Click:Connect(function()
    on = not on
    btn.Text = "Auto Bond: "..(on and "ON" or "OFF")
    btn.BackgroundColor3 = on and Color3.fromRGB(0,170,0) or Color3.fromRGB(50,50,50)
    log.Text = on and "[Log] Farming started" or "[Log] Farming stopped"
end)

-- Tự ngồi
local function trySit()
    local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Sit = true end
end

-- Hồi sinh nếu chết
local function autoRespawn()
    local function respawned()
        repeat task.wait() until p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        log.Text = "[Log] Respawned"
    end

    p.CharacterAdded:Connect(respawned)
end

autoRespawn()

-- Dịch chuyển và nhặt bond
local function collect()
    local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, b in ipairs(workspace:GetDescendants()) do
        if b:IsA("BasePart") and b.Name:lower():find("bond") then
            p.Character:PivotTo(b.CFrame + Vector3.new(0,2,0))
            trySit()
            collectedCount += 1
            counter.Text = "Bond Collected: "..collectedCount
            log.Text = "[Log] Bond Found: "..b.Name
            task.wait(0.1)
        end
    end
end

-- Loop chính
task.spawn(function()
    while task.wait(0.7) do
        if on then
            collect()
            task.wait(0.3)
        end
    end
end)
