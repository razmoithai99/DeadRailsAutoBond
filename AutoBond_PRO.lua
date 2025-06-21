--// ✅ FULL DEAD RAILS SCRIPT v1.0 by Kimizuka Kimiho (Arceus X optimized)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

--// ✅ UI LIBRARY (Lightweight for Mobile)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "DeadRailsHub"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.Size = UDim2.new(0, 280, 0, 300)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 1
UIStroke.Color = Color3.fromRGB(90,90,90)

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "Dead Rails Hub"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 20

--// 🔁 Toggle System
local function createToggle(name, default, callback)
    local Toggle = Instance.new("TextButton", MainFrame)
    Toggle.Text = name .. " [" .. (default and "ON" or "OFF") .. "]"
    Toggle.Size = UDim2.new(1, -20, 0, 30)
    Toggle.Position = UDim2.new(0, 10, 0, #MainFrame:GetChildren() * 35)
    Toggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Toggle.TextColor3 = Color3.fromRGB(255,255,255)
    Toggle.Font = Enum.Font.Gotham
    Toggle.TextSize = 16
    Toggle.BorderSizePixel = 0
    Toggle.AutoButtonColor = false
    local toggled = default

    Toggle.MouseButton1Click:Connect(function()
        toggled = not toggled
        Toggle.Text = name .. " [" .. (toggled and "ON" or "OFF") .. "]"
        callback(toggled)
    end)
end

--// ✅ AUTO BOND + AUTO FARM
local function findBond()
    local target = nil
    local shortest = math.huge
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Model") and item:FindFirstChild("Activate") and item.PrimaryPart and item.Name:lower():find("bond") then
            local dist = (HumanoidRootPart.Position - item.PrimaryPart.Position).Magnitude
            if dist < shortest then
                target = item
                shortest = dist
            end
        end
    end
    return target
end

local autoFarm = false
createToggle("Auto Bond+Farm", false, function(state)
    autoFarm = state
    task.spawn(function()
        while autoFarm do
            local bond = findBond()
            if bond then
                HumanoidRootPart.CFrame = bond.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                local prompt = bond:FindFirstChildWhichIsA("ProximityPrompt") or bond:FindFirstChild("Activate")
                if prompt then fireproximityprompt(prompt) end
                task.wait(1.25)
            else
                task.wait(0.5)
            end
        end
    end)
end)

--// ✅ AUTO WIN
local autoWin = false
createToggle("Auto Win", false, function(state)
    autoWin = state
    task.spawn(function()
        while autoWin do
            local winRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Win")
            if winRemote then winRemote:FireServer() end
            task.wait(2)
        end
    end)
end)

--// ✅ ESP (basic)
local ESP_Enabled = false
createToggle("ESP Items", false, function(state)
    ESP_Enabled = state
end)

RunService.RenderStepped:Connect(function()
    if ESP_Enabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Activate") and obj.PrimaryPart and not obj:FindFirstChild("ESP") then
                if obj.Name:lower():find("bond") then
                    local tag = Instance.new("BillboardGui", obj)
                    tag.Name = "ESP"
                    tag.Size = UDim2.new(0, 100, 0, 20)
                    tag.Adornee = obj.PrimaryPart
                    tag.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", tag)
                    txt.Text = "[BOND]"
                    txt.TextColor3 = Color3.fromRGB(255, 215, 0)
                    txt.BackgroundTransparency = 1
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.Font = Enum.Font.GothamBold
                    txt.TextScaled = true
                end
            end
        end
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BillboardGui") and v.Name == "ESP" then
                v:Destroy()
            end
        end
    end
end)"
}
