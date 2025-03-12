local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")

-- Global Functions (Mocked for now, replace with actual implementation if needed)
getgenv().readdata = getgenv().readdata or function(foldername, filename, tabs) return {} end
getgenv().save = getgenv().save or function(foldername, filename, filecontent) end
getgenv().loadsetting = getgenv().loadsetting or function(foldername, filename, tabs) return {} end

-- Utility Functions
local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition
    local function UpdatePos(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        TweenService:Create(object, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Position = pos}):Play()
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then UpdatePos(input) end
    end)
end

local function MakeResizable(object)
    local ResizeHandle = Instance.new("Frame")
    ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
    ResizeHandle.Position = UDim2.new(1, -10, 1, -10)
    ResizeHandle.BackgroundTransparency = 1
    ResizeHandle.Parent = object

    local Dragging, DragInput, DragStart, StartSize
    local MinSize = Vector2.new(300, 200)

    local function UpdateSize(input)
        local Delta = input.Position - DragStart
        local NewSize = Vector2.new(math.max(StartSize.X + Delta.X, MinSize.X), math.max(StartSize.Y + Delta.Y, MinSize.Y))
        TweenService:Create(object, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Size = UDim2.new(0, NewSize.X, 0, NewSize.Y)}):Play()
    end

    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartSize = Vector2.new(object.Size.X.Offset, object.Size.Y.Offset)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)

    ResizeHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = input end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then UpdateSize(input) end
    end)
end

local function AddTooltip(element, text)
    local Tooltip = Instance.new("TextLabel")
    Tooltip.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tooltip.Text = text
    Tooltip.TextSize = 12
    Tooltip.Size = UDim2.new(0, 100, 0, 20)
    Tooltip.Visible = false
    Tooltip.Parent = CoreGui

    element.MouseEnter:Connect(function()
        Tooltip.Position = UDim2.new(0, Mouse.X + 10, 0, Mouse.Y + 10)
        Tooltip.Visible = true
    end)

    element.MouseLeave:Connect(function()
        Tooltip.Visible = false
    end)
end

-- WazureV3.1 Library
local WazureV3 = {Themes = {
    Dark = {Primary = Color3.fromRGB(25, 25, 25), Secondary = Color3.fromRGB(35, 35, 35), Accent = Color3.fromRGB(6, 141, 234), Text = Color3.fromRGB(255, 255, 255)},
    Light = {Primary = Color3.fromRGB(240, 240, 240), Secondary = Color3.fromRGB(220, 220, 220), Accent = Color3.fromRGB(0, 120, 200), Text = Color3.fromRGB(0, 0, 0)}
}}

function WazureV3:Notify(NotifyConfig)
    local NotifyConfig = NotifyConfig or {}
    NotifyConfig.Title = NotifyConfig.Title or "Notification"
    NotifyConfig.Content = NotifyConfig.Content or "This is a notification."
    NotifyConfig.Logo = NotifyConfig.Logo or "rbxassetid://18289959127"
    NotifyConfig.Time = NotifyConfig.Time or 0.5
    NotifyConfig.Delay = NotifyConfig.Delay or 5

    local NotifyGui = CoreGui:FindFirstChild("NotifyGui") or Instance.new("ScreenGui", CoreGui)
    NotifyGui.Name = "NotifyGui"
    NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local NotifyLayout = NotifyGui:FindFirstChild("NotifyLayout") or Instance.new("Frame", NotifyGui)
    NotifyLayout.Name = "NotifyLayout"
    NotifyLayout.AnchorPoint = Vector2.new(1, 0)
    NotifyLayout.Position = UDim2.new(1, -10, 0, 10)
    NotifyLayout.Size = UDim2.new(0, 260, 1, -20)
    NotifyLayout.BackgroundTransparency = 1

    local NotifyFrame = Instance.new("Frame")
    NotifyFrame.Size = UDim2.new(1, 0, 0, 70)
    NotifyFrame.BackgroundTransparency = 1
    NotifyFrame.Parent = NotifyLayout

    local NotifyFrameReal = Instance.new("Frame")
    NotifyFrameReal.BackgroundColor3 = WazureV3.CurrentTheme.Primary
    NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
    NotifyFrameReal.Position = UDim2.new(0, 270, 0, 0)
    NotifyFrameReal.Parent = NotifyFrame
    Instance.new("UICorner", NotifyFrameReal).CornerRadius = UDim.new(0, 5)

    local NotifyLogo = Instance.new("ImageLabel")
    NotifyLogo.Image = NotifyConfig.Logo
    NotifyLogo.Size = UDim2.new(0, 45, 0, 45)
    NotifyLogo.Position = UDim2.new(0, 12, 0.5, 0)
    NotifyLogo.AnchorPoint = Vector2.new(0, 0.5)
    NotifyLogo.BackgroundTransparency = 1
    NotifyLogo.Parent = NotifyFrameReal
    Instance.new("UICorner", NotifyLogo).CornerRadius = UDim.new(0, 5)

    local NotifyTitle = Instance.new("TextLabel")
    NotifyTitle.Text = NotifyConfig.Title
    NotifyTitle.Font = Enum.Font.GothamBold
    NotifyTitle.TextColor3 = WazureV3.CurrentTheme.Text
    NotifyTitle.TextSize = 14
    NotifyTitle.Position = UDim2.new(0, 69, 0, 15)
    NotifyTitle.Size = UDim2.new(1, -140, 0, 14)
    NotifyTitle.BackgroundTransparency = 1
    NotifyTitle.Parent = NotifyFrameReal

    local NotifyContent = Instance.new("TextLabel")
    NotifyContent.Text = NotifyConfig.Content
    NotifyContent.Font = Enum.Font.Gotham
    NotifyContent.TextColor3 = WazureV3.CurrentTheme.Text
    NotifyContent.TextTransparency = 0.3
    NotifyContent.TextSize = 12
    NotifyContent.Position = UDim2.new(0, 69, 0, 29)
    NotifyContent.Size = UDim2.new(1, -140, 0, 24)
    NotifyContent.TextWrapped = true
    NotifyContent.BackgroundTransparency = 1
    NotifyContent.Parent = NotifyFrameReal

    NotifyContent.Size = UDim2.new(1, -140, 0, NotifyContent.TextBounds.Y + 10)
    NotifyFrame.Size = UDim2.new(1, 0, 0, math.max(70, NotifyContent.TextBounds.Y + 40))

    local function Close()
        TweenService:Create(NotifyFrameReal, TweenInfo.new(NotifyConfig.Time), {Position = UDim2.new(0, 270, 0, 0)}):Play()
        task.delay(NotifyConfig.Time, function() NotifyFrame:Destroy() end)
    end

    TweenService:Create(NotifyFrameReal, TweenInfo.new(NotifyConfig.Time), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    task.delay(NotifyConfig.Delay, Close)

    return {Close = Close}
end

function WazureV3:Start(GuiConfig)
    local GuiConfig = GuiConfig or {}
    GuiConfig.Name = GuiConfig.Name or "WazureV3.1"
    GuiConfig.LogoPlayer = GuiConfig.LogoPlayer or "rbxassetid://18243105495"
    GuiConfig.NamePlayer = GuiConfig.NamePlayer or LocalPlayer.Name
    GuiConfig.TabWidth = GuiConfig.TabWidth or 120
    GuiConfig.Color = GuiConfig.Color or Color3.fromRGB(6, 141, 234)
    GuiConfig.SaveConfig = GuiConfig.SaveConfig or {Folder = GuiConfig.Name, NameConfig = "Config"}
    GuiConfig.Theme = GuiConfig.Theme or "Dark"
    WazureV3.CurrentTheme = WazureV3.Themes[GuiConfig.Theme] or WazureV3.Themes.Dark

    local AzuGui = Instance.new("ScreenGui", CoreGui)
    AzuGui.Name = "WazureV3Gui"
    AzuGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Main = Instance.new("Frame", AzuGui)
    Main.Size = UDim2.new(0, 550, 0, 400)
    Main.Position = UDim2.new(0.5, -275, 0.5, -200)
    Main.BackgroundColor3 = WazureV3.CurrentTheme.Primary
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

    local Top = Instance.new("Frame", Main)
    Top.Size = UDim2.new(1, 0, 0, 40)
    Top.BackgroundColor3 = WazureV3.CurrentTheme.Secondary
    Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 6)

    local NameHub = Instance.new("TextLabel", Top)
    NameHub.Text = GuiConfig.Name
    NameHub.Font = Enum.Font.GothamBold
    NameHub.TextColor3 = WazureV3.CurrentTheme.Text
    NameHub.TextSize = 18
    NameHub.Size = UDim2.new(1, -80, 1, 0)
    NameHub.Position = UDim2.new(0, 10, 0, 0)
    NameHub.BackgroundTransparency = 1

    local CloseButton = Instance.new("TextButton", Top)
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundTransparency = 1
    local CloseImage = Instance.new("ImageLabel", CloseButton)
    CloseImage.Size = UDim2.new(1, 0, 1, 0)
    CloseImage.Image = "rbxassetid://18328658828"
    CloseImage.BackgroundTransparency = 1

    MakeDraggable(Top, Main)
    MakeResizable(Main)

    local Tabs = Instance.new("Frame", Main)
    Tabs.Size = UDim2.new(0, GuiConfig.TabWidth, 1, -50)
    Tabs.Position = UDim2.new(0, 5, 0, 45)
    Tabs.BackgroundTransparency = 1

    local ScrollTab = Instance.new("ScrollingFrame", Tabs)
    ScrollTab.Size = UDim2.new(1, 0, 1, -50)
    ScrollTab.BackgroundTransparency = 1
    ScrollTab.ScrollBarThickness = 2
    ScrollTab.ScrollBarImageTransparency = 0.7
    local UIListLayout = Instance.new("UIListLayout", ScrollTab)
    UIListLayout.Padding = UDim.new(0, 5)

    local Layers = Instance.new("Frame", Main)
    Layers.Size = UDim2.new(1, -GuiConfig.TabWidth - 10, 1, -50)
    Layers.Position = UDim2.new(0, GuiConfig.TabWidth + 5, 0, 45)
    Layers.BackgroundTransparency = 1
    Layers.ClipsDescendants = true

    local LayersFolder = Instance.new("Folder", Layers)
    local LayersPageLayout = Instance.new("UIPageLayout", LayersFolder)
    LayersPageLayout.EasingStyle = Enum.EasingStyle.Quart
    LayersPageLayout.TweenTime = 0.2

    local TabFunctions = {}
    function TabFunctions:MakeTab(TabName)
        local Items = {}
        local ScrollLayers = Instance.new("ScrollingFrame", LayersFolder)
        ScrollLayers.Size = UDim2.new(1, 0, 1, 0)
        ScrollLayers.BackgroundTransparency = 1
        ScrollLayers.ScrollBarThickness = 2
        ScrollLayers.ScrollBarImageTransparency = 0.7
        ScrollLayers.LayoutOrder = #ScrollTab:GetChildren() - 1

        local UIListLayout2 = Instance.new("UIListLayout", ScrollLayers)
        UIListLayout2.Padding = UDim.new(0, 5)

        local TabButton = Instance.new("TextButton", ScrollTab)
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.BackgroundColor3 = WazureV3.CurrentTheme.Secondary
        TabButton.Text = TabName
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextColor3 = WazureV3.CurrentTheme.Text
        TabButton.TextSize = 14
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 4)

        TabButton.Activated:Connect(function()
            LayersPageLayout:JumpTo(ScrollLayers)
            for _, tab in ScrollTab:GetChildren() do
                if tab:IsA("TextButton") and tab ~= TabButton then
                    TweenService:Create(tab, TweenInfo.new(0.2), {BackgroundColor3 = WazureV3.CurrentTheme.Secondary}):Play()
                end
            end
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = WazureV3.CurrentTheme.Accent}):Play()
        end)

        if #ScrollTab:GetChildren() == 1 then
            LayersPageLayout:JumpTo(ScrollLayers)
            TabButton.BackgroundColor3 = WazureV3.CurrentTheme.Accent
        end

        local function UpdateCanvasSize()
            local height = 0
            for _, child in ScrollLayers:GetChildren() do
                if child:IsA("Frame") then height = height + child.Size.Y.Offset + 5 end
            end
            ScrollLayers.CanvasSize = UDim2.new(0, 0, 0, height)
        end

        ScrollLayers.ChildAdded:Connect(UpdateCanvasSize)
        ScrollLayers.ChildRemoved:Connect(UpdateCanvasSize)

        function Items:MakeSeperator(Text)
            local Separator = Instance.new("Frame", ScrollLayers)
            Separator.Size = UDim2.new(1, -10, 0, 20)
            Separator.BackgroundTransparency = 1

            local Line = Instance.new("Frame", Separator)
            Line.Size = UDim2.new(1, 0, 0, 1)
            Line.Position = UDim2.new(0, 0, 0.5, 0)
            Line.BackgroundColor3 = WazureV3.CurrentTheme.Accent

            local Label = Instance.new("TextLabel", Separator)
            Label.Text = Text or ""
            Label.Font = Enum.Font.GothamBold
            Label.TextColor3 = WazureV3.CurrentTheme.Text
            Label.TextSize = 12
            Label.Size = UDim2.new(0, 100, 0, 20)
            Label.Position = UDim2.new(0.5, -50, 0, 0)
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Center
        end

        function Items:MakeLabel(Text)
            local LabelFrame = Instance.new("Frame", ScrollLayers)
            LabelFrame.Size = UDim2.new(1, -10, 0, 30)
            LabelFrame.BackgroundTransparency = 1

            local Label = Instance.new("TextLabel", LabelFrame)
            Label.Text = Text or "Label"
            Label.Font = Enum.Font.Gotham
            Label.TextColor3 = WazureV3.CurrentTheme.Text
            Label.TextSize = 14
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.BackgroundTransparency = 1
        end

        function Items:MakeButton(Name, ButtonConfig)
            local ButtonConfig = ButtonConfig or {}
            local Button = Instance.new("Frame", ScrollLayers)
            Button.Size = UDim2.new(1, -10, 0, 40)
            Button.BackgroundColor3 = WazureV3.CurrentTheme.Secondary
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)

            local ButtonText = Instance.new("TextButton", Button)
            ButtonText.Size = UDim2.new(1, -50, 1, 0)
            ButtonText.Position = UDim2.new(0, 10, 0, 0)
            ButtonText.Text = ButtonConfig.Title or Name or "Button"
            ButtonText.Font = Enum.Font.GothamBold
            ButtonText.TextColor3 = WazureV3.CurrentTheme.Text
            ButtonText.TextSize = 14
            ButtonText.BackgroundTransparency = 1

            local ButtonIcon = Instance.new("ImageLabel", Button)
            ButtonIcon.Size = UDim2.new(0, 20, 0, 20)
            ButtonIcon.Position = UDim2.new(1, -30, 0.5, -10)
            ButtonIcon.Image = ButtonConfig.Logo or ""
            ButtonIcon.BackgroundTransparency = 1

            ButtonText.Activated:Connect(function()
                if ButtonConfig.Callback then ButtonConfig.Callback() end
            end)

            AddTooltip(Button, ButtonConfig.Content or "Button Description")
        end

        function Items:MakeTextInput(Name, InputConfig)
            local InputConfig = InputConfig or {}
            local Input = Instance.new("Frame", ScrollLayers)
            Input.Size = UDim2.new(1, -10, 0, 50)
            Input.BackgroundColor3 = WazureV3.CurrentTheme.Secondary
            Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", Input)
            Title.Text = InputConfig.Title or Name or "Input"
            Title.Font = Enum.Font.GothamBold
            Title.TextColor3 = WazureV3.CurrentTheme.Text
            Title.TextSize = 14
            Title.Position = UDim2.new(0, 10, 0, 5)
            Title.Size = UDim2.new(1, -10, 0, 20)
            Title.BackgroundTransparency = 1

            local TextBox = Instance.new("TextBox", Input)
            TextBox.Size = UDim2.new(1, -20, 0, 20)
            TextBox.Position = UDim2.new(0, 10, 0, 25)
            TextBox.BackgroundColor3 = WazureV3.CurrentTheme.Primary
            TextBox.Text = ""
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextColor3 = WazureV3.CurrentTheme.Text
            TextBox.TextSize = 12
            TextBox.ClearTextOnFocus = false
            Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)

            TextBox.FocusLost:Connect(function()
                if InputConfig.Callback then InputConfig.Callback(TextBox.Text) end
            end)

            AddTooltip(Input, InputConfig.Content or "Input Description")
            return {Value = function() return TextBox.Text end}
        end

        function Items:MakeToggle(Name, ToggleConfig)
            ToggleConfig = ToggleConfig or {}
            local Toggle = Instance.new("Frame", ScrollLayers)
            Toggle.Size = UDim2.new(1, -10, 0, 50)
            Toggle.BackgroundColor3 = WazureV3.CurrentTheme.Secondary
            Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", Toggle)
            Title.Text = ToggleConfig.Title or Name or "Toggle"
            Title.Font = Enum.Font.GothamBold
            Title.TextColor3 = WazureV3.CurrentTheme.Text
            Title.TextSize = 14
            Title.Position = UDim2.new(0, 10, 0, 5)
            Title.Size = UDim2.new(1, -60, 0, 20)
            Title.BackgroundTransparency = 1

            local Switch = Instance.new("Frame", Toggle)
            Switch.Size = UDim2.new(0, 40, 0, 20)
            Switch.Position = UDim2.new(1, -45, 0.5, 0)
            Switch.AnchorPoint = Vector2.new(1, 0.5)
            Switch.BackgroundColor3 = WazureV3.CurrentTheme.Primary
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

            local Knob = Instance.new("Frame", Switch)
            Knob.Size = UDim2.new(0, 16, 0, 16)
            Knob.Position = ToggleConfig.Default and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            Knob.AnchorPoint = Vector2.new(0, 0.5)
            Knob.BackgroundColor3 = ToggleConfig.Default and WazureV3.CurrentTheme.Accent or WazureV3.CurrentTheme.Primary
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            local ToggleFunc = {Value = ToggleConfig.Default or false}
            local function UpdateToggle(value)
                ToggleFunc.Value = value
                TweenService:Create(Knob, TweenInfo.new(0.2), {
                    Position = value and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                    BackgroundColor3 = value and WazureV3.CurrentTheme.Accent or WazureV3.CurrentTheme.Primary
                }):Play()
                if ToggleConfig.Callback then ToggleConfig.Callback(value) end
            end

            Toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    UpdateToggle(not ToggleFunc.Value)
                end
            end)

            AddTooltip(Toggle, ToggleConfig.Content or "Toggle Description")

            function ToggleFunc:AddSetting()
                local SettingFrame = Instance.new("Frame", ScrollLayers)
                SettingFrame.Size = UDim2.new(1, -20, 0, 0)
                SettingFrame.Position = UDim2.new(0, 10, 0, 0)
                SettingFrame.BackgroundColor3 = WazureV3.CurrentTheme.Primary
                SettingFrame.Visible = false
                Instance.new("UICorner", SettingFrame).CornerRadius = UDim.new(0, 4)

                local SettingList = Instance.new("UIListLayout", SettingFrame)
                SettingList.Padding = UDim.new(0, 5)

                local SettingFunc = {}
                function SettingFunc:Toggle(Name, Config)
                    local Config = Config or {}
                    local SubToggle = Instance.new("Frame", SettingFrame)
                    SubToggle.Size = UDim2.new(1, -10, 0, 30)
                    SubToggle.BackgroundColor3 = WazureV3.CurrentTheme.Secondary
                    Instance.new("UICorner", SubToggle).CornerRadius = UDim.new(0, 4)

                    local SubTitle = Instance.new("TextLabel", SubToggle)
                    SubTitle.Text = Config.Name or Name or "Sub Toggle"
                    SubTitle.Font = Enum.Font.Gotham
                    SubTitle.TextColor3 = WazureV3.CurrentTheme.Text
                    SubTitle.TextSize = 12
                    SubTitle.Position = UDim2.new(0, 10, 0, 5)
                    SubTitle.Size = UDim2.new(1, -60, 0, 20)
                    SubTitle.BackgroundTransparency = 1

                    local SubSwitch = Instance.new("Frame", SubToggle)
                    SubSwitch.Size = UDim2.new(0, 30, 0, 15)
                    SubSwitch.Position = UDim2.new(1, -40, 0.5, 0)
                    SubSwitch.AnchorPoint = Vector2.new(1, 0.5)
                    SubSwitch.BackgroundColor3 = WazureV3.CurrentTheme.Primary
                    Instance.new("UICorner", SubSwitch).CornerRadius = UDim.new(1, 0)

                    local SubKnob = Instance.new("Frame", SubSwitch)
                    SubKnob.Size = UDim2.new(0, 12, 0, 12)
                    SubKnob.Position = Config.Default and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                    SubKnob.AnchorPoint = Vector2.new(0, 0.5)
                    SubKnob.BackgroundColor3 = Config.Default and WazureV3.CurrentTheme.Accent or WazureV3.CurrentTheme.Primary
                    Instance.new("UICorner", SubKnob).CornerRadius = UDim.new(1, 0)

                    local SubToggleFunc = {Value = Config.Default or false}
                    local function UpdateSubToggle(value)
                        SubToggleFunc.Value = value
                        TweenService:Create(SubKnob, TweenInfo.new(0.2), {
                            Position = value and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                            BackgroundColor3 = value and WazureV3.CurrentTheme.Accent or WazureV3.CurrentTheme.Primary
                        }):Play()
                        if Config.Callback then Config.Callback(value) end
                    end

                    SubToggle.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            UpdateSubToggle(not SubToggleFunc.Value)
                        end
                    end)

                    SettingFrame.Size = UDim2.new(1, -20, 0, SettingList.AbsoluteContentSize.Y + 10)
                    SettingFrame.Visible = ToggleFunc.Value
                    return SubToggleFunc
                end

                function SettingFunc:Slider(Name, Config)
                    local Config = Config or {}
                    local SubSlider = Instance.new("Frame", SettingFrame)
                    SubSlider.Size = UDim2.new(1, -10, 0, 40)
                    SubSlider.BackgroundColor3 = WazureV3.CurrentTheme.Secondary
                    Instance.new("UICorner", SubSlider).CornerRadius = UDim.new(0, 4)

                    local SubTitle = Instance.new("TextLabel", SubSlider)
                    SubTitle.Text = Config.Name or Name or "Sub Slider"
                    SubTitle.Font = Enum.Font.Gotham
                    SubTitle.TextColor3 = WazureV3.CurrentTheme.Text
                    SubTitle.TextSize = 12
                    SubTitle.Position = UDim2.new(0, 10, 0, 5)
                    SubTitle.Size = UDim2.new(1, -10, 0, 15)
                    SubTitle.BackgroundTransparency = 1

                    local Bar = Instance.new("Frame", SubSlider)
                    Bar.Size = UDim2.new(1, -20, 0, 4)
                    Bar.Position = UDim2.new(0, 10, 0, 25)
                    Bar.BackgroundColor3 = WazureV3.CurrentTheme.Primary
                    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

                    local Fill = Instance.new("Frame", Bar)
                    Fill.Size = UDim2.new((Config.Default or 0) / (Config.Max or 100), 0, 1, 0)
                    Fill.BackgroundColor3 = WazureV3.CurrentTheme.Accent
                    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

                    local SliderFunc = {Value = Config.Default or 0}
                    local Dragging = false

                    local function UpdateSlider(input)
                        local SizeScale = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        local Value = Config.Min + ((Config.Max - Config.Min) * SizeScale)
                        Value = math.floor(Value / (Config.Increment or 1) + 0.5) * (Config.Increment or 1)
                        SliderFunc.Value = math.clamp(Value, Config.Min or 0, Config.Max or 100)
                        TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(SliderFunc.Value / (Config.Max or 100), 0, 1, 0)}):Play()
                        if Config.Callback then Config.Callback(SliderFunc.Value) end
                    end

                    SubSlider.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true end
                    end)

                    SubSlider.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
                    end)

                    UserInputService.InputChanged:Connect(function(input)
                        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider(input) end
                    end)

                    SettingFrame.Size = UDim2.new(1, -20, 0, SettingList.AbsoluteContentSize.Y + 10)
                    SettingFrame.Visible = ToggleFunc.Value
                    return SliderFunc
                end

                Toggle:GetPropertyChangedSignal("Visible"):Connect(function()
                    SettingFrame.Visible = ToggleFunc.Value
                end)

                return SettingFunc
            end

            UpdateToggle(ToggleFunc.Value)
            return ToggleFunc
        end

        function Items:MakeSlider(Name, SliderConfig)
            SliderConfig = SliderConfig or {}
            local Slider = Instance.new("Frame", ScrollLayers)
            Slider.Size = UDim2.new(1, -10, 0, 60)
            Slider.BackgroundColor3 = WazureV3.CurrentTheme.Secondary
            Instance.new("UICorner", Slider).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", Slider)
            Title.Text = SliderConfig.Title or Name or "Slider"
            Title.Font = Enum.Font.GothamBold
            Title.TextColor3 = WazureV3.CurrentTheme.Text
            Title.TextSize = 14
            Title.Position = UDim2.new(0, 10, 0, 5)
            Title.Size = UDim2.new(1, -10, 0, 20)
            Title.BackgroundTransparency = 1

            local Bar = Instance.new("Frame", Slider)
            Bar.Size = UDim2.new(1, -20, 0, 4)
            Bar.Position = UDim2.new(0, 10, 0, 35)
            Bar.BackgroundColor3 = WazureV3.CurrentTheme.Primary
            Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((SliderConfig.Default or 0) / (SliderConfig.Max or 100), 0, 1, 0)
            Fill.BackgroundColor3 = WazureV3.CurrentTheme.Accent
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            local SliderFunc = {Value = SliderConfig.Default or 0}
            local Dragging = false

            local function UpdateSlider(input)
                local SizeScale = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local Value = SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale)
                Value = math.floor(Value / (SliderConfig.Increment or 1) + 0.5) * (SliderConfig.Increment or 1)
                SliderFunc.Value = math.clamp(Value, SliderConfig.Min or 0, SliderConfig.Max or 100)
                TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(SliderFunc.Value / (SliderConfig.Max or 100), 0, 1, 0)}):Play()
                if SliderConfig.Callback then SliderConfig.Callback(SliderFunc.Value) end
            end

            Slider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true end
            end)

            Slider.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider(input) end
            end)

            AddTooltip(Slider, SliderConfig.Content or "Slider Description")
            return SliderFunc
        end

        function Items:MakeDropdown(Name, DropdownConfig)
            DropdownConfig = DropdownConfig or {}
            local Dropdown = Instance.new("Frame", ScrollLayers)
            Dropdown.Size = UDim2.new(1, -10, 0, 40)
            Dropdown.BackgroundColor3 = WazureV3.CurrentTheme.Secondary
            Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 4)

            local Title = Instance.new("TextLabel", Dropdown)
            Title.Text = DropdownConfig.Title or Name or "Dropdown"
            Title.Font = Enum.Font.GothamBold
            Title.TextColor3 = WazureV3.CurrentTheme.Text
            Title.TextSize = 14
            Title.Position = UDim2.new(0, 10, 0, 5)
            Title.Size = UDim2.new(1, -40, 0, 20)
            Title.BackgroundTransparency = 1

            local DropFrame = Instance.new("Frame", Dropdown)
            DropFrame.Size = UDim2.new(0, 0, 0, 100)
            DropFrame.Position = UDim2.new(0, 10, 0, 40)
            DropFrame.BackgroundColor3 = WazureV3.CurrentTheme.Primary
            DropFrame.Visible = false
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 4)

            local ScrollDrop = Instance.new("ScrollingFrame", DropFrame)
            ScrollDrop.Size = UDim2.new(1, -10, 1, -10)
            ScrollDrop.Position = UDim2.new(0, 5, 0, 5)
            ScrollDrop.BackgroundTransparency = 1
            ScrollDrop.ScrollBarThickness = 2
            local DropList = Instance.new("UIListLayout", ScrollDrop)
            DropList.Padding = UDim.new(0, 5)

            local DropdownFunc = {Value = DropdownConfig.Default or {}, Options = DropdownConfig.Options or {}}
            local Open = false

            local function ToggleDropdown()
                Open = not Open
                TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = Open and UDim2.new(1, -20, 0, 100) or UDim2.new(0, 0, 0, 100)}):Play()
                DropFrame.Visible = true
                task.delay(0.2, function() if not Open then DropFrame.Visible = false end end)
            end

            Dropdown.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then ToggleDropdown() end
            end)

            for _, option in ipairs(DropdownConfig.Options or {}) do
                local OptionButton = Instance.new("TextButton", ScrollDrop)
                OptionButton.Size = UDim2.new(1, 0, 0, 25)
                OptionButton.BackgroundColor3 = WazureV3.CurrentTheme.Secondary
                OptionButton.Text = option
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.TextColor3 = WazureV3.CurrentTheme.Text
                OptionButton.TextSize = 12
                Instance.new("UICorner", OptionButton).CornerRadius = UDim.new(0, 4)

                OptionButton.Activated:Connect(function()
                    if DropdownConfig.Multi then
                        if table.find(DropdownFunc.Value, option) then
                            table.remove(DropdownFunc.Value, table.find(DropdownFunc.Value, option))
                        else
                            table.insert(DropdownFunc.Value, option)
                        end
                    else
                        DropdownFunc.Value = {option}
                        ToggleDropdown()
                    end
                    if DropdownConfig.Callback then DropdownConfig.Callback(DropdownConfig.Multi and DropdownFunc.Value or DropdownFunc.Value[1]) end
                end)
            end

            AddTooltip(Dropdown, DropdownConfig.Content or "Dropdown Description")
            return DropdownFunc
        end

        return Items
    end

    CloseButton.Activated:Connect(function()
        AzuGui:Destroy()
        if GuiConfig.CloseCallBack then GuiConfig.CloseCallBack() end
    end)

    return TabFunctions
end

return WazureV3