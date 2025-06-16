local p = game.Players.LocalPlayer
local rs = game:GetService("RunService")

local function getAllBonds()
    local bonds = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Name:lower():find("bond") then
            table.insert(bonds, obj)
        end
    end
    return bonds
end

local function tpTo(pos)
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        p.Character:PivotTo(CFrame.new(pos + Vector3.new(0, 2, 0)))
    end
end

local function trySit()
    local hum = p.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Sit = true end
end

local running = true
task.spawn(function()
    while running do
        local bonds = getAllBonds()
        for _, bond in ipairs(bonds) do
            tpTo(bond.Position)
            trySit()
            task.wait(0.6)
        end
        task.wait(1.5) -- Lặp lại sau 1.5s
    end
end)
