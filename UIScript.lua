local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = LocalPlayer.PlayerGui

local CatLib = {}

-- Theme mặc định
local Theme = {
    Primary = Color3.fromRGB(0, 170, 255),
    Secondary = Color3.fromRGB(40, 40, 40),
    Background = Color3.fromRGB(20, 20, 20),
    Text = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(200, 200, 200),
    Shadow = Color3.fromRGB(0, 0, 0),
    Success = Color3.fromRGB(100, 255, 100)
}

-- Object Pooling
local ElementPool = {}
local function GetFromPool(className)
    ElementPool[className] = ElementPool[className] or {}
    if #ElementPool[className] > 0 then
        local element = table.remove(ElementPool[className])
        element.Visible = true
        return element
    end
    return Instance.new(className)
end

local function ReturnToPool(element)
    element.Visible = false
    element.Parent = nil
    ElementPool[element.ClassName] = ElementPool[element.ClassName] or {}
    table.insert(ElementPool[element.ClassName], element)
end

-- Hiệu ứng CircleClick
local function CircleClick(Button, X, Y)
    task.spawn(function()
        Button.ClipsDescendants = true
        local Circle = GetFromPool("ImageLabel")
        Circle.Image = "rbxassetid://266543268"
        Circle.ImageColor3 = Theme.Accent
        Circle.BackgroundTransparency = 1
        Circle.ZIndex = 10
        Circle.Parent = Button
        
        local NewX, NewY = X - Circle.AbsolutePosition.X, Y - Circle.AbsolutePosition.Y
        Circle.Position = UDim2.new(0, NewX, 0, NewY)
        local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 1.5
        TweenService:Create(Circle, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {
            Size = UDim2.new(0, Size, 0, Size),
            Position = UDim2.new(0.5, -Size/2, 0.5, -Size/2)
        }):Play()
        task.wait(0.4)
        TweenService:Create(Circle, TweenInfo.new(0.4), {ImageTransparency = 1}):Play()
        task.wait(0.4)
        ReturnToPool(Circle)
    end)
end

-- MakeDraggable và Resizable
local function MakeDraggable(topbar, object)
    local Dragging, DragInput, DragStart, StartPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPos = object.Position
        end
    end)
    topbar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and input == DragInput then
            local Delta = input.Position - DragStart
            TweenService:Create(object, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
            }):Play()
        end
    end)
end

local function MakeResizable(object)
    local Dragging, DragInput, DragStart, StartSize
    local minSizeX, minSizeY = 400, 300
    local ResizeHandle = GetFromPool("Frame")
    ResizeHandle.AnchorPoint = Vector2.new(1, 1)
    ResizeHandle.BackgroundTransparency = 0.9
    ResizeHandle.Position = UDim2.new(1, 0, 1, 0)
    ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
    ResizeHandle.Name = "ResizeHandle"
    ResizeHandle.Parent = object

    local function UpdateSize(input)
        local Delta = input.Position - DragStart
        local newWidth = math.max(StartSize.X.Offset + Delta.X, minSizeX)
        local newHeight = math.max(StartSize.Y.Offset + Delta.Y, minSizeY)
        TweenService:Create(object, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(0, newWidth, 0, newHeight)}):Play()
    end

    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartSize = object.Size
        end
    end)
    ResizeHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and input == DragInput then UpdateSize(input) end
    end)
end

-- Hệ thống thông báo
local NotifyPool = {}
function CatLib:MakeNotify(NotifyConfig)
    NotifyConfig = NotifyConfig or {}
    NotifyConfig.Title = NotifyConfig.Title or "CatLib v0.5"
    NotifyConfig.Description = NotifyConfig.Description or "Notification"
    NotifyConfig.Content = NotifyConfig.Content or "Content"
    NotifyConfig.Color = NotifyConfig.Color or Theme.Primary
    NotifyConfig.Time = NotifyConfig.Time or 0.5
    NotifyConfig.Delay = NotifyConfig.Delay or 5

    local NotifyFunction = {}
    task.spawn(function()
        local NotifyGui = CoreGui:FindFirstChild("NotifyGui") or Instance.new("ScreenGui")
        NotifyGui.Name = "NotifyGui"
        NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        NotifyGui.Parent = CoreGui

        local NotifyLayout = NotifyGui:FindFirstChild("NotifyLayout") or Instance.new("Frame")
        NotifyLayout.AnchorPoint = Vector2.new(1, 1)
        NotifyLayout.BackgroundTransparency = 1
        NotifyLayout.Position = UDim2.new(1, -30, 1, -30)
        NotifyLayout.Size = UDim2.new(0, 320, 1, 0)
        NotifyLayout.Name = "NotifyLayout"
        NotifyLayout.Parent = NotifyGui

        local NotifyFrame = #NotifyPool > 0 and table.remove(NotifyPool) or GetFromPool("Frame")
        NotifyFrame.BackgroundTransparency = 1
        NotifyFrame.Size = UDim2.new(1, 0, 0, 150)
        NotifyFrame.Name = "NotifyFrame"
        NotifyFrame.AnchorPoint = Vector2.new(0, 1)
        NotifyFrame.Parent = NotifyLayout

        local NotifyFrameReal = NotifyFrame:FindFirstChild("NotifyFrameReal") or GetFromPool("Frame")
        NotifyFrameReal.BackgroundColor3 = Theme.Secondary
        NotifyFrameReal.Position = UDim2.new(0, 400, 0, 0)
        NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
        NotifyFrameReal.Parent = NotifyFrame
        local UICorner = NotifyFrameReal:FindFirstChild("UICorner") or Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 8)
        UICorner.Parent = NotifyFrameReal

        local Gradient = NotifyFrameReal:FindFirstChild("Gradient") or Instance.new("UIGradient")
        Gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Theme.Secondary), ColorSequenceKeypoint.new(1, Theme.Background)}
        Gradient.Rotation = 90
        Gradient.Parent = NotifyFrameReal

        local DropShadow = NotifyFrameReal:FindFirstChild("DropShadow") or Instance.new("ImageLabel")
        DropShadow.Image = "rbxassetid://6015897843"
        DropShadow.ImageColor3 = Theme.Shadow
        DropShadow.ImageTransparency = 0.4
        DropShadow.ScaleType = Enum.ScaleType.Slice
        DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
        DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        DropShadow.BackgroundTransparency = 1
        DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        DropShadow.Size = UDim2.new(1, 60, 1, 60)
        DropShadow.ZIndex = 0
        DropShadow.Parent = NotifyFrameReal

        local Top = NotifyFrameReal:FindFirstChild("Top") or GetFromPool("Frame")
        Top.BackgroundTransparency = 1
        Top.Size = UDim2.new(1, 0, 0, 36)
        Top.Parent = NotifyFrameReal

        local TitleLabel = Top:FindFirstChild("TitleLabel") or GetFromPool("TextLabel")
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextColor3 = Theme.Text
        TitleLabel.TextSize = 14
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Position = UDim2.new(0, 10, 0, 0)
        TitleLabel.Size = UDim2.new(1, -50, 1, 0)
        TitleLabel.Text = NotifyConfig.Title
        TitleLabel.Parent = Top

        local DescLabel = Top:FindFirstChild("DescLabel") or GetFromPool("TextLabel")
        DescLabel.Font = Enum.Font.GothamBold
        DescLabel.TextSize = 14
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.BackgroundTransparency = 1
        DescLabel.Size = UDim2.new(1, -50, 1, 0)
        DescLabel.Text = NotifyConfig.Description
        DescLabel.TextColor3 = NotifyConfig.Color
        DescLabel.Parent = Top

        local ContentLabel = NotifyFrameReal:FindFirstChild("ContentLabel") or GetFromPool("TextLabel")
        ContentLabel.Font = Enum.Font.Gotham
        ContentLabel.TextColor3 = Theme.Accent
        ContentLabel.TextSize = 13
        ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
        ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.Position = UDim2.new(0, 10, 0, 36)
        ContentLabel.Text = NotifyConfig.Content
        ContentLabel.Parent = NotifyFrameReal

        local Close = Top:FindFirstChild("Close") or GetFromPool("TextButton")
        Close.Text = ""
        Close.AnchorPoint = Vector2.new(1, 0.5)
        Close.BackgroundTransparency = 1
        Close.Position = UDim2.new(1, -5, 0.5, 0)
        Close.Size = UDim2.new(0, 25, 0, 25)
        Close.Parent = Top

        local CloseImg = Close:FindFirstChild("CloseImg") or GetFromPool("ImageLabel")
        CloseImg.Image = "rbxassetid://9886659671"
        CloseImg.AnchorPoint = Vector2.new(0.5, 0.5)
        CloseImg.BackgroundTransparency = 1
        CloseImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        CloseImg.Size = UDim2.new(1, -8, 1, -8)
        CloseImg.Parent = Close

        local NotifyPosHeight = 0
        for _, v in NotifyLayout:GetChildren() do
            if v ~= NotifyFrame then
                NotifyPosHeight = -(v.Position.Y.Offset) + v.Size.Y.Offset + 12
            end
        end
        NotifyFrame.Position = UDim2.new(0, 0, 1, -NotifyPosHeight)
        DescLabel.Position = UDim2.new(0, TitleLabel.TextBounds.X + 15, 0, 0)
        ContentLabel.Size = UDim2.new(1, -20, 0, 13 + (13 * math.ceil(ContentLabel.TextBounds.X / ContentLabel.AbsoluteSize.X)))
        NotifyFrame.Size = UDim2.new(1, 0, 0, math.max(ContentLabel.AbsoluteSize.Y + 40, 65))

        local waitbruh = false
        function NotifyFunction:Close()
            if waitbruh then return end
            waitbruh = true
            TweenService:Create(NotifyFrameReal, TweenInfo.new(NotifyConfig.Time, Enum.EasingStyle.Sine), {Position = UDim2.new(0, 400, 0, 0)}):Play()
            task.wait(NotifyConfig.Time)
            NotifyFrame.Visible = false
            table.insert(NotifyPool, NotifyFrame)
        end

        Close.Activated:Connect(NotifyFunction.Close)
        TweenService:Create(NotifyFrameReal, TweenInfo.new(NotifyConfig.Time, Enum.EasingStyle.Sine), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(NotifyConfig.Delay)
        NotifyFunction:Close()
    end)
    return NotifyFunction
end

-- Tạo GUI chính
function CatLib:MakeGui(GuiConfig)
    GuiConfig = GuiConfig or {}
    GuiConfig.NameHub = GuiConfig.NameHub or "CatLib v0.5"
    GuiConfig.Description = GuiConfig.Description or "by: catdzs1vn"
    GuiConfig.Color = GuiConfig.Color or Theme.Primary
    GuiConfig.Font = GuiConfig.Font or Enum.Font.Gotham
    GuiConfig.TabWidth = GuiConfig.TabWidth or 120
    GuiConfig.LogoPlayer = GuiConfig.LogoPlayer or "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
    GuiConfig.NamePlayer = GuiConfig.NamePlayer or LocalPlayer.Name

    local GuiFunc = {}
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "CatLibGui"
    MainGui.Parent = CoreGui

    local DropShadowHolder = Instance.new("Frame")
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Size = UDim2.new(0, 600, 0, 400)
    DropShadowHolder.Position = UDim2.new(0.5, -300, 0.5, -200)
    DropShadowHolder.Parent = MainGui

    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Theme.Shadow
    DropShadow.ImageTransparency = 0.4
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 60, 1, 60)
    DropShadow.ZIndex = 0
    DropShadow.Parent = DropShadowHolder

    local Main = Instance.new("Frame")
    Main.BackgroundColor3 = Theme.Background
    Main.Size = UDim2.new(1, -20, 1, -20)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Parent = DropShadowHolder
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Main
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Theme.Secondary), ColorSequenceKeypoint.new(1, Theme.Background)}
    UIGradient.Rotation = 90
    UIGradient.Parent = Main

    local Top = Instance.new("Frame")
    Top.BackgroundTransparency = 1
    Top.Size = UDim2.new(1, 0, 0, 40)
    Top.Parent = Main
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Font = GuiConfig.Font
    NameLabel.Text = GuiConfig.NameHub
    NameLabel.TextColor3 = Theme.Text
    NameLabel.TextSize = 16
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.BackgroundTransparency = 1
    NameLabel.Position = UDim2.new(0, 10, 0, 0)
    NameLabel.Size = UDim2.new(1, -100, 1, 0)
    NameLabel.Parent = Top
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Font = GuiConfig.Font
    DescLabel.Text = GuiConfig.Description
    DescLabel.TextColor3 = GuiConfig.Color
    DescLabel.TextSize = 16
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.BackgroundTransparency = 1
    DescLabel.Position = UDim2.new(0, NameLabel.TextBounds.X + 15, 0, 0)
    DescLabel.Size = UDim2.new(1, -(NameLabel.TextBounds.X + 104), 1, 0)
    DescLabel.Parent = Top

    local Close = Instance.new("TextButton")
    Close.Text = "✖"
    Close.Font = GuiConfig.Font
    Close.TextColor3 = Theme.Text
    Close.TextSize = 16
    Close.BackgroundTransparency = 1
    Close.Position = UDim2.new(1, -30, 0, 5)
    Close.Size = UDim2.new(0, 25, 0, 25)
    Close.Parent = Top

    local TabsFrame = Instance.new("Frame")
    TabsFrame.BackgroundTransparency = 1
    TabsFrame.Position = UDim2.new(0, 10, 0, 50)
    TabsFrame.Size = UDim2.new(0, GuiConfig.TabWidth, 1, -60)
    TabsFrame.Parent = Main

    local ScrollTab = Instance.new("ScrollingFrame")
    ScrollTab.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollTab.ScrollBarThickness = 2
    ScrollTab.BackgroundTransparency = 1
    ScrollTab.Size = UDim2.new(1, 0, 1, -30)
    ScrollTab.Position = UDim2.new(0, 0, 0, 30)
    ScrollTab.Parent = TabsFrame
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = ScrollTab

    local SearchBar = Instance.new("TextBox")
    SearchBar.Size = UDim2.new(1, -10, 0, 25)
    SearchBar.Position = UDim2.new(0, 5, 0, 0)
    SearchBar.PlaceholderText = "Search Tabs..."
    SearchBar.Font = GuiConfig.Font
    SearchBar.TextSize = 12
    SearchBar.BackgroundColor3 = Theme.Secondary
    SearchBar.TextColor3 = Theme.Text
    SearchBar.Parent = TabsFrame
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.Parent = SearchBar

    local PagesFrame = Instance.new("Frame")
    PagesFrame.BackgroundTransparency = 1
    PagesFrame.Position = UDim2.new(0, GuiConfig.TabWidth + 20, 0, 50)
    PagesFrame.Size = UDim2.new(1, -(GuiConfig.TabWidth + 30), 1, -60)
    PagesFrame.Parent = Main
    local PagesFolder = Instance.new("Folder")
    PagesFolder.Parent = PagesFrame

    local function UpdateTabSize()
        local OffsetY = 0
        for _, child in ScrollTab:GetChildren() do
            if child:IsA("TextButton") then OffsetY = OffsetY + child.Size.Y.Offset + 5 end
        end
        ScrollTab.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
    end

    SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = SearchBar.Text:lower()
        for _, tab in pairs(ScrollTab:GetChildren()) do
            if tab:IsA("TextButton") then
                tab.Visible = searchText == "" or tab.Text:lower():find(searchText) ~= nil
            end
        end
        UpdateTabSize()
    end)

    Close.Activated:Connect(function() CircleClick(Close, Mouse.X, Mouse.Y) MainGui:Destroy() end)
    MakeDraggable(Top, DropShadowHolder)
    MakeResizable(DropShadowHolder)

    local Tabs = {}
    local currentTab = nil
    function Tabs:CreateTab(TabConfig)
        TabConfig = TabConfig or {}
        TabConfig.Name = TabConfig.Name or "Tab"
        TabConfig.Icon = TabConfig.Icon or ""

        local TabButton = GetFromPool("TextButton")
        TabButton.Text = TabConfig.Name
        TabButton.Font = GuiConfig.Font
        TabButton.TextColor3 = Theme.Text
        TabButton.TextSize = 14
        TabButton.BackgroundColor3 = Theme.Secondary
        TabButton.Size = UDim2.new(1, -10, 0, 30)
        TabButton.Parent = ScrollTab
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        local Page = GetFromPool("ScrollingFrame")
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.ScrollBarThickness = 2
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Visible = false
        Page.Parent = PagesFolder
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 5)
        PageLayout.Parent = Page

        if not currentTab then
            currentTab = TabButton
            Page.Visible = true
            TabButton.BackgroundColor3 = GuiConfig.Color
        end

        TabButton.Activated:Connect(function()
            CircleClick(TabButton, Mouse.X, Mouse.Y)
            if currentTab ~= TabButton then
                for _, p in pairs(PagesFolder:GetChildren()) do
                    if p:IsA("ScrollingFrame") then p.Visible = false end
                end
                Page.Visible = true
                TweenService:Create(currentTab, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundColor3 = Theme.Secondary}):Play()
                TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundColor3 = GuiConfig.Color}):Play()
                currentTab = TabButton
            end
        end)

        TabButton.MouseEnter:Connect(function()
            if currentTab ~= TabButton then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Primary:Lerp(Theme.Secondary, 0.5)}):Play()
            end
        end)
        TabButton.MouseLeave:Connect(function()
            if currentTab ~= TabButton then
                TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Secondary}):Play()
            end
        end)

        local Sections = {}
        function Sections:AddSection(SectionConfig)
            SectionConfig = SectionConfig or {}
            SectionConfig.Title = SectionConfig.Title or "Section"

            local Section = GetFromPool("Frame")
            Section.BackgroundColor3 = Theme.Secondary
            Section.Size = UDim2.new(1, -10, 0, 30)
            Section.Parent = Page
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 6)
            SectionCorner.Parent = Section
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Text = SectionConfig.Title
            SectionTitle.Font = GuiConfig.Font
            SectionTitle.TextColor3 = Theme.Text
            SectionTitle.TextSize = 14
            SectionTitle.Position = UDim2.new(0, 10, 0, 0)
            SectionTitle.Size = UDim2.new(1, -20, 1, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Parent = Section

            local SectionContent = GetFromPool("Frame")
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 0, 0, 35)
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.Parent = Section
            local ContentLayout = Instance.new("UIListLayout")
            ContentLayout.Padding = UDim.new(0, 5)
            ContentLayout.Parent = SectionContent

            local isOpen = false
            local function UpdateSize()
                local totalHeight = 30
                if isOpen then
                    totalHeight = totalHeight + ContentLayout.AbsoluteContentSize.Y + 5
                end
                TweenService:Create(Section, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(1, -10, 0, totalHeight)}):Play()
                Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
            end

            SectionTitle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    CircleClick(SectionTitle, Mouse.X, Mouse.Y)
                    isOpen = not isOpen
                    UpdateSize()
                end
            end)

            local Items = {}
            function Items:AddToggle(ToggleConfig)
                ToggleConfig = ToggleConfig or {}
                ToggleConfig.Title = ToggleConfig.Title or "Toggle"
                ToggleConfig.Default = ToggleConfig.Default or false
                ToggleConfig.Callback = ToggleConfig.Callback or function() end

                local Toggle = GetFromPool("Frame")
                Toggle.BackgroundColor3 = Theme.Background
                Toggle.Size = UDim2.new(1, -10, 0, 40)
                Toggle.Parent = SectionContent
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 6)
                ToggleCorner.Parent = Toggle

                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Text = ToggleConfig.Title
                ToggleLabel.Font = GuiConfig.Font
                ToggleLabel.TextColor3 = Theme.Text
                ToggleLabel.TextSize = 14
                ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
                ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Parent = Toggle

                local ToggleSwitch = Instance.new("Frame")
                ToggleSwitch.BackgroundColor3 = ToggleConfig.Default and GuiConfig.Color or Theme.Secondary
                ToggleSwitch.Size = UDim2.new(0, 40, 0, 20)
                ToggleSwitch.Position = UDim2.new(1, -50, 0.5, -10)
                ToggleSwitch.Parent = Toggle
                local SwitchCorner = Instance.new("UICorner")
                SwitchCorner.CornerRadius = UDim.new(1, 0)
                SwitchCorner.Parent = ToggleSwitch

                local ToggleCircle = Instance.new("Frame")
                ToggleCircle.BackgroundColor3 = Theme.Text
                ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
                ToggleCircle.Position = UDim2.new(ToggleConfig.Default and 0.6 or 0.1, 0, 0.5, -8)
                ToggleCircle.Parent = ToggleSwitch
                local CircleCorner = Instance.new("UICorner")
                CircleCorner.CornerRadius = UDim.new(1, 0)
                CircleCorner.Parent = ToggleCircle

                local ToggleFunc = {Value = ToggleConfig.Default}
                local function UpdateToggle()
                    TweenService:Create(ToggleSwitch, TweenInfo.new(0.3), {BackgroundColor3 = ToggleFunc.Value and GuiConfig.Color or Theme.Secondary}):Play()
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.3), {Position = UDim2.new(ToggleFunc.Value and 0.6 or 0.1, 0, 0.5, -8)}):Play()
                    ToggleConfig.Callback(ToggleFunc.Value)
                end

                Toggle.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        CircleClick(Toggle, Mouse.X, Mouse.Y)
                        ToggleFunc.Value = not ToggleFunc.Value
                        UpdateToggle()
                    end
                end)

                function ToggleFunc:Set(value)
                    ToggleFunc.Value = value
                    UpdateToggle()
                end

                UpdateSize()
                return ToggleFunc
            end

            function Items:AddButton(ButtonConfig)
                ButtonConfig = ButtonConfig or {}
                ButtonConfig.Title = ButtonConfig.Title or "Button"
                ButtonConfig.Callback = ButtonConfig.Callback or function() end

                local Button = GetFromPool("Frame")
                Button.BackgroundColor3 = Theme.Background
                Button.Size = UDim2.new(1, -10, 0, 40)
                Button.Parent = SectionContent
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = Button

                local ButtonLabel = Instance.new("TextLabel")
                ButtonLabel.Text = ButtonConfig.Title
                ButtonLabel.Font = GuiConfig.Font
                ButtonLabel.TextColor3 = Theme.Text
                ButtonLabel.TextSize = 14
                ButtonLabel.Position = UDim2.new(0, 10, 0, 0)
                ButtonLabel.Size = UDim2.new(1, -20, 1, 0)
                ButtonLabel.BackgroundTransparency = 1
                ButtonLabel.Parent = Button

                Button.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        CircleClick(Button, Mouse.X, Mouse.Y)
                        ButtonConfig.Callback()
                    end
                end)

                UpdateSize()
                return {}
            end

            function Items:AddDropdown(DropdownConfig)
                DropdownConfig = DropdownConfig or {}
                DropdownConfig.Title = DropdownConfig.Title or "Dropdown"
                DropdownConfig.Items = DropdownConfig.Items or {"Option 1", "Option 2"}
                DropdownConfig.Default = DropdownConfig.Default or DropdownConfig.Items[1]
                DropdownConfig.Callback = DropdownConfig.Callback or function() end

                local Dropdown = GetFromPool("Frame")
                Dropdown.BackgroundColor3 = Theme.Background
                Dropdown.Size = UDim2.new(1, -10, 0, 40)
                Dropdown.Parent = SectionContent
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 6)
                DropdownCorner.Parent = Dropdown

                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Text = DropdownConfig.Title
                DropdownLabel.Font = GuiConfig.Font
                DropdownLabel.TextColor3 = Theme.Text
                DropdownLabel.TextSize = 14
                DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
                DropdownLabel.Size = UDim2.new(1, -20, 0.5, 0)
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Parent = Dropdown

                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Text = DropdownConfig.Default
                DropdownButton.Font = GuiConfig.Font
                DropdownButton.TextColor3 = Theme.Text
                DropdownButton.TextSize = 14
                DropdownButton.BackgroundColor3 = Theme.Secondary
                DropdownButton.Position = UDim2.new(0, 10, 0.5, 0)
                DropdownButton.Size = UDim2.new(1, -20, 0.5, 0)
                DropdownButton.Parent = Dropdown
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 4)
                ButtonCorner.Parent = DropdownButton

                local DropdownList = GetFromPool("Frame")
                DropdownList.BackgroundColor3 = Theme.Secondary
                DropdownList.Position = UDim2.new(0, 10, 1, 5)
                DropdownList.Size = UDim2.new(1, -20, 0, 0)
                DropdownList.ClipsDescendants = true
                DropdownList.Visible = false
                DropdownList.Parent = Dropdown
                local ListCorner = Instance.new("UICorner")
                ListCorner.CornerRadius = UDim.new(0, 4)
                ListCorner.Parent = DropdownList

                local ListScroll = Instance.new("ScrollingFrame")
                ListScroll.BackgroundTransparency = 1
                ListScroll.Size = UDim2.new(1, 0, 1, 0)
                ListScroll.ScrollBarThickness = 2
                ListScroll.Parent = DropdownList
                local ListLayout = Instance.new("UIListLayout")
                ListLayout.Padding = UDim.new(0, 5)
                ListLayout.Parent = ListScroll

                local DropdownFunc = {Value = DropdownConfig.Default}
                local isOpen = false

                local function UpdateList()
                    for _, child in pairs(ListScroll:GetChildren()) do
                        if child:IsA("TextButton") then ReturnToPool(child) end
                    end
                    for _, item in ipairs(DropdownConfig.Items) do
                        local ItemButton = GetFromPool("TextButton")
                        ItemButton.Text = item
                        ItemButton.Font = GuiConfig.Font
                        ItemButton.TextColor3 = Theme.Text
                        ItemButton.TextSize = 14
                        ItemButton.BackgroundColor3 = Theme.Secondary
                        ItemButton.Size = UDim2.new(1, -10, 0, 30)
                        ItemButton.Parent = ListScroll
                        local ItemCorner = Instance.new("UICorner")
                        ItemCorner.CornerRadius = UDim.new(0, 4)
                        ItemCorner.Parent = ItemButton

                        ItemButton.Activated:Connect(function()
                            DropdownFunc.Value = item
                            DropdownButton.Text = item
                            isOpen = false
                            TweenService:Create(DropdownList, TweenInfo.new(0.3), {Size = UDim2.new(1, -20, 0, 0)}):Play()
                            DropdownConfig.Callback(item)
                        end)
                    end
                    ListScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
                end

                UpdateList()

                DropdownButton.Activated:Connect(function()
                    CircleClick(DropdownButton, Mouse.X, Mouse.Y)
                    isOpen = not isOpen
                    TweenService:Create(DropdownList, TweenInfo.new(0.3), {Size = UDim2.new(1, -20, 0, isOpen and math.min(ListScroll.CanvasSize.Y.Offset, 100) or 0)}):Play()
                    DropdownList.Visible = true
                    if not isOpen then task.wait(0.3) DropdownList.Visible = false end
                end)

                function DropdownFunc:Set(value)
                    if table.find(DropdownConfig.Items, value) then
                        DropdownFunc.Value = value
                        DropdownButton.Text = value
                        DropdownConfig.Callback(value)
                    end
                end

                UpdateSize()
                return DropdownFunc
            end

            function Items:AddSlider(SliderConfig)
                SliderConfig = SliderConfig or {}
                SliderConfig.Title = SliderConfig.Title or "Slider"
                SliderConfig.Min = SliderConfig.Min or 0
                SliderConfig.Max = SliderConfig.Max or 100
                SliderConfig.Default = SliderConfig.Default or SliderConfig.Min
                SliderConfig.Callback = SliderConfig.Callback or function() end

                local Slider = GetFromPool("Frame")
                Slider.BackgroundColor3 = Theme.Background
                Slider.Size = UDim2.new(1, -10, 0, 60)
                Slider.Parent = SectionContent
                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 6)
                SliderCorner.Parent = Slider

                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Text = SliderConfig.Title
                SliderLabel.Font = GuiConfig.Font
                SliderLabel.TextColor3 = Theme.Text
                SliderLabel.TextSize = 14
                SliderLabel.Position = UDim2.new(0, 10, 0, 0)
                SliderLabel.Size = UDim2.new(1, -20, 0, 20)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Parent = Slider

                local SliderValue = Instance.new("TextLabel")
                SliderValue.Text = tostring(SliderConfig.Default)
                SliderValue.Font = GuiConfig.Font
                SliderValue.TextColor3 = Theme.Text
                SliderValue.TextSize = 14
                SliderValue.Position = UDim2.new(1, -60, 0, 0)
                SliderValue.Size = UDim2.new(0, 50, 0, 20)
                SliderValue.BackgroundTransparency = 1
                SliderValue.Parent = Slider

                local SliderBar = Instance.new("Frame")
                SliderBar.BackgroundColor3 = Theme.Secondary
                SliderBar.Size = UDim2.new(1, -20, 0, 10)
                SliderBar.Position = UDim2.new(0, 10, 0, 40)
                SliderBar.Parent = Slider
                local BarCorner = Instance.new("UICorner")
                BarCorner.CornerRadius = UDim.new(1, 0)
                BarCorner.Parent = SliderBar

                local SliderFill = Instance.new("Frame")
                SliderFill.BackgroundColor3 = GuiConfig.Color
                SliderFill.Size = UDim2.new((SliderConfig.Default - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 0, 1, 0)
                SliderFill.Parent = SliderBar
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SliderFill

                local SliderKnob = Instance.new("Frame")
                SliderKnob.BackgroundColor3 = Theme.Text
                SliderKnob.Size = UDim2.new(0, 16, 0, 16)
                SliderKnob.Position = UDim2.new((SliderConfig.Default - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), -8, 0, -3)
                SliderKnob.Parent = SliderBar
                local KnobCorner = Instance.new("UICorner")
                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = SliderKnob

                local SliderFunc = {Value = SliderConfig.Default}
                local Dragging = false

                local function UpdateSlider(input)
                    local percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    SliderFunc.Value = math.floor(SliderConfig.Min + (SliderConfig.Max - SliderConfig.Min) * percent)
                    SliderValue.Text = tostring(SliderFunc.Value)
                    TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
                    TweenService:Create(SliderKnob, TweenInfo.new(0.1), {Position = UDim2.new(percent, -8, 0, -3)}):Play()
                    SliderConfig.Callback(SliderFunc.Value)
                end

                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = true
                        UpdateSlider(input)
                    end
                end)
                SliderBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(input)
                    end
                end)

                function SliderFunc:Set(value)
                    value = math.clamp(value, SliderConfig.Min, SliderConfig.Max)
                    SliderFunc.Value = value
                    SliderValue.Text = tostring(value)
                    local percent = (value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
                    TweenService:Create(SliderFill, TweenInfo.new(0.3), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
                    TweenService:Create(SliderKnob, TweenInfo.new(0.3), {Position = UDim2.new(percent, -8, 0, -3)}):Play()
                    SliderConfig.Callback(value)
                end

                UpdateSize()
                return SliderFunc
            end

            return Items
        end
        UpdateTabSize()
        return Sections
    end

    return Tabs
end

-- API để thay đổi Theme
function CatLib:SetTheme(newTheme)
    for key, value in pairs(newTheme) do
        Theme[key] = value
    end
end

return CatLib