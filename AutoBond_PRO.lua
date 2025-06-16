-- Dead Rails All‑in‑One by ChatGPT
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/UI-Librarys/main/Wally UI v3"))()
local win = lib:CreateWindow("Dead Rails | Multi‑Hack")

local autoBond = false
local autoWin = false
local speedVal = 16  -- speed multiplier

win:Toggle("Auto Bond", function(v) autoBond = v end)
win:Toggle("Auto Win", function(v) autoWin = v end)
win:Slider("Speedhack", {min = 16, max = 120, Default = 16}, function(v) speedVal = v end)

-- Keybinds
win:Keybind("Toggle GUI (F)", Enum.KeyCode.F, function() win:ToggleWindow() end)

-- Core loops
task.spawn(function()
    while true do
        task.wait(0.1)
        local player = game.Players.LocalPlayer
        if player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                player.Character.Humanoid.WalkSpeed = speedVal
                player.Character.Humanoid.JumpPower = speedVal * 0.5
            end
        end

        if autoBond and game.PlaceId == 70876832253163 then
            local items = workspace:FindFirstChild("RuntimeItems")
            local fire = game.ReplicatedStorage:FindFirstChild("Packages"):FindFirstChild("ActivateObjectClient")
            if items and fire then
                for _, b in pairs(items:GetChildren()) do
                    if b.Name == "Bond" and b:IsA("Model") and b.PrimaryPart then
                        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = b.PrimaryPart.CFrame
                            fire:FireServer({object = b})
                            task.wait(0.05)
                        end
                    end
                end
            end
        end

        if autoWin and game.PlaceId == 70876832253163 then
            local winEvent = game.ReplicatedStorage:FindFirstChild("Packages"):FindFirstChild("CompleteRaceClient")
            if winEvent then
                winEvent:FireServer()
                task.wait(1)
            end
        end
    end
end)

-- Global toggle key (Shift+S)
game:GetService("UserInputService").InputBegan:Connect(function(inp, gp)
    if not gp and inp.KeyCode == Enum.KeyCode.S and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
        autoBond = false
        autoWin = false
        speedVal = 16
        win:ToggleWindow(true)
    end
end)

