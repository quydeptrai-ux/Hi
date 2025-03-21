local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Theme mặc định với gradient
local Themes = {
    Default = {
        Primary = Color3.fromRGB(127, 146, 242),
        Secondary = Color3.fromRGB(45, 45, 45),
        Background = Color3.fromRGB(28, 28, 28),
        Text = Color3.fromRGB(230, 230, 230),
        Accent = Color3.fromRGB(80, 80, 80),
        Shadow = Color3.fromRGB(0, 0, 0),
        Gradient = {Color3.fromRGB(127, 146, 242), Color3.fromRGB(80, 100, 200)}
    }
}

-- Hàm tiện ích
local function Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

local function CreateGradient(frame, colors)
    local gradient = Instance.new("UIGradient", frame)
    gradient.Color = ColorSequence.new(colors or Themes.Default.Gradient)
    return gradient
end

-- MakeDraggable với resize mượt mà hơn
local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition
    local Resizing, ResizeStart, StartSize

    local function UpdatePos(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        TweenService:Create(object, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {Position = pos}):Play()
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

    local ResizeFrame = Instance.new("Frame")
    ResizeFrame.Size = UDim2.new(0, 15, 0, 15)
    ResizeFrame.Position = UDim2.new(1, -15, 1, -15)
    ResizeFrame.BackgroundTransparency = 1
    ResizeFrame.Parent = object

    local function UpdateSize(input)
        local Delta = input.Position - ResizeStart
        local newSize = UDim2.new(0, Clamp(StartSize.X.Offset + Delta.X, 300, 1200), 0, Clamp(StartSize.Y.Offset + Delta.Y, 200, 900))
        TweenService:Create(object, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {Size = newSize}):Play()
    end

    ResizeFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Resizing = true
            ResizeStart = input.Position
            StartSize = object.Size
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Resizing = false end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Resizing and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSize(input) end
    end)
end

-- Hiệu ứng click đẹp hơn
local ClickGui = Instance.new("ScreenGui", CoreGui)
ClickGui.Name = "ClickGui"
ClickGui.DisplayOrder = 10

local function CircleClick(X, Y)
    local Circle = Instance.new("ImageLabel")
    Circle.Image = "rbxassetid://266543268"
    Circle.ImageColor3 = Themes.Default.Primary
    Circle.ImageTransparency = 0.6
    Circle.BackgroundTransparency = 1
    Circle.Size = UDim2.new(0, 0, 0, 0)
    Circle.Position = UDim2.new(0, X, 0, Y)
    Circle.Parent = ClickGui

    local tween = TweenService:Create(Circle, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 60, 0, 60),
        ImageTransparency = 1,
        Position = UDim2.new(0, X - 30, 0, Y - 30)
    })
    tween:Play()
    tween.Completed:Connect(function() Circle:Destroy() end)
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then CircleClick(Mouse.X, Mouse.Y) end
end)

-- Cập nhật CanvasSize cho ScrollingFrame
local function UpdateScrollSize(Scroll)
    local OffsetY = 0
    for _, child in Scroll:GetChildren() do
        if child:IsA("GuiObject") and child ~= Scroll.UIListLayout then
            OffsetY = OffsetY + child.Size.Y.Offset + Scroll.UIListLayout.Padding.Offset
        end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
end

local function AutoUpdateScroll(Scroll)
    Scroll.ChildAdded:Connect(function() UpdateScrollSize(Scroll) end)
    Scroll.ChildRemoved:Connect(function() UpdateScrollSize(Scroll) end)
end

-- Hiệu ứng hover với gradient
local function AddHoverEffect(frame, useGradient)
    local originalColor = frame.BackgroundColor3
    local gradient = frame:FindFirstChildOfClass("UIGradient")

    frame.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine)
        if gradient and useGradient then
            TweenService:Create(gradient, tweenInfo, {Offset = Vector2.new(0.5, 0)}):Play()
        else
            TweenService:Create(frame, tweenInfo, {
                BackgroundColor3 = Color3.fromRGB(
                    Clamp(originalColor.R * 255 + 30, 0, 255),
                    Clamp(originalColor.G * 255 + 30, 0, 255),
                    Clamp(originalColor.B * 255 + 30, 0, 255)
                )
            }):Play()
        end
    end)

    frame.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine)
        if gradient and useGradient then
            TweenService:Create(gradient, tweenInfo, {Offset = Vector2.new(0, 0)}):Play()
        else
            TweenService:Create(frame, tweenInfo, {BackgroundColor3 = originalColor}):Play()
        end
    end)
end

-- Thư viện chính
local sitinklib = {Theme = Themes.Default}

-- Notify với hiệu ứng gradient
function sitinklib:Notify(config)
    local NotifyConfig = config or {}
    NotifyConfig.Title = NotifyConfig.Title or "Notification"
    NotifyConfig.Description = NotifyConfig.Description or ""
    NotifyConfig.Content = NotifyConfig.Content or ""
    NotifyConfig.Color = NotifyConfig.Color or self.Theme.Primary
    NotifyConfig.Time = NotifyConfig.Time or 0.3
    NotifyConfig.Delay = NotifyConfig.Delay or 5

    local NotifyGui = CoreGui:FindFirstChild("NotifyGui") or Instance.new("ScreenGui", CoreGui)
    NotifyGui.Name = "NotifyGui"
    NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local NotifyLayout = NotifyGui:FindFirstChild("NotifyLayout") or Instance.new("Frame", NotifyGui)
    NotifyLayout.Name = "NotifyLayout"
    NotifyLayout.AnchorPoint = Vector2.new(1, 1)
    NotifyLayout.Position = UDim2.new(1, -10, 1, -10)
    NotifyLayout.Size = UDim2.new(0, 320, 1, -20)
    NotifyLayout.BackgroundTransparency = 1

    local NotifyFrame = Instance.new("Frame")
    NotifyFrame.Size = UDim2.new(1, 0, 0, 90)
    NotifyFrame.Position = UDim2.new(0, 0, 1, 0)
    NotifyFrame.BackgroundTransparency = 1
    NotifyFrame.Parent = NotifyLayout

    local NotifyReal = Instance.new("Frame", NotifyFrame)
    NotifyReal.BackgroundColor3 = self.Theme.Secondary
    NotifyReal.Size = UDim2.new(1, 0, 1, 0)
    NotifyReal.Position = UDim2.new(0, 320, 0, 0)
    Instance.new("UICorner", NotifyReal).CornerRadius = UDim.new(0, 8)
    CreateGradient(NotifyReal)

    local DropShadow = Instance.new("ImageLabel", NotifyReal)
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = self.Theme.Shadow
    DropShadow.ImageTransparency = 0.5
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.Size = UDim2.new(1, 50, 1, 50)
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.ZIndex = 0

    local Title = Instance.new("TextLabel", NotifyReal)
    Title.Text = NotifyConfig.Title
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = NotifyConfig.Color
    Title.TextSize = 16
    Title.Position = UDim2.new(0, 15, 0, 10)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Description = Instance.new("TextLabel", NotifyReal)
    Description.Text = NotifyConfig.Description
    Description.Font = Enum.Font.Gotham
    Description.TextColor3 = self.Theme.Text
    Description.TextSize = 14
    Description.Position = UDim2.new(0, 15 + Title.TextBounds.X + 5, 0, 10)
    Description.BackgroundTransparency = 1
    Description.TextXAlignment = Enum.TextXAlignment.Left

    local Content = Instance.new("TextLabel", NotifyReal)
    Content.Text = NotifyConfig.Content
    Content.Font = Enum.Font.Gotham
    Content.TextColor3 = self.Theme.Text
    Content.TextSize = 12
    Content.Position = UDim2.new(0, 15, 0, 35)
    Content.Size = UDim2.new(1, -30, 0, 0)
    Content.TextWrapped = true
    Content.BackgroundTransparency = 1
    Content.TextXAlignment = Enum.TextXAlignment.Left

    local CloseButton = Instance.new("TextButton", NotifyReal)
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = ""

    local CloseImage = Instance.new("ImageLabel", CloseButton)
    CloseImage.Image = "rbxassetid://18328658828"
    CloseImage.Size = UDim2.new(0, 20, 0, 20)
    CloseImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    CloseImage.AnchorPoint = Vector2.new(0.5, 0.5)
    CloseImage.BackgroundTransparency = 1

    Content.Size = UDim2.new(1, -30, 0, Content.TextBounds.Y)
    NotifyFrame.Size = UDim2.new(1, 0, 0, math.max(Content.TextBounds.Y + 50, 90))

    local function UpdatePositions()
        local count = 0
        for _, frame in NotifyLayout:GetChildren() do
            if frame:IsA("Frame") then
                TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {
                    Position = UDim2.new(0, 0, 1, -(frame.Size.Y.Offset + 10) * count)
                }):Play()
                count = count + 1
            end
        end
    end

    NotifyLayout.ChildRemoved:Connect(UpdatePositions)

    TweenService:Create(NotifyReal, TweenInfo.new(NotifyConfig.Time, Enum.EasingStyle.Sine), {Position = UDim2.new(0, 0, 0, 0)}):Play()

    local function Close()
        TweenService:Create(NotifyReal, TweenInfo.new(NotifyConfig.Time, Enum.EasingStyle.Sine), {Position = UDim2.new(0, 320, 0, 0)}):Play()
        task.delay(NotifyConfig.Time, function() NotifyFrame:Destroy() end)
    end

    CloseButton.Activated:Connect(Close)
    task.delay(NotifyConfig.Delay, Close)

    UpdatePositions()
    return {Close = Close}
end

-- Start GUI với giao diện xịn hơn
function sitinklib:Start(config)
    local GuiConfig = config or {}
    GuiConfig.Name = GuiConfig.Name or "Sitink Hub"
    GuiConfig.Description = GuiConfig.Description or "Ultimate UI"
    GuiConfig.InfoColor = GuiConfig.InfoColor or self.Theme.Primary
    GuiConfig.LogoInfo = GuiConfig.LogoInfo or "rbxassetid://18243105495"
    GuiConfig.LogoPlayer = GuiConfig.LogoPlayer or "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
    GuiConfig.NameInfo = GuiConfig.NameInfo or "Hub Info"
    GuiConfig.NamePlayer = GuiConfig.NamePlayer or LocalPlayer.Name
    GuiConfig.InfoDescription = GuiConfig.InfoDescription or "discord.gg/sitink"
    GuiConfig.TabWidth = GuiConfig.TabWidth or 160
    GuiConfig.Color = GuiConfig.Color or self.Theme.Primary
    GuiConfig.CloseCallBack = GuiConfig.CloseCallBack or function() end

    local SitinkGui = Instance.new("ScreenGui", CoreGui)
    SitinkGui.Name = "SitinkGui"
    SitinkGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Main = Instance.new("Frame", SitinkGui)
    Main.Size = UDim2.new(0, 650, 0, 450)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = self.Theme.Background
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    CreateGradient(Main)

    local Top = Instance.new("Frame", Main)
    Top.Size = UDim2.new(1, 0, 0, 50)
    Top.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel", Top)
    Title.Text = GuiConfig.Name
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = GuiConfig.Color
    Title.TextSize = 18
    Title.Position = UDim2.new(0, 20, 0, 15)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Description = Instance.new("TextLabel", Top)
    Description.Text = GuiConfig.Description
    Description.Font = Enum.Font.Gotham
    Description.TextColor3 = self.Theme.Text
    Description.TextSize = 14
    Description.Position = UDim2.new(0, 20 + Title.TextBounds.X + 10, 0, 15)
    Description.BackgroundTransparency = 1
    Description.TextXAlignment = Enum.TextXAlignment.Left

    local CloseButton = Instance.new("TextButton", Top)
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(1, -45, 0, 7.5)
    CloseButton.BackgroundColor3 = self.Theme.Accent
    CloseButton.Text = ""
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 8)
    AddHoverEffect(CloseButton)

    local CloseImage = Instance.new("ImageLabel", CloseButton)
    CloseImage.Image = "rbxassetid://18328658828"
    CloseImage.Size = UDim2.new(0, 20, 0, 20)
    CloseImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    CloseImage.AnchorPoint = Vector2.new(0.5, 0.5)
    CloseImage.BackgroundTransparency = 1

    local DropShadow = Instance.new("ImageLabel", Main)
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = self.Theme.Shadow
    DropShadow.ImageTransparency = 0.5
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.Size = UDim2.new(1, 60, 1, 60)
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.ZIndex = 0

    MakeDraggable(Top, Main)

    -- Tab Layer
    local TabsFrame = Instance.new("Frame", Main)
    TabsFrame.Size = UDim2.new(0, GuiConfig.TabWidth, 1, -60)
    TabsFrame.Position = UDim2.new(0, 10, 0, 50)
    TabsFrame.BackgroundTransparency = 1

    local ScrollTab = Instance.new("ScrollingFrame", TabsFrame)
    ScrollTab.Size = UDim2.new(1, 0, 1, -40)
    ScrollTab.Position = UDim2.new(0, 0, 0, 40)
    ScrollTab.BackgroundTransparency = 1
    ScrollTab.ScrollBarThickness = 0
    ScrollTab.CanvasSize = UDim2.new(0, 0, 0, 0)

    local UIListLayout = Instance.new("UIListLayout", ScrollTab)
    UIListLayout.Padding = UDim.new(0, 6)

    AutoUpdateScroll(ScrollTab)

    -- Info Section
    local Info = Instance.new("Frame", TabsFrame)
    Info.Size = UDim2.new(1, 0, 0, 35)
    Info.BackgroundColor3 = self.Theme.Secondary
    Instance.new("UICorner", Info).CornerRadius = UDim.new(0, 6)
    AddHoverEffect(Info)

    local InfoButton = Instance.new("TextButton", Info)
    InfoButton.Size = UDim2.new(1, 0, 1, 0)
    InfoButton.BackgroundTransparency = 1
    InfoButton.Text = ""

    local LogoFrame = Instance.new("Frame", Info)
    LogoFrame.Size = UDim2.new(0, 30, 0, 30)
    LogoFrame.Position = UDim2.new(0, 5, 0.5, 0)
    LogoFrame.AnchorPoint = Vector2.new(0, 0.5)
    LogoFrame.BackgroundTransparency = 1

    local Logo = Instance.new("ImageLabel", LogoFrame)
    Logo.Image = GuiConfig.LogoInfo
    Logo.Size = UDim2.new(1, 0, 1, 0)
    Logo.Position = UDim2.new(0.5, 0, 0.5, 0)
    Logo.AnchorPoint = Vector2.new(0.5, 0.5)
    Logo.BackgroundTransparency = 1
    Instance.new("UICorner", Logo).CornerRadius = UDim.new(0, 100)

    local NameLabel = Instance.new("TextLabel", Info)
    NameLabel.Text = GuiConfig.NameInfo
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextColor3 = self.Theme.Text
    NameLabel.TextSize = 14
    NameLabel.Position = UDim2.new(0, 40, 0, 0)
    NameLabel.Size = UDim2.new(1, -40, 1, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Info Popup
    local InfoPopup = Instance.new("Frame", Main)
    InfoPopup.Size = UDim2.new(0, 0, 0, 0)
    InfoPopup.Position = UDim2.new(0.5, 0, 0.5, 0)
    InfoPopup.AnchorPoint = Vector2.new(0.5, 0.5)
    InfoPopup.BackgroundColor3 = GuiConfig.InfoColor
    InfoPopup.Visible = false
    InfoPopup.ClipsDescendants = true
    Instance.new("UICorner", InfoPopup).CornerRadius = UDim.new(0, 10)
    CreateGradient(InfoPopup)

    local PopupUnder = Instance.new("Frame", InfoPopup)
    PopupUnder.Size = UDim2.new(1, 0, 1, -60)
    PopupUnder.Position = UDim2.new(0, 0, 0, 60)
    PopupUnder.BackgroundColor3 = self.Theme.Secondary
    Instance.new("UICorner", PopupUnder).CornerRadius = UDim.new(0, 6)

    local PopupTitle = Instance.new("TextLabel", PopupUnder)
    PopupTitle.Text = GuiConfig.NamePlayer
    PopupTitle.Font = Enum.Font.GothamBold
    PopupTitle.TextColor3 = self.Theme.Text
    PopupTitle.TextSize = 18
    PopupTitle.Position = UDim2.new(0, 15, 0, 10)
    PopupTitle.BackgroundTransparency = 1
    PopupTitle.TextXAlignment = Enum.TextXAlignment.Left

    local PopupDesc = Instance.new("TextLabel", PopupUnder)
    PopupDesc.Text = GuiConfig.InfoDescription
    PopupDesc.Font = Enum.Font.Gotham
    PopupDesc.TextColor3 = self.Theme.Text
    PopupDesc.TextSize = 14
    PopupDesc.Position = UDim2.new(0, 15, 0, 35)
    PopupDesc.BackgroundTransparency = 1
    PopupDesc.TextXAlignment = Enum.TextXAlignment.Left

    local PopupLogo = Instance.new("ImageLabel", InfoPopup)
    PopupLogo.Image = GuiConfig.LogoPlayer
    PopupLogo.Size = UDim2.new(0, 50, 0, 50)
    PopupLogo.Position = UDim2.new(0, 15, 0, 5)
    PopupLogo.BackgroundTransparency = 1
    Instance.new("UICorner", PopupLogo).CornerRadius = UDim.new(0, 100)

    InfoButton.Activated:Connect(function()
        InfoPopup.Visible = true
        TweenService:Create(InfoPopup, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 280, 0, 140)}):Play()
    end)

    local ClosePopup = Instance.new("TextButton", InfoPopup)
    ClosePopup.Size = UDim2.new(1, 0, 1, 0)
    ClosePopup.BackgroundTransparency = 1
    ClosePopup.Text = ""
    ClosePopup.Activated:Connect(function()
        TweenService:Create(InfoPopup, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.delay(0.3, function() InfoPopup.Visible = false end)
    end)

    -- Layers
    local Layers = Instance.new("Frame", Main)
    Layers.Size = UDim2.new(1, -GuiConfig.TabWidth - 20, 1, -60)
    Layers.Position = UDim2.new(0, GuiConfig.TabWidth + 10, 0, 50)
    Layers.BackgroundTransparency = 1

    local RealLayers = Instance.new("Frame", Layers)
    RealLayers.Size = UDim2.new(1, 0, 1, -40)
    RealLayers.Position = UDim2.new(0, 0, 0, 40)
    RealLayers.BackgroundTransparency = 1
    RealLayers.ClipsDescendants = true

    local LayersFolder = Instance.new("Folder", RealLayers)
    local UIPageLayout = Instance.new("UIPageLayout", LayersFolder)
    UIPageLayout.EasingStyle = Enum.EasingStyle.Sine
    UIPageLayout.TweenTime = 0.3

    -- Top Layers
    local TopLayers = Instance.new("Frame", Layers)
    TopLayers.Size = UDim2.new(1, 0, 0, 40)
    TopLayers.BackgroundTransparency = 1

    local BackButton = Instance.new("TextButton", TopLayers)
    BackButton.Text = ""
    BackButton.Font = Enum.Font.GothamBold
    BackButton.TextColor3 = self.Theme.Text
    BackButton.TextSize = 16
    BackButton.Position = UDim2.new(0, 10, 0, 0)
    BackButton.BackgroundTransparency = 1

    local function JumpToTab(index, name)
        BackButton.Text = name
        BackButton.Size = UDim2.new(0, BackButton.TextBounds.X + 20, 1, 0)
        UIPageLayout:JumpToIndex(index)
    end

    CloseButton.Activated:Connect(function()
        SitinkGui.Enabled = false
        GuiConfig.CloseCallBack()
    end)

    -- Tabs
    local Tabs = {}
    local tabCount = 0

    function Tabs:MakeTab(name)
        local TabScroll = Instance.new("ScrollingFrame", LayersFolder)
        TabScroll.Size = UDim2.new(1, 0, 1, 0)
        TabScroll.BackgroundTransparency = 1
        TabScroll.ScrollBarThickness = 4
        TabScroll.ScrollBarImageColor3 = self.Theme.Accent
        TabScroll.LayoutOrder = tabCount
        TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

        local TabUIList = Instance.new("UIListLayout", TabScroll)
        TabUIList.Padding = UDim.new(0, 6)
        AutoUpdateScroll(TabScroll)

        local TabFrame = Instance.new("Frame", ScrollTab)
        TabFrame.Size = UDim2.new(1, -10, 0, 35)
        TabFrame.BackgroundColor3 = tabCount == 0 and self.Theme.Secondary or self.Theme.Background
        TabFrame.LayoutOrder = tabCount
        Instance.new("UICorner", TabFrame).CornerRadius = UDim.new(0, 6)
        AddHoverEffect(TabFrame)

        local TabName = Instance.new("TextLabel", TabFrame)
        TabName.Text = name
        TabName.Font = Enum.Font.GothamBold
        TabName.TextColor3 = self.Theme.Text
        TabName.TextSize = 14
        TabName.Position = UDim2.new(0, 15, 0, 0)
        TabName.Size = UDim2.new(1, -30, 1, 0)
        TabName.BackgroundTransparency = 1
        TabName.TextXAlignment = Enum.TextXAlignment.Left

        local TabButton = Instance.new("TextButton", TabFrame)
        TabButton.Size = UDim2.new(1, 0, 1, 0)
        TabButton.BackgroundTransparency = 1
        TabButton.Text = ""

        if tabCount == 0 then
            BackButton.Text = name
            BackButton.Size = UDim2.new(0, BackButton.TextBounds.X + 20, 1, 0)
            UIPageLayout:JumpToIndex(0)
        end

        TabButton.Activated:Connect(function()
            for _, tab in ScrollTab:GetChildren() do
                if tab:IsA("Frame") then
                    TweenService:Create(tab, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundColor3 = self.Theme.Background}):Play()
                end
            end
            TweenService:Create(TabFrame, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundColor3 = self.Theme.Secondary}):Play()
            JumpToTab(TabFrame.LayoutOrder, name)
        end)

        local Sections = {}
        local sectionCount = 0

        function Sections:Section(config)
            local SectionConfig = config or {}
            SectionConfig.Title = SectionConfig.Title or "Section"
            SectionConfig.Content = SectionConfig.Content or ""

            local SectionFrame = Instance.new("Frame", TabScroll)
            SectionFrame.Size = UDim2.new(1, -10, 0, 50)
            SectionFrame.BackgroundColor3 = self.Theme.Secondary
            SectionFrame.LayoutOrder = sectionCount
            Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0, 6)
            CreateGradient(SectionFrame)

            local SectionTitle = Instance.new("TextLabel", SectionFrame)
            SectionTitle.Text = SectionConfig.Title
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextColor3 = self.Theme.Text
            SectionTitle.TextSize = 16
            SectionTitle.Position = UDim2.new(0, 15, 0, 5)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

            local SectionDesc = Instance.new("TextLabel", SectionFrame)
            SectionDesc.Text = SectionConfig.Content
            SectionDesc.Font = Enum.Font.Gotham
            SectionDesc.TextColor3 = self.Theme.Text
            SectionDesc.TextSize = 12
            SectionDesc.Position = UDim2.new(0, 15, 0, 25)
            SectionDesc.BackgroundTransparency = 1
            SectionDesc.TextXAlignment = Enum.TextXAlignment.Left

            local Items = {}
            local itemCount = 0

            -- Button
            function Items:Button(config)
                local ButtonConfig = config or {}
                ButtonConfig.Title = ButtonConfig.Title or "Button"
                ButtonConfig.Content = ButtonConfig.Content or ""
                ButtonConfig.Callback = ButtonConfig.Callback or function() end

                local ButtonFrame = Instance.new("Frame", TabScroll)
                ButtonFrame.Size = UDim2.new(1, -10, 0, ButtonConfig.Content == "" and 45 or 65)
                ButtonFrame.BackgroundColor3 = self.Theme.Background
                ButtonFrame.LayoutOrder = itemCount
                Instance.new("UICorner", ButtonFrame).CornerRadius = UDim.new(0, 6)
                AddHoverEffect(ButtonFrame)

                local ButtonTitle = Instance.new("TextLabel", ButtonFrame)
                ButtonTitle.Text = ButtonConfig.Title
                ButtonTitle.Font = Enum.Font.GothamBold
                ButtonTitle.TextColor3 = self.Theme.Text
                ButtonTitle.TextSize = 14
                ButtonTitle.Position = UDim2.new(0, 15, 0, 5)
                ButtonTitle.BackgroundTransparency = 1
                ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left

                local ButtonDesc = Instance.new("TextLabel", ButtonFrame)
                ButtonDesc.Text = ButtonConfig.Content
                ButtonDesc.Font = Enum.Font.Gotham
                ButtonDesc.TextColor3 = self.Theme.Text
                ButtonDesc.TextSize = 12
                ButtonDesc.Position = UDim2.new(0, 15, 0, 25)
                ButtonDesc.BackgroundTransparency = 1
                ButtonDesc.TextXAlignment = Enum.TextXAlignment.Left

                local ButtonClick = Instance.new("TextButton", ButtonFrame)
                ButtonClick.Size = UDim2.new(0, 110, 0, 30)
                ButtonClick.Position = UDim2.new(1, -125, 0.5, -15)
                ButtonClick.BackgroundColor3 = self.Theme.Primary
                ButtonClick.Text = "Click"
                ButtonClick.Font = Enum.Font.GothamBold
                ButtonClick.TextColor3 = self.Theme.Text
                ButtonClick.TextSize = 12
                Instance.new("UICorner", ButtonClick).CornerRadius = UDim.new(0, 6)
                CreateGradient(ButtonClick)
                AddHoverEffect(ButtonClick, true)

                ButtonClick.Activated:Connect(function()
                    TweenService:Create(ButtonClick, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {BackgroundColor3 = self.Theme.Accent}):Play()
                    task.delay(0.1, function()
                        TweenService:Create(ButtonClick, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {BackgroundColor3 = self.Theme.Primary}):Play()
                    end)
                    ButtonConfig.Callback()
                end)

                itemCount = itemCount + 1
                return {}
            end

            -- Toggle
            function Items:Toggle(config)
                local ToggleConfig = config or {}
                ToggleConfig.Title = ToggleConfig.Title or "Toggle"
                ToggleConfig.Content = ToggleConfig.Content or ""
                ToggleConfig.Default = ToggleConfig.Default or false
                ToggleConfig.Callback = ToggleConfig.Callback or function() end
                local ToggleFunc = {Value = ToggleConfig.Default}

                local ToggleFrame = Instance.new("Frame", TabScroll)
                ToggleFrame.Size = UDim2.new(1, -10, 0, ToggleConfig.Content == "" and 45 or 65)
                ToggleFrame.BackgroundColor3 = self.Theme.Background
                ToggleFrame.LayoutOrder = itemCount
                Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
                AddHoverEffect(ToggleFrame)

                local ToggleTitle = Instance.new("TextLabel", ToggleFrame)
                ToggleTitle.Text = ToggleConfig.Title
                ToggleTitle.Font = Enum.Font.GothamBold
                ToggleTitle.TextColor3 = self.Theme.Text
                ToggleTitle.TextSize = 14
                ToggleTitle.Position = UDim2.new(0, 15, 0, 5)
                ToggleTitle.BackgroundTransparency = 1
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

                local ToggleDesc = Instance.new("TextLabel", ToggleFrame)
                ToggleDesc.Text = ToggleConfig.Content
                ToggleDesc.Font = Enum.Font.Gotham
                ToggleDesc.TextColor3 = self.Theme.Text
                ToggleDesc.TextSize = 12
                ToggleDesc.Position = UDim2.new(0, 15, 0, 25)
                ToggleDesc.BackgroundTransparency = 1
                ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left

                local ToggleSwitch = Instance.new("Frame", ToggleFrame)
                ToggleSwitch.Size = UDim2.new(0, 60, 0, 25)
                ToggleSwitch.Position = UDim2.new(1, -75, 0.5, -12.5)
                ToggleSwitch.BackgroundColor3 = self.Theme.Accent
                Instance.new("UICorner", ToggleSwitch).CornerRadius = UDim.new(0, 12)

                local ToggleKnob = Instance.new("Frame", ToggleSwitch)
                ToggleKnob.Size = UDim2.new(0, 20, 0, 20)
                ToggleKnob.Position = ToggleConfig.Default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                ToggleKnob.BackgroundColor3 = ToggleConfig.Default and self.Theme.Primary or self.Theme.Secondary
                ToggleKnob.AnchorPoint = Vector2.new(0, 0.5)
                Instance.new("UICorner", ToggleKnob).CornerRadius = UDim.new(0, 12)
                CreateGradient(ToggleKnob)

                local ToggleButton = Instance.new("TextButton", ToggleFrame)
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Text = ""

                local function UpdateToggle(value)
                    ToggleFunc.Value = value
                    TweenService:Create(ToggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
                        Position = value and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10),
                        BackgroundColor3 = value and self.Theme.Primary or self.Theme.Secondary
                    }):Play()
                    ToggleConfig.Callback(value)
                end

                ToggleButton.Activated:Connect(function() UpdateToggle(not ToggleFunc.Value) end)

                function ToggleFunc:Set(value) UpdateToggle(value) end

                itemCount = itemCount + 1
                return ToggleFunc
            end

            -- Slider
            function Items:Slider(config)
                local SliderConfig = config or {}
                SliderConfig.Title = SliderConfig.Title or "Slider"
                SliderConfig.Content = SliderConfig.Content or ""
                SliderConfig.Min = SliderConfig.Min or 0
                SliderConfig.Max = SliderConfig.Max or 100
                SliderConfig.Default = SliderConfig.Default or 50
                SliderConfig.Callback = SliderConfig.Callback or function() end
                local SliderFunc = {Value = SliderConfig.Default}

                local SliderFrame = Instance.new("Frame", TabScroll)
                SliderFrame.Size = UDim2.new(1, -10, 0, SliderConfig.Content == "" and 65 or 85)
                SliderFrame.BackgroundColor3 = self.Theme.Background
                SliderFrame.LayoutOrder = itemCount
                Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)
                AddHoverEffect(SliderFrame)

                local SliderTitle = Instance.new("TextLabel", SliderFrame)
                SliderTitle.Text = SliderConfig.Title
                SliderTitle.Font = Enum.Font.GothamBold
                SliderTitle.TextColor3 = self.Theme.Text
                SliderTitle.TextSize = 14
                SliderTitle.Position = UDim2.new(0, 15, 0, 5)
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

                local SliderDesc = Instance.new("TextLabel", SliderFrame)
                SliderDesc.Text = SliderConfig.Content
                SliderDesc.Font = Enum.Font.Gotham
                SliderDesc.TextColor3 = self.Theme.Text
                SliderDesc.TextSize = 12
                SliderDesc.Position = UDim2.new(0, 15, 0, 25)
                SliderDesc.BackgroundTransparency = 1
                SliderDesc.TextXAlignment = Enum.TextXAlignment.Left

                local SliderBar = Instance.new("Frame", SliderFrame)
                SliderBar.Size = UDim2.new(1, -30, 0, 8)
                SliderBar.Position = UDim2.new(0, 15, 1, -25)
                SliderBar.BackgroundColor3 = self.Theme.Accent
                Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(0, 4)

                local SliderFill = Instance.new("Frame", SliderBar)
                SliderFill.Size = UDim2.new((SliderConfig.Default - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 0, 1, 0)
                SliderFill.BackgroundColor3 = self.Theme.Primary
                Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(0, 4)
                CreateGradient(SliderFill)

                local SliderKnob = Instance.new("Frame", SliderBar)
                SliderKnob.Size = UDim2.new(0, 16, 0, 16)
                SliderKnob.Position = UDim2.new((SliderConfig.Default - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), -8, 0.5, -8)
                SliderKnob.BackgroundColor3 = self.Theme.Primary
                SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
                Instance.new("UICorner", SliderKnob).CornerRadius = UDim.new(0, 8)

                local SliderValue = Instance.new("TextLabel", SliderFrame)
                SliderValue.Text = tostring(SliderConfig.Default)
                SliderValue.Font = Enum.Font.Gotham
                SliderValue.TextColor3 = self.Theme.Text
                SliderValue.TextSize = 12
                SliderValue.Position = UDim2.new(1, -60, 1, -40)
                SliderValue.BackgroundTransparency = 1

                local SliderButton = Instance.new("TextButton", SliderBar)
                SliderButton.Size = UDim2.new(1, 0, 1, 0)
                SliderButton.BackgroundTransparency = 1
                SliderButton.Text = ""

                local dragging = false
                local function UpdateSlider(input)
                    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    SliderFunc.Value = math.floor(SliderConfig.Min + (SliderConfig.Max - SliderConfig.Min) * pos)
                    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    SliderKnob.Position = UDim2.new(pos, -8, 0.5, -8)
                    SliderValue.Text = tostring(SliderFunc.Value)
                    SliderConfig.Callback(SliderFunc.Value)
                end

                SliderButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        UpdateSlider(input)
                    end
                end)

                SliderButton.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider(input) end
                end)

                function SliderFunc:Set(value)
                    SliderFunc.Value = Clamp(value, SliderConfig.Min, SliderConfig.Max)
                    local pos = (SliderFunc.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
                    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    SliderKnob.Position = UDim2.new(pos, -8, 0.5, -8)
                    SliderValue.Text = tostring(SliderFunc.Value)
                    SliderConfig.Callback(SliderFunc.Value)
                end

                itemCount = itemCount + 1
                return SliderFunc
            end

            -- Dropdown (Làm lại hoàn toàn)
            function Items:Dropdown(config)
                local DropdownConfig = config or {}
                DropdownConfig.Title = DropdownConfig.Title or "Dropdown"
                DropdownConfig.Content = DropdownConfig.Content or ""
                DropdownConfig.Options = DropdownConfig.Options or {"Option 1", "Option 2"}
                DropdownConfig.Default = DropdownConfig.Default or DropdownConfig.Options[1]
                DropdownConfig.Searchable = DropdownConfig.Searchable or false
                DropdownConfig.Callback = DropdownConfig.Callback or function() end
                local DropdownFunc = {Value = DropdownConfig.Default}

                local DropdownFrame = Instance.new("Frame", TabScroll)
                DropdownFrame.Size = UDim2.new(1, -10, 0, DropdownConfig.Content == "" and 45 or 65)
                DropdownFrame.BackgroundColor3 = self.Theme.Background
                DropdownFrame.LayoutOrder = itemCount
                Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 6)
                AddHoverEffect(DropdownFrame)

                local DropdownTitle = Instance.new("TextLabel", DropdownFrame)
                DropdownTitle.Text = DropdownConfig.Title
                DropdownTitle.Font = Enum.Font.GothamBold
                DropdownTitle.TextColor3 = self.Theme.Text
                DropdownTitle.TextSize = 14
                DropdownTitle.Position = UDim2.new(0, 15, 0, 5)
                DropdownTitle.BackgroundTransparency = 1
                DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left

                local DropdownDesc = Instance.new("TextLabel", DropdownFrame)
                DropdownDesc.Text = DropdownConfig.Content
                DropdownDesc.Font = Enum.Font.Gotham
                DropdownDesc.TextColor3 = self.Theme.Text
                DropdownDesc.TextSize = 12
                DropdownDesc.Position = UDim2.new(0, 15, 0, 25)
                DropdownDesc.BackgroundTransparency = 1
                DropdownDesc.TextXAlignment = Enum.TextXAlignment.Left

                local DropdownButton = Instance.new("TextButton", DropdownFrame)
                DropdownButton.Size = UDim2.new(0, 140, 0, 30)
                DropdownButton.Position = UDim2.new(1, -155, 0.5, -15)
                DropdownButton.BackgroundColor3 = self.Theme.Accent
                DropdownButton.Text = DropdownConfig.Default
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.TextColor3 = self.Theme.Text
                DropdownButton.TextSize = 12
                Instance.new("UICorner", DropdownButton).CornerRadius = UDim.new(0, 6)
                CreateGradient(DropdownButton)
                AddHoverEffect(DropdownButton, true)

                local DropdownIcon = Instance.new("ImageLabel", DropdownButton)
                DropdownIcon.Image = "rbxassetid://3926305904"
                DropdownIcon.ImageRectOffset = Vector2.new(764, 204)
                DropdownIcon.ImageRectSize = Vector2.new(36, 36)
                DropdownIcon.Size = UDim2.new(0, 16, 0, 16)
                DropdownIcon.Position = UDim2.new(1, -25, 0.5, -8)
                DropdownIcon.BackgroundTransparency = 1

                local DropdownList = Instance.new("Frame", DropdownFrame)
                DropdownList.Size = UDim2.new(0, 140, 0, 0)
                DropdownList.Position = UDim2.new(1, -155, 0.5, 15)
                DropdownList.BackgroundColor3 = self.Theme.Secondary
                DropdownList.Visible = false
                DropdownList.ClipsDescendants = true
                Instance.new("UICorner", DropdownList).CornerRadius = UDim.new(0, 6)
                CreateGradient(DropdownList)

                local DropdownScroll = Instance.new("ScrollingFrame", DropdownList)
                DropdownScroll.Size = UDim2.new(1, 0, 1, DropdownConfig.Searchable and -35 or 0)
                DropdownScroll.Position = UDim2.new(0, 0, 0, DropdownConfig.Searchable and 35 or 0)
                DropdownScroll.BackgroundTransparency = 1
                DropdownScroll.ScrollBarThickness = 4
                DropdownScroll.ScrollBarImageColor3 = self.Theme.Accent
                DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, #DropdownConfig.Options * 30)

                local DropdownUIList = Instance.new("UIListLayout", DropdownScroll)
                DropdownUIList.Padding = UDim.new(0, 2)

                local SearchBox
                if DropdownConfig.Searchable then
                    SearchBox = Instance.new("TextBox", DropdownList)
                    SearchBox.Size = UDim2.new(1, -10, 0, 30)
                    SearchBox.Position = UDim2.new(0, 5, 0, 5)
                    SearchBox.BackgroundColor3 = self.Theme.Accent
                    SearchBox.PlaceholderText = "Search..."
                    SearchBox.Font = Enum.Font.Gotham
                    SearchBox.TextColor3 = self.Theme.Text
                    SearchBox.TextSize = 12
                    SearchBox.Text = ""
                    Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 6)
                end

                local function PopulateOptions(filter)
                    for _, child in pairs(DropdownScroll:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    for _, option in pairs(DropdownConfig.Options) do
                        if not filter or string.find(string.lower(option), string.lower(filter)) then
                            local OptionButton = Instance.new("TextButton", DropdownScroll)
                            OptionButton.Size = UDim2.new(1, -8, 0, 28)
                            OptionButton.BackgroundColor3 = self.Theme.Accent
                            OptionButton.Text = option
                            OptionButton.Font = Enum.Font.Gotham
                            OptionButton.TextColor3 = self.Theme.Text
                            OptionButton.TextSize = 12
                            Instance.new("UICorner", OptionButton).CornerRadius = UDim.new(0, 6)
                            AddHoverEffect(OptionButton)

                            OptionButton.Activated:Connect(function()
                                DropdownFunc.Value = option
                                DropdownButton.Text = option
                                TweenService:Create(DropdownList, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 140, 0, 0)}):Play()
                                task.delay(0.2, function() DropdownList.Visible = false end)
                                DropdownConfig.Callback(option)
                            end)
                        end
                    end
                    UpdateScrollSize(DropdownScroll)
                end

                PopulateOptions("")

                if DropdownConfig.Searchable then
                    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                        PopulateOptions(SearchBox.Text)
                    end)
                end

                DropdownButton.Activated:Connect(function()
                    if DropdownList.Visible then
                        TweenService:Create(DropdownList, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 140, 0, 0)}):Play()
                        task.delay(0.2, function() DropdownList.Visible = false end)
                    else
                        DropdownList.Visible = true
                        TweenService:Create(DropdownList, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 140, 0, math.min(#DropdownConfig.Options * 30, 150) + (DropdownConfig.Searchable and 35 or 0))}):Play()
                    end
                end)

                function DropdownFunc:Set(value)
                    if table.find(DropdownConfig.Options, value) then
                        DropdownFunc.Value = value
                        DropdownButton.Text = value
                        DropdownConfig.Callback(value)
                    end
                end

                itemCount = itemCount + 1
                return DropdownFunc
            end

            -- Dropdown Multi (Tính năng mới)
            function Items:DropdownMulti(config)
                local DropdownConfig = config or {}
                DropdownConfig.Title = DropdownConfig.Title or "Multi Dropdown"
                DropdownConfig.Content = DropdownConfig.Content or ""
                DropdownConfig.Options = DropdownConfig.Options or {"Option 1", "Option 2"}
                DropdownConfig.Default = DropdownConfig.Default or {}
                DropdownConfig.Searchable = DropdownConfig.Searchable or false
                DropdownConfig.Callback = DropdownConfig.Callback or function() end
                local DropdownFunc = {Value = DropdownConfig.Default}

                local DropdownFrame = Instance.new("Frame", TabScroll)
                DropdownFrame.Size = UDim2.new(1, -10, 0, DropdownConfig.Content == "" and 45 or 65)
                DropdownFrame.BackgroundColor3 = self.Theme.Background
                DropdownFrame.LayoutOrder = itemCount
                Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 6)
                AddHoverEffect(DropdownFrame)

                local DropdownTitle = Instance.new("TextLabel", DropdownFrame)
                DropdownTitle.Text = DropdownConfig.Title
                DropdownTitle.Font = Enum.Font.GothamBold
                DropdownTitle.TextColor3 = self.Theme.Text
                DropdownTitle.TextSize = 14
                DropdownTitle.Position = UDim2.new(0, 15, 0, 5)
                DropdownTitle.BackgroundTransparency = 1
                DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left

                local DropdownDesc = Instance.new("TextLabel", DropdownFrame)
                DropdownDesc.Text = DropdownConfig.Content
                DropdownDesc.Font = Enum.Font.Gotham
                DropdownDesc.TextColor3 = self.Theme.Text
                DropdownDesc.TextSize = 12
                DropdownDesc.Position = UDim2.new(0, 15, 0, 25)
                DropdownDesc.BackgroundTransparency = 1
                DropdownDesc.TextXAlignment = Enum.TextXAlignment.Left

                local DropdownButton = Instance.new("TextButton", DropdownFrame)
                DropdownButton.Size = UDim2.new(0, 140, 0, 30)
                DropdownButton.Position = UDim2.new(1, -155, 0.5, -15)
                DropdownButton.BackgroundColor3 = self.Theme.Accent
                DropdownButton.Text = #DropdownConfig.Default > 0 and table.concat(DropdownConfig.Default, ", ") or "Select..."
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.TextColor3 = self.Theme.Text
                DropdownButton.TextSize = 12
                Instance.new("UICorner", DropdownButton).CornerRadius = UDim.new(0, 6)
                CreateGradient(DropdownButton)
                AddHoverEffect(DropdownButton, true)

                local DropdownIcon = Instance.new("ImageLabel", DropdownButton)
                DropdownIcon.Image = "rbxassetid://3926305904"
                DropdownIcon.ImageRectOffset = Vector2.new(764, 204)
                DropdownIcon.ImageRectSize = Vector2.new(36, 36)
                DropdownIcon.Size = UDim2.new(0, 16, 0, 16)
                DropdownIcon.Position = UDim2.new(1, -25, 0.5, -8)
                DropdownIcon.BackgroundTransparency = 1

                local DropdownList = Instance.new("Frame", DropdownFrame)
                DropdownList.Size = UDim2.new(0, 140, 0, 0)
                DropdownList.Position = UDim2.new(1, -155, 0.5, 15)
                DropdownList.BackgroundColor3 = self.Theme.Secondary
                DropdownList.Visible = false
                DropdownList.ClipsDescendants = true
                Instance.new("UICorner", DropdownList).CornerRadius = UDim.new(0, 6)
                CreateGradient(DropdownList)

                local DropdownScroll = Instance.new("ScrollingFrame", DropdownList)
                DropdownScroll.Size = UDim2.new(1, 0, 1, DropdownConfig.Searchable and -35 or 0)
                DropdownScroll.Position = UDim2.new(0, 0, 0, DropdownConfig.Searchable and 35 or 0)
                DropdownScroll.BackgroundTransparency = 1
                DropdownScroll.ScrollBarThickness = 4
                DropdownScroll.ScrollBarImageColor3 = self.Theme.Accent
                DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, #DropdownConfig.Options * 30)

                local DropdownUIList = Instance.new("UIListLayout", DropdownScroll)
                DropdownUIList.Padding = UDim.new(0, 2)

                local SearchBox
                if DropdownConfig.Searchable then
                    SearchBox = Instance.new("TextBox", DropdownList)
                    SearchBox.Size = UDim2.new(1, -10, 0, 30)
                    SearchBox.Position = UDim2.new(0, 5, 0, 5)
                    SearchBox.BackgroundColor3 = self.Theme.Accent
                    SearchBox.PlaceholderText = "Search..."
                    SearchBox.Font = Enum.Font.Gotham
                    SearchBox.TextColor3 = self.Theme.Text
                    SearchBox.TextSize = 12
                    SearchBox.Text = ""
                    Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 6)
                end

                local function UpdateButtonText()
                    DropdownButton.Text = #DropdownFunc.Value > 0 and table.concat(DropdownFunc.Value, ", ") or "Select..."
                end

                local function PopulateOptions(filter)
                    for _, child in pairs(DropdownScroll:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    for _, option in pairs(DropdownConfig.Options) do
                        if not filter or string.find(string.lower(option), string.lower(filter)) then
                            local OptionButton = Instance.new("TextButton", DropdownScroll)
                            OptionButton.Size = UDim2.new(1, -8, 0, 28)
                            OptionButton.BackgroundColor3 = table.find(DropdownFunc.Value, option) and self.Theme.Primary or self.Theme.Accent
                            OptionButton.Text = option
                            OptionButton.Font = Enum.Font.Gotham
                            OptionButton.TextColor3 = self.Theme.Text
                            OptionButton.TextSize = 12
                            Instance.new("UICorner", OptionButton).CornerRadius = UDim.new(0, 6)
                            AddHoverEffect(OptionButton)

                            OptionButton.Activated:Connect(function()
                                if table.find(DropdownFunc.Value, option) then
                                    table.remove(DropdownFunc.Value, table.find(DropdownFunc.Value, option))
                                    OptionButton.BackgroundColor3 = self.Theme.Accent
                                else
                                    table.insert(DropdownFunc.Value, option)
                                    OptionButton.BackgroundColor3 = self.Theme.Primary
                                end
                                UpdateButtonText()
                                DropdownConfig.Callback(DropdownFunc.Value)
                            end)
                        end
                    end
                    UpdateScrollSize(DropdownScroll)
                end

                PopulateOptions("")

                if DropdownConfig.Searchable then
                    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                        PopulateOptions(SearchBox.Text)
                    end)
                end

                DropdownButton.Activated:Connect(function()
                    if DropdownList.Visible then
                        TweenService:Create(DropdownList, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 140, 0, 0)}):Play()
                        task.delay(0.2, function() DropdownList.Visible = false end)
                    else
                        DropdownList.Visible = true
                        TweenService:Create(DropdownList, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 140, 0, math.min(#DropdownConfig.Options * 30, 150) + (DropdownConfig.Searchable and 35 or 0))}):Play()
                    end
                end)

                function DropdownFunc:Set(values)
                    DropdownFunc.Value = values
                    UpdateButtonText()
                    PopulateOptions("")
                    DropdownConfig.Callback(DropdownFunc.Value)
                end

                itemCount = itemCount + 1
                return DropdownFunc
            end

            -- TextInput
            function Items:TextInput(config)
                local TextInputConfig = config or {}
                TextInputConfig.Title = TextInputConfig.Title or "Text Input"
                TextInputConfig.Content = TextInputConfig.Content or ""
                TextInputConfig.Placeholder = TextInputConfig.Placeholder or "Enter text..."
                TextInputConfig.Default = TextInputConfig.Default or ""
                TextInputConfig.Callback = TextInputConfig.Callback or function() end
                local TextInputFunc = {Value = TextInputConfig.Default}

                local TextInputFrame = Instance.new("Frame", TabScroll)
                TextInputFrame.Size = UDim2.new(1, -10, 0, TextInputConfig.Content == "" and 45 or 65)
                TextInputFrame.BackgroundColor3 = self.Theme.Background
                TextInputFrame.LayoutOrder = itemCount
                Instance.new("UICorner", TextInputFrame).CornerRadius = UDim.new(0, 6)
                AddHoverEffect(TextInputFrame)

                local TextInputTitle = Instance.new("TextLabel", TextInputFrame)
                TextInputTitle.Text = TextInputConfig.Title
                TextInputTitle.Font = Enum.Font.GothamBold
                TextInputTitle.TextColor3 = self.Theme.Text
                TextInputTitle.TextSize = 14
                TextInputTitle.Position = UDim2.new(0, 15, 0, 5)
                TextInputTitle.BackgroundTransparency = 1
                TextInputTitle.TextXAlignment = Enum.TextXAlignment.Left

                local TextInputDesc = Instance.new("TextLabel", TextInputFrame)
                TextInputDesc.Text = TextInputConfig.Content
                TextInputDesc.Font = Enum.Font.Gotham
                TextInputDesc.TextColor3 = self.Theme.Text
                TextInputDesc.TextSize = 12
                TextInputDesc.Position = UDim2.new(0, 15, 0, 25)
                TextInputDesc.BackgroundTransparency = 1
                TextInputDesc.TextXAlignment = Enum.TextXAlignment.Left

                local TextBox = Instance.new("TextBox", TextInputFrame)
                TextBox.Size = UDim2.new(0, 140, 0, 30)
                TextBox.Position = UDim2.new(1, -155, 0.5, -15)
                TextBox.BackgroundColor3 = self.Theme.Accent
                TextBox.Text = TextInputConfig.Default
                TextBox.PlaceholderText = TextInputConfig.Placeholder
                TextBox.Font = Enum.Font.Gotham
                TextBox.TextColor3 = self.Theme.Text
                TextBox.TextSize = 12
                Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)
                CreateGradient(TextBox)

                TextBox.FocusLost:Connect(function()
                    TextInputFunc.Value = TextBox.Text
                    TextInputConfig.Callback(TextBox.Text)
                end)

                function TextInputFunc:Set(value)
                    TextInputFunc.Value = value
                    TextBox.Text = value
                    TextInputConfig.Callback(value)
                end

                itemCount = itemCount + 1
                return TextInputFunc
            end

            -- Label
            function Items:Label(config)
                local LabelConfig = config or {}
                LabelConfig.Text = LabelConfig.Text or "Label"

                local LabelFrame = Instance.new("Frame", TabScroll)
                LabelFrame.Size = UDim2.new(1, -10, 0, 35)
                LabelFrame.BackgroundColor3 = self.Theme.Background
                LabelFrame.LayoutOrder = itemCount
                Instance.new("UICorner", LabelFrame).CornerRadius = UDim.new(0, 6)

                local LabelText = Instance.new("TextLabel", LabelFrame)
                LabelText.Text = LabelConfig.Text
                LabelText.Font = Enum.Font.Gotham
                LabelText.TextColor3 = self.Theme.Text
                LabelText.TextSize = 12
                LabelText.Position = UDim2.new(0, 15, 0, 0)
                LabelText.Size = UDim2.new(1, -30, 1, 0)
                LabelText.BackgroundTransparency = 1
                LabelText.TextXAlignment = Enum.TextXAlignment.Left

                local LabelFunc = {}
                function LabelFunc:Set(text) LabelText.Text = text end

                itemCount = itemCount + 1
                return LabelFunc
            end

            -- ColorPicker
            function Items:ColorPicker(config)
                local ColorPickerConfig = config or {}
                ColorPickerConfig.Title = ColorPickerConfig.Title or "Color Picker"
                ColorPickerConfig.Default = ColorPickerConfig.Default or Color3.fromRGB(255, 255, 255)
                ColorPickerConfig.Callback = ColorPickerConfig.Callback or function() end
                local ColorPickerFunc = {Value = ColorPickerConfig.Default}

                local ColorPickerFrame = Instance.new("Frame", TabScroll)
                ColorPickerFrame.Size = UDim2.new(1, -10, 0, 45)
                ColorPickerFrame.BackgroundColor3 = self.Theme.Background
                ColorPickerFrame.LayoutOrder = itemCount
                Instance.new("UICorner", ColorPickerFrame).CornerRadius = UDim.new(0, 6)
                AddHoverEffect(ColorPickerFrame)

                local ColorPickerTitle = Instance.new("TextLabel", ColorPickerFrame)
                ColorPickerTitle.Text = ColorPickerConfig.Title
                ColorPickerTitle.Font = Enum.Font.GothamBold
                ColorPickerTitle.TextColor3 = self.Theme.Text
                ColorPickerTitle.TextSize = 14
                ColorPickerTitle.Position = UDim2.new(0, 15, 0, 5)
                ColorPickerTitle.BackgroundTransparency = 1
                ColorPickerTitle.TextXAlignment = Enum.TextXAlignment.Left

                local ColorDisplay = Instance.new("Frame", ColorPickerFrame)
                ColorDisplay.Size = UDim2.new(0, 30, 0, 30)
                ColorDisplay.Position = UDim2.new(1, -45, 0.5, -15)
                ColorDisplay.BackgroundColor3 = ColorPickerConfig.Default
                Instance.new("UICorner", ColorDisplay).CornerRadius = UDim.new(0, 6)

                local ColorPickerButton = Instance.new("TextButton", ColorPickerFrame)
                ColorPickerButton.Size = UDim2.new(1, 0, 1, 0)
                ColorPickerButton.BackgroundTransparency = 1
                ColorPickerButton.Text = ""

                local PickerFrame = Instance.new("Frame", ColorPickerFrame)
                PickerFrame.Size = UDim2.new(0, 180, 0, 0)
                PickerFrame.Position = UDim2.new(1, -190, 0.5, 15)
                PickerFrame.BackgroundColor3 = self.Theme.Secondary
                PickerFrame.Visible = false
                Instance.new("UICorner", PickerFrame).CornerRadius = UDim.new(0, 6)
                CreateGradient(PickerFrame)

                local HueBar = Instance.new("Frame", PickerFrame)
                HueBar.Size = UDim2.new(0, 25, 1, -10)
                HueBar.Position = UDim2.new(0, 10, 0, 5)
                HueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                local HueGradient = Instance.new("UIGradient", HueBar)
                HueGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
                }

                local SaturationValue = Instance.new("Frame", PickerFrame)
                SaturationValue.Size = UDim2.new(0, 120, 1, -10)
                SaturationValue.Position = UDim2.new(0, 45, 0, 5)
                SaturationValue.BackgroundColor3 = ColorPickerConfig.Default
                local SatGradient = Instance.new("UIGradient", SaturationValue)
                SatGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, ColorPickerConfig.Default)
                }
                local ValGradient = Instance.new("UIGradient", SaturationValue)
                ValGradient.Rotation = 90
                ValGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
                }

                local HueButton = Instance.new("TextButton", HueBar)
                HueButton.Size = UDim2.new(1, 0, 1, 0)
                HueButton.BackgroundTransparency = 1
                HueButton.Text = ""

                local SatValButton = Instance.new("TextButton", SaturationValue)
                SatValButton.Size = UDim2.new(1, 0, 1, 0)
                SatValButton.BackgroundTransparency = 1
                SatValButton.Text = ""

                local function UpdateColor(h, s, v)
                    local color = Color3.fromHSV(h, s, v)
                    ColorPickerFunc.Value = color
                    ColorDisplay.BackgroundColor3 = color
                    SatGradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, 1))
                    }
                    ColorPickerConfig.Callback(color)
                end

                local h, s, v = ColorPickerConfig.Default:ToHSV()
                HueButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local draggingHue = true
                        local function UpdateHue()
                            local pos = math.clamp((Mouse.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                            h = 1 - pos
                            UpdateColor(h, s, v)
                        end
                        UpdateHue()
                        local conn = RunService.RenderStepped:Connect(function()
                            if draggingHue then UpdateHue() end
                        end)
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                draggingHue = false
                                conn:Disconnect()
                            end
                        end)
                    end
                end)

                SatValButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local draggingSV = true
                        local function UpdateSV()
                            local xPos = math.clamp((Mouse.X - SaturationValue.AbsolutePosition.X) / SaturationValue.AbsoluteSize.X, 0, 1)
                            local yPos = math.clamp((Mouse.Y - SaturationValue.AbsolutePosition.Y) / SaturationValue.AbsoluteSize.Y, 0, 1)
                            s = xPos
                            v = 1 - yPos
                            UpdateColor(h, s, v)
                        end
                        UpdateSV()
                        local conn = RunService.RenderStepped:Connect(function()
                            if draggingSV then UpdateSV() end
                        end)
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                draggingSV = false
                                conn:Disconnect()
                            end
                        end)
                    end
                end)

                ColorPickerButton.Activated:Connect(function()
                    if PickerFrame.Visible then
                        TweenService:Create(PickerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 180, 0, 0)}):Play()
                        task.delay(0.2, function() PickerFrame.Visible = false end)
                    else
                        PickerFrame.Visible = true
                        TweenService:Create(PickerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 180, 0, 120)}):Play()
                    end
                end)

                function ColorPickerFunc:Set(color)
                    ColorPickerFunc.Value = color
                    ColorDisplay.BackgroundColor3 = color
                    h, s, v = color:ToHSV()
                    SatGradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, 1))
                    }
                    ColorPickerConfig.Callback(color)
                end

                itemCount = itemCount + 1
                return ColorPickerFunc
            end

            -- Keybind
            function Items:Keybind(config)
                local KeybindConfig = config or {}
                KeybindConfig.Title = KeybindConfig.Title or "Keybind"
                KeybindConfig.Default = KeybindConfig.Default or Enum.KeyCode.E
                KeybindConfig.Callback = KeybindConfig.Callback or function() end
                local KeybindFunc = {Value = KeybindConfig.Default}

                local KeybindFrame = Instance.new("Frame", TabScroll)
                KeybindFrame.Size = UDim2.new(1, -10, 0, 45)
                KeybindFrame.BackgroundColor3 = self.Theme.Background
                KeybindFrame.LayoutOrder = itemCount
                Instance.new("UICorner", KeybindFrame).CornerRadius = UDim.new(0, 6)
                AddHoverEffect(KeybindFrame)

                local KeybindTitle = Instance.new("TextLabel", KeybindFrame)
                KeybindTitle.Text = KeybindConfig.Title
                KeybindTitle.Font = Enum.Font.GothamBold
                KeybindTitle.TextColor3 = self.Theme.Text
                KeybindTitle.TextSize = 14
                KeybindTitle.Position = UDim2.new(0, 15, 0, 5)
                KeybindTitle.BackgroundTransparency = 1
                KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left

                local KeybindButton = Instance.new("TextButton", KeybindFrame)
                KeybindButton.Size = UDim2.new(0, 70, 0, 30)
                KeybindButton.Position = UDim2.new(1, -85, 0.5, -15)
                KeybindButton.BackgroundColor3 = self.Theme.Accent
                KeybindButton.Text = KeybindConfig.Default.Name
                KeybindButton.Font = Enum.Font.Gotham
                KeybindButton.TextColor3 = self.Theme.Text
                KeybindButton.TextSize = 12
                Instance.new("UICorner", KeybindButton).CornerRadius = UDim.new(0, 6)
                CreateGradient(KeybindButton)
                AddHoverEffect(KeybindButton, true)

                local waitingForKey = false
                KeybindButton.Activated:Connect(function()
                    waitingForKey = true
                    KeybindButton.Text = "..."
                end)

                UserInputService.InputBegan:Connect(function(input)
                    if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
                        KeybindFunc.Value = input.KeyCode
                        KeybindButton.Text = input.KeyCode.Name
                        waitingForKey = false
                    elseif input.KeyCode == KeybindFunc.Value and not waitingForKey then
                        KeybindConfig.Callback()
                    end
                end)

                function KeybindFunc:Set(key)
                    KeybindFunc.Value = key
                    KeybindButton.Text = key.Name
                end

                itemCount = itemCount + 1
                return KeybindFunc
            end

            -- ProgressBar
            function Items:ProgressBar(config)
                local ProgressConfig = config or {}
                ProgressConfig.Title = ProgressConfig.Title or "Progress"
                ProgressConfig.Min = ProgressConfig.Min or 0
                ProgressConfig.Max = ProgressConfig.Max or 100
                ProgressConfig.Default = ProgressConfig.Default or 0
                ProgressConfig.Color = ProgressConfig.Color or self.Theme.Primary

                local ProgressFrame = Instance.new("Frame", TabScroll)
                ProgressFrame.Size = UDim2.new(1, -10, 0, 50)
                ProgressFrame.BackgroundColor3 = self.Theme.Background
                ProgressFrame.LayoutOrder = itemCount
                Instance.new("UICorner", ProgressFrame).CornerRadius = UDim.new(0, 6)
                AddHoverEffect(ProgressFrame)

                local ProgressTitle = Instance.new("TextLabel", ProgressFrame)
                ProgressTitle.Text = ProgressConfig.Title
                ProgressTitle.Font = Enum.Font.GothamBold
                ProgressTitle.TextColor3 = self.Theme.Text
                ProgressTitle.TextSize = 14
                ProgressTitle.Position = UDim2.new(0, 15, 0, 5)
                ProgressTitle.BackgroundTransparency = 1
                ProgressTitle.TextXAlignment = Enum.TextXAlignment.Left

                local ProgressBar = Instance.new("Frame", ProgressFrame)
                ProgressBar.Size = UDim2.new(1, -30, 0, 10)
                ProgressBar.Position = UDim2.new(0, 15, 1, -20)
                ProgressBar.BackgroundColor3 = self.Theme.Accent
                Instance.new("UICorner", ProgressBar).CornerRadius = UDim.new(0, 5)

                local ProgressFill = Instance.new("Frame", ProgressBar)
                ProgressFill.Size = UDim2.new((ProgressConfig.Default - ProgressConfig.Min) / (ProgressConfig.Max - ProgressConfig.Min), 0, 1, 0)
                ProgressFill.BackgroundColor3 = ProgressConfig.Color
                Instance.new("UICorner", ProgressFill).CornerRadius = UDim.new(0, 5)
                CreateGradient(ProgressFill)

                local ProgressValue = Instance.new("TextLabel", ProgressFrame)
                ProgressValue.Text = tostring(ProgressConfig.Default) .. "/" .. tostring(ProgressConfig.Max)
                ProgressValue.Font = Enum.Font.Gotham
                ProgressValue.TextColor3 = self.Theme.Text
                ProgressValue.TextSize = 12
                ProgressValue.Position = UDim2.new(1, -80, 0, 5)
                ProgressValue.BackgroundTransparency = 1

                local ProgressFunc = {}
                function ProgressFunc:Set(value)
                    local clamped = Clamp(value, ProgressConfig.Min, ProgressConfig.Max)
                    TweenService:Create(ProgressFill, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
                        Size = UDim2.new((clamped - ProgressConfig.Min) / (ProgressConfig.Max - ProgressConfig.Min), 0, 1, 0)
                    }):Play()
                    ProgressValue.Text = tostring(clamped) .. "/" .. tostring(ProgressConfig.Max)
                end

                itemCount = itemCount + 1
                return ProgressFunc
            end

            sectionCount = sectionCount + 1
            return Items
        end

        tabCount = tabCount + 1
        return Sections
    end

    return Tabs
end

-- Thêm hàm đổi theme động
function sitinklib:SetTheme(theme)
    self.Theme = theme or Themes.Default
    -- Cập nhật lại giao diện nếu cần (có thể thêm logic để áp dụng theme cho các thành phần đã tạo)
end

-- Hàm mở/tắt GUI
function sitinklib:Toggle()
    local gui = CoreGui:FindFirstChild("SitinkGui")
    if gui then
        gui.Enabled = not gui.Enabled
    end
end

-- Hàm thêm tooltip
local function AddTooltip(element, text)
    local Tooltip = Instance.new("TextLabel")
    Tooltip.Size = UDim2.new(0, 0, 0, 20)
    Tooltip.BackgroundColor3 = self.Theme.Secondary
    Tooltip.Text = text
    Tooltip.Font = Enum.Font.Gotham
    Tooltip.TextColor3 = self.Theme.Text
    Tooltip.TextSize = 12
    Tooltip.Visible = false
    Tooltip.Parent = CoreGui:FindFirstChild("SitinkGui") or element.Parent.Parent
    Instance.new("UICorner", Tooltip).CornerRadius = UDim.new(0, 4)

    element.MouseEnter:Connect(function()
        Tooltip.Position = UDim2.new(0, Mouse.X + 10, 0, Mouse.Y + 10)
        Tooltip.Size = UDim2.new(0, Tooltip.TextBounds.X + 10, 0, 20)
        Tooltip.Visible = true
    end)

    element.MouseLeave:Connect(function()
        Tooltip.Visible = false
    end)
end

return sitinklib