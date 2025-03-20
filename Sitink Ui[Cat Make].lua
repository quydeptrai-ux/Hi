local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")

local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition
    local function UpdatePos(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        local Tween = TweenService:Create(object, TweenInfo.new(0.2), {Position = pos})
        Tween:Play()
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            UpdatePos(input)
        end
    end)
end

local function AutoUp(Scroll)
    local function UpSize()
        local OffsetY = 0
        for _, child in Scroll:GetChildren() do
            if child.Name ~= "UIListLayout" then
                OffsetY = OffsetY + Scroll.UIListLayout.Padding.Offset + child.Size.Y.Offset
            end
        end
        Scroll.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
    end
    Scroll.ChildAdded:Connect(UpSize)
    Scroll.ChildRemoved:Connect(UpSize)
    UpSize()
end

local function EnterMouse(frame)
    local oldColor = frame.BackgroundColor3
    local oldTrans = frame.BackgroundTransparency
    frame.MouseEnter:Connect(function()
        if oldColor == Color3.fromRGB(255, 255, 255) then
            TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = oldTrans - 0.035}):Play()
        else
            TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB((oldColor.R * 255) + 8, (oldColor.G * 255) + 8, (oldColor.B * 255) + 8)}):Play()
        end
    end)
    frame.MouseLeave:Connect(function()
        if oldColor == Color3.fromRGB(255, 255, 255) then
            TweenService:Create(frame, TweenInfo.new(0.15), {BackgroundTransparency = oldTrans}):Play()
        else
            TweenService:Create(frame, TweenInfo.new(0.15), {BackgroundColor3 = oldColor}):Play()
        end
    end)
end

local sitinklib = {}

function sitinklib:Notify(NotifyConfig)
    NotifyConfig = NotifyConfig or {}
    NotifyConfig.Title = NotifyConfig.Title or "Notification"
    NotifyConfig.Description = NotifyConfig.Description or ""
    NotifyConfig.Content = NotifyConfig.Content or ""
    NotifyConfig.Color = NotifyConfig.Color or Color3.fromRGB(127, 146, 242)
    NotifyConfig.Icon = NotifyConfig.Icon or "rbxassetid://18243105495"
    NotifyConfig.Time = NotifyConfig.Time or 0.5
    NotifyConfig.Delay = NotifyConfig.Delay or 5

    spawn(function()
        local NotifyGui = CoreGui:FindFirstChild("NotifyGui") or Instance.new("ScreenGui")
        NotifyGui.Name = "NotifyGui"
        NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        NotifyGui.Parent = CoreGui

        local NotifyLayout = NotifyGui:FindFirstChild("NotifyLayout") or Instance.new("Frame")
        NotifyLayout.AnchorPoint = Vector2.new(1, 1)
        NotifyLayout.BackgroundTransparency = 1
        NotifyLayout.Position = UDim2.new(1, -30, 1, -30)
        NotifyLayout.Size = UDim2.new(0, 300, 1, -30)
        NotifyLayout.Name = "NotifyLayout"
        NotifyLayout.Parent = NotifyGui

        local NotifyFrame = Instance.new("Frame")
        local NotifyFrameReal = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local NotifyIcon = Instance.new("ImageLabel")
        local NotifyTitle = Instance.new("TextLabel")
        local NotifyDescription = Instance.new("TextLabel")
        local NotifyContent = Instance.new("TextLabel")
        local NotifyClose = Instance.new("TextButton")

        NotifyFrame.AnchorPoint = Vector2.new(0, 1)
        NotifyFrame.BackgroundTransparency = 1
        NotifyFrame.Position = UDim2.new(0, 0, 1, 0)
        NotifyFrame.Size = UDim2.new(1, 0, 0, 65)
        NotifyFrame.Parent = NotifyLayout

        NotifyFrameReal.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        NotifyFrameReal.Position = UDim2.new(0, 330, 0, 0)
        NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
        NotifyFrameReal.Parent = NotifyFrame

        UICorner.CornerRadius = UDim.new(0, 5)
        UICorner.Parent = NotifyFrameReal

        NotifyIcon.Image = NotifyConfig.Icon
        NotifyIcon.Size = UDim2.new(0, 24, 0, 24)
        NotifyIcon.Position = UDim2.new(0, 8, 0, 8)
        NotifyIcon.BackgroundTransparency = 1
        NotifyIcon.Parent = NotifyFrameReal

        NotifyTitle.Font = Enum.Font.GothamBold
        NotifyTitle.Text = NotifyConfig.Title
        NotifyTitle.TextColor3 = NotifyConfig.Color
        NotifyTitle.TextSize = 14
        NotifyTitle.Position = UDim2.new(0, 40, 0, 8)
        NotifyTitle.Size = UDim2.new(0, 200, 0, 14)
        NotifyTitle.BackgroundTransparency = 1
        NotifyTitle.Parent = NotifyFrameReal

        NotifyDescription.Font = Enum.Font.Gotham
        NotifyDescription.Text = NotifyConfig.Description
        NotifyDescription.TextColor3 = Color3.fromRGB(230, 230, 230)
        NotifyDescription.TextSize = 12
        NotifyDescription.Position = UDim2.new(0, 40, 0, 24)
        NotifyDescription.Size = UDim2.new(0, 200, 0, 12)
        NotifyDescription.BackgroundTransparency = 1
        NotifyDescription.Parent = NotifyFrameReal

        NotifyContent.Font = Enum.Font.Gotham
        NotifyContent.Text = NotifyConfig.Content
        NotifyContent.TextColor3 = Color3.fromRGB(140, 140, 140)
        NotifyContent.TextSize = 13
        NotifyContent.TextWrapped = true
        NotifyContent.Position = UDim2.new(0, 8, 0, 40)
        NotifyContent.Size = UDim2.new(1, -16, 0, 20)
        NotifyContent.BackgroundTransparency = 1
        NotifyContent.Parent = NotifyFrameReal

        NotifyClose.Text = "X"
        NotifyClose.Font = Enum.Font.GothamBold
        NotifyClose.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotifyClose.TextSize = 14
        NotifyClose.BackgroundTransparency = 1
        NotifyClose.Position = UDim2.new(1, -20, 0, 0)
        NotifyClose.Size = UDim2.new(0, 20, 0, 20)
        NotifyClose.Parent = NotifyFrameReal

        NotifyFrame.Size = UDim2.new(1, 0, 0, NotifyContent.TextBounds.Y + 50)
        TweenService:Create(NotifyFrameReal, TweenInfo.new(NotifyConfig.Time), {Position = UDim2.new(0, 0, 0, 0)}):Play()

        NotifyClose.Activated:Connect(function()
            TweenService:Create(NotifyFrameReal, TweenInfo.new(NotifyConfig.Time), {Position = UDim2.new(0, 330, 0, 0)}):Play()
            task.wait(NotifyConfig.Time)
            NotifyFrame:Destroy()
        end)

        task.wait(NotifyConfig.Delay)
        if NotifyFrame.Parent then
            NotifyClose.Activated:Fire()
        end
    end)
end

function sitinklib:Start(GuiConfig)
    GuiConfig = GuiConfig or {}
    GuiConfig.Name = GuiConfig.Name or "Sitink Hub"
    GuiConfig.Description = GuiConfig.Description or ""
    GuiConfig.InfoColor = GuiConfig.InfoColor or Color3.fromRGB(5, 59, 113)
    GuiConfig.LogoInfo = GuiConfig.LogoInfo or "rbxassetid://18243105495"
    GuiConfig.LogoPlayer = GuiConfig.LogoPlayer or "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
    GuiConfig.NameInfo = GuiConfig.NameInfo or "Sitink Hub Info"
    GuiConfig.NamePlayer = GuiConfig.NamePlayer or LocalPlayer.Name
    GuiConfig.InfoDescription = GuiConfig.InfoDescription or "discord.gg/3Aatp4Nhjp"
    GuiConfig.TabWidth = GuiConfig.TabWidth or 135
    GuiConfig.Color = GuiConfig.Color or Color3.fromRGB(127, 146, 242)
    GuiConfig.CloseCallBack = GuiConfig.CloseCallBack or function() end
    GuiConfig.BackgroundColor = GuiConfig.BackgroundColor or Color3.fromRGB(45, 45, 45)
    GuiConfig.ShadowTransparency = GuiConfig.ShadowTransparency or 0.6

    local SitinkGui = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Top = Instance.new("Frame")
    local TopTitle = Instance.new("TextLabel")
    local TopDescription = Instance.new("TextLabel")
    local CloseButton = Instance.new("TextButton")
    local DropShadowHolder = Instance.new("Frame")
    local DropShadow = Instance.new("ImageLabel")

    SitinkGui.Name = "SitinkGui"
    SitinkGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    SitinkGui.Parent = CoreGui

    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = GuiConfig.BackgroundColor
    Main.Size = UDim2.new(0, 500, 0, 300)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Parent = SitinkGui

    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = Main

    Top.BackgroundTransparency = 1
    Top.Size = UDim2.new(1, 0, 0, 34)
    Top.Parent = Main

    TopTitle.Font = Enum.Font.GothamBold
    TopTitle.Text = GuiConfig.Name
    TopTitle.TextColor3 = GuiConfig.Color
    TopTitle.TextSize = 14
    TopTitle.Position = UDim2.new(0, 12, 0, 10)
    TopTitle.BackgroundTransparency = 1
    TopTitle.Parent = Top

    TopDescription.Font = Enum.Font.GothamBold
    TopDescription.Text = GuiConfig.Description
    TopDescription.TextColor3 = Color3.fromRGB(230, 230, 230)
    TopDescription.TextSize = 14
    TopDescription.Position = UDim2.new(0, TopTitle.TextBounds.X + 16, 0, 10)
    TopDescription.BackgroundTransparency = 1
    TopDescription.Parent = Top

    CloseButton.Text = "X"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 14
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -20, 0, 0)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Parent = Top

    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
    DropShadowHolder.ZIndex = 0
    DropShadowHolder.Parent = Main

    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = GuiConfig.ShadowTransparency
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 47, 1, 47)
    DropShadow.ZIndex = 0
    DropShadow.Parent = DropShadowHolder

    MakeDraggable(Top, Main)

    local function ToggleUI()
        Main.Visible = not Main.Visible
    end

    CloseButton.Activated:Connect(function()
        ToggleUI()
        GuiConfig.CloseCallBack()
    end)

    local LayersTab = Instance.new("Frame")
    local ScrollTab = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")

    LayersTab.BackgroundTransparency = 1
    LayersTab.Position = UDim2.new(0, 10, 0, 34)
    LayersTab.Size = UDim2.new(0, GuiConfig.TabWidth, 1, -44)
    LayersTab.Parent = Main

    ScrollTab.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollTab.ScrollBarThickness = 0
    ScrollTab.BackgroundTransparency = 1
    ScrollTab.Size = UDim2.new(1, 0, 1, 0)
    ScrollTab.Parent = LayersTab

    UIListLayout.Padding = UDim.new(0, 3)
    UIListLayout.Parent = ScrollTab

    AutoUp(ScrollTab)

    local Layers = Instance.new("Frame")
    local RealLayers = Instance.new("Frame")
    local LayersFolder = Instance.new("Folder")
    local UIPageLayout = Instance.new("UIPageLayout")

    Layers.BackgroundTransparency = 1
    Layers.Position = UDim2.new(0, GuiConfig.TabWidth + 18, 0, 34)
    Layers.Size = UDim2.new(1, -(GuiConfig.TabWidth + 26), 1, -44)
    Layers.Parent = Main

    RealLayers.BackgroundTransparency = 1
    RealLayers.ClipsDescendants = true
    RealLayers.Size = UDim2.new(1, 0, 1, 0)
    RealLayers.Parent = Layers

    LayersFolder.Parent = RealLayers

    UIPageLayout.EasingStyle = Enum.EasingStyle.Quad
    UIPageLayout.TweenTime = 0.3
    UIPageLayout.Parent = LayersFolder

    local Tabs = {}
    local CountTab = 0

    function Tabs:MakeTab(NameTab)
        NameTab = NameTab or "Tab"
        local ScrollLayer = Instance.new("ScrollingFrame")
        local UIListLayout1 = Instance.new("UIListLayout")

        ScrollLayer.ScrollBarThickness = 3
        ScrollLayer.BackgroundTransparency = 1
        ScrollLayer.Size = UDim2.new(1, 0, 1, 0)
        ScrollLayer.LayoutOrder = CountTab
        ScrollLayer.Parent = LayersFolder

        UIListLayout1.Padding = UDim.new(0, 4)
        UIListLayout1.Parent = ScrollLayer

        AutoUp(ScrollLayer)

        local Tab = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local TabName = Instance.new("TextLabel")
        local TabButton = Instance.new("TextButton")

        Tab.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        Tab.Size = UDim2.new(1, 0, 0, 25)
        Tab.LayoutOrder = CountTab
        Tab.Parent = ScrollTab

        UICorner.CornerRadius = UDim.new(0, 3)
        UICorner.Parent = Tab

        TabName.Font = Enum.Font.GothamBold
        TabName.Text = NameTab
        TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabName.TextSize = 12
        TabName.Position = UDim2.new(0, 14, 0, 0)
        TabName.Size = UDim2.new(1, -25, 1, 0)
        TabName.BackgroundTransparency = 1
        TabName.Parent = Tab

        TabButton.Text = ""
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, 0, 1, 0)
        TabButton.Parent = Tab

        if CountTab == 0 then
            UIPageLayout:JumpToIndex(0)
            Tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end

        TabButton.Activated:Connect(function()
            if Tab.LayoutOrder ~= UIPageLayout.CurrentPage.LayoutOrder then
                for _, TabFrame in ScrollTab:GetChildren() do
                    if TabFrame.Name ~= "UIListLayout" then
                        TweenService:Create(TabFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}):Play()
                    end
                end
                TweenService:Create(Tab, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
                UIPageLayout:JumpToIndex(Tab.LayoutOrder)
            end
        end)

        local Sections = {}
        local CountSection = 0

        function Sections:Section(SectionConfig)
            SectionConfig = SectionConfig or {}
            SectionConfig.Title = SectionConfig.Title or "Section"
            SectionConfig.Content = SectionConfig.Content or ""

            local Section = Instance.new("Frame")
            local UICorner = Instance.new("UICorner")
            local SectionName = Instance.new("TextLabel")
            local SectionDescription = Instance.new("TextLabel")

            Section.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
            Section.Size = UDim2.new(1, -8, 0, 44)
            Section.LayoutOrder = CountSection
            Section.Parent = ScrollLayer

            UICorner.CornerRadius = UDim.new(0, 3)
            UICorner.Parent = Section

            SectionName.Font = Enum.Font.GothamBold
            SectionName.Text = SectionConfig.Title
            SectionName.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionName.TextSize = 13
            SectionName.Position = UDim2.new(0, 10, 0, 10)
            SectionName.Size = UDim2.new(1, -20, 0, 13)
            SectionName.BackgroundTransparency = 1
            SectionName.Parent = Section

            SectionDescription.Font = Enum.Font.Gotham
            SectionDescription.Text = SectionConfig.Content
            SectionDescription.TextColor3 = Color3.fromRGB(230, 230, 230)
            SectionDescription.TextSize = 11
            SectionDescription.Position = UDim2.new(0, 10, 0, 24)
            SectionDescription.Size = UDim2.new(1, -20, 0, 11)
            SectionDescription.BackgroundTransparency = 1
            SectionDescription.Parent = Section

            local Items = {}
            local CountItem = 0

            function Items:Paragraph(ParagraphConfig)
                ParagraphConfig = ParagraphConfig or {}
                ParagraphConfig.Title = ParagraphConfig.Title or "Paragraph"
                ParagraphConfig.Content = ParagraphConfig.Content or "Content"

                local Paragraph = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local ParagraphTitle = Instance.new("TextLabel")
                local ParagraphContent = Instance.new("TextLabel")

                Paragraph.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
                Paragraph.Size = UDim2.new(1, -8, 0, 50)
                Paragraph.LayoutOrder = CountItem
                Paragraph.Parent = ScrollLayer

                UICorner.CornerRadius = UDim.new(0, 3)
                UICorner.Parent = Paragraph

                ParagraphTitle.Font = Enum.Font.GothamBold
                ParagraphTitle.Text = ParagraphConfig.Title
                ParagraphTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                ParagraphTitle.TextSize = 12
                ParagraphTitle.Position = UDim2.new(0, 10, 0, 10)
                ParagraphTitle.Size = UDim2.new(1, -20, 0, 12)
                ParagraphTitle.BackgroundTransparency = 1
                ParagraphTitle.Parent = Paragraph

                ParagraphContent.Font = Enum.Font.Gotham
                ParagraphContent.Text = ParagraphConfig.Content
                ParagraphContent.TextColor3 = Color3.fromRGB(230, 230, 230)
                ParagraphContent.TextSize = 11
                ParagraphContent.TextWrapped = true
                ParagraphContent.Position = UDim2.new(0, 10, 0, 24)
                ParagraphContent.Size = UDim2.new(1, -20, 0, 20)
                ParagraphContent.BackgroundTransparency = 1
                ParagraphContent.Parent = Paragraph

                local ParagraphFunc = {}
                function ParagraphFunc:Set(config)
                    ParagraphTitle.Text = config.Title or ParagraphTitle.Text
                    ParagraphContent.Text = config.Content or ParagraphContent.Text
                end

                CountItem = CountItem + 1
                return ParagraphFunc
            end

            function Items:Button(ButtonConfig)
                ButtonConfig = ButtonConfig or {}
                ButtonConfig.Title = ButtonConfig.Title or "Button"
                ButtonConfig.Content = ButtonConfig.Content or ""
                ButtonConfig.Callback = ButtonConfig.Callback or function() end

                local Button = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local ButtonTitle = Instance.new("TextLabel")
                local ButtonContent = Instance.new("TextLabel")
                local ButtonButton = Instance.new("TextButton")
                local ClickFrame = Instance.new("Frame")
                local ClickText = Instance.new("TextLabel")

                Button.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
                Button.Size = UDim2.new(1, -8, 0, 44)
                Button.LayoutOrder = CountItem
                Button.Parent = ScrollLayer

                UICorner.CornerRadius = UDim.new(0, 3)
                UICorner.Parent = Button

                ButtonTitle.Font = Enum.Font.GothamBold
                ButtonTitle.Text = ButtonConfig.Title
                ButtonTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                ButtonTitle.TextSize = 12
                ButtonTitle.Position = UDim2.new(0, 10, 0, 10)
                ButtonTitle.Size = UDim2.new(1, -150, 0, 12)
                ButtonTitle.BackgroundTransparency = 1
                ButtonTitle.Parent = Button

                ButtonContent.Font = Enum.Font.Gotham
                ButtonContent.Text = ButtonConfig.Content
                ButtonContent.TextColor3 = Color3.fromRGB(230, 230, 230)
                ButtonContent.TextSize = 11
                ButtonContent.Position = UDim2.new(0, 10, 0, 24)
                ButtonContent.Size = UDim2.new(1, -150, 0, 11)
                ButtonContent.BackgroundTransparency = 1
                ButtonContent.Parent = Button

                ButtonButton.Text = ""
                ButtonButton.BackgroundTransparency = 1
                ButtonButton.Size = UDim2.new(1, 0, 1, 0)
                ButtonButton.Parent = Button

                ClickFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                ClickFrame.AnchorPoint = Vector2.new(1, 0.5)
                ClickFrame.Position = UDim2.new(1, -10, 0.5, 0)
                ClickFrame.Size = UDim2.new(0, 120, 0, 26)
                ClickFrame.Parent = Button

                local ClickUICorner = Instance.new("UICorner")
                ClickUICorner.CornerRadius = UDim.new(0, 3)
                ClickUICorner.Parent = ClickFrame

                ClickText.Font = Enum.Font.GothamBold
                ClickText.Text = "Click"
                ClickText.TextColor3 = Color3.fromRGB(230, 230, 230)
                ClickText.TextSize = 12
                ClickText.Size = UDim2.new(1, 0, 1, 0)
                ClickText.BackgroundTransparency = 1
                ClickText.Parent = ClickFrame

                ButtonButton.Activated:Connect(ButtonConfig.Callback)
                EnterMouse(Button)

                CountItem = CountItem + 1
            end

            function Items:Separator(SeparatorText)
                SeparatorText = SeparatorText or "Separator"

                local Separator = Instance.new("Frame")
                local SeparatorLine = Instance.new("Frame")
                local SeparatorLabel = Instance.new("TextLabel")

                Separator.BackgroundTransparency = 1
                Separator.Size = UDim2.new(1, -8, 0, 20)
                Separator.LayoutOrder = CountItem
                Separator.Parent = ScrollLayer

                SeparatorLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                SeparatorLine.Size = UDim2.new(1, 0, 0, 2)
                SeparatorLine.Position = UDim2.new(0, 0, 0.5, -1)
                SeparatorLine.Parent = Separator

                SeparatorLabel.Font = Enum.Font.GothamBold
                SeparatorLabel.Text = SeparatorText
                SeparatorLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                SeparatorLabel.TextSize = 12
                SeparatorLabel.BackgroundTransparency = 1
                SeparatorLabel.Size = UDim2.new(0, SeparatorLabel.TextBounds.X + 10, 0, 14)
                SeparatorLabel.Position = UDim2.new(0.5, -SeparatorLabel.Size.X.Offset / 2, 0.5, -7)
                SeparatorLabel.Parent = Separator

                CountItem = CountItem + 1
            end

            function Items:Toggle(ToggleConfig)
                ToggleConfig = ToggleConfig or {}
                ToggleConfig.Title = ToggleConfig.Title or "Toggle"
                ToggleConfig.Content = ToggleConfig.Content or ""
                ToggleConfig.Default = ToggleConfig.Default or false
                ToggleConfig.Callback = ToggleConfig.Callback or function() end

                local ToggleFunc = {Value = ToggleConfig.Default}

                local Toggle = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local ToggleTitle = Instance.new("TextLabel")
                local ToggleContent = Instance.new("TextLabel")
                local ToggleSwitch = Instance.new("Frame")
                local ToggleSwitchInner = Instance.new("Frame")
                local ToggleButton = Instance.new("TextButton")

                Toggle.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
                Toggle.Size = UDim2.new(1, -8, 0, 44)
                Toggle.LayoutOrder = CountItem
                Toggle.Parent = ScrollLayer

                UICorner.CornerRadius = UDim.new(0, 3)
                UICorner.Parent = Toggle

                ToggleTitle.Font = Enum.Font.GothamBold
                ToggleTitle.Text = ToggleConfig.Title
                ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleTitle.TextSize = 12
                ToggleTitle.Position = UDim2.new(0, 10, 0, 10)
                ToggleTitle.Size = UDim2.new(1, -70, 0, 12)
                ToggleTitle.BackgroundTransparency = 1
                ToggleTitle.Parent = Toggle

                ToggleContent.Font = Enum.Font.Gotham
                ToggleContent.Text = ToggleConfig.Content
                ToggleContent.TextColor3 = Color3.fromRGB(230, 230, 230)
                ToggleContent.TextSize = 11
                ToggleContent.Position = UDim2.new(0, 10, 0, 24)
                ToggleContent.Size = UDim2.new(1, -70, 0, 11)
                ToggleContent.BackgroundTransparency = 1
                ToggleContent.Parent = Toggle

                ToggleSwitch.BackgroundColor3 = ToggleConfig.Default and GuiConfig.Color or Color3.fromRGB(230, 230, 230)
                ToggleSwitch.AnchorPoint = Vector2.new(1, 0.5)
                ToggleSwitch.Position = UDim2.new(1, -10, 0.5, 0)
                ToggleSwitch.Size = UDim2.new(0, 40, 0, 18)
                ToggleSwitch.Parent = Toggle

                local SwitchUICorner = Instance.new("UICorner")
                SwitchUICorner.CornerRadius = UDim.new(1, 0)
                SwitchUICorner.Parent = ToggleSwitch

                ToggleSwitchInner.BackgroundColor3 = ToggleConfig.Default and GuiConfig.Color or Color3.fromRGB(40, 40, 40)
                ToggleSwitchInner .Position = UDim2.new(0, 1, 0, 1)
                ToggleSwitchInner .Size = UDim2.new(1, -2, 1, -2)
                ToggleSwitchInner .Parent = ToggleSwitch

                local InnerUICorner = Instance.new("UICorner")
                InnerUICorner.CornerRadius = UDim.new(1, 0)
                InnerUICorner.Parent = ToggleSwitchInner

                local SwitchImage = Instance.new("ImageLabel")
                SwitchImage.Image = "rbxassetid://3926305904"
                SwitchImage.ImageRectOffset = Vector2.new(124, 124)
                SwitchImage.ImageRectSize = Vector2.new(36, 36)
                SwitchImage.BackgroundTransparency = 1
                SwitchImage.Position = ToggleConfig.Default and UDim2.new(0, 22, 0, 0) or U FAILED TO GENERATE CODE COMPLETELY HERE DUE TO LENGTH LIMITATIONS IN ONE RESPONSE

---

### Tiếp tục sau khi bị cắt
Do giới hạn ký tự, tôi sẽ tiếp tục phần còn lại trong phản hồi tiếp theo. Dưới đây là phần tiếp tục của `Toggle` và các thành phần còn lại:

```lua
                SwitchImage.Size = UDim2.new(0, 16, 0, 16)
                SwitchImage.Parent = ToggleSwitchInner

                ToggleButton.Text = ""
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                ToggleButton.Parent = Toggle

                function ToggleFunc:Set(Value)
                    ToggleFunc.Value = Value
                    TweenService:Create(ToggleSwitch, TweenInfo.new(0.2), {BackgroundColor3 = Value and GuiConfig.Color or Color3.fromRGB(230, 230, 230)}):Play()
                    TweenService:Create(ToggleSwitchInner, TweenInfo.new(0.2), {BackgroundColor3 = Value and GuiConfig.Color or Color3.fromRGB(40, 40, 40)}):Play()
                    TweenService:Create(SwitchImage, TweenInfo.new(0.2), {Position = Value and UDim2.new(0, 22, 0, 0) or UDim2.new(0, 0, 0, 0)}):Play()
                    ToggleConfig.Callback(Value)
                end

                ToggleButton.Activated:Connect(function()
                    ToggleFunc:Set(not ToggleFunc.Value)
                end)

                EnterMouse(Toggle)
                CountItem = CountItem + 1
                return ToggleFunc
            end

            function Items:Slider(SliderConfig)
                SliderConfig = SliderConfig or {}
                SliderConfig.Title = SliderConfig.Title or "Slider"
                SliderConfig.Content = SliderConfig.Content or ""
                SliderConfig.Min = SliderConfig.Min or 0
                SliderConfig.Max = SliderConfig.Max or 100
                SliderConfig.Increment = SliderConfig.Increment or 1
                SliderConfig.Default = SliderConfig.Default or SliderConfig.Min
                SliderConfig.Callback = SliderConfig.Callback or function() end

                local SliderFunc = {Value = SliderConfig.Default}

                local Slider = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local SliderTitle = Instance.new("TextLabel")
                local SliderContent = Instance.new("TextLabel")
                local SliderFrame = Instance.new("Frame")
                local SliderDrag = Instance.new("Frame")
                local SliderNumber = Instance.new("TextLabel")

                Slider.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
                Slider.Size = UDim2.new(1, -8, 0, 50)
                Slider.LayoutOrder = CountItem
                Slider.Parent = ScrollLayer

                UICorner.CornerRadius = UDim.new(0, 3)
                UICorner.Parent = Slider

                SliderTitle.Font = Enum.Font.GothamBold
                SliderTitle.Text = SliderConfig.Title
                SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderTitle.TextSize = 12
                SliderTitle.Position = UDim2.new(0, 10, 0, 10)
                SliderTitle.Size = UDim2.new(1, -150, 0, 12)
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Parent = Slider

                SliderContent.Font = Enum.Font.Gotham
                SliderContent.Text = SliderConfig.Content
                SliderContent.TextColor3 = Color3.fromRGB(230, 230, 230)
                SliderContent.TextSize = 11
                SliderContent.Position = UDim2.new(0, 10, 0, 24)
                SliderContent.Size = UDim2.new(1, -150, 0, 11)
                SliderContent.BackgroundTransparency = 1
                SliderContent.Parent = Slider

                SliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderFrame.BackgroundTransparency = 0.8
                SliderFrame.AnchorPoint = Vector2.new(1, 0.5)
                SliderFrame.Position = UDim2.new(1, -10, 0.5, 0)
                SliderFrame rainbowSize = UDim2.new(0, 100, 0, 2)
                SliderFrame.Parent = Slider

                local SliderFrameUICorner = Instance.new("UICorner")
                SliderFrameUICorner.CornerRadius = UDim.new(0, 3)
                SliderFrameUICorner.Parent = SliderFrame

                SliderDrag.BackgroundColor3 = GuiConfig.Color
                SliderDrag.AnchorPoint = Vector2.new(0, 0.5)
                SliderDrag.Position = UDim2.new(0, 0, 0.5, 0)
                SliderDrag.Size = UDim2.fromScale((SliderConfig.Default - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 1)
                SliderDrag.Parent = SliderFrame

                local DragUICorner = Instance.new("UICorner")
                DragUICorner.CornerRadius = UDim.new(0, 3)
                DragUICorner.Parent = SliderDrag

                SliderNumber.Font = Enum.Font.GothamBold
                SliderNumber.Text = tostring(SliderConfig.Default)
                SliderNumber.TextColor3 = Color3.fromRGB(230, 230, 230)
                SliderNumber.TextSize = 12
                SliderNumber.AnchorPoint = Vector2.new(1, 0.5)
                SliderNumber.Position = UDim2.new(1, -120, 0.5, 0)
                SliderNumber.Size = UDim2.new(0, 40, 0, 13)
                SliderNumber.BackgroundTransparency = 1
                SliderNumber.Parent = Slider

                local Dragging = false
                local function Round(Number, Factor)
                    local Result = math.floor(Number / Factor + (math.sign(Number) * 0.5)) * Factor
                    return math.clamp(Result, SliderConfig.Min, SliderConfig.Max)
                end

                function SliderFunc:Set(Value)
                    Value = Round(Value, SliderConfig.Increment)
                    SliderFunc.Value = Value
                    SliderNumber.Text = tostring(Value)
                    TweenService:Create(SliderDrag, TweenInfo.new(0.3), {Size = UDim2.fromScale((Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 1)}):Play()
                    SliderConfig.Callback(Value)
                end

                SliderFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = true
                    end
                end)

                SliderFrame.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local SizeScale = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
                        SliderFunc:Set(SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale))
                    end
                end)

                SliderFunc:Set(SliderFunc.Value)
                CountItem = CountItem + 1
                return SliderFunc
            end

            function Items:Dropdown(DropdownConfig)
                DropdownConfig = DropdownConfig or {}
                DropdownConfig.Title = DropdownConfig.Title or "Dropdown"
                DropdownConfig.Multi = DropdownConfig.Multi or false
                DropdownConfig.Options = DropdownConfig.Options or {}
                DropdownConfig.Default = DropdownConfig.Default or (DropdownConfig.Multi and {} or DropdownConfig.Options[1])
                DropdownConfig.PlaceHolderText = DropdownConfig.PlaceHolderText or "Select Option"
                DropdownConfig.Callback = DropdownConfig.Callback or function() end

                local DropdownFunc = {Value = DropdownConfig.Default, Options = DropdownConfig.Options}

                local Dropdown = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local DropdownTitle = Instance.new("TextLabel")
                local DropdownFrame = Instance.new("Frame")
                local DropdownBox = Instance.new("TextBox")
                local DropdownButton = Instance.new("TextButton")
                local DropdownUnder = Instance.new("Frame")
                local ScrollUnder = Instance.new("ScrollingFrame")
                local UIListLayout2 = Instance.new("UIListLayout")

                Dropdown.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
                Dropdown.ClipsDescendants = true
                Dropdown.Size = UDim2.new(1, -8, 0, 44)
                Dropdown.LayoutOrder = CountItem
                Dropdown.Parent = ScrollLayer

                UICorner.CornerRadius = UDim.new(0, 3)
                UICorner.Parent = Dropdown

                DropdownTitle.Font = Enum.Font.GothamBold
                DropdownTitle.Text = DropdownConfig.Title
                DropdownTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                DropdownTitle.TextSize = 12
                DropdownTitle.Position = UDim2.new(0, 10, 0, 6)
                DropdownTitle.Size = UDim2.new(1, -20, 0, 12)
                DropdownTitle.BackgroundTransparency = 1
                DropdownTitle.Parent = Dropdown

                DropdownFrame.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
                DropdownFrame.Position = UDim2.new(0, 8, 0, 20)
                DropdownFrame.Size = UDim2.new(1, -16, 0, 18)
                DropdownFrame.Parent = Dropdown

                local FrameUICorner = Instance.new("UICorner")
                FrameUICorner.CornerRadius = UDim.new(0, 3)
                FrameUICorner.Parent = DropdownFrame

                DropdownBox.Font = Enum.Font.GothamBold
                DropdownBox.PlaceholderText = DropdownConfig.PlaceHolderText
                DropdownBox.Text = DropdownConfig.Multi and table.concat(DropdownConfig.Default, ", ") or DropdownConfig.Default
                DropdownBox.TextColor3 = Color3.fromRGB(230, 230, 230)
                DropdownBox.TextSize = 12
                DropdownBox.Position = UDim2.new(0, 5, 0, 0)
                DropdownBox.Size = UDim2.new(1, -24, 1, 0)
                DropdownBox.BackgroundTransparency = 1
                DropdownBox.Parent = DropdownFrame

                DropdownButton.Text = ""
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Size = UDim2.new(1, 0, 1, 0)
                DropdownButton.Parent = Dropdown

                DropdownUnder.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
                DropdownUnder.ClipsDescendants = true
                DropdownUnder.Position = UDim2.new(0, 8, 0, 40)
                DropdownUnder.Size = UDim2.new(1, -16, 0, 0)
                DropdownUnder.Parent = Dropdown

                local UnderUICorner = Instance.new("UICorner")
                UnderUICorner.CornerRadius = UDim.new(0, 3)
                UnderUICorner.Parent = DropdownUnder

                ScrollUnder.ScrollBarThickness = 0
                ScrollUnder.BackgroundTransparency = 1
                ScrollUnder.Size = UDim2.new(1, -10, 1, -10)
                ScrollUnder.Position = UDim2.new(0.5, 0, 0.5, 0)
                ScrollUnder.AnchorPoint = Vector2.new(0.5, 0.5)
                ScrollUnder.Parent = DropdownUnder

                UIListLayout2.Padding = UDim.new(0, 3)
                UIListLayout2.Parent = ScrollUnder

                AutoUp(ScrollUnder)

                function DropdownFunc:Clear()
                    for _, child in ScrollUnder:GetChildren() do
                        if child.Name == "Option" then
                            child:Destroy()
                        end
                    end
                    DropdownFunc.Value = DropdownConfig.Multi and {} or nil
                    DropdownBox.Text = ""
                end

                function DropdownFunc:Add(OptionName)
                    local Option = Instance.new("Frame")
                    local OptionUICorner = Instance.new("UICorner")
                    local OptionText = Instance.new("TextLabel")
                    local OptionButton = Instance.new("TextButton")

                    Option.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
                    Option.Size = UDim2.new(1, 0, 0, 20)
                    Option.Name = "Option"
                    Option.Parent = ScrollUnder

                    OptionUICorner.CornerRadius = UDim.new(0, 3)
                    OptionUICorner.Parent = Option

                    OptionText.Font = Enum.Font.GothamBold
                    OptionText.Text = OptionName
                    OptionText.TextColor3 = Color3.fromRGB(255, 255, 255)
                    OptionText.TextSize = 11
                    OptionText.Position = UDim2.new(0, 14, 0, 0)
                    OptionText.Size = UDim2.new(1, -25, 1, 0)
                    OptionText.BackgroundTransparency = 1
                    OptionText.Parent = Option

                    OptionButton.Text = ""
                    OptionButton.BackgroundTransparency = 1
                    OptionButton.Size = UDim2.new(1, 0, 1, 0)
                    OptionButton.Parent = Option

                    OptionButton.Activated:Connect(function()
                        if DropdownConfig.Multi then
                            if table.find(DropdownFunc.Value, OptionText.Text) then
                                table.remove(DropdownFunc.Value, table.find(DropdownFunc.Value, OptionText.Text))
                            else
                                table.insert(DropdownFunc.Value, OptionText.Text)
                            end
                        else
                            DropdownFunc.Value = OptionText.Text
                            TweenService:Create(Dropdown, TweenInfo.new(0.3), {Size = UDim2.new(1, -8, 0, 44)}):Play()
                        end
                        DropdownBox.Text = DropdownConfig.Multi and table.concat(DropdownFunc.Value, ", ") or DropdownFunc.Value
                        DropdownConfig.Callback(DropdownFunc.Value)
                    end)

                    table.insert(DropdownFunc.Options, OptionName)
                end

                function DropdownFunc:Set(Value)
                    DropdownFunc.Value = Value
                    DropdownBox.Text = DropdownConfig.Multi and table.concat(Value, ", ") or Value
                    DropdownConfig.Callback(Value)
                end

                function DropdownFunc:Refresh(Options, Default)
                    DropdownFunc:Clear()
                    for _, opt in Options do
                        DropdownFunc:Add(opt)
                    end
                    DropdownFunc.Options = Options
                    DropdownFunc:Set(Default or (DropdownConfig.Multi and {} or Options[1]))
                end

                for _, opt in DropdownConfig.Options do
                    DropdownFunc:Add(opt)
                end

                DropdownButton.Activated:Connect(function()
                    local newSize = Dropdown.Size.Y.Offset == 44 and UDim2.new(1, -8, 0, 168) or UDim2.new(1, -8, 0, 44)
                    TweenService:Create(Dropdown, TweenInfo.new(0.3), {Size = newSize}):Play()
                end)

                DropdownBox.Focused:Connect(function()
                    TweenService:Create(Dropdown, TweenInfo.new(0.3), {Size = UDim2.new(1, -8, 0, 168)}):Play()
                end)

                DropdownBox:GetPropertyChangedSignal("Text"):Connect(function()
                    for _, opt in ScrollUnder:GetChildren() do
                        if opt.Name == "Option" then
                            opt.Visible = DropdownBox.Text == "" or string.find(string.lower(opt.OptionText.Text), string.lower(DropdownBox.Text))
                        end
                    end
                end)

                CountItem = CountItem + 1
                return DropdownFunc
            end

            function Items:TextInput(TextInputConfig)
                TextInputConfig = TextInputConfig or {}
                TextInputConfig.Title = TextInputConfig.Title or "Text Input"
                TextInputConfig.Content = TextInputConfig.Content or ""
                TextInputConfig.PlaceHolderText = TextInputConfig.PlaceHolderText or "Enter text..."
                TextInputConfig.Default = TextInputConfig.Default or ""
                TextInputConfig.Callback = TextInputConfig.Callback or function() end

                local TextInputFunc = {Value = TextInputConfig.Default}

                local TextInput = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local TextInputTitle = Instance.new("TextLabel")
                local TextInputContent = Instance.new("TextLabel")
                local InputFrame = Instance.new("Frame")
                local InputBox = Instance.new("TextBox")

                TextInput.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
                TextInput.Size = UDim2.new(1, -8, 0, 44)
                TextInput.LayoutOrder = CountItem
                TextInput.Parent = ScrollLayer

                UICorner.CornerRadius = UDim.new(0, 3)
                UICorner.Parent = TextInput

                TextInputTitle.Font = Enum.Font.GothamBold
                TextInputTitle.Text = TextInputConfig.Title
                TextInputTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextInputTitle.TextSize = 12
                TextInputTitle.Position = UDim2.new(0, 10, 0, 10)
                TextInputTitle.Size = UDim2.new(1, -150, 0, 12)
                TextInputTitle.BackgroundTransparency = 1
                TextInputTitle.Parent = TextInput

                TextInputContent.Font = Enum.Font.Gotham
                TextInputContent.Text = TextInputConfig.Content
                TextInputContent.TextColor3 = Color3.fromRGB(230, 230, 230)
                TextInputContent.TextSize = 11
                TextInputContent.Position = UDim2.new(0, 10, 0, 24)
                TextInputContent.Size = UDim2.new(1, -150, 0, 11)
                TextInputContent.BackgroundTransparency = 1
                TextInputContent.Parent = TextInput

                InputFrame.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
                InputFrame.AnchorPoint = Vector2.new(1, 0.5)
                InputFrame.Position = UDim2.new(1, -10, 0.5, 0)
                InputFrame.Size = UDim2.new(0, 120, 0, 26)
                InputFrame.Parent = TextInput

                local InputUICorner = Instance.new("UICorner")
                InputUICorner.CornerRadius = UDim.new(0, 3)
                InputUICorner.Parent = InputFrame

                InputBox.Font = Enum.Font.GothamBold
                InputBox.Text = TextInputConfig.Default
                InputBox.PlaceholderText = TextInputConfig.PlaceHolderText
                InputBox.TextColor3 = Color3.fromRGB(230, 230, 230)
                InputBox.TextSize = 11
                InputBox.Position = UDim2.new(0, 5, 0, 0)
                InputBox.Size = UDim2.new(1, -10, 1, 0)
                InputBox.BackgroundTransparency = 1
                InputBox.Parent = InputFrame

                function TextInputFunc:Set(Value)
                    InputBox.Text = Value
                    TextInputFunc.Value = Value
                    TextInputConfig.Callback(Value)
                end

                InputBox.FocusLost:Connect(function()
                    TextInputFunc:Set(InputBox.Text)
                end)

                CountItem = CountItem + 1
                return TextInputFunc
            end

            function Items:Keybind(KeybindConfig)
                KeybindConfig = KeybindConfig or {}
                KeybindConfig.Title = KeybindConfig.Title or "Keybind"
                KeybindConfig.Default = KeybindConfig.Default or Enum.KeyCode.Unknown
                KeybindConfig.Callback = KeybindConfig.Callback or function() end

                local KeybindFunc = {Value = KeybindConfig.Default}

                local Keybind = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local KeybindTitle = Instance.new("TextLabel")
                local KeybindButton = Instance.new("TextButton")
                local KeybindText = Instance.new("TextLabel")

                Keybind.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
                Keybind.Size = UDim2.new(1, -8, 0, 44)
                Keybind.LayoutOrder = CountItem
                Keybind.Parent = ScrollLayer

                UICorner.CornerRadius = UDim.new(0, 3)
                UICorner.Parent = Keybind

                KeybindTitle.Font = Enum.Font.GothamBold
                KeybindTitle.Text = KeybindConfig.Title
                KeybindTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                KeybindTitle.TextSize = 12
                KeybindTitle.Position = UDim2.new(0, 10, 0, 10)
                KeybindTitle.Size = UDim2.new(1, -70, 0, 12)
                KeybindTitle.BackgroundTransparency = 1
                KeybindTitle.Parent = Keybind

                KeybindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                KeybindButton.AnchorPoint = Vector2.new(1, 0.5)
                KeybindButton.Position = UDim2.new(1, -10, 0.5, 0)
                KeybindButton.Size = UDim2.new(0, 50, 0, 20)
                KeybindButton.Text = ""
                KeybindButton.Parent = Keybind

                local ButtonUICorner = Instance.new("UICorner")
                ButtonUICorner.CornerRadius = UDim.new(0, 3)
                ButtonUICorner.Parent = KeybindButton

                KeybindText.Font = Enum.Font.GothamBold
                KeybindText.Text = KeybindConfig.Default.Name or "None"
                KeybindText.TextColor3 = Color3.fromRGB(230, 230, 230)
                KeybindText.TextSize = 12
                KeybindText.Size = UDim2.new(1, 0, 1, 0)
                KeybindText.BackgroundTransparency = 1
                KeybindText.Parent = KeybindButton

                local waitingForKey = false
                KeybindButton.Activated:Connect(function()
                    waitingForKey = true
                    KeybindText.Text = "..."
                end)

                UserInputService.InputBegan:Connect(function(input)
                    if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
                        KeybindFunc.Value = input.KeyCode
                        KeybindText.Text = input.KeyCode.Name
                        KeybindConfig.Callback(input.KeyCode)
                        waitingForKey = false
                    end
                end)

                function KeybindFunc:Set(Value)
                    KeybindFunc.Value = Value
                    KeybindText.Text = Value.Name
                    KeybindConfig.Callback(Value)
                end

                CountItem = CountItem + 1
                return KeybindFunc
            end

            function Items:ColorPicker(ColorPickerConfig)
                ColorPickerConfig = ColorPickerConfig or {}
                ColorPickerConfig.Title = ColorPickerConfig.Title or "Color Picker"
                ColorPickerConfig.Default = ColorPickerConfig.Default or Color3.fromRGB(255, 255, 255)
                ColorPickerConfig.Callback = ColorPickerConfig.Callback or function() end

                local ColorPickerFunc = {Value = ColorPickerConfig.Default}

                local ColorPicker = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local ColorPickerTitle = Instance.new("TextLabel")
                local ColorPreview = Instance.new("Frame")
                local ColorButton = Instance.new("TextButton")
                local ColorPickerFrame = Instance.new("Frame")
                local HueSlider = Instance.new("Frame")
                local HueDrag = Instance.new("Frame")
                local SatValFrame = Instance.new("Frame")

                ColorPicker.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
                ColorPicker.ClipsDescendants = true
                ColorPicker.Size = UDim2.new(1, -8, 0, 44)
                ColorPicker.LayoutOrder = CountItem
                ColorPicker.Parent = ScrollLayer

                UICorner.CornerRadius = UDim.new(0, 3)
                UICorner.Parent = ColorPicker

                ColorPickerTitle.Font = Enum.Font.GothamBold
                ColorPickerTitle.Text = ColorPickerConfig.Title
                ColorPickerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                ColorPickerTitle.TextSize = 12
                ColorPickerTitle.Position = UDim2.new(0, 10, 0, 10)
                ColorPickerTitle.Size = UDim2.new(1, -70, 0, 12)
                ColorPickerTitle.BackgroundTransparency = 1
                ColorPickerTitle.Parent = ColorPicker

                ColorPreview.BackgroundColor3 = ColorPickerConfig.Default
                ColorPreview.AnchorPoint = Vector2.new(1, 0.5)
                ColorPreview.Position = UDim2.new(1, -10, 0.5, 0)
                ColorPreview.Size = UDim2.new(0, 30, 0, 20)
                ColorPreview.Parent = ColorPicker

                local PreviewUICorner = Instance.new("UICorner")
                PreviewUICorner.CornerRadius = UDim.new(0, 3)
                PreviewUICorner.Parent = ColorPreview

                ColorButton.Text = ""
                ColorButton.BackgroundTransparency = 1
                ColorButton.Size = UDim2.new(1, 0, 1, 0)
                ColorButton.Parent = ColorPicker

                ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
                ColorPickerFrame.Position = UDim2.new(0, 8, 0, 40)
                ColorPickerFrame.Size = UDim2.new(1, -16, 0, 0)
                ColorPickerFrame.Parent = ColorPicker

                local PickerUICorner = Instance.new("UICorner")
                PickerUICorner.CornerRadius = UDim.new(0, 3)
                PickerUICorner.Parent = ColorPickerFrame

                HueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                HueSlider.Position = UDim2.new(0, 10, 0, 10)
                HueSlider.Size = UDim2.new(0, 20, 0, 100)
                HueSlider.Parent = ColorPickerFrame

                HueDrag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                HueDrag.Size = UDim2.new(1, 0, 0, 2)
                HueDrag.Parent = HueSlider

                SatValFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SatValFrame.Position = UDim2.new(0, 40, 0, 10)
                SatValFrame.Size = UDim2.new(0, 100, 0, 100)
                SatValFrame.Parent = ColorPickerFrame

                local h, s, v = ColorPickerConfig.Default:ToHSV()
                HueDrag.Position = UDim2.new(0, 0, 0, h * 100)

                local function UpdateColor()
                    local hue = HueDrag.Position.Y.Offset / 100
                    local sat = (Mouse.X - SatValFrame.AbsolutePosition.X) / SatValFrame.AbsoluteSize.X
                    local val = 1 - (Mouse.Y - SatValFrame.AbsolutePosition.Y) / SatValFrame.AbsoluteSize.Y
                    sat = math.clamp(sat, 0, 1)
                    val = math.clamp(val, 0, 1)
                    local newColor = Color3.fromHSV(hue, sat, val)
                    ColorPreview.BackgroundColor3 = newColor
                    ColorPickerFunc.Value = newColor
                    ColorPickerConfig.Callback(newColor)
                end

                ColorButton.Activated:Connect(function()
                    local newSize = ColorPicker.Size.Y.Offset == 44 and UDim2.new(1, -8, 0, 160) or UDim2.new(1, -8, 0, 44)
                    TweenService:Create(ColorPicker, TweenInfo.new(0.3), {Size = newSize}):Play()
                end)

                HueSlider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local dragging = true
                        UserInputService.InputChanged:Connect(function(input)
                            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                                local y = math.clamp(input.Position.Y - HueSlider.AbsolutePosition.Y, 0, HueSlider.AbsoluteSize.Y)
                                HueDrag.Position = UDim2.new(0, 0, 0, y)
                                UpdateColor()
                            end
                        end)
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                dragging = false
                            end
                        end)
                    end
                end)

                SatValFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local dragging = true
                        UpdateColor()
                        UserInputService.InputChanged:Connect(function(input)
                            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                                UpdateColor()
                            end
                        end)
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                dragging = false
                            end
                        end)
                    end
                end)

                function ColorPickerFunc:Set(Value)
                    ColorPickerFunc.Value = Value
                    ColorPreview.BackgroundColor3 = Value
                    local h, s, v = Value:ToHSV()
                    HueDrag.Position = UDim2.new(0, 0, 0, h * 100)
                    ColorPickerConfig.Callback(Value)
                end

                CountItem = CountItem + 1
                return ColorPickerFunc
            end

            CountSection = CountSection + 1
            return Items
        end

        CountTab = CountTab + 1
        return Sections
    end

    return Tabs
end

return sitinklib