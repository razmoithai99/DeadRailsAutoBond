-- DeadRails  Mobile/PC Script
local P, W, RS = game:GetService("Players"), game:GetService("Workspace"), game:GetService("ReplicatedStorage")
local lp = P.LocalPlayer
repeat task.wait() until lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
local hrp = lp.Character.HumanoidRootPart

-- GUI setup
local gui = Instance.new("ScreenGui", lp.PlayerGui); gui.Name = "DRNatGui"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,180,0,280); frame.Position = UDim2.new(0.02,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25); frame.BorderSizePixel = 0
frame.Active = true; frame.Draggable = true
local list = Instance.new("UIListLayout", frame); list.Padding = UDim.new(0,8)

-- State
local st = {bond=false, farm=false, win=false, esp=false}

-- Core functions
local function autoBond()
  while st.bond do
    task.wait(0.25)
    for _,v in ipairs(W:GetDescendants()) do
      if v:IsA("Model") and v:FindFirstChild("Activate") then
        pcall(fireproximityprompt, v.Activate)
      end
    end
  end
end

local function autoFarm()
  while st.farm do
    task.wait(0.35)
    for _,v in ipairs(W:GetDescendants()) do
      if v:IsA("Model") and v:FindFirstChild("Activate") then
        pcall(function()
          hrp.CFrame = v:GetModelCFrame() + Vector3.new(0,3,0)
          task.wait(0.1)
          fireproximityprompt(v.Activate)
        end)
      end
    end
  end
end

local function autoWin()
  while st.win do
    task.wait(1)
    pcall(function()
      RS.RemoteEvent:FireServer({"CompleteRaceClient"})
    end)
  end
end

local function teleportToEnd()
  for _,v in ipairs(W:GetDescendants()) do
    if v.Name == "EndPart" then
      hrp.CFrame = v.CFrame + Vector3.new(0,5,0)
      break
    end
  end
end

local function toggleESP()
  for _,v in ipairs(W:GetDescendants()) do
    if v:IsA("Model") and v:FindFirstChild("Activate") and not v:FindFirstChild("ESP") then
      local bb = Instance.new("BillboardGui", v)
      bb.Name = "ESP"; bb.Size = UDim2.new(0,90,0,35); bb.AlwaysOnTop = true; bb.Adornee = v
      local txt = Instance.new("TextLabel", bb)
      txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1
      txt.Text = "BOND"; txt.TextColor3 = Color3.fromRGB(255,215,0); txt.TextScaled = true
    end
  end
end

-- Button utility
local function addBtn(label, f)
  local b = Instance.new("TextButton", frame)
  b.Size = UDim2.new(1,-10,0,34); b.Text=label
  b.Font=Enum.Font.SourceSansBold; b.TextScaled=true
  b.TextColor3=Color3.new(1,1,1); b.BackgroundColor3=Color3.fromRGB(45,45,45)
  b.MouseButton1Click:Connect(f)
end

-- Build UI
addBtn("Auto Bond", function()
  st.bond = not st.bond
  if st.bond then task.spawn(autoBond) end
end)
addBtn("Auto Farm", function()
  st.farm = not st.farm
  if st.farm then task.spawn(autoFarm) end
end)
addBtn("Auto Win", function()
  st.win = not st.win
  if st.win then task.spawn(autoWin) end
end)
addBtn("Teleport to End", teleportToEnd)
addBtn("ESP Bonds", function()
  st.esp = not st.esp
  if st.esp then toggleESP() end
end)

print("[✅] NatHub-style Dead Rails script loaded")
