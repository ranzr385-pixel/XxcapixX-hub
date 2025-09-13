-- // XxcapixX Hub - Mount CKPTW
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

local TARGET_PLACE_ID = 123456789 -- ganti sesuai PlaceId game
if game.PlaceId ~= TARGET_PLACE_ID then
return warn("Script hanya untuk game Mount CKPTW!")
end

local player = game.Players.LocalPlayer
player.CharacterAdded:Wait()

-- // Posisi Teleport
local positions = {
Vector3.new(512,161,-531),
Vector3.new(388,310,-185),
Vector3.new(99,412,615),
Vector3.new(11,601,1000),
Vector3.new(873,865,581),
Vector3.new(1618,1081,159),
Vector3.new(2971,1528,707),
Vector3.new(1946,1744,1225),
Vector3.new(1797,1982,2171)
}

local function teleportTo(i)
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart",5)
if hrp then
hrp.CFrame = CFrame.new(positions[i] + Vector3.new(0,3,0))
end
end

-- // OrionLib GUI
local Window = OrionLib:MakeWindow({
Name = "XxcapixX Hub | Mount CKPTW",
HidePremium = false,
SaveConfig = true,
ConfigFolder = "XxcapixXHubConfig"
})

-- // Tab: Home
local HomeTab = Window:MakeTab({
Name = "Home",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})
HomeTab:AddParagraph("Selamat datang!", "Ini adalah XxcapixX Hub untuk Mount CKPTW 🚀")

-- // Tab: Main (Speed, Inf Jump, Fly)
local MainTab = Window:MakeTab({
Name = "Main",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

-- WalkSpeed
MainTab:AddTextbox({
Name = "WalkSpeed",
Default = "16",
TextDisappear = true,
Callback = function(val)
local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
local num = tonumber(val)
if hum and num then
hum.WalkSpeed = math.clamp(num,16,1000)
end
end
})

-- Infinite Jump
local infJump = false
MainTab:AddToggle({
Name = "Infinite Jump",
Default = false,
Callback = function(v)
infJump = v
end
})
game:GetService("UserInputService").JumpRequest:Connect(function()
if infJump then
local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
if hum then hum:ChangeState("Jumping") end
end
end)

-- Fly
local flying = false
local flyVel
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local function startFly()
if flyVel then flyVel:Destroy() end
local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
if not hrp then return end
flyVel = Instance.new("BodyVelocity", hrp)
flyVel.MaxForce = Vector3.new(4000,4000,4000)
flyVel.Velocity = Vector3.zero
RS:BindToRenderStep("Flying", Enum.RenderPriority.Character.Value, function()
if flying then
local moveDir = Vector3.zero
local cam = workspace.CurrentCamera.CFrame
if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.RightVector end
flyVel.Velocity = moveDir * 80
else
flyVel.Velocity = Vector3.zero
end
end)
end

MainTab:AddToggle({
Name = "Fly",
Default = false,
Callback = function(v)
flying = v
if flying then startFly() end
end
})

-- // Tab: Teleport
local TPTab = Window:MakeTab({
Name = "Teleport",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

-- Tombol teleport manual
for i=1,#positions do
TPTab:AddButton({
Name = "Teleport Pos "..i,
Callback = function() teleportTo(i) end
})
end

-- // Auto Teleport Settings
local autoTP = false
local tpDelay = 2 -- default (detik)

TPTab:AddSlider({
Name = "Delay Auto Teleport",
Min = 1,
Max = 100,
Default = 2,
Increment = 1,
ValueName = "detik",
Callback = function(val)
tpDelay = val
end
})

TPTab:AddToggle({
Name = "Auto Teleport (1 → 9)",
Default = false,
Callback = function(v)
autoTP = v
if autoTP then
task.spawn(function()
for i=1,#positions do
if not autoTP then break end
teleportTo(i)
task.wait(tpDelay)
end
autoTP = false
end)
end
end
})

-- // Init OrionLib
OrionLib:Init()

