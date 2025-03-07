
getgenv().config = {
    ["Fruit"] = {
        ["FarmFruit"] = true,           -- Farm Fruit luôn bật
        ["StoreFruit"] = true,          -- Auto-store fruits
        ["Esp Fruit"] = true,           -- Enable ESP for fruits
        ["PriorityFruits"] = {"Dragon", "Leopard", "Venom", "Dough", "T-Rex", "Kitsune", "Gas", "Yeti"} -- Rare fruits
    },
    ["Setting"] = {
        ["TweenSpeed"] = 350,           -- Speed for teleport tweening
        ["HopForFruit"] = true,         -- Enable server hopping
        ["Hop"] = "Smart",              -- Hopping mode
        ["MinPlayers"] = 1,             -- Min players in target server
        ["MaxPlayers"] = 12,            -- Max players in target server
        ["MaxHopAttempts"] = 15,        -- Max hop attempts
        ["AntiAFK"] = true,             -- Anti-AFK feature
        ["FPSBoost"] = true,            -- FPS boost
        ["Team"] = "Pirates"            -- Đội mặc định (Pirates hoặc Marines)
    },
    ["Webhook"] = {
        ["Send Webhook"] = true,        -- Enable webhook
        ["Webhook Url"] = ""            -- Replace with your Discord webhook URL
    }
}

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "Catdzs1vnStatus"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BackgroundTransparency = 0
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Name = "TitleBar"
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.Size = UDim2.new(1, -80, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "Cắt Tai Hub [Status Board]"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left

local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Name = "ToggleButton"
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ToggleButton.Position = UDim2.new(0.01, 0, 0.95, -60) -- Góc dưới bên trái
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "Status"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 10)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 15, 0, 50)
ContentFrame.Size = UDim2.new(1, -30, 1, -60)

-- Nhãn trạng thái
local function CreateStatusLabel(name, position, defaultText)
    local Label = Instance.new("TextLabel", ContentFrame)
    Label.Name = name
    Label.BackgroundTransparency = 1
    Label.Position = position
    Label.Size = UDim2.new(1, 0, 0, 25)
    Label.Font = Enum.Font.Gotham
    Label.Text = defaultText
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    return Label
end

local FruitsCollectedLabel = CreateStatusLabel("FruitsCollected", UDim2.new(0, 0, 0, 0), "Fruits Collected: 0")
local LastFruitLabel = CreateStatusLabel("LastFruit", UDim2.new(0, 0, 0, 30), "Last Fruit: None")
local ServerHopStatusLabel = CreateStatusLabel("ServerHopStatus", UDim2.new(0, 0, 0, 60), "Server Hop: Idle (ID: N/A)")
local CurrentFruitsLabel = CreateStatusLabel("CurrentFruits", UDim2.new(0, 0, 0, 90), "Current Fruits: None")
local RareFruitsLabel = CreateStatusLabel("RareFruits", UDim2.new(0, 0, 0, 120), "Rare Fruits Found: 0")

-- Wait for Game Load
repeat task.wait() until game:IsLoaded() and Players.LocalPlayer:FindFirstChild("DataLoaded")

-- Helper Functions
local function Round(num) return math.floor(num + 0.5) end
local function Notify(text)
    game.StarterGui:SetCore("SendNotification", {Title = "Cắt Tai Hub", Text = text, Duration = 5})
end

-- Improved topos Function
local function topos(targetCFrame)
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")
    local tweenInfo = TweenInfo.new(
        (root.Position - targetCFrame.Position).Magnitude / getgenv().config["Setting"]["TweenSpeed"],
        Enum.EasingStyle.Linear
    )
    local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame + Vector3.new(0, 5, 0)})
    tween:Play()
    tween.Completed:Wait()
end

-- Auto Choose Team Function (Cập nhật mới)
task.spawn(function()
    local player = Players.LocalPlayer
    if player.PlayerGui.Main:FindFirstChild("ChooseTeam") then
        repeat task.wait()
            if player.PlayerGui:WaitForChild("Main").ChooseTeam.Visible then
                if getgenv().config["Setting"]["Team"] == "Marines" then
                    for i, v in pairs(getconnections(player.PlayerGui.Main.ChooseTeam.Container["Marines"].Frame.TextButton.Activated)) do
                        for a, b in pairs(getconnections(UserInputService.TouchTapInWorld)) do
                            b:Fire()
                        end
                        v:Function()
                        Notify("Joined team: Marines")
                    end
                else
                    for i, v in pairs(getconnections(player.PlayerGui.Main.ChooseTeam.Container["Pirates"].Frame.TextButton.Activated)) do
                        for a, b in pairs(getconnections(UserInputService.TouchTapInWorld)) do
                            b:Fire()
                        end
                        v:Function()
                        Notify("Joined team: Pirates")
                    end
                end
            end
        until player.Team ~= nil and game:IsLoaded()
    end
end)

-- ESP Function
local function UpdateBfEsp()
    if not getgenv().config["Fruit"]["Esp Fruit"] then return end
    local player = Players.LocalPlayer
    local head = (player.Character or player.CharacterAdded:Wait()):WaitForChild("Head")
    local rareFruits = getgenv().config["Fruit"]["PriorityFruits"]

    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v.Name:find("Fruit") then
            local handle = v:FindFirstChild("Handle")
            if handle then
                local bill = handle:FindFirstChild("NameEsp") or Instance.new("BillboardGui", handle)
                bill.Name = "NameEsp"
                bill.Size = UDim2.new(0, 200, 0, 50)
                bill.Adornee = handle
                bill.AlwaysOnTop = true

                local name = bill:FindFirstChild("TextLabel") or Instance.new("TextLabel", bill)
                name.Font = Enum.Font.GothamBold
                name.TextSize = 16
                name.Size = UDim2.new(1, 0, 1, 0)
                name.BackgroundTransparency = 1
                name.TextStrokeTransparency = 0.5

                local fruitName = v.Name:gsub(" Fruit", "")
                name.TextColor3 = table.find(rareFruits, fruitName) and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(186, 255, 219)
                name.Text = fruitName .. " (" .. Round((head.Position - handle.Position).Magnitude / 3) .. "m)"
            end
        end
    end
end

-- Anti-AFK
if getgenv().config["Setting"]["AntiAFK"] then
    task.spawn(function()
        while task.wait(60) do
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end

-- Upgraded Webhook Function
local function SendWebhook(fruitName, action, position)
    if not getgenv().config["Webhook"]["Send Webhook"] or getgenv().config["Webhook"]["Webhook Url"] == "" then return end
    local playerCount = #Players:GetPlayers()
    local currentFruits = {}
    local rareCount = 0
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v.Name:find("Fruit") then
            local fname = v.Name:gsub(" Fruit", "")
            table.insert(currentFruits, fname)
            if table.find(getgenv().config["Fruit"]["PriorityFruits"], fname) then rareCount = rareCount + 1 end
        end
    end
    local fruitList = table.concat(currentFruits, ", ") or "None"
    local data = {
        username = "Fruit Notifier",
        embeds = {{
            title = action == "pickup" and "🍎 Fruit Picked Up!" or "🍇 Fruit Spawned!",
            description = string.format(
                "Fruit: %s\nAction: %s\nServer ID: %s\nPlayers: %d\nTime: %s\nPosition: (%.1f, %.1f, %.1f)\nCurrent Fruits: %s\nRare Fruits: %d\nTeam: %s",
                fruitName, action == "pickup" and "Picked Up" or "Spawned", game.JobId, playerCount,
                os.date("!%H:%M:%S", os.time() + 7 * 3600), position.X, position.Y, position.Z, fruitList, rareCount,
                getgenv().config["Setting"]["Team"]
            ),
            color = action == "pickup" and 65280 or 16711680,
            thumbnail = {url = "https://blox-fruits.com/wp-content/uploads/" .. fruitName .. ".png"} -- Thay bằng URL thực
        }}
    }
    pcall(function()
        (http_request or request or syn.request)({
            Url = getgenv().config["Webhook"]["Webhook Url"],
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end)
end

-- Get_Fruit Function
local function Get_Fruit(Fruit)
    local fruitMap = {
        ["Rocket Fruit"] = "Rocket-Rocket", ["Spin Fruit"] = "Spin-Spin", ["Chop Fruit"] = "Chop-Chop",
        ["Spring Fruit"] = "Spring-Spring", ["Bomb Fruit"] = "Bomb-Bomb", ["Smoke Fruit"] = "Smoke-Smoke",
        ["Spike Fruit"] = "Spike-Spike", ["Flame Fruit"] = "Flame-Flame", ["Falcon Fruit"] = "Falcon-Falcon",
        ["Ice Fruit"] = "Ice-Ice", ["Sand Fruit"] = "Sand-Sand", ["Dark Fruit"] = "Dark-Dark",
        ["Ghost Fruit"] = "Ghost-Ghost", ["Diamond Fruit"] = "Diamond-Diamond", ["Light Fruit"] = "Light-Light",
        ["Rubber Fruit"] = "Rubber-Rubber", ["Barrier Fruit"] = "Barrier-Barrier", ["Magma Fruit"] = "Magma-Magma",
        ["Quake Fruit"] = "Quake-Quake", ["Buddha Fruit"] = "Buddha-Buddha", ["Love Fruit"] = "Love-Love",
        ["Spider Fruit"] = "Spider-Spider", ["Sound Fruit"] = "Sound-Sound", ["Phoenix Fruit"] = "Phoenix-Phoenix",
        ["Portal Fruit"] = "Portal-Portal", ["Rumble Fruit"] = "Rumble-Rumble", ["Pain Fruit"] = "Pain-Pain",
        ["Blizzard Fruit"] = "Blizzard-Blizzard", ["Gravity Fruit"] = "Gravity-Gravity", ["Mammoth Fruit"] = "Mammoth-Mammoth",
        ["Dough Fruit"] = "Dough-Dough", ["Shadow Fruit"] = "Shadow-Shadow", ["Venom Fruit"] = "Venom-Venom",
        ["Control Fruit"] = "Control-Control", ["Spirit Fruit"] = "Spirit-Spirit", ["Dragon Fruit"] = "Dragon-Dragon",
        ["Leopard Fruit"] = "Leopard-Leopard", ["T-Rex Fruit"] = "T-Rex-T-Rex", ["Kitsune Fruit"] = "Kitsune-Kitsune",
        ["Gas Fruit"] = "Gas-Gas", ["Yeti Fruit"] = "Yeti-Yeti"
    }
    return fruitMap[Fruit] or (Fruit:gsub(" Fruit", "") .. "-" .. Fruit:gsub(" Fruit", ""))
end

-- Store Fruit
local function StoreFruit(fruit)
    local fruitName = Get_Fruit(fruit.Name)
    pcall(function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", fruitName, fruit)
    end)
end

-- Auto Store Fruit Loop
task.spawn(function()
    local player = Players.LocalPlayer
    while task.wait(0.5) do
        if not getgenv().config["Fruit"]["StoreFruit"] then continue end
        pcall(function()
            local plrBag = player.Backpack
            local plrChar = player.Character
            for _, fruit in pairs(plrChar:GetChildren()) do
                if fruit:IsA("Tool") and fruit:FindFirstChild("Fruit") then
                    StoreFruit(fruit)
                end
            end
            for _, fruit in pairs(plrBag:GetChildren()) do
                if fruit:IsA("Tool") and fruit:FindFirstChild("Fruit") then
                    StoreFruit(fruit)
                end
            end
        end)
    end
end)

-- Check for Fruits in Current Server
local function CheckCurrentServerForFruits()
    local fruitCount = 0
    local fruitList = {}
    local rareCount = 0
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v.Name:find("Fruit") and v:FindFirstChild("Handle") then
            local fruitName = v.Name:gsub(" Fruit", "")
            fruitCount = fruitCount + 1
            table.insert(fruitList, fruitName)
            if table.find(getgenv().config["Fruit"]["PriorityFruits"], fruitName) then
                rareCount = rareCount + 1
            end
        end
    end
    CurrentFruitsLabel.Text = "Current Fruits: " .. (table.concat(fruitList, ", ") or "None")
    RareFruitsLabel.Text = "Rare Fruits Found: " .. rareCount
    return fruitCount > 0, fruitCount, fruitList, rareCount
end

-- Improved Smart Server Hopping
local hopCount = 0
local function SmartHop()
    if not getgenv().config["Setting"]["HopForFruit"] or getgenv().config["Setting"]["Hop"] ~= "Smart" then return end
    
    ServerHopStatusLabel.Text = "Server Hop: Checking current server (ID: " .. game.JobId .. ")"
    local hasFruits, fruitCount = CheckCurrentServerForFruits()
    if hasFruits then
        ServerHopStatusLabel.Text = "Server Hop: " .. fruitCount .. " fruits found (ID: " .. game.JobId .. ")"
        Notify(fruitCount .. " fruits found, staying!")
        return true
    end

    local placeId = game.PlaceId
    local cursor = ""
    local attempts = 0
    ServerHopStatusLabel.Text = "Server Hop: Scanning servers..."

    while attempts < getgenv().config["Setting"]["MaxHopAttempts"] do
        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")))
        end)
        if not success then
            ServerHopStatusLabel.Text = "Server Hop: API Error, retrying..."
            Notify("API Error, retrying in 5s...")
            task.wait(5)
            continue
        end

        cursor = response.nextPageCursor or ""
        for _, server in pairs(response.data) do
            local playerCount = server.playing
            local serverId = server.id
            if playerCount >= getgenv().config["Setting"]["MinPlayers"] and playerCount <= getgenv().config["Setting"]["MaxPlayers"] and serverId ~= game.JobId then
                hopCount = hopCount + 1
                attempts = attempts + 1
                ServerHopStatusLabel.Text = "Server Hop: Hopping to " .. serverId .. " (" .. playerCount .. " players)"
                Notify("Hopping to server " .. serverId)
                TeleportService:TeleportToPlaceInstance(placeId, serverId)
                task.wait(10)

                local fruitFound = false
                for i = 1, 30 do
                    local hasFruitsCheck = CheckCurrentServerForFruits()
                    if hasFruitsCheck[1] then
                        fruitFound = true
                        ServerHopStatusLabel.Text = "Server Hop: Fruits found (ID: " .. serverId .. ")"
                        Notify("Fruits detected in " .. serverId .. "!")
                        return true
                    end
                    task.wait(1)
                end
                if not fruitFound then
                    ServerHopStatusLabel.Text = "Server Hop: No fruits in " .. serverId .. ", hopping again..."
                end
            end
        end
        task.wait(1)
        if cursor == "" then break end
    end

    ServerHopStatusLabel.Text = "Server Hop: No suitable servers after " .. attempts .. " attempts"
    Notify("No servers with fruits found!")
    return false
end

-- Fruit Spawn Detection
local knownFruits = {}
task.spawn(function()
    while task.wait(1) do
        local currentFruits = {}
        for _, v in pairs(Workspace:GetChildren()) do
            if v:IsA("Model") and v.Name:find("Fruit") and v:FindFirstChild("Handle") then
                local fruitId = tostring(v)
                currentFruits[fruitId] = v
                if not knownFruits[fruitId] then
                    local fruitName = v.Name:gsub(" Fruit", "")
                    Notify("New fruit spawned: " .. fruitName .. "!")
                    SendWebhook(fruitName, "spawn", v.Handle.Position)
                    knownFruits[fruitId] = v
                end
            end
        end
        for id in pairs(knownFruits) do
            if not currentFruits[id] then
                knownFruits[id] = nil
            end
        end
    end
end)

-- Fruit Farming Loop with Priority and Hop Check
local collectedFruits = 0
local rareFruitsFound = 0
task.spawn(function()
    local player = Players.LocalPlayer
    while task.wait(0.05) do
        if not getgenv().config["Fruit"]["FarmFruit"] then continue end

        local hasFruits, fruitCount, fruitList, rareCount = CheckCurrentServerForFruits()
        if not hasFruits then
            ServerHopStatusLabel.Text = "Server Hop: No fruits detected, hopping..."
            Notify("No fruits in server, hopping...")
            SmartHop()
            continue
        end

        local priorityTarget = nil
        local normalTarget = nil
        for _, v in pairs(Workspace:GetChildren()) do
            if v:IsA("Model") and v.Name:find("Fruit") and v:FindFirstChild("Handle") then
                local fruitName = v.Name:gsub(" Fruit", "")
                if table.find(getgenv().config["Fruit"]["PriorityFruits"], fruitName) then
                    priorityTarget = v
                    break
                elseif not normalTarget then
                    normalTarget = v
                end
            end
        end

        local target = priorityTarget or normalTarget
        if target then
            local fruitName = target.Name:gsub(" Fruit", "")
            topos(target.Handle.CFrame)
            collectedFruits = collectedFruits + 1
            if table.find(getgenv().config["Fruit"]["PriorityFruits"], fruitName) then rareFruitsFound = rareFruitsFound + 1 end
            FruitsCollectedLabel.Text = "Fruits Collected: " .. collectedFruits
            LastFruitLabel.Text = "Last Fruit: " .. fruitName
            RareFruitsLabel.Text = "Rare Fruits Found: " .. rareFruitsFound
            Notify("Picked up: " .. fruitName .. "!")
            SendWebhook(fruitName, "pickup", target.Handle.Position)
            if getgenv().config["Fruit"]["StoreFruit"] then StoreFruit(target) end

            -- Kiểm tra lại sau khi nhặt
            task.wait(0.5)
            local stillHasFruits, newFruitCount = CheckCurrentServerForFruits()
            if not stillHasFruits then
                ServerHopStatusLabel.Text = "Server Hop: All fruits collected, hopping..."
                Notify("All fruits collected, hopping...")
                SmartHop()
            end
        end
    end
end)

-- ESP Loop
task.spawn(function()
    while task.wait(0.05) do UpdateBfEsp() end
end)

-- FPS Boost
if getgenv().config["Setting"]["FPSBoost"] then
    RunService:Set3dRenderingEnabled(false)
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end