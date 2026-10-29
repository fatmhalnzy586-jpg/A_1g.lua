-- ==========================================================
-- Developer: A_1g
-- Map: Ultimate Hub with ESP, Auto-Fish, Bypass & Aimbot
-- ==========================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("A_1gHub_ESP") then
    CoreGui.A_1gHub_ESP:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "A_1gHub_ESP"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 460)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Title.Text = "⚡ A_1g Hub | مع ميزة ESP ⚡"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

local function createButton(text, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.88, 0, 0, 40)
    btn.Position = UDim2.new(0.06, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextSize = 14
    btn.Parent = MainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

local autoFishing = false
local aimbotEnabled = false
local wallCheckEnabled = true
local espEnabled = false
local flying = false
local flySpeed = 50

-- تخزين رسومات الـ ESP
local espBoxes = {}

local function removeESP(player)
    if espBoxes[player] then
        for _, obj in pairs(espBoxes[player]) do
            pcall(function() obj:Remove() end)
        end
        espBoxes[player] = nil
    end
end

-- 1. زر الـ ESP (كشف اللاعبين)
createButton("كشف اللاعبين (ESP): معطل ❌", 60, function(btn)
    espEnabled = not espEnabled
    if espEnabled then
        btn.Text = "كشف اللاعبين (ESP): شغال ✅"
        btn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
    else
        btn.Text = "كشف اللاعبين (ESP): معطل ❌"
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
        for _, player in pairs(Players:GetPlayers()) do
            removeESP(player)
        end
    end
end)

-- 2. الصيد التلقائي
createButton("الصيد التلقائي وتخطي الميني جيم: معطل ❌", 110, function(btn)
    autoFishing = not autoFishing
    if autoFishing then
        btn.Text = "الصيد التلقائي وتخطي الميني جيم: شغال ✅"
        btn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        task.spawn(function()
            while autoFishing do
                task.wait(0.2)
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then
                            tool:Activate()
                        end
                    end
                    for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                        if gui:IsA("Frame") or gui:IsA("ImageLabel") or gui:IsA("TextButton") then
                            local name = gui.Name:lower()
                            if name:match("minigame") or name:match("bar") or name:match("fish") or name:match("reel") or name:match("catch") then
                                pcall(function()
                                    gui.Visible = false
                                    gui:Destroy()
                                end)
                            end
                        end
                    end
                end)
            end
        end)
    else
        btn.Text = "الصيد التلقائي وتخطي الميني جيم: معطل ❌"
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    end
end)

-- 3. الإيم بوت
createButton("الإيم بوت القوي: معطل ❌", 160, function(btn)
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        btn.Text = "الإيم بوت القوي: شغال ✅"
        btn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
    else
        btn.Text = "الإيم بوت القوي: معطل ❌"
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    end
end)

-- 4. فحص الجدران
createButton("فحص الجدران (ضد الشبك): شغال ✅", 210, function(btn)
    wallCheckEnabled = not wallCheckEnabled
    if wallCheckEnabled then
        btn.Text = "فحص الجدران (ضد الشبك): شغال ✅"
        btn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
    else
        btn.Text = "فحص الجدران (ضد الشبك): معطل ❌"
        btn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
    end
end)

-- 5. الطيران
createButton("الطيران السلس: معطل ❌", 260, function(btn)
    flying = not flying
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    if flying then
        btn.Text = "الطيران السلس: شغال ✅"
        btn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        local bv = Instance.new("BodyVelocity")
        bv.Name = "A_1gFlyEngine"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp

        task.spawn(function()
            while flying and task.wait() do
                bv.Velocity = Camera.CFrame.LookVector * flySpeed
            end
            bv:Destroy()
        end)
    else
        btn.Text = "الطيران السلس: معطل ❌"
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
        if hrp:FindFirstChild("A_1gFlyEngine") then
            hrp.A_1gFlyEngine:Destroy()
        end
    end
end)

-- 6. نسخ السكربت
createButton("📋 نسخ السكربت بالكامل للحافظة", 310, function(btn)
    if setclipboard then
        setclipboard("loadstring(game:HttpGet('https://raw.githubusercontent.com/fatmhalnzy586-jpg/A_1g.lua/main/A_1g.lua'))()")
        btn.Text = "تم النسخ بنجاح! ✅"
        task.wait(1.5)
        btn.Text = "📋 نسخ السكربت بالكامل للحافظة"
    else
        btn.Text = "المنفذ لا يدعم النسخ التلقائي"
    end
end)

local Credits = Instance.new("TextLabel")
Credits.Size = UDim2.new(1, 0, 0, 30)
Credits.Position = UDim2.new(0, 0, 1, -35)
Credits.BackgroundTransparency = 1
Credits.Text = "صنع بكل فخر بواسطة: A_1g"
Credits.TextColor3 = Color3.fromRGB(160, 160, 180)
Credits.TextSize = 13
Credits.Font = Enum.Font.SourceSansItalic
Credits.Parent = MainFrame

-- تحديث الـ ESP ورسم الأسماء فوق اللاعبين
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if espEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                if not espBoxes[player] then
                    local nameText = Drawing.new("Text")
                    nameText.Visible = false
                    nameText.Center = true
                    nameText.Outline = true
                    nameText.Color = Color3.fromRGB(255, 255, 255)
                    nameText.Size = 14
                    espBoxes[player] = {Text = nameText}
                end
                
                local rootPart = player.Character.HumanoidRootPart
                local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                
                if onScreen then
                    espBoxes[player].Text.Text = player.Name
                    espBoxes[player].Text.Position = Vector2.new(vector.X, vector.Y - 20)
                    espBoxes[player].Text.Visible = true
                else
                    espBoxes[player].Text.Visible = false
                end
            else
                removeESP(player)
            end
        end
    end
end)

-- نظام الإيم بوت وفحص الجدران
local function isVisible(targetPart)
    if not wallCheckEnabled then return true end
    local origin = Camera.CFrame.Position
    local destination = targetPart.Position
    local rayParams = RaycastParams.new()
    rayParams.FilterType = RaycastFilterType.Exclude

    local filterList = {Camera}
    if LocalPlayer.Character then
        table.insert(filterList, LocalPlayer.Character)
    end
    rayParams.FilterDescendantsInstances = filterList

    local result = Workspace:Raycast(origin, destination - origin, rayParams)
    if result and result.Instance then
        return result.Instance:IsDescendantOf(targetPart.Parent)
    end
    return true
end

local function getClosestTarget()
    local closest = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local head = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDistance and dist <= 500 then
                        if isVisible(head) then
                            closest = head
                            shortestDistance = dist
                        end
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getClosestTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)
