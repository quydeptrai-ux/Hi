getgenv().config = {
    ["Fruit"] = {
        ["FarmFruit"] = true,
        ["StoreFruit"] = true,
        ["Esp Fruit"] = true,
        ["PriorityFruits"] = {"Dragon", "Leopard", "Venom", "Dough", "T-Rex", "Kitsune", "Gas", "Yeti"},
        ["MaxDistance"] = 1000
    },
    ["Setting"] = {
        ["TweenSpeed"] = 500,
        ["HopForFruit"] = true,
        ["Hop"] = "Smart",
        ["MinPlayers"] = 1,
        ["MaxPlayers"] = 8,
        ["MaxHopAttempts"] = 30,
        ["HopTimeout"] = 300,
        ["AntiAFK"] = true,
        ["FPSBoost"] = false,
        ["Select Team"] = "Pirates"
    },
    ["Webhook"] = {
        ["Send Webhook"] = true,
        ["Webhook Url"] = "https://discord.com/api/webhooks/1336551381254934641/V73uXNSAy1IyjjE5MEN6rp5U2EbCCW8u8ldpEvkegyaojOmeQ1So493j8ovGn9Pp8MIj"
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
TitleBar.BackgroundTransparency = 0
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
ToggleButton.BackgroundTransparency = 0
ToggleButton.Position = UDim2.new(0.01, 0, 0.95, -60)
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
repeat task.wait(0.1) until game:IsLoaded() and Players.LocalPlayer:FindFirstChild("DataLoaded") and Players.LocalPlayer.Character

-- Helper Functions
local function Round(num) return math.floor(num + 0.5) end
local function Notify(text)
    game.StarterGui:SetCore("SendNotification", {Title = "Cắt Tai Hub", Text = text, Duration = 5})
end

-- Fast Teleport Function
local function fastTeleport(targetCFrame)
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")
    root.CFrame = targetCFrame + Vector3.new(0, 5, 0)
    task.wait(0.1)
end

-- Auto Choose Team Function
task.spawn(function()
    local teamToSelect = getgenv().config.Setting["Select Team"] or "Pirates"
    while not game.Players.LocalPlayer.Team do
        local success, err = pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", teamToSelect)
        end)
        if success then Notify("Đã chọn team: " .. teamToSelect) else Notify("Lỗi khi chọn team: " .. tostring(err)) end
        task.wait(1)
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
        while task.wait(math.random(50, 70)) do
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end

-- Webhook Function
local hasSentActiveWebhook = false
local function SendWebhook(fruitName, action, position)
    if not getgenv().config["Webhook"]["Send Webhook"] or getgenv().config["Webhook"]["Webhook Url"] == "" then return end
    local webhookUrl = getgenv().config["Webhook"]["Webhook Url"]
    if not webhookUrl:match("^https://discord.com/api/webhooks/") then
        Notify("Webhook URL không hợp lệ!")
        return
    end

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
    local data
    if action == "active" then
        data = {
            username = "Fruit Notifier",
            embeds = {{
                title = "Script Status",
                description = "Cắt Tai Hub has been active! 🟢\nServer ID: " .. game.JobId .. "\nPlayers: " .. playerCount .. "\nTime: " .. os.date("!%H:%M:%S", os.time() + 7 * 3600),
                color = 65280,
                footer = {text = "One-time activation message"}
            }}
        }
    else
        data = {
            username = "Fruit Notifier",
            embeds = {{
                title = action == "pickup" and "🍎 Fruit Picked Up!" or action == "spawn" and "🍇 Fruit Spawned!" or "🌐 Server Hopped!",
                description = string.format(
                    "Fruit: %s\nAction: %s\nServer ID: %s\nPlayers: %d\nTime: %s\nPosition: (%.1f, %.1f, %.1f)\nCurrent Fruits: %s\nRare Fruits: %d\nTeam: %s",
                    fruitName or "N/A", action == "pickup" and "Picked Up" or action == "spawn" and "Spawned" or "Hopped", game.JobId, playerCount,
                    os.date("!%H:%M:%S", os.time() + 7 * 3600), position.X, position.Y, position.Z, fruitList, rareCount,
                    getgenv().config["Setting"]["Select Team"]
                ),
                color = action == "pickup" and 65280 or action == "spawn" and 16711680 or 255,
                thumbnail = action ~= "hop" and {url = "https://blox-fruits.com/wp-content/uploads/" .. (fruitName or "Default") .. ".png"} or nil
            }}
        }
    end
    pcall(function()
        (http_request or request or syn.request)({
            Url = webhookUrl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end)
end

-- Send Active Webhook Once
if not hasSentActiveWebhook and getgenv().config["Webhook"]["Send Webhook"] and getgenv().config["Webhook"]["Webhook Url"] ~= "" then
    SendWebhook(nil, "active", Vector3.new(0, 0, 0))
    hasSentActiveWebhook = true
    Notify("Script đã kích hoạt và gửi thông báo tới Webhook!")
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
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", fruitName, fruit)
    end)
end

-- Auto Store Fruit Loop
task.spawn(function()
    local player = Players.LocalPlayer
    while task.wait(0.3) do
        if not getgenv().config["Fruit"]["StoreFruit"] then continue end
        pcall(function()
            local plrBag = player.Backpack
            local plrChar = player.Character
            for _, fruit in pairs(plrChar:GetChildren()) do
                if fruit:IsA("Tool") and fruit:FindFirstChild("Fruit") then StoreFruit(fruit) end
            end
            for _, fruit in pairs(plrBag:GetChildren()) do
                if fruit:IsA("Tool") and fruit:FindFirstChild("Fruit") then StoreFruit(fruit) end
            end
        end)
    end
end)

-- Check for Fruits in Current Server
local function CheckCurrentServerForFruits()
    local player = Players.LocalPlayer
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false, 0, {}, 0 end

    local fruitCount = 0
    local fruitList = {}
    local rareCount = 0
    local fruitsInRange = {}
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v.Name:find("Fruit") and v:FindFirstChild("Handle") then
            local fruitName = v.Name:gsub(" Fruit", "")
            local distance = (root.Position - v.Handle.Position).Magnitude
            if distance <= getgenv().config["Fruit"]["MaxDistance"] then
                fruitCount = fruitCount + 1
                table.insert(fruitList, fruitName)
                table.insert(fruitsInRange, {Model = v, Distance = distance, Name = fruitName})
                if table.find(getgenv().config["Fruit"]["PriorityFruits"], fruitName) then rareCount = rareCount + 1 end
            end
        end
    end
    CurrentFruitsLabel.Text = "Current Fruits: " .. (table.concat(fruitList, ", ") or "None")
    RareFruitsLabel.Text = "Rare Fruits Found: " .. rareCount
    return fruitCount > 0, fruitCount, fruitList, rareCount, fruitsInRange
end

-- SmartHop v10
local hopCount = 0
local visitedServers = {}
local serverStartTime = os.time()
local function SmartHop()
    if not getgenv().config["Setting"]["HopForFruit"] or getgenv().config["Setting"]["Hop"] ~= "Smart" then return end
    
    ServerHopStatusLabel.Text = "Server Hop: Checking current server (ID: " .. game.JobId .. ")"
    local hasFruits, fruitCount, _, rareCount = CheckCurrentServerForFruits()
    local timeInServer = os.time() - serverStartTime
    local dynamicTimeout = math.max(60, getgenv().config["Setting"]["HopTimeout"] - (fruitCount * 30)) -- Giảm timeout nếu ít fruit

    if hasFruits and (rareCount > 0 or timeInServer < dynamicTimeout) then
        ServerHopStatusLabel.Text = "Server Hop: " .. fruitCount .. " fruits found (ID: " .. game.JobId .. ")"
        Notify(fruitCount .. " fruits found, staying! (Time: " .. timeInServer .. "s)")
        return true
    end

    local placeId = game.PlaceId
    local cursor = ""
    local attempts = 0
    local backoff = 0.5 -- Initial backoff time
    visitedServers[game.JobId] = os.time() -- Đánh dấu server hiện tại với timestamp
    ServerHopStatusLabel.Text = "Server Hop: Scanning servers... (Attempts: " .. attempts .. "/" .. getgenv().config["Setting"]["MaxHopAttempts"] .. ")"

    -- Hàm chọn server ưu tiên ít người trước, sau đó thử đông hơn
    local function findBestServer(servers)
        local bestServer = nil
        local minDiff = math.huge
        for _, server in pairs(servers) do
            local playerCount = server.playing
            local serverId = server.id
            local diff = math.abs(playerCount - getgenv().config["Setting"]["MinPlayers"])
            if playerCount >= getgenv().config["Setting"]["MinPlayers"] and 
               playerCount <= getgenv().config["Setting"]["MaxPlayers"] and 
               serverId ~= game.JobId and 
               (not visitedServers[serverId] or (os.time() - visitedServers[serverId]) > 300) then -- Tránh server ghé thăm trong 5 phút
                if diff < minDiff then
                    minDiff = diff
                    bestServer = server
                end
            end
        end
        return bestServer
    end

    while attempts < getgenv().config["Setting"]["MaxHopAttempts"] do
        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")))
        end)

        if not success then
            backoff = math.min(backoff * 2, 5) -- Exponential backoff, max 5s
            ServerHopStatusLabel.Text = "Server Hop: API Error, retrying in " .. backoff .. "s..."
            Notify("API Error, retrying in " .. backoff .. "s...")
            task.wait(backoff)
            continue
        end

        backoff = 0.5 -- Reset backoff on success
        cursor = response.nextPageCursor or ""
        local targetServer = findBestServer(response.data)
        
        if targetServer then
            hopCount = hopCount + 1
            attempts = attempts + 1
            visitedServers[targetServer.id] = os.time()
            ServerHopStatusLabel.Text = "Server Hop: Hopping to " .. targetServer.id .. " (" .. targetServer.playing .. " players, Attempt " .. attempts .. ")"
            Notify("Hopping to server " .. targetServer.id .. " (" .. targetServer.playing .. " players)")
            SendWebhook(nil, "hop", Vector3.new(0, 0, 0))
            TeleportService:TeleportToPlaceInstance(placeId, targetServer.id)
            task.wait(math.random(3, 5))

            for i = 1, 15 do
                local hasFruitsCheck, fruitCountCheck = CheckCurrentServerForFruits()
                if hasFruitsCheck then
                    serverStartTime = os.time()
                    ServerHopStatusLabel.Text = "Server Hop: Fruits found (ID: " .. targetServer.id .. ", " .. fruitCountCheck .. " fruits)"
                    Notify("Fruits detected in " .. targetServer.id .. " (" .. fruitCountCheck .. " fruits)!")
                    return true
                end
                task.wait(0.3)
            end
            ServerHopStatusLabel.Text = "Server Hop: No fruits in " .. targetServer.id .. ", hopping again..."
            Notify("No fruits in " .. targetServer.id .. ", hopping again...")
        end

        task.wait(math.random(0.2, 0.5)) -- Giảm thời gian chờ giữa các trang
        if cursor == "" then
            -- Thử server đông hơn nếu không tìm thấy server ít người
            if attempts > getgenv().config["Setting"]["MaxHopAttempts"] / 2 then
                getgenv().config["Setting"]["MaxPlayers"] = math.min(getgenv().config["Setting"]["MaxPlayers"] + 2, 12)
                Notify("Tăng MaxPlayers lên " .. getgenv().config["Setting"]["MaxPlayers"] .. " để thử server đông hơn!")
            end
            break
        end
    end

    ServerHopStatusLabel.Text = "Server Hop: No suitable servers after " .. attempts .. " attempts"
    Notify("No servers with fruits found after " .. attempts .. " attempts!")
    return false
end

-- Fruit Spawn Detection
local knownFruits = {}
task.spawn(function()
    while task.wait(0.5) do
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
            if not currentFruits[id] then knownFruits[id] = nil end
        end
    end
end)

-- Fruit Farming Loop
local collectedFruits = 0
local rareFruitsFound = 0
task.spawn(function()
    local player = Players.LocalPlayer
    while task.wait(0.03) do
        if not getgenv().config["Fruit"]["FarmFruit"] then continue end

        local hasFruits, fruitCount, fruitList, rareCount, fruitsInRange = CheckCurrentServerForFruits()
        if not hasFruits then
            ServerHopStatusLabel.Text = "Server Hop: No fruits in range, hopping..."
            Notify("No fruits in range, hopping...")
            SmartHop()
            continue
        end

        table.sort(fruitsInRange, function(a, b)
            local aIsRare = table.find(getgenv().config["Fruit"]["PriorityFruits"], a.Name)
            local bIsRare = table.find(getgenv().config["Fruit"]["PriorityFruits"], b.Name)
            if aIsRare and not bIsRare then return true end
            if bIsRare and not aIsRare then return false end
            return a.Distance < b.Distance
        end)

        for _, fruitData in pairs(fruitsInRange) do
            if fruitData.Distance <= 50 then
                local fruit = fruitData.Model
                local fruitName = fruitData.Name
                fastTeleport(fruit.Handle.CFrame)
                collectedFruits = collectedFruits + 1
                if table.find(getgenv().config["Fruit"]["PriorityFruits"], fruitName) then rareFruitsFound = rareFruitsFound + 1 end
                FruitsCollectedLabel.Text = "Fruits Collected: " .. collectedFruits
                LastFruitLabel.Text = "Last Fruit: " .. fruitName
                RareFruitsLabel.Text = "Rare Fruits Found: " .. rareFruitsFound
                Notify("Picked up: " .. fruitName .. " (Fast)")
                SendWebhook(fruitName, "pickup", fruit.Handle.Position)
                if getgenv().config["Fruit"]["StoreFruit"] then StoreFruit(fruit) end
                task.wait(0.1)
            end
        end

        local targetFruit = fruitsInRange[1]
        if targetFruit then
            local fruit = targetFruit.Model
            local fruitName = targetFruit.Name
            fastTeleport(fruit.Handle.CFrame)
            collectedFruits = collectedFruits + 1
            if table.find(getgenv().config["Fruit"]["PriorityFruits"], fruitName) then rareFruitsFound = rareFruitsFound + 1 end
            FruitsCollectedLabel.Text = "Fruits Collected: " .. collectedFruits
            LastFruitLabel.Text = "Last Fruit: " .. fruitName
            RareFruitsLabel.Text = "Rare Fruits Found: " .. rareFruitsFound
            Notify("Picked up: " .. fruitName .. " (Priority)")
            SendWebhook(fruitName, "pickup", fruit.Handle.Position)
            if getgenv().config["Fruit"]["StoreFruit"] then StoreFruit(fruit) end
        end

        task.wait(0.2)
        local stillHasFruits, _, _, stillHasRare = CheckCurrentServerForFruits()
        local timeInServer = os.time() - serverStartTime
        if not stillHasFruits or (stillHasRare == 0 and rareFruitsFound > 0) or timeInServer >= getgenv().config["Setting"]["HopTimeout"] then
            ServerHopStatusLabel.Text = "Server Hop: Triggered (No fruits/rare or timeout after " .. timeInServer .. "s)"
            Notify("Hopping: No fruits/rare or timeout after " .. timeInServer .. "s")
            SmartHop()
        end
    end
end)

-- ESP Loop
task.spawn(function()
    while task.wait(0.03) do UpdateBfEsp() end
end)