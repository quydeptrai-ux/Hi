local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui") -- Sử dụng CoreGui thay vì PlayerGui để tránh bị reset
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Bộ nhớ đệm Tween
local TweenCache = setmetatable({}, {__mode = "k"})

-- Cấu hình mặc định
local DefaultConfig = {
    NameHub = "Cat Hub",
    Description = "Enhanced by Grok",
    Color = Color3.fromRGB(255, 0, 255),
    TabWidth = 130,
    Theme = "Dark",
    AnimationSpeed = 0.3,
    ParticleEffects = true,
}

-- Theme động
local Themes = {
    Dark = {Background = Color3.fromRGB(20, 20, 20), Secondary = Color3.fromRGB(30, 30, 30), Text = Color3.fromRGB(255, 255, 255), Accent = DefaultConfig.Color, Shadow = Color3.fromRGB(0, 0, 0)},
    Light = {Background = Color3.fromRGB(240, 240, 240), Secondary = Color3.fromRGB(220, 220, 220), Text = Color3.fromRGB(0, 0, 0), Accent = DefaultConfig.Color, Shadow = Color3.fromRGB(100, 100, 100)},
}

-- Hàm hỗ trợ
local function GetTween(object, info, properties)
    local key = tostring(object)
    if TweenCache[key] then TweenCache[key]:Cancel() end
    TweenCache[key] = TweenService:Create(object, info, properties)
    TweenCache[key]:Play()
    return TweenCache[key]
end

local function MakeDraggable(topbarobject, object)
    local Dragging, DragStart, StartPosition
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = input.Position - DragStart
            GetTween(object, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
                Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
            })
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
end

local function CircleClick(Button, X, Y)
    task.spawn(function()
        Button.ClipsDescendants = true
        local Circle = Instance.new("ImageLabel")
        Circle.Image = "rbxassetid://266543268"
        Circle.ImageColor3 = Color3.fromRGB(255, 255, 255)
        Circle.ImageTransparency = 0.6
        Circle.BackgroundTransparency = 1
        Circle.ZIndex = 10
        Circle.Parent = Button
        local NewX, NewY = X - Button.AbsolutePosition.X, Y - Button.AbsolutePosition.Y
        Circle.Position = UDim2.new(0, NewX, 0, NewY)
        local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 2
        GetTween(Circle, TweenInfo.new(0.35, Enum.EasingStyle.Elastic), {
            Size = UDim2.new(0, Size, 0, Size),
            Position = UDim2.new(0.5, -Size / 2, 0.5, -Size / 2),
            ImageTransparency = 1
        })
        task.wait(0.35)
        Circle:Destroy()
    end)
end

local function AddParticleEffect(parent)
    if not DefaultConfig.ParticleEffects then return end
    task.spawn(function()
        while parent and parent.Parent do
            local Particle = Instance.new("Frame")
            Particle.Size = UDim2.new(0, 5, 0, 5)
            Particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
            Particle.BackgroundColor3 = DefaultConfig.Color
            Particle.BackgroundTransparency = 0.7
            Particle.Parent = parent
            local Corner = Instance.new("UICorner", Particle)
            Corner.CornerRadius = UDim.new(1, 0)
            GetTween(Particle, TweenInfo.new(1, Enum.EasingStyle.Quad), {
                Position = UDim2.new(math.random(), 0, math.random(), 0),
                BackgroundTransparency = 1
            })
            task.wait(1)
            Particle:Destroy()
            task.wait(math.random(0.1, 0.5))
        end
    end)
end

local CatLib = {}

function CatLib:MakeGui(GuiConfig)
    GuiConfig = GuiConfig or {}
    for k, v in pairs(DefaultConfig) do if GuiConfig[k] == nil then GuiConfig[k] = v end end
    local CurrentTheme = Themes[GuiConfig.Theme]

    local HirimiGui = Instance.new("ScreenGui")
    HirimiGui.Name = "HirimiGui"
    HirimiGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    HirimiGui.Parent = CoreGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 550, 0, 450)
    Main.Position = UDim2.new(0.5, -275, 0.5, -225)
    Main.BackgroundColor3 = CurrentTheme.Background
    Main.Parent = HirimiGui
    local UICorner = Instance.new("UICorner", Main)
    UICorner.CornerRadius = UDim.new(0, 10)

    local Shadow = Instance.new("ImageLabel", Main)
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = CurrentTheme.Shadow
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.Size = UDim2.new(1, 47, 1, 47)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.ZIndex = 0

    local Gradient = Instance.new("UIGradient", Main)
    Gradient.Color = ColorSequence.new{GuiConfig.Color, CurrentTheme.Background}
    Gradient.Rotation = 45
    RunService.RenderStepped:Connect(function(dt)
        Gradient.Offset = Vector2.new(math.sin(tick() * 2) * 0.1, math.cos(tick() * 2) * 0.1)
    end)

    local Top = Instance.new("Frame", Main)
    Top.Size = UDim2.new(1, 0, 0, 40)
    Top.BackgroundColor3 = CurrentTheme.Secondary
    Top.BackgroundTransparency = 0.1

    local Title = Instance.new("TextLabel", Top)
    Title.Text = GuiConfig.NameHub
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = CurrentTheme.Text
    Title.TextSize = 16
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.BackgroundTransparency = 1

    local Description = Instance.new("TextLabel", Top)
    Description.Text = GuiConfig.Description
    Description.Font = Enum.Font.GothamBold
    Description.TextColor3 = GuiConfig.Color
    Description.TextSize = 14
    Description.Position = UDim2.new(0, Title.TextBounds.X + 15, 0, 0)
    Description.Size = UDim2.new(0.5, -Title.TextBounds.X - 15, 1, 0)
    Description.BackgroundTransparency = 1

    local Close = Instance.new("TextButton", Top)
    Close.Text = "X"
    Close.Font = Enum.Font.Gotham
    Close.TextColor3 = Color3.fromRGB(255, 100, 100)
    Close.TextSize = 14
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -35, 0.5, -15)
    Close.BackgroundTransparency = 1

    MakeDraggable(Top, Main)
    AddParticleEffect(Main)

    local TabsContainer = Instance.new("Frame", Main)
    TabsContainer.Size = UDim2.new(0, GuiConfig.TabWidth, 1, -50)
    TabsContainer.Position = UDim2.new(0, 10, 0, 40)
    TabsContainer.BackgroundTransparency = 1

    local SearchBar = Instance.new("TextBox", TabsContainer)
    SearchBar.Size = UDim2.new(1, -10, 0, 30)
    SearchBar.Position = UDim2.new(0, 5, 0, 5)
    SearchBar.BackgroundColor3 = CurrentTheme.Secondary
    SearchBar.Text = "Search..."
    SearchBar.TextColor3 = CurrentTheme.Text
    SearchBar.TextSize = 14
    SearchBar.Font = Enum.Font.Gotham
    SearchBar.TextTransparency = 0.5
    SearchBar.ClearTextOnFocus = true
    local SearchCorner = Instance.new("UICorner", SearchBar)
    SearchCorner.CornerRadius = UDim.new(0, 6)

    local TabsScroll = Instance.new("ScrollingFrame", TabsContainer)
    TabsScroll.Size = UDim2.new(1, 0, 1, -40)
    TabsScroll.Position = UDim2.new(0, 0, 0, 40)
    TabsScroll.BackgroundTransparency = 1
    TabsScroll.ScrollBarThickness = 0
    local UIListLayout = Instance.new("UIListLayout", TabsScroll)
    UIListLayout.Padding = UDim.new(0, 5)

    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.new(1, -GuiConfig.TabWidth - 20, 1, -50)
    Pages.Position = UDim2.new(0, GuiConfig.TabWidth + 20, 0, 40)
    Pages.BackgroundTransparency = 1

    local PageFolder = Instance.new("Folder", Pages)
    local PageLayout = Instance.new("UIPageLayout", PageFolder)
    PageLayout.TweenTime = GuiConfig.AnimationSpeed
    PageLayout.EasingStyle = Enum.EasingStyle.Sine

    local Tabs = {}
    local TabCount = 0
    local ConfigState = {}

    function Tabs:CreateTab(TabConfig)
        TabConfig = TabConfig or {}
        TabConfig.Name = TabConfig.Name or "Tab"
        TabConfig.Icon = TabConfig.Icon or "rbxassetid://6034830835"

        local TabButton = Instance.new("TextButton", TabsScroll)
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.BackgroundColor3 = TabCount == 0 and CurrentTheme.Secondary or Color3.fromRGB(35, 35, 35)
        TabButton.Text = ""
        TabButton.LayoutOrder = TabCount
        local UICorner = Instance.new("UICorner", TabButton)
        UICorner.CornerRadius = UDim.new(0, 6)

        local Icon = Instance.new("ImageLabel", TabButton)
        Icon.Image = TabConfig.Icon
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.Position = UDim2.new(0, 5, 0.5, -10)
        Icon.BackgroundTransparency = 1

        local TabName = Instance.new("TextLabel", TabButton)
        TabName.Text = TabConfig.Name
        TabName.Font = Enum.Font.GothamBold
        TabName.TextColor3 = CurrentTheme.Text
        TabName.TextSize = 14
        TabName.Size = UDim2.new(1, -30, 1, 0)
        TabName.Position = UDim2.new(0, 30, 0, 0)
        TabName.BackgroundTransparency = 1

        local Page = Instance.new("ScrollingFrame", PageFolder)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = GuiConfig.Color
        Page.LayoutOrder = TabCount
        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, 8)

        if TabCount == 0 then PageLayout:JumpTo(Page) end

        TabButton.Activated:Connect(function()
            CircleClick(TabButton, Mouse.X, Mouse.Y)
            for _, tab in TabsScroll:GetChildren() do
                if tab:IsA("TextButton") then
                    GetTween(tab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
                end
            end
            GetTween(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.Secondary})
            PageLayout:JumpTo(Page)
        end)

        SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
            local query = SearchBar.Text:lower()
            TabButton.Visible = (query == "" or query == "search...") or TabConfig.Name:lower():find(query) ~= nil
        end)

        local Sections = {}
        local SectionCount = 0

        function Sections:AddSection(SectionName)
            SectionName = SectionName or "Section"

            local Section = Instance.new("Frame", Page)
            Section.Size = UDim2.new(1, -10, 0, 0)
            Section.BackgroundColor3 = CurrentTheme.Secondary
            Section.LayoutOrder = SectionCount
            Section.AutomaticSize = Enum.AutomaticSize.Y
            local UICorner = Instance.new("UICorner", Section)
            UICorner.CornerRadius = UDim.new(0, 6)

            local SectionTitle = Instance.new("TextLabel", Section)
            SectionTitle.Text = SectionName
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextColor3 = GuiConfig.Color
            SectionTitle.TextSize = 16
            SectionTitle.Size = UDim2.new(1, 0, 0, 25)
            SectionTitle.BackgroundTransparency = 1

            local ItemsContainer = Instance.new("Frame", Section)
            ItemsContainer.Size = UDim2.new(1, -10, 1, -30)
            ItemsContainer.Position = UDim2.new(0, 5, 0, 25)
            ItemsContainer.BackgroundTransparency = 1
            local ItemsList = Instance.new("UIListLayout", ItemsContainer)
            ItemsList.Padding = UDim.new(0, 5)

            local Items = {}
            local ItemCount = 0

            function Items:AddButton(ButtonConfig)
                ButtonConfig = ButtonConfig or {}
                ButtonConfig.Title = ButtonConfig.Title or "Button"
                ButtonConfig.Callback = ButtonConfig.Callback or function() end

                local Button = Instance.new("TextButton", ItemsContainer)
                Button.Size = UDim2.new(1, 0, 0, 35)
                Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                Button.Text = ButtonConfig.Title
                Button.Font = Enum.Font.GothamBold
                Button.TextColor3 = CurrentTheme.Text
                Button.TextSize = 14
                Button.LayoutOrder = ItemCount
                local UICorner = Instance.new("UICorner", Button)
                UICorner.CornerRadius = UDim.new(0, 6)

                Button.MouseEnter:Connect(function()
                    GetTween(Button, TweenInfo.new(0.2), {BackgroundColor3 = GuiConfig.Color})
                end)
                Button.MouseLeave:Connect(function()
                    GetTween(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
                end)
                Button.Activated:Connect(function()
                    CircleClick(Button, Mouse.X, Mouse.Y)
                    ButtonConfig.Callback()
                end)

                ItemCount = ItemCount + 1
                return {}
            end

            function Items:AddToggle(ToggleConfig)
                ToggleConfig = ToggleConfig or {}
                ToggleConfig.Title = ToggleConfig.Title or "Toggle"
                ToggleConfig.Default = ToggleConfig.Default or false
                ToggleConfig.Callback = ToggleConfig.Callback or function(value) end

                local Toggle = Instance.new("Frame", ItemsContainer)
                Toggle.Size = UDim2.new(1, 0, 0, 35)
                Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                Toggle.LayoutOrder = ItemCount
                local UICorner = Instance.new("UICorner", Toggle)
                UICorner.CornerRadius = UDim.new(0, 6)

                local Title = Instance.new("TextLabel", Toggle)
                Title.Text = ToggleConfig.Title
                Title.Font = Enum.Font.GothamBold
                Title.TextColor3 = CurrentTheme.Text
                Title.TextSize = 14
                Title.Size = UDim2.new(1, -50, 1, 0)
                Title.Position = UDim2.new(0, 10, 0, 0)
                Title.BackgroundTransparency = 1

                local Switch = Instance.new("Frame", Toggle)
                Switch.Size = UDim2.new(0, 40, 0, 20)
                Switch.Position = UDim2.new(1, -45, 0.5, -10)
                Switch.BackgroundColor3 = ToggleConfig.Default and GuiConfig.Color or Color3.fromRGB(80, 80, 80)
                local SwitchCorner = Instance.new("UICorner", Switch)
                SwitchCorner.CornerRadius = UDim.new(0, 10)

                local Circle = Instance.new("Frame", Switch)
                Circle.Size = UDim2.new(0, 16, 0, 16)
                Circle.Position = ToggleConfig.Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                Circle.BackgroundColor3 = CurrentTheme.Text
                local CircleCorner = Instance.new("UICorner", Circle)
                CircleCorner.CornerRadius = UDim.new(0, 8)

                local ToggleButton = Instance.new("TextButton", Toggle)
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Text = ""

                local ToggleFunc = {Value = ToggleConfig.Default}
                ToggleButton.Activated:Connect(function()
                    CircleClick(ToggleButton, Mouse.X, Mouse.Y)
                    ToggleFunc.Value = not ToggleFunc.Value
                    GetTween(Switch, TweenInfo.new(0.2), {BackgroundColor3 = ToggleFunc.Value and GuiConfig.Color or Color3.fromRGB(80, 80, 80)})
                    GetTween(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Position = ToggleFunc.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                    ToggleConfig.Callback(ToggleFunc.Value)
                end)

                function ToggleFunc:Set(value)
                    ToggleFunc.Value = value
                    GetTween(Switch, TweenInfo.new(0.2), {BackgroundColor3 = value and GuiConfig.Color or Color3.fromRGB(80, 80, 80)})
                    GetTween(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Position = value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                    ToggleConfig.Callback(value)
                end

                ConfigState[ToggleConfig.Title] = ToggleFunc.Value
                ItemCount = ItemCount + 1
                return ToggleFunc
            end

            function Items:AddSlider(SliderConfig)
                SliderConfig = SliderConfig or {}
                SliderConfig.Title = SliderConfig.Title or "Slider"
                SliderConfig.Min = SliderConfig.Min or 0
                SliderConfig.Max = SliderConfig.Max or 100
                SliderConfig.Default = SliderConfig.Default or 50
                SliderConfig.Increment = SliderConfig.Increment or 1
                SliderConfig.Callback = SliderConfig.Callback or function(value) end

                local Slider = Instance.new("Frame", ItemsContainer)
                Slider.Size = UDim2.new(1, 0, 0, 50)
                Slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                Slider.LayoutOrder = ItemCount
                local UICorner = Instance.new("UICorner", Slider)
                UICorner.CornerRadius = UDim.new(0, 6)

                local Title = Instance.new("TextLabel", Slider)
                Title.Text = SliderConfig.Title
                Title.Font = Enum.Font.GothamBold
                Title.TextColor3 = CurrentTheme.Text
                Title.TextSize = 14
                Title.Size = UDim2.new(1, -150, 0, 20)
                Title.Position = UDim2.new(0, 10, 0, 5)
                Title.BackgroundTransparency = 1

                local SliderBar = Instance.new("Frame", Slider)
                SliderBar.Size = UDim2.new(1, -20, 0, 5)
                SliderBar.Position = UDim2.new(0, 10, 1, -15)
                SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                local BarCorner = Instance.new("UICorner", SliderBar)
                BarCorner.CornerRadius = UDim.new(0, 5)

                local Fill = Instance.new("Frame", SliderBar)
                Fill.Size = UDim2.new((SliderConfig.Default - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 0, 1, 0)
                Fill.BackgroundColor3 = GuiConfig.Color
                local FillCorner = Instance.new("UICorner", Fill)
                FillCorner.CornerRadius = UDim.new(0, 5)

                local Circle = Instance.new("Frame", Fill)
                Circle.Size = UDim2.new(0, 12, 0, 12)
                Circle.Position = UDim2.new(1, -6, 0.5, -6)
                Circle.BackgroundColor3 = GuiConfig.Color
                local CircleCorner = Instance.new("UICorner", Circle)
                CircleCorner.CornerRadius = UDim.new(0, 6)

                local ValueLabel = Instance.new("TextLabel", Slider)
                ValueLabel.Text = tostring(SliderConfig.Default)
                ValueLabel.Font = Enum.Font.Gotham
                ValueLabel.TextColor3 = CurrentTheme.Text
                ValueLabel.TextSize = 12
                ValueLabel.Size = UDim2.new(0, 50, 0, 20)
                ValueLabel.Position = UDim2.new(1, -60, 0, 5)
                ValueLabel.BackgroundTransparency = 1

                local SliderFunc = {Value = SliderConfig.Default}
                local Dragging = false
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = true
                    end
                end)
                SliderBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = false
                        SliderConfig.Callback(SliderFunc.Value)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                        SliderFunc.Value = math.floor(SliderConfig.Min + (SliderConfig.Max - SliderConfig.Min) * pos / SliderConfig.Increment) * SliderConfig.Increment
                        GetTween(Fill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)})
                        ValueLabel.Text = tostring(SliderFunc.Value)
                    end
                end)

                function SliderFunc:Set(value)
                    SliderFunc.Value = math.clamp(value, SliderConfig.Min, SliderConfig.Max)
                    local pos = (SliderFunc.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
                    GetTween(Fill, TweenInfo.new(0.2), {Size = UDim2.new(pos, 0, 1, 0)})
                    ValueLabel.Text = tostring(SliderFunc.Value)
                    SliderConfig.Callback(SliderFunc.Value)
                end

                ConfigState[SliderConfig.Title] = SliderFunc.Value
                ItemCount = ItemCount + 1
                return SliderFunc
            end

            function Items:AddDropdown(DropdownConfig)
                DropdownConfig = DropdownConfig or {}
                DropdownConfig.Title = DropdownConfig.Title or "Dropdown"
                DropdownConfig.Content = DropdownConfig.Content or "Select an option"
                DropdownConfig.Multi = DropdownConfig.Multi or false
                DropdownConfig.Options = DropdownConfig.Options or {"Option 1", "Option 2", "Option 3"}
                DropdownConfig.Default = DropdownConfig.Default or (DropdownConfig.Multi and {} or DropdownConfig.Options[1])
                DropdownConfig.Callback = DropdownConfig.Callback or function(value) end

                local Dropdown = Instance.new("Frame", ItemsContainer)
                Dropdown.Size = UDim2.new(1, 0, 0, 60)
                Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                Dropdown.LayoutOrder = ItemCount
                local UICorner = Instance.new("UICorner", Dropdown)
                UICorner.CornerRadius = UDim.new(0, 6)

                local Title = Instance.new("TextLabel", Dropdown)
                Title.Text = DropdownConfig.Title
                Title.Font = Enum.Font.GothamBold
                Title.TextColor3 = CurrentTheme.Text
                Title.TextSize = 14
                Title.Size = UDim2.new(1, -150, 0, 20)
                Title.Position = UDim2.new(0, 10, 0, 5)
                Title.BackgroundTransparency = 1

                local Content = Instance.new("TextLabel", Dropdown)
                Content.Text = DropdownConfig.Content
                Content.Font = Enum.Font.Gotham
                Content.TextColor3 = CurrentTheme.Text
                Content.TextSize = 12
                Content.TextTransparency = 0.6
                Content.Size = UDim2.new(1, -150, 0, 15)
                Content.Position = UDim2.new(0, 10, 0, 25)
                Content.BackgroundTransparency = 1

                local SelectedText = Instance.new("TextLabel", Dropdown)
                SelectedText.Text = DropdownConfig.Multi and table.concat(DropdownConfig.Default, ", ") or DropdownConfig.Default
                SelectedText.Font = Enum.Font.Gotham
                SelectedText.TextColor3 = CurrentTheme.Text
                SelectedText.TextSize = 12
                SelectedText.Size = UDim2.new(0, 130, 0, 25)
                SelectedText.Position = UDim2.new(1, -140, 0.5, -12)
                SelectedText.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                SelectedText.TextTruncate = Enum.TextTruncate.AtEnd
                local SelectedCorner = Instance.new("UICorner", SelectedText)
                SelectedCorner.CornerRadius = UDim.new(0, 4)

                local DropdownButton = Instance.new("TextButton", Dropdown)
                DropdownButton.Size = UDim2.new(1, 0, 1, 0)
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Text = ""

                local DropdownMenu = Instance.new("Frame", Main)
                DropdownMenu.Size = UDim2.new(0, 200, 0, 0)
                DropdownMenu.Position = UDim2.new(0, Dropdown.AbsolutePosition.X, 0, Dropdown.AbsolutePosition.Y + 60)
                DropdownMenu.BackgroundColor3 = CurrentTheme.Secondary
                DropdownMenu.Visible = false
                DropdownMenu.ClipsDescendants = true
                local MenuCorner = Instance.new("UICorner", DropdownMenu)
                MenuCorner.CornerRadius = UDim.new(0, 6)

                local OptionsScroll = Instance.new("ScrollingFrame", DropdownMenu)
                OptionsScroll.Size = UDim2.new(1, -10, 1, -10)
                OptionsScroll.Position = UDim2.new(0, 5, 0, 5)
                OptionsScroll.BackgroundTransparency = 1
                OptionsScroll.ScrollBarThickness = 2

                local OptionsList = Instance.new("UIListLayout", OptionsScroll)
                OptionsList.Padding = UDim.new(0, 3)

                local DropdownFunc = {Value = DropdownConfig.Default, Options = DropdownConfig.Options}
                local function RefreshOptions()
                    OptionsScroll:ClearAllChildren()
                    OptionsList.Parent = nil
                    OptionsList.Parent = OptionsScroll
                    for _, option in pairs(DropdownConfig.Options) do
                        local OptionButton = Instance.new("TextButton", OptionsScroll)
                        OptionButton.Size = UDim2.new(1, 0, 0, 30)
                        OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        OptionButton.Text = option
                        OptionButton.Font = Enum.Font.Gotham
                        OptionButton.TextColor3 = CurrentTheme.Text
                        OptionButton.TextSize = 12
                        local OptionCorner = Instance.new("UICorner", OptionButton)
                        OptionCorner.CornerRadius = UDim.new(0, 4)

                        OptionButton.MouseEnter:Connect(function()
                            GetTween(OptionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
                        end)
                        OptionButton.MouseLeave:Connect(function()
                            GetTween(OptionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
                        end)
                        OptionButton.Activated:Connect(function()
                            CircleClick(OptionButton, Mouse.X, Mouse.Y)
                            if DropdownConfig.Multi then
                                if table.find(DropdownFunc.Value, option) then
                                    table.remove(DropdownFunc.Value, table.find(DropdownFunc.Value, option))
                                else
                                    table.insert(DropdownFunc.Value, option)
                                end
                            else
                                DropdownFunc.Value = option
                                DropdownMenu.Visible = false
                                GetTween(DropdownMenu, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 200, 0, 0)})
                            end
                            SelectedText.Text = DropdownConfig.Multi and table.concat(DropdownFunc.Value, ", ") or DropdownFunc.Value
                            DropdownConfig.Callback(DropdownFunc.Value)
                        end)
                    end
                    OptionsScroll.CanvasSize = UDim2.new(0, 0, 0, #DropdownConfig.Options * 33)
                end

                DropdownButton.Activated:Connect(function()
                    CircleClick(DropdownButton, Mouse.X, Mouse.Y)
                    DropdownMenu.Visible = not DropdownMenu.Visible
                    if DropdownMenu.Visible then
                        DropdownMenu.Position = UDim2.new(0, Dropdown.AbsolutePosition.X, 0, Dropdown.AbsolutePosition.Y + 60)
                        GetTween(DropdownMenu, TweenInfo.new(0.3, Enum.EasingStyle.Elastic), {Size = UDim2.new(0, 200, 0, math.min(#DropdownConfig.Options * 33, 150))})
                        RefreshOptions()
                    else
                        GetTween(DropdownMenu, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 200, 0, 0)})
                    end
                end)

                function DropdownFunc:Set(value)
                    DropdownFunc.Value = value
                    SelectedText.Text = DropdownConfig.Multi and table.concat(value, ", ") or value
                    DropdownConfig.Callback(value)
                    RefreshOptions()
                end

                function DropdownFunc:Refresh(options, default)
                    DropdownConfig.Options = options or DropdownConfig.Options
                    DropdownFunc.Value = default or DropdownFunc.Value
                    SelectedText.Text = DropdownConfig.Multi and table.concat(DropdownFunc.Value, ", ") or DropdownFunc.Value
                    RefreshOptions()
                end

                ConfigState[DropdownConfig.Title] = DropdownFunc.Value
                ItemCount = ItemCount + 1
                return DropdownFunc
            end

            function Items:AddColorPicker(ColorConfig)
                ColorConfig = ColorConfig or {}
                ColorConfig.Title = ColorConfig.Title or "Color Picker"
                ColorConfig.Default = ColorConfig.Default or Color3.fromRGB(255, 255, 255)
                ColorConfig.Callback = ColorConfig.Callback or function(color) end

                local ColorPicker = Instance.new("Frame", ItemsContainer)
                ColorPicker.Size = UDim2.new(1, 0, 0, 35)
                ColorPicker.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                ColorPicker.LayoutOrder = ItemCount
                local UICorner = Instance.new("UICorner", ColorPicker)
                UICorner.CornerRadius = UDim.new(0, 6)

                local Title = Instance.new("TextLabel", ColorPicker)
                Title.Text = ColorConfig.Title
                Title.Font = Enum.Font.GothamBold
                Title.TextColor3 = CurrentTheme.Text
                Title.TextSize = 14
                Title.Size = UDim2.new(1, -50, 1, 0)
                Title.Position = UDim2.new(0, 10, 0, 0)
                Title.BackgroundTransparency = 1

                local ColorPreview = Instance.new("Frame", ColorPicker)
                ColorPreview.Size = UDim2.new(0, 30, 0, 20)
                ColorPreview.Position = UDim2.new(1, -40, 0.5, -10)
                ColorPreview.BackgroundColor3 = ColorConfig.Default
                local PreviewCorner = Instance.new("UICorner", ColorPreview)
                PreviewCorner.CornerRadius = UDim.new(0, 4)

                local PickerMenu = Instance.new("Frame", Main)
                PickerMenu.Size = UDim2.new(0, 150, 0, 0)
                PickerMenu.Position = UDim2.new(0, ColorPicker.AbsolutePosition.X, 0, ColorPicker.AbsolutePosition.Y + 35)
                PickerMenu.BackgroundColor3 = CurrentTheme.Secondary
                PickerMenu.Visible = false
                local PickerCorner = Instance.new("UICorner", PickerMenu)
                PickerCorner.CornerRadius = UDim.new(0, 6)

                local HueBar = Instance.new("Frame", PickerMenu)
                HueBar.Size = UDim2.new(1, -10, 0, 10)
                HueBar.Position = UDim2.new(0, 5, 0, 5)
                HueBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                local HueGradient = Instance.new("UIGradient", HueBar)
                HueGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
                }

                local SaturationValue = Instance.new("Frame", PickerMenu)
                SaturationValue.Size = UDim2.new(1, -10, 0, 100)
                SaturationValue.Position = UDim2.new(0, 5, 0, 20)
                SaturationValue.BackgroundColor3 = ColorConfig.Default

                local ColorPickerButton = Instance.new("TextButton", ColorPicker)
                ColorPickerButton.Size = UDim2.new(1, 0, 1, 0)
                ColorPickerButton.BackgroundTransparency = 1
                ColorPickerButton.Text = ""

                local ColorFunc = {Value = ColorConfig.Default}
                ColorPickerButton.Activated:Connect(function()
                    CircleClick(ColorPickerButton, Mouse.X, Mouse.Y)
                    PickerMenu.Visible = not PickerMenu.Visible
                    if PickerMenu.Visible then
                        GetTween(PickerMenu, TweenInfo.new(0.3, Enum.EasingStyle.Elastic), {Size = UDim2.new(0, 150, 0, 130)})
                    else
                        GetTween(PickerMenu, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 150, 0, 0)})
                    end
                end)

                function ColorFunc:Set(color)
                    ColorFunc.Value = color
                    ColorPreview.BackgroundColor3 = color
                    SaturationValue.BackgroundColor3 = color
                    ColorConfig.Callback(color)
                end

                ConfigState[ColorConfig.Title] = ColorFunc.Value
                ItemCount = ItemCount + 1
                return ColorFunc
            end

            SectionCount = SectionCount + 1
            return Items
        end

        TabCount = TabCount + 1
        return Sections
    end

    local GuiFunc = {}
    function GuiFunc:DestroyGui()
        HirimiGui:Destroy()
    end

    function GuiFunc:SetTheme(themeName)
        CurrentTheme = Themes[themeName] or Themes.Dark
        Main.BackgroundColor3 = CurrentTheme.Background
        Top.BackgroundColor3 = CurrentTheme.Secondary
        Title.TextColor3 = CurrentTheme.Text
        Gradient.Color = ColorSequence.new{GuiConfig.Color, CurrentTheme.Background}
        Shadow.ImageColor3 = CurrentTheme.Shadow
        for _, tab in TabsScroll:GetChildren() do
            if tab:IsA("TextButton") then
                tab.BackgroundColor3 = TabCount == 0 and CurrentTheme.Secondary or Color3.fromRGB(35, 35, 35)
            end
        end
    end

    function GuiFunc:SaveConfig()
        ConfigState.Position = Main.Position
        ConfigState.Size = Main.Size
        ConfigState.Theme = GuiConfig.Theme
        return HttpService:JSONEncode(ConfigState)
    end

    function GuiFunc:LoadConfig(json)
        local config = HttpService:JSONDecode(json)
        Main.Position = config.Position or Main.Position
        Main.Size = config.Size or Main.Size
        self:SetTheme(config.Theme or "Dark")
    end

    Close.Activated:Connect(function()
        CircleClick(Close, Mouse.X, Mouse.Y)
        HirimiGui:Destroy()
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            Main.Visible = not Main.Visible
        end
    end)

    return Tabs, GuiFunc
end

return CatLib