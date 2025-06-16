-- Auto Bond Script for Dead Rails - PRO Version (Optimized like NatHub with Visual Log)

--// Variables
local p = game.Players.LocalPlayer
local hrp = nil
local bondEvent = nil

--// Try to detect RemoteEvent related to Bond
for _,v in pairs(game:GetDescendants()) do
    if v:IsA("RemoteEvent") and v.Name:lower():find("bond") then
        bondEvent = v
        break
    end
end

--// GUI Setup
local f = Instance.new
local gui = f("ScreenGui", p:WaitForChild("PlayerGui"))
gui.Name = "AutoBondProUI"

-- Toggle Button
local btn = f("TextButton", gui)
btn.Size = UDim2.new(0, 160, 0, 40)
btn.Position = UDim2.new(0, 10, 0, 10)
btn.Text = "Auto Bond: OFF"
btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.TextScaled = true

-- Debug Label
local log = f("TextLabel", gui)
log.Size = UDim2.new(0, 300, 0, 25)
log.Position = UDim2.new(0, 10, 0, 55)
log.Text = "[LOG] Waiting..."
log.TextColor3 = Color3.fromRGB(0,255,127)
log.BackgroundTransparency = 1
log.TextScaled = true

-- Auto Bond Toggle
local on = false
btn.MouseButton1Click:Connect(function()
    on = not on
    btn.Text = "Auto Bond: " .. (on and "ON" or "OFF")
    btn.BackgroundColor3 = on and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
    log.Text = "[LOG] AutoBond is " .. (on and "ACTIVE" or "OFF")
end)

-- Check if it's safe (no other players near you)
local function isSafe()
    if not hrp then return false end
    for _,v in pairs(game.Players:GetPlayers()) do
        if v ~= p and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if (v.Character.HumanoidRootPart.Position - hrp.Position).Magnitude < 25 then
                return false
            end
        end
    end
    return true
end

-- Main AutoBond Logic
spawn(function()
    while task.wait(math.random(6,12)/10) do -- 0.6s - 1.2s
        if on and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            hrp = p.Character.HumanoidRootPart
            if not isSafe() then
                log.Text = "[LOG] Nearby player detected – pausing"
                continue
            end

            local found = false
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:lower():find("bond") and v.Parent:FindFirstChild("TouchInterest") then
                    if bondEvent then
                        pcall(function() bondEvent:FireServer(v) end)
                    else
                        hrp.CFrame = v.CFrame + Vector3.new(0,2,0)
                    end
                    log.Text = "[LOG] Collected bond at: "..v:GetFullName()
                    wait(math.random(8,16)/100) -- 0.08s - 0.16s
                    found = true
                    break
                end
            end
            if not found then
                log.Text = "[LOG] No bond found in current scan"
            end
        end
    end
end)

-- Final protection (anti-error fallback)
log.Text = "[LOG] AutoBond PRO loaded – ready!"
