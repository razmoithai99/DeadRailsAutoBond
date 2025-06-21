--[[
DeadRails NatHub-Enhanced Script
Features:
• Ultimate Auto Bond
• Auto Farm (movement + pickup)
• Auto Win
• Teleport to End
• ESP
• WalkSpeed / JumpPower sliders
• NoClip (PC-only)
]]

local P,W,RS,PS = game:GetService("Players"),game:GetService("Workspace"),
game:GetService("ReplicatedStorage"),game:GetService("Players").LocalPlayer

repeat task.wait() until PS.Character and PS.Character:FindFirstChild("HumanoidRootPart")
local hrp = PS.Character.HumanoidRootPart
local hb = PS.Character:FindFirstChildOfClass("Humanoid")

-- GUI Init
local gui = Instance.new("ScreenGui", PS.PlayerGui); gui.Name="NatHubEnhanced"
local frame = Instance.new("Frame",gui); frame.Size=UDim2.new(0,240,0,380); frame.Position=UDim2.new(0.02,0,0.1,0)
frame.BackgroundTransparency=0.2;frame.BackgroundColor3=Color3.fromRGB(15,15,15)
frame.BorderSizePixel=0;frame.Active=true;frame.Draggable=true
local layout = Instance.new("UIListLayout", frame); layout.Padding=UDim.new(0,6)
local title=Instance.new("TextLabel",frame)
title.Size=UDim2.new(1,0,0,30); title.Text="NatHub Enhanced";title.TextColor3=Color3.new(1,1,1)
title.Font=Enum.Font.SourceSansBold;title.TextSize=18;title.BackgroundTransparency=1

-- States
local st = {bond=false,farm=false,win=false,esp=false,noclip=false}
local sliders = {ws=16,jp=50}

-- Functions
function ultimateBond()
  while st.bond do
    task.wait(0.15)
    for _,v in ipairs(W:GetDescendants()) do
      if v:IsA("Model") and v:FindFirstChild("Activate") then
        pcall(fireproximityprompt, v.Activate)
      end
    end
  end
end

function autoFarm()
  while st.farm do
    task.wait(0.3)
    for _,v in ipairs(W:GetDescendants()) do
      if v:IsA("Model") and v:FindFirstChild("Activate") then
        pcall(function()
          hrp.CFrame = v:GetModelCFrame() + Vector3.new(0,2,0)
          task.wait(0.07)
          fireproximityprompt(v.Activate)
        end)
      end
    end
  end
end

function autoWin()
  while st.win do
    task.wait(1)
    pcall(function() RS:WaitForChild("RemoteEvent"):FireServer({"CompleteRaceClient"}) end)
  end
end

function teleportEnd()
  for _,v in ipairs(W:GetDescendants()) do
    if v.Name=="EndPart" then
      hrp.CFrame=v.CFrame + Vector3.new(0,5,0)
      break
    end
  end
end

function updateESP()
  for _,v in ipairs(W:GetDescendants()) do
    if v:IsA("Model") and v:FindFirstChild("Activate") and not v:FindFirstChild("ESP") then
      local bb=Instance.new("BillboardGui",v); bb.Name="ESP"
      bb.Size=UDim2.new(0,80,0,30); bb.AlwaysOnTop=true; bb.Adornee=v
      local lbl=Instance.new("TextLabel",bb)
      lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1; lbl.Text="BOND"
      lbl.TextColor3=Color3.fromRGB(255,200,0); lbl.TextScaled=true
    end
  end
end

-- Toggle Creator
local function addToggle(txt,key,func)
  local fr=Instance.new("Frame",frame); fr.Size=UDim2.new(1,-10,0,40); fr.BackgroundTransparency=0.3
  local lbl=Instance.new("TextLabel",fr)
  lbl.Text=txt;lbl.Size=UDim2.new(0.6,0,1,0);lbl.BackgroundTransparency=1;lbl.TextColor3=Color3.new(1,1,1)
  local tog=Instance.new("TextButton",fr)
  tog.Size=UDim2.new(0.4,-5,1,0);tog.Position=UDim2.new(0.6,0,0,0)
  tog.BackgroundColor3=Color3.fromRGB(60,60,60);tog.Font=Enum.Font.SourceSansBold;tog.Text="OFF"
  tog.TextColor3=Color3.new(1,1,1);tog.TextScaled=true
  tog.MouseButton1Click:Connect(function()
    st[key]=not st[key]
    tog.Text=st[key] and "ON" or "OFF"
    tog.BackgroundColor3=st[key] and Color3.fromRGB(0,150,0) or Color3.fromRGB(60,60,60)
    if func and st[key] then task.spawn(func) end
  end)
end

-- Slider Creator
local function addSlider(txt,key,min,max)
  local fr=Instance.new("Frame",frame); fr.Size=UDim2.new(1,-10,0,60);fr.BackgroundTransparency=0.3
  local lbl=Instance.new("TextLabel",fr);lbl.Text=txt;lbl.Size=UDim2.new(1,0,0,20)
  lbl.BackgroundTransparency=1;lbl.TextColor3=Color3.new(1,1,1);lbl.Font=Enum.Font.SourceSans
  -- Value display
  local val=Instance.new("TextLabel",fr);val.Position=UDim2.new(0,0,0,20)
  val.Size=UDim2.new(1,0,0,20);val.BackgroundTransparency=1;val.TextColor3=Color3.new(1,1,1)
  val.Text = tostring(sliders[key])
  -- Slider bar
  local slider = Instance.new("TextButton",fr)
  slider.Position=UDim2.new(0,0,0,40);slider.Size=UDim2.new(1,0,0,10)
  slider.BackgroundColor3=Color3.fromRGB(70,70,70)
  local fill=Instance.new("Frame",slider)
  fill.Size=UDim2.new((sliders[key]-min)/(max-min),0,1,0)
  fill.BackgroundColor3=Color3.fromRGB(100,200,100)
  slider.MouseButton1Down:Connect(function(x)
    local conn
    conn = slider.MouseMovement:Connect(function(mx)
      local pct = math.clamp((mx - slider.AbsolutePosition.X)/slider.AbsoluteSize.X, 0,1)
      sliders[key] = math.floor(min + (max-min)*pct)
      fill.Size=UDim2.new(pct,0,1,0)
      val.Text=tostring(sliders[key])
      if key=="ws" then hb.WalkSpeed=sliders.ws end
      if key=="jp" then hb.JumpPower=sliders.jp end
    end)
    local r; r = slider.MouseButton1Up:Connect(function()
      conn:Disconnect(); r:Disconnect()
    end)
  end)
end

-- Add toggles and sliders
addToggle("Ultimate Auto Bond","bond",ultimateBond)
addToggle("Auto Farm","farm",autoFarm)
addToggle("Auto Win","win",autoWin)
addToggle("ESP Bonds","esp",updateESP)
addToggle("NoClip (PC)","noclip",function()
  while st.noclip do
    PS.Character.HumanoidRootPart.CanCollide=false
    task.wait()
  end
end)
addSlider("WalkSpeed", "ws", 16, 200)
addSlider("JumpPower", "jp", 50, 200)
addToggle("Teleport to End","tele",teleportEnd)

print("[✅] NatHub Enhanced loaded")
