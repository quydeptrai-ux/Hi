local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = LocalPlayer.PlayerGui

-- Theme Configuration
local Themes = {
    Dark = {
        Background = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(255, 0, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(150, 150, 150),
        Shadow = Color3.fromRGB(0, 0, 0),
        Highlight = Color3.fromRGB(50, 50, 50)
    }
}
local CurrentTheme = Themes.Dark

-- Draggable Function
local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition
    local MinSize = Vector2.new(400, 300)
    local MaxSize = Vector2.new(800, 600)

    local function UpdatePos(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        TweenService:Create(object, TweenInfo.new(0.2), {Position = pos}):Play()
    end

    local function UpdateSize(input)
        local Delta = input.Position - DragStart
        local newWidth = math.clamp(StartSize.X.Offset + Delta.X, MinSize.X, MaxSize.X)
        local newHeight = math.clamp(StartSize.Y.Offset + Delta.Y, MinSize.Y, MaxSize.Y)
        TweenService:Create(object, TweenInfo.new(0.2), {Size = UDim2.new(0, newWidth, 0, newHeight)}):Play()
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)

    local resizeHandle = Instance.new("Frame")
    resizeHandle.Size = UDim2.new(0, 20, 0, 20)
    resizeHandle.Position = UDim2.new(1, 0, 1, 0)
    resizeHandle.AnchorPoint = Vector2.new(1, 1)
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.Parent = object

    local StartSize
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartSize = object.Size
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            if StartPosition then UpdatePos(input) elseif StartSize then UpdateSize(input) end
        end
    end)
end

-- Circle Click Effect
local function CircleClick(Button, X, Y)
    spawn(function()
        Button.ClipsDescendants = true
        local Circle = Instance.new("ImageLabel")
        Circle.Image = "rbxassetid://266543268"
        Circle.ImageColor3 = CurrentTheme.Accent
        Circle.ImageTransparency = 0.9
        Circle.BackgroundTransparency = 1
        Circle.ZIndex = 10
        Circle.Parent = Button

        local NewX = X - Circle.AbsolutePosition.X
        local NewY = Y - Circle.AbsolutePosition.Y
        Circle.Position = UDim2.new(0, NewX, 0, NewY)
        local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 1.5

        TweenService:Create(Circle, TweenInfo.new(0.5), {Size = UDim2.new(0, Size, 0, Size), Position = UDim2.new(0.5, -Size / 2, 0.5, -Size / 2), ImageTransparency = 1}):Play()
        task.wait(0.5)
        Circle:Destroy()
    end)
end

-- CatLib Library v4.5
local CatLib = {}

function CatLib:MakeNotify(NotifyConfig)
    NotifyConfig = NotifyConfig or {}
    NotifyConfig.Title = NotifyConfig.Title or "Cat Hub"
    NotifyConfig.Description = NotifyConfig.Description or "Notification"
    NotifyConfig.Content = NotifyConfig.Content or "Content"
    NotifyConfig.Color = NotifyConfig.Color or CurrentTheme.Accent
    NotifyConfig.Time = NotifyConfig.Time or 0.5
    NotifyConfig.Delay = NotifyConfig.Delay or 5

    local NotifyGui = CoreGui:FindFirstChild("NotifyGui") or Instance.new("ScreenGui", CoreGui)
    NotifyGui.Name = "NotifyGui"
    NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local NotifyLayout = NotifyGui:FindFirstChild("NotifyLayout") or Instance.new("Frame", NotifyGui)
    NotifyLayout.Name = "NotifyLayout"
    NotifyLayout.AnchorPoint = Vector2.new(1, 1)
    NotifyLayout.BackgroundTransparency = 1
    NotifyLayout.Position = UDim2.new(1, -30, 1, -30)
    NotifyLayout.Size = UDim2.new(0, 320, 1, 0)

    local NotifyFrame = Instance.new("Frame")
    NotifyFrame.BackgroundTransparency = 1
    NotifyFrame.Size = UDim2.new(1, 0, 0, 150)
    NotifyFrame.Parent = NotifyLayout
    NotifyFrame.AnchorPoint = Vector2.new(0, 1)

    local NotifyFrameReal = Instance.new("Frame", NotifyFrame)
    NotifyFrameReal.BackgroundColor3 = CurrentTheme.Background
    NotifyFrameReal.Position = UDim2.new(0, 400, 0, 0)
    NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
    Instance.new("UICorner", NotifyFrameReal).CornerRadius = UDim.new(0, 8)

    local DropShadow = Instance.new("ImageLabel", NotifyFrameReal)
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = CurrentTheme.Shadow
    DropShadow.ImageTransparency = 0.5
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 47, 1, 47)
    DropShadow.ZIndex = 0

    local Top = Instance.new("Frame", NotifyFrameReal)
    Top.BackgroundTransparency = 1
    Top.Size = UDim2.new(1, 0, 0, 36)

    local Title = Instance.new("TextLabel", Top)
    Title.Font = Enum.Font.GothamBold
    Title.Text = NotifyConfig.Title
    Title.TextColor3 = CurrentTheme.Text
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(1, 0, 1, 0)

    local Description = Instance.new("TextLabel", Top)
    Description.Font = Enum.Font.GothamBold
    Description.Text = NotifyConfig.Description
    Description.TextColor3 = NotifyConfig.Color
    Description.TextSize = 14
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.BackgroundTransparency = 1
    Description.Position = UDim2.new(0, Title.TextBounds.X + 15, 0, 0)
    Description.Size = UDim2.new(1, 0, 1, 0)

    local Close = Instance.new("TextButton", Top)
    Close.Text = ""
    Close.AnchorPoint = Vector2.new(1, 0.5)
    Close.BackgroundTransparency = 1
    Close.Position = UDim2.new(1, -5, 0.5, 0)
    Close.Size = UDim2.new(0, 25, 0, 25)

    local CloseIcon = Instance.new("ImageLabel", Close)
    CloseIcon.Image = "rbxassetid://9886659671"
    CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    CloseIcon.Size = UDim2.new(1, -8, 1, -8)

    local Content = Instance.new("TextLabel", NotifyFrameReal)
    Content.Font = Enum.Font.GothamBold
    Content.Text = NotifyConfig.Content
    Content.TextColor3 = CurrentTheme.SubText
    Content.TextSize = 13
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.TextYAlignment = Enum.TextYAlignment.Top
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 10, 0, 27)
    Content.Size = UDim2.new(1, -20, 0, 13)
    Content.TextWrapped = true

    Content.Size = UDim2.new(1, -20, 0, 13 + (13 * math.ceil(Content.TextBounds.X / Content.AbsoluteSize.X)))
    NotifyFrame.Size = UDim2.new(1, 0, 0, Content.AbsoluteSize.Y + 40)

    local NotifyPosHeight = 0
    for _, v in NotifyLayout:GetChildren() do
        if v ~= NotifyFrame then
            NotifyPosHeight = -(v.Position.Y.Offset) + v.Size.Y.Offset + 12
        end
    end
    NotifyFrame.Position = UDim2.new(0, 0, 1, -NotifyPosHeight)

    local function CloseNotify()
        TweenService:Create(NotifyFrameReal, TweenInfo.new(NotifyConfig.Time), {Position = UDim2.new(0, 400, 0, 0)}):Play()
        task.wait(NotifyConfig.Time)
        NotifyFrame:Destroy()
    end

    Close.Activated:Connect(CloseNotify)
    TweenService:Create(NotifyFrameReal, TweenInfo.new(NotifyConfig.Time), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(NotifyConfig.Delay)
    CloseNotify()

    return {Close = CloseNotify}
end

function CatLib:MakeGui(GuiConfig)
    GuiConfig = GuiConfig or {}
    GuiConfig.NameHub = GuiConfig.NameHub or "Cat Hub"
    GuiConfig.Description = GuiConfig.Description or "by: catdzs1vn"
    GuiConfig.Color = GuiConfig.Color or CurrentTheme.Accent
    GuiConfig.LogoPlayer = GuiConfig.LogoPlayer or "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
    GuiConfig.NamePlayer = GuiConfig.NamePlayer or LocalPlayer.Name
    GuiConfig.TabWidth = GuiConfig.TabWidth or 120

    local HirimiGui = Instance.new("ScreenGui", CoreGui)
    HirimiGui.Name = "HirimiGui"
    HirimiGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local DropShadowHolder = Instance.new("Frame", HirimiGui)
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Size = UDim2.new(0, 455, 0, 350)
    DropShadowHolder.Position = UDim2.new(0.5, -DropShadowHolder.Size.X.Offset / 2, 0.5, -DropShadowHolder.Size.Y.Offset / 2)

    local DropShadow = Instance.new("ImageLabel", DropShadowHolder)
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = CurrentTheme.Shadow
    DropShadow.ImageTransparency = 0.5
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 47, 1, 47)

    local Main = Instance.new("Frame", DropShadowHolder)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = CurrentTheme.Background
    Main.BackgroundTransparency = 0.05
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(1, -20, 1, -20)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

    local Top = Instance.new("Frame", Main)
    Top.BackgroundTransparency = 1
    Top.Size = UDim2.new(1, 0, 0, 38)

    local NameHub = Instance.new("TextLabel", Top)
    NameHub.Font = Enum.Font.GothamBold
    NameHub.Text = GuiConfig.NameHub
    NameHub.TextColor3 = CurrentTheme.Text
    NameHub.TextSize = 14
    NameHub.TextXAlignment = Enum.TextXAlignment.Left
    NameHub.BackgroundTransparency = 1
    NameHub.Position = UDim2.new(0, 10, 0, 0)
    NameHub.Size = UDim2.new(1, -100, 1, 0)

    local Description = Instance.new("TextLabel", Top)
    Description.Font = Enum.Font.GothamBold
    Description.Text = GuiConfig.Description
    Description.TextColor3 = GuiConfig.Color
    Description.TextSize = 14
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.BackgroundTransparency = 1
    Description.Position = UDim2.new(0, NameHub.TextBounds.X + 15, 0, 0)
    Description.Size = UDim2.new(1, -(NameHub.TextBounds.X + 104), 1, 0)

    local MaxRestore = Instance.new("TextButton", Top)
    MaxRestore.Text = ""
    MaxRestore.AnchorPoint = Vector2.new(1, 0.5)
    MaxRestore.BackgroundTransparency = 1
    MaxRestore.Position = UDim2.new(1, -42, 0.5, 0)
    MaxRestore.Size = UDim2.new(0, 25, 0, 25)

    local MaxRestoreIcon = Instance.new("ImageLabel", MaxRestore)
    MaxRestoreIcon.Image = "rbxassetid://9886659406"
    MaxRestoreIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    MaxRestoreIcon.BackgroundTransparency = 1
    MaxRestoreIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    MaxRestoreIcon.Size = UDim2.new(1, -8, 1, -8)

    local Close = Instance.new("TextButton", Top)
    Close.Text = ""
    Close.AnchorPoint = Vector2.new(1, 0.5)
    Close.BackgroundTransparency = 1
    Close.Position = UDim2.new(1, -8, 0.5, 0)
    Close.Size = UDim2.new(0, 25, 0, 25)

    local CloseIcon = Instance.new("ImageLabel", Close)
    CloseIcon.Image = "rbxassetid://9886659671"
    CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    CloseIcon.Size = UDim2.new(1, -8, 1, -8)

    local Min = Instance.new("TextButton", Top)
    Min.Text = ""
    Min.AnchorPoint = Vector2.new(1, 0.5)
    Min.BackgroundTransparency = 1
    Min.Position = UDim2.new(1, -78, 0.5, 0)
    Min.Size = UDim2.new(0, 25, 0, 25)

    local MinIcon = Instance.new("ImageLabel", Min)
    MinIcon.Image = "rbxassetid://9886659276"
    MinIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    MinIcon.BackgroundTransparency = 1
    MinIcon.ImageTransparency = 0.2
    MinIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    MinIcon.Size = UDim2.new(1, -9, 1, -9)

    local LayersTab = Instance.new("Frame", Main)
    LayersTab.BackgroundTransparency = 1
    LayersTab.Position = UDim2.new(0, 9, 0, 50)
    LayersTab.Size = UDim2.new(0, GuiConfig.TabWidth, 1, -59)

    local Layers = Instance.new("Frame", Main)
    Layers.BackgroundTransparency = 1
    Layers.Position = UDim2.new(0, GuiConfig.TabWidth + 18, 0, 50)
    Layers.Size = UDim2.new(1, -(GuiConfig.TabWidth + 27), 1, -59)

    local NameTab = Instance.new("TextLabel", Layers)
    NameTab.Font = Enum.Font.GothamBold
    NameTab.Text = ""
    NameTab.TextColor3 = CurrentTheme.Text
    NameTab.TextSize = 24
    NameTab.TextXAlignment = Enum.TextXAlignment.Left
    NameTab.BackgroundTransparency = 1
    NameTab.Size = UDim2.new(1, 0, 0, 30)

    local LayersReal = Instance.new("Frame", Layers)
    LayersReal.AnchorPoint = Vector2.new(0, 1)
    LayersReal.BackgroundTransparency = 1
    LayersReal.ClipsDescendants = true
    LayersReal.Position = UDim2.new(0, 0, 1, 0)
    LayersReal.Size = UDim2.new(1, 0, 1, -33)

    local LayersFolder = Instance.new("Folder", LayersReal)
    local LayersPageLayout = Instance.new("UIPageLayout", LayersFolder)
    LayersPageLayout.TweenTime = 0.5
    LayersPageLayout.EasingStyle = Enum.EasingStyle.Quad

    local ScrollTab = Instance.new("ScrollingFrame", LayersTab)
    ScrollTab.BackgroundTransparency = 1
    ScrollTab.ScrollBarThickness = 0
    ScrollTab.Size = UDim2.new(1, 0, 1, -50)

    local UIListLayout = Instance.new("UIListLayout", ScrollTab)
    UIListLayout.Padding = UDim.new(0, 3)

    local function UpdateTabSize()
        local OffsetY = 0
        for _, child in ScrollTab:GetChildren() do
            if child:IsA("Frame") then OffsetY = OffsetY + child.Size.Y.Offset + 3 end
        end
        ScrollTab.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
    end
    ScrollTab.ChildAdded:Connect(UpdateTabSize)
    ScrollTab.ChildRemoved:Connect(UpdateTabSize)

    local Info = Instance.new("Frame", LayersTab)
    Info.AnchorPoint = Vector2.new(1, 1)
    Info.BackgroundColor3 = CurrentTheme.Background
    Info.BackgroundTransparency = 0.95
    Info.Position = UDim2.new(1, 0, 1, 0)
    Info.Size = UDim2.new(1, 0, 0, 40)

    local LogoPlayerFrame = Instance.new("Frame", Info)
    LogoPlayerFrame.AnchorPoint = Vector2.new(0, 0.5)
    LogoPlayerFrame.BackgroundTransparency = 0.95
    LogoPlayerFrame.Position = UDim2.new(0, 5, 0.5, 0)
    LogoPlayerFrame.Size = UDim2.new(0, 30, 0, 30)

    local LogoPlayer = Instance.new("ImageLabel", LogoPlayerFrame)
    LogoPlayer.Image = GuiConfig.LogoPlayer
    LogoPlayer.AnchorPoint = Vector2.new(0.5, 0.5)
    LogoPlayer.BackgroundTransparency = 1
    LogoPlayer.Position = UDim2.new(0.5, 0, 0.5, 0)
    LogoPlayer.Size = UDim2.new(1, -5, 1, -5)
    Instance.new("UICorner", LogoPlayer).CornerRadius = UDim.new(1, 0)

    local NamePlayer = Instance.new("TextLabel", Info)
    NamePlayer.Font = Enum.Font.GothamBold
    NamePlayer.Text = GuiConfig.NamePlayer
    NamePlayer.TextColor3 = CurrentTheme.Text
    NamePlayer.TextSize = 12
    NamePlayer.TextXAlignment = Enum.TextXAlignment.Left
    NamePlayer.BackgroundTransparency = 1
    NamePlayer.Position = UDim2.new(0, 40, 0, 0)
    NamePlayer.Size = UDim2.new(1, -45, 1, 0)

    local OldPos, OldSize = DropShadowHolder.Position, DropShadowHolder.Size
    MaxRestore.Activated:Connect(function()
        CircleClick(MaxRestore, Mouse.X, Mouse.Y)
        if MaxRestoreIcon.Image == "rbxassetid://9886659406" then
            MaxRestoreIcon.Image = "rbxassetid://9886659001"
            OldPos = DropShadowHolder.Position
            OldSize = DropShadowHolder.Size
            TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 1, 0)}):Play()
        else
            MaxRestoreIcon.Image = "rbxassetid://9886659406"
            TweenService:Create(DropShadowHolder, TweenInfo.new(0.3), {Position = OldPos, Size = OldSize}):Play()
        end
    end)

    Min.Activated:Connect(function()
        CircleClick(Min, Mouse.X, Mouse.Y)
        DropShadowHolder.Visible = false
    end)

    Close.Activated:Connect(function()
        CircleClick(Close, Mouse.X, Mouse.Y)
        HirimiGui:Destroy()
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            DropShadowHolder.Visible = not DropShadowHolder.Visible
        end
    end)

    MakeDraggable(Top, DropShadowHolder)

    local MoreBlur = Instance.new("Frame", Layers)
    MoreBlur.AnchorPoint = Vector2.new(1, 1)
    MoreBlur.BackgroundColor3 = CurrentTheme.Background
    MoreBlur.BackgroundTransparency = 0.999
    MoreBlur.Position = UDim2.new(1, 8, 1, 8)
    MoreBlur.Size = UDim2.new(1, 154, 1, 54)
    MoreBlur.Visible = false

    local DropdownSelect = Instance.new("Frame", MoreBlur)
    DropdownSelect.AnchorPoint = Vector2.new(1, 0.5)
    DropdownSelect.BackgroundColor3 = CurrentTheme.Background
    DropdownSelect.Position = UDim2.new(1, 172, 0.5, 0)
    DropdownSelect.Size = UDim2.new(0, 160, 1, -16)
    DropdownSelect.ClipsDescendants = true
    Instance.new("UICorner", DropdownSelect).CornerRadius = UDim.new(0, 8)

    local DropdownFolder = Instance.new("Folder", DropdownSelect)
    local DropPageLayout = Instance.new("UIPageLayout", DropdownFolder)
    DropPageLayout.TweenTime = 0.01
    DropPageLayout.EasingStyle = Enum.EasingStyle.Quad

    local Tabs = {}
    local CountTab = 0
    local CountDropdown = 0

    function Tabs:CreateTab(TabConfig)
        TabConfig = TabConfig or {}
        TabConfig.Name = TabConfig.Name or "Tab"
        TabConfig.Icon = TabConfig.Icon or ""

        local ScrolLayers = Instance.new("ScrollingFrame", LayersFolder)
        ScrolLayers.BackgroundTransparency = 1
        ScrolLayers.ScrollBarThickness = 0
        ScrolLayers.LayoutOrder = CountTab
        ScrolLayers.Size = UDim2.new(1, 0, 1, 0)

        local UIListLayout = Instance.new("UIListLayout", ScrolLayers)
        UIListLayout.Padding = UDim.new(0, 3)

        local Tab = Instance.new("Frame", ScrollTab)
        Tab.BackgroundTransparency = CountTab == 0 and 0.92 or 1
        Tab.LayoutOrder = CountTab
        Tab.Size = UDim2.new(1, 0, 0, 30)

        local TabButton = Instance.new("TextButton", Tab)
        TabButton.Text = ""
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, 0, 1, 0)

        local TabName = Instance.new("TextLabel", Tab)
        TabName.Font = Enum.Font.GothamBold
        TabName.Text = TabConfig.Name
        TabName.TextColor3 = CurrentTheme.Text
        TabName.TextSize = 13
        TabName.TextXAlignment = Enum.TextXAlignment.Left
        TabName.BackgroundTransparency = 1
        TabName.Position = UDim2.new(0, 30, 0, 0)
        TabName.Size = UDim2.new(1, 0, 1, 0)

        local FeatureImg = Instance.new("ImageLabel", Tab)
        FeatureImg.Image = TabConfig.Icon
        FeatureImg.BackgroundTransparency = 1
        FeatureImg.Position = UDim2.new(0, 9, 0, 7)
        FeatureImg.Size = UDim2.new(0, 16, 0, 16)

        if CountTab == 0 then
            LayersPageLayout:JumpToIndex(0)
            NameTab.Text = TabConfig.Name
            local ChooseFrame = Instance.new("Frame", Tab)
            ChooseFrame.BackgroundColor3 = GuiConfig.Color
            ChooseFrame.Position = UDim2.new(0, 2, 0, 9)
            ChooseFrame.Size = UDim2.new(0, 1, 0, 12)
        end

        TabButton.Activated:Connect(function()
            CircleClick(TabButton, Mouse.X, Mouse.Y)
            for _, tab in ScrollTab:GetChildren() do
                if tab:IsA("Frame") then TweenService:Create(tab, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play() end
            end
            TweenService:Create(Tab, TweenInfo.new(0.6), {BackgroundTransparency = 0.92}):Play()
            LayersPageLayout:JumpToIndex(Tab.LayoutOrder)
            NameTab.Text = TabConfig.Name
        end)

        local Sections = {}
        local CountSection = 0

        function Sections:AddSection(Title)
            Title = Title or "Section"
            local Section = Instance.new("Frame", ScrolLayers)
            Section.BackgroundTransparency = 1
            Section.LayoutOrder = CountSection
            Section.Size = UDim2.new(1, 0, 0, 30)

            local SectionReal = Instance.new("Frame", Section)
            SectionReal.AnchorPoint = Vector2.new(0.5, 0)
            SectionReal.BackgroundColor3 = CurrentTheme.Background
            SectionReal.BackgroundTransparency = 0.935
            SectionReal.Position = UDim2.new(0.5, 0, 0, 0)
            SectionReal.Size = UDim2.new(1, 0, 0, 30)
            Instance.new("UICorner", SectionReal).CornerRadius = UDim.new(0, 6)

            local SectionButton = Instance.new("TextButton", SectionReal)
            SectionButton.Text = ""
            SectionButton.BackgroundTransparency = 1
            SectionButton.Size = UDim2.new(1, 0, 1, 0)

            local SectionTitle = Instance.new("TextLabel", SectionReal)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = Title
            SectionTitle.TextColor3 = CurrentTheme.Text
            SectionTitle.TextSize = 13
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.AnchorPoint = Vector2.new(0, 0.5)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 10, 0.5, 0)
            SectionTitle.Size = UDim2.new(1, -50, 0, 13)

            local FeatureImg = Instance.new("ImageLabel", SectionReal)
            FeatureImg.Image = "rbxassetid://16851841101"
            FeatureImg.AnchorPoint = Vector2.new(1, 0.5)
            FeatureImg.BackgroundTransparency = 1
            FeatureImg.Position = UDim2.new(1, -5, 0.5, 0)
            FeatureImg.Size = UDim2.new(0, 20, 0, 20)
            FeatureImg.Rotation = -90

            local SectionAdd = Instance.new("Frame", Section)
            SectionAdd.AnchorPoint = Vector2.new(0.5, 0)
            SectionAdd.BackgroundTransparency = 1
            SectionAdd.Position = UDim2.new(0.5, 0, 0, 38)
            SectionAdd.Size = UDim2.new(1, 0, 0, 0)

            local UIListLayout = Instance.new("UIListLayout", SectionAdd)
            UIListLayout.Padding = UDim.new(0, 3)

            local OpenSection = true
            local function UpdateSize()
                local OffsetY = 38
                for _, child in SectionAdd:GetChildren() do
                    if child:IsA("Frame") then OffsetY = OffsetY + child.Size.Y.Offset + 3 end
                end
                if OpenSection then
                    TweenService:Create(Section, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 0, OffsetY)}):Play()
                    TweenService:Create(FeatureImg, TweenInfo.new(0.5), {Rotation = 90}):Play()
                end
                ScrolLayers.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
            end

            SectionButton.Activated:Connect(function()
                CircleClick(SectionButton, Mouse.X, Mouse.Y)
                OpenSection = not OpenSection
                if OpenSection then UpdateSize() else
                    TweenService:Create(Section, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 0, 30)}):Play()
                    TweenService:Create(FeatureImg, TweenInfo.new(0.5), {Rotation = 0}):Play()
                end
            end)

            SectionAdd.ChildAdded:Connect(UpdateSize)
            SectionAdd.ChildRemoved:Connect(UpdateSize)

            local Items = {}
            local CountItem = 0

            function Items:AddToggle(ToggleConfig)
                ToggleConfig = ToggleConfig or {}
                ToggleConfig.Title = ToggleConfig.Title or "Toggle"
                ToggleConfig.Content = ToggleConfig.Content or "Toggle me"
                ToggleConfig.Default = ToggleConfig.Default or false
                ToggleConfig.Callback = ToggleConfig.Callback or function() end

                local Toggle = Instance.new("Frame", SectionAdd)
                Toggle.BackgroundColor3 = CurrentTheme.Background
                Toggle.BackgroundTransparency = 0.935
                Toggle.LayoutOrder = CountItem
                Toggle.Size = UDim2.new(1, 0, 0, 46)
                Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 6)

                local Title = Instance.new("TextLabel", Toggle)
                Title.Font = Enum.Font.GothamBold
                Title.Text = ToggleConfig.Title
                Title.TextColor3 = CurrentTheme.Text
                Title.TextSize = 13
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 10, 0, 10)
                Title.Size = UDim2.new(1, -100, 0, 13)

                local Content = Instance.new("TextLabel", Toggle)
                Content.Font = Enum.Font.GothamBold
                Content.Text = ToggleConfig.Content
                Content.TextColor3 = CurrentTheme.SubText
                Content.TextSize = 12
                Content.TextXAlignment = Enum.TextXAlignment.Left
                Content.BackgroundTransparency = 1
                Content.Position = UDim2.new(0, 10, 0, 23)
                Content.Size = UDim2.new(1, -100, 0, 12)
                Content.TextWrapped = true

                Content.Size = UDim2.new(1, -100, 0, 12 + (12 * math.ceil(Content.TextBounds.X / Content.AbsoluteSize.X)))
                Toggle.Size = UDim2.new(1, 0, 0, Content.AbsoluteSize.Y + 33)

                local ToggleButton = Instance.new("TextButton", Toggle)
                ToggleButton.Text = ""
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)

                local ToggleFrame = Instance.new("Frame", Toggle)
                ToggleFrame.AnchorPoint = Vector2.new(1, 0.5)
                ToggleFrame.BackgroundColor3 = CurrentTheme.Background
                ToggleFrame.BackgroundTransparency = 0.92
                ToggleFrame.Position = UDim2.new(1, -30, 0.5, 0)
                ToggleFrame.Size = UDim2.new(0, 30, 0, 15)
                Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(1, 0)

                local ToggleCircle = Instance.new("Frame", ToggleFrame)
                ToggleCircle.BackgroundColor3 = CurrentTheme.Text
                ToggleCircle.Position = UDim2.new(0, ToggleConfig.Default and 15 or 0, 0, 0)
                ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
                Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)

                local ToggleFunc = {Value = ToggleConfig.Default}
                ToggleButton.Activated:Connect(function()
                    CircleClick(ToggleButton, Mouse.X, Mouse.Y)
                    ToggleFunc.Value = not ToggleFunc.Value
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, ToggleFunc.Value and 15 or 0, 0, 0)}):Play()
                    TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = ToggleFunc.Value and GuiConfig.Color or CurrentTheme.Background}):Play()
                    ToggleConfig.Callback(ToggleFunc.Value)
                end)

                local SettingsBoard = Instance.new("Frame", Layers)
                SettingsBoard.BackgroundColor3 = CurrentTheme.Background
                SettingsBoard.BackgroundTransparency = 0.9
                SettingsBoard.Position = UDim2.new(1, -180, 0, Toggle.AbsolutePosition.Y - Layers.AbsolutePosition.Y + 50)
                SettingsBoard.Size = UDim2.new(0, 160, 0, 0)
                SettingsBoard.Visible = false
                Instance.new("UICorner", SettingsBoard).CornerRadius = UDim.new(0, 8)

                local SettingsList = Instance.new("UIListLayout", SettingsBoard)
                SettingsList.Padding = UDim.new(0, 3)

                local function UpdateSettingsSize()
                    local height = 10 -- Padding
                    for _, child in SettingsBoard:GetChildren() do
                        if child:IsA("Frame") then height = height + child.Size.Y.Offset + 3 end
                    end
                    SettingsBoard.Size = UDim2.new(0, 160, 0, height)
                end

                local Settings = {}
                function Settings:Toggle(name, config)
                    config = config or {}
                    config.Name = config.Name or "Toggle"
                    config.Default = config.Default or false
                    config.Callback = config.Callback or function() end

                    local SettingToggle = Instance.new("Frame", SettingsBoard)
                    SettingToggle.BackgroundColor3 = CurrentTheme.Background
                    SettingToggle.Size = UDim2.new(1, 0, 0, 30)
                    Instance.new("UICorner", SettingToggle).CornerRadius = UDim.new(0, 6)

                    local SettingToggleButton = Instance.new("TextButton", SettingToggle)
                    SettingToggleButton.Text = ""
                    SettingToggleButton.BackgroundTransparency = 1
                    SettingToggleButton.Size = UDim2.new(1, 0, 1, 0)

                    local SettingName = Instance.new("TextLabel", SettingToggle)
                    SettingName.Font = Enum.Font.GothamBold
                    SettingName.Text = config.Name
                    SettingName.TextColor3 = CurrentTheme.Text
                    SettingName.TextSize = 12
                    SettingName.BackgroundTransparency = 1
                    SettingName.Position = UDim2.new(0, 5, 0, 0)
                    SettingName.Size = UDim2.new(1, -40, 1, 0)

                    local SettingFrame = Instance.new("Frame", SettingToggle)
                    SettingFrame.AnchorPoint = Vector2.new(1, 0.5)
                    SettingFrame.BackgroundColor3 = CurrentTheme.Background
                    SettingFrame.Position = UDim2.new(1, -5, 0.5, 0)
                    SettingFrame.Size = UDim2.new(0, 30, 0, 15)
                    Instance.new("UICorner", SettingFrame).CornerRadius = UDim.new(1, 0)

                    local SettingCircle = Instance.new("Frame", SettingFrame)
                    SettingCircle.BackgroundColor3 = CurrentTheme.Text
                    SettingCircle.Position = UDim2.new(0, config.Default and 15 or 0, 0, 0)
                    SettingCircle.Size = UDim2.new(0, 14, 0, 14)
                    Instance.new("UICorner", SettingCircle).CornerRadius = UDim.new(1, 0)

                    local SettingFunc = {Value = config.Default}
                    SettingToggleButton.Activated:Connect(function()
                        CircleClick(SettingToggleButton, Mouse.X, Mouse.Y)
                        SettingFunc.Value = not SettingFunc.Value
                        TweenService:Create(SettingCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, SettingFunc.Value and 15 or 0, 0, 0)}):Play()
                        TweenService:Create(SettingFrame, TweenInfo.new(0.2), {BackgroundColor3 = SettingFunc.Value and GuiConfig.Color or CurrentTheme.Background}):Play()
                        config.Callback(SettingFunc.Value)
                    end)

                    UpdateSettingsSize()
                    return SettingFunc
                end

                function Settings:Slider(name, config)
                    config = config or {}
                    config.Name = config.Name or "Slider"
                    config.Min = config.Min or 0
                    config.Max = config.Max or 100
                    config.Increment = config.Increment or 1
                    config.Default = config.Default or 50
                    config.Callback = config.Callback or function() end

                    local SettingSlider = Instance.new("Frame", SettingsBoard)
                    SettingSlider.BackgroundColor3 = CurrentTheme.Background
                    SettingSlider.Size = UDim2.new(1, 0, 0, 40)
                    Instance.new("UICorner", SettingSlider).CornerRadius = UDim.new(0, 6)

                    local SettingName = Instance.new("TextLabel", SettingSlider)
                    SettingName.Font = Enum.Font.GothamBold
                    SettingName.Text = config.Name
                    SettingName.TextColor3 = CurrentTheme.Text
                    SettingName.TextSize = 12
                    SettingName.BackgroundTransparency = 1
                    SettingName.Position = UDim2.new(0, 5, 0, 5)
                    SettingName.Size = UDim2.new(1, -40, 0, 12)

                    local SliderFrame = Instance.new("Frame", SettingSlider)
                    SliderFrame.BackgroundColor3 = CurrentTheme.SubText
                    SliderFrame.BackgroundTransparency = 0.8
                    SliderFrame.Position = UDim2.new(0, 5, 0, 20)
                    SliderFrame.Size = UDim2.new(1, -10, 0, 3)
                    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 2)

                    local SliderDraggable = Instance.new("Frame", SliderFrame)
                    SliderDraggable.BackgroundColor3 = GuiConfig.Color
                    SliderDraggable.Size = UDim2.new((config.Default - config.Min) / (config.Max - config.Min), 0, 1, 0)
                    Instance.new("UICorner", SliderDraggable).CornerRadius = UDim.new(0, 2)

                    local SliderCircle = Instance.new("Frame", SliderDraggable)
                    SliderCircle.AnchorPoint = Vector2.new(1, 0.5)
                    SliderCircle.BackgroundColor3 = GuiConfig.Color
                    SliderCircle.Position = UDim2.new(1, 4, 0.5, 0)
                    SliderCircle.Size = UDim2.new(0, 8, 0, 8)
                    Instance.new("UICorner", SliderCircle).CornerRadius = UDim.new(1, 0)

                    local SliderFunc = {Value = config.Default}
                    local Dragging = false

                    SliderFrame.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true end
                    end)

                    SliderFrame.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Dragging = false
                            config.Callback(SliderFunc.Value)
                        end
                    end)

                    UserInputService.InputChanged:Connect(function(input)
                        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            local SizeScale = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
                            SliderFunc.Value = math.floor(config.Min + ((config.Max - config.Min) * SizeScale) / config.Increment) * config.Increment
                            TweenService:Create(SliderDraggable, TweenInfo.new(0.1), {Size = UDim2.new(SizeScale, 0, 1, 0)}):Play()
                        end
                    end)

                    UpdateSettingsSize()
                    return SliderFunc
                end

                ToggleButton.MouseButton2Click:Connect(function()
                    SettingsBoard.Visible = not SettingsBoard.Visible
                end)

                CountItem = CountItem + 1
                return {
                    Value = ToggleFunc.Value,
                    AddSetting = function() return Settings end,
                    Set = function(value)
                        ToggleFunc.Value = value
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, ToggleFunc.Value and 15 or 0, 0, 0)}):Play()
                        TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = ToggleFunc.Value and GuiConfig.Color or CurrentTheme.Background}):Play()
                        ToggleConfig.Callback(ToggleFunc.Value)
                    end
                }
            end

            function Items:AddMultiToggle(ToggleConfig)
                ToggleConfig = ToggleConfig or {}
                ToggleConfig.Title = ToggleConfig.Title or "Multi Toggle"
                ToggleConfig.Content = ToggleConfig.Content or "Select options"
                ToggleConfig.Options = ToggleConfig.Options or {"Option 1", "Option 2"}
                ToggleConfig.Default = ToggleConfig.Default or {}
                ToggleConfig.Callback = ToggleConfig.Callback or function() end

                local Toggle = Instance.new("Frame", SectionAdd)
                Toggle.BackgroundColor3 = CurrentTheme.Background
                Toggle.BackgroundTransparency = 0.935
                Toggle.LayoutOrder = CountItem
                Toggle.Size = UDim2.new(1, 0, 0, 46)
                Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 6)

                local Title = Instance.new("TextLabel", Toggle)
                Title.Font = Enum.Font.GothamBold
                Title.Text = ToggleConfig.Title
                Title.TextColor3 = CurrentTheme.Text
                Title.TextSize = 13
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 10, 0, 10)
                Title.Size = UDim2.new(1, -180, 0, 13)

                local Content = Instance.new("TextLabel", Toggle)
                Content.Font = Enum.Font.GothamBold
                Content.Text = ToggleConfig.Content
                Content.TextColor3 = CurrentTheme.SubText
                Content.TextSize = 12
                Content.TextXAlignment = Enum.TextXAlignment.Left
                Content.BackgroundTransparency = 1
                Content.Position = UDim2.new(0, 10, 0, 23)
                Content.Size = UDim2.new(1, -180, 0, 12)
                Content.TextWrapped = true

                Content.Size = UDim2.new(1, -180, 0, 12 + (12 * math.ceil(Content.TextBounds.X / Content.AbsoluteSize.X)))
                Toggle.Size = UDim2.new(1, 0, 0, Content.AbsoluteSize.Y + 33)

                local ToggleButton = Instance.new("TextButton", Toggle)
                ToggleButton.Text = ""
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)

                local SelectFrame = Instance.new("Frame", Toggle)
                SelectFrame.AnchorPoint = Vector2.new(1, 0.5)
                SelectFrame.BackgroundColor3 = CurrentTheme.Background
                SelectFrame.BackgroundTransparency = 0.95
                SelectFrame.Position = UDim2.new(1, -7, 0.5, 0)
                SelectFrame.Size = UDim2.new(0, 148, 0, 30)
                SelectFrame.LayoutOrder = CountDropdown
                Instance.new("UICorner", SelectFrame).CornerRadius = UDim.new(0, 6)

                local OptionText = Instance.new("TextLabel", SelectFrame)
                OptionText.Font = Enum.Font.GothamBold
                OptionText.Text = table.concat(ToggleConfig.Default, ", ") ~= "" and table.concat(ToggleConfig.Default, ", ") or "None"
                OptionText.TextColor3 = CurrentTheme.SubText
                OptionText.TextSize = 12
                OptionText.TextXAlignment = Enum.TextXAlignment.Left
                OptionText.BackgroundTransparency = 1
                OptionText.Position = UDim2.new(0, 5, 0, 0)
                OptionText.Size = UDim2.new(1, -30, 1, 0)

                local ScrollSelect = Instance.new("ScrollingFrame", DropdownFolder)
                ScrollSelect.BackgroundTransparency = 1
                ScrollSelect.ScrollBarThickness = 0
                ScrollSelect.LayoutOrder = CountDropdown
                ScrollSelect.Size = UDim2.new(1, 0, 1, 0)

                local UIListLayout = Instance.new("UIListLayout", ScrollSelect)
                UIListLayout.Padding = UDim.new(0, 3)

                local ToggleFunc = {
                    Value = ToggleConfig.Default,
                    Options = ToggleConfig.Options,
                    UpdateOptions = function()
                        for _, child in ipairs(ScrollSelect:GetChildren()) do
                            if child:IsA("Frame") then child:Destroy() end
                        end
                        for _, option in ipairs(ToggleFunc.Options) do
                            local Option = Instance.new("Frame", ScrollSelect)
                            Option.BackgroundTransparency = 1
                            Option.Size = UDim2.new(1, 0, 0, 30)

                            local OptionButton = Instance.new("TextButton", Option)
                            OptionButton.Text = ""
                            OptionButton.BackgroundTransparency = 1
                            OptionButton.Size = UDim2.new(1, 0, 1, 0)

                            local OptionLabel = Instance.new("TextLabel", Option)
                            OptionLabel.Font = Enum.Font.GothamBold
                            OptionLabel.Text = option
                            OptionLabel.TextColor3 = CurrentTheme.Text
                            OptionLabel.TextSize = 13
                            OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
                            OptionLabel.BackgroundTransparency = 1
                            OptionLabel.Position = UDim2.new(0, 8, 0, 0)
                            OptionLabel.Size = UDim2.new(1, -30, 1, 0)

                            local CheckIcon = Instance.new("ImageLabel", Option)
                            CheckIcon.Image = "rbxassetid://7072706620"
                            CheckIcon.BackgroundTransparency = 1
                            CheckIcon.Position = UDim2.new(1, -25, 0, 5)
                            CheckIcon.Size = UDim2.new(0, 20, 0, 20)
                            CheckIcon.Visible = table.find(ToggleFunc.Value, option) ~= nil

                            OptionButton.Activated:Connect(function()
                                CircleClick(OptionButton, Mouse.X, Mouse.Y)
                                if table.find(ToggleFunc.Value, option) then
                                    table.remove(ToggleFunc.Value, table.find(ToggleFunc.Value, option))
                                else
                                    table.insert(ToggleFunc.Value, option)
                                end
                                CheckIcon.Visible = table.find(ToggleFunc.Value, option) ~= nil
                                OptionText.Text = table.concat(ToggleFunc.Value, ", ") ~= "" and table.concat(ToggleFunc.Value, ", ") or "None"
                                ToggleConfig.Callback(ToggleFunc.Value)
                            end)
                        end
                        ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, (#ToggleFunc.Options * 33))
                    end
                }
                ToggleFunc:UpdateOptions()

                ToggleButton.Activated:Connect(function()
                    MoreBlur.Visible = true
                    DropPageLayout:JumpToIndex(SelectFrame.LayoutOrder)
                    TweenService:Create(MoreBlur, TweenInfo.new(0.3), {BackgroundTransparency = 0.7}):Play()
                    TweenService:Create(DropdownSelect, TweenInfo.new(0.3), {Position = UDim2.new(1, -11, 0.5, 0)}):Play()
                end)

                local SettingsBoard = Instance.new("Frame", Layers)
                SettingsBoard.BackgroundColor3 = CurrentTheme.Background
                SettingsBoard.BackgroundTransparency = 0.9
                SettingsBoard.Position = UDim2.new(1, -180, 0, Toggle.AbsolutePosition.Y - Layers.AbsolutePosition.Y + 50)
                SettingsBoard.Size = UDim2.new(0, 160, 0, 0)
                SettingsBoard.Visible = false
                Instance.new("UICorner", SettingsBoard).CornerRadius = UDim.new(0, 8)

                local SettingsList = Instance.new("UIListLayout", SettingsBoard)
                SettingsList.Padding = UDim.new(0, 3)

                local function UpdateSettingsSize()
                    local height = 10 -- Padding
                    for _, child in SettingsBoard:GetChildren() do
                        if child:IsA("Frame") then height = height + child.Size.Y.Offset + 3 end
                    end
                    SettingsBoard.Size = UDim2.new(0, 160, 0, height)
                end

                local Settings = {}
                function Settings:Toggle(name, config)
                    config = config or {}
                    config.Name = config.Name or "Toggle"
                    config.Default = config.Default or false
                    config.Callback = config.Callback or function() end

                    local SettingToggle = Instance.new("Frame", SettingsBoard)
                    SettingToggle.BackgroundColor3 = CurrentTheme.Background
                    SettingToggle.Size = UDim2.new(1, 0, 0, 30)
                    Instance.new("UICorner", SettingToggle).CornerRadius = UDim.new(0, 6)

                    local SettingToggleButton = Instance.new("TextButton", SettingToggle)
                    SettingToggleButton.Text = ""
                    SettingToggleButton.BackgroundTransparency = 1
                    SettingToggleButton.Size = UDim2.new(1, 0, 1, 0)

                    local SettingName = Instance.new("TextLabel", SettingToggle)
                    SettingName.Font = Enum.Font.GothamBold
                    SettingName.Text = config.Name
                    SettingName.TextColor3 = CurrentTheme.Text
                    SettingName.TextSize = 12
                    SettingName.BackgroundTransparency = 1
                    SettingName.Position = UDim2.new(0, 5, 0, 0)
                    SettingName.Size = UDim2.new(1, -40, 1, 0)

                    local SettingFrame = Instance.new("Frame", SettingToggle)
                    SettingFrame.AnchorPoint = Vector2.new(1, 0.5)
                    SettingFrame.BackgroundColor3 = CurrentTheme.Background
                    SettingFrame.Position = UDim2.new(1, -5, 0.5, 0)
                    SettingFrame.Size = UDim2.new(0, 30, 0, 15)
                    Instance.new("UICorner", SettingFrame).CornerRadius = UDim.new(1, 0)

                    local SettingCircle = Instance.new("Frame", SettingFrame)
                    SettingCircle.BackgroundColor3 = CurrentTheme.Text
                    SettingCircle.Position = UDim2.new(0, config.Default and 15 or 0, 0, 0)
                    SettingCircle.Size = UDim2.new(0, 14, 0, 14)
                    Instance.new("UICorner", SettingCircle).CornerRadius = UDim.new(1, 0)

                    local SettingFunc = {Value = config.Default}
                    SettingToggleButton.Activated:Connect(function()
                        CircleClick(SettingToggleButton, Mouse.X, Mouse.Y)
                        SettingFunc.Value = not SettingFunc.Value
                        TweenService:Create(SettingCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, SettingFunc.Value and 15 or 0, 0, 0)}):Play()
                        TweenService:Create(SettingFrame, TweenInfo.new(0.2), {BackgroundColor3 = SettingFunc.Value and GuiConfig.Color or CurrentTheme.Background}):Play()
                        config.Callback(SettingFunc.Value)
                    end)

                    UpdateSettingsSize()
                    return SettingFunc
                end

                function Settings:Slider(name, config)
                    config = config or {}
                    config.Name = config.Name or "Slider"
                    config.Min = config.Min or 0
                    config.Max = config.Max or 100
                    config.Increment = config.Increment or 1
                    config.Default = config.Default or 50
                    config.Callback = config.Callback or function() end

                    local SettingSlider = Instance.new("Frame", SettingsBoard)
                    SettingSlider.BackgroundColor3 = CurrentTheme.Background
                    SettingSlider.Size = UDim2.new(1, 0, 0, 40)
                    Instance.new("UICorner", SettingSlider).CornerRadius = UDim.new(0, 6)

                    local SettingName = Instance.new("TextLabel", SettingSlider)
                    SettingName.Font = Enum.Font.GothamBold
                    SettingName.Text = config.Name
                    SettingName.TextColor3 = CurrentTheme.Text
                    SettingName.TextSize = 12
                    SettingName.BackgroundTransparency = 1
                    SettingName.Position = UDim2.new(0, 5, 0, 5)
                    SettingName.Size = UDim2.new(1, -40, 0, 12)

                    local SliderFrame = Instance.new("Frame", SettingSlider)
                    SliderFrame.BackgroundColor3 = CurrentTheme.SubText
                    SliderFrame.BackgroundTransparency = 0.8
                    SliderFrame.Position = UDim2.new(0, 5, 0, 20)
                    SliderFrame.Size = UDim2.new(1, -10, 0, 3)
                    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 2)

                    local SliderDraggable = Instance.new("Frame", SliderFrame)
                    SliderDraggable.BackgroundColor3 = GuiConfig.Color
                    SliderDraggable.Size = UDim2.new((config.Default - config.Min) / (config.Max - config.Min), 0, 1, 0)
                    Instance.new("UICorner", SliderDraggable).CornerRadius = UDim.new(0, 2)

                    local SliderCircle = Instance.new("Frame", SliderDraggable)
                    SliderCircle.AnchorPoint = Vector2.new(1, 0.5)
                    SliderCircle.BackgroundColor3 = GuiConfig.Color
                    SliderCircle.Position = UDim2.new(1, 4, 0.5, 0)
                    SliderCircle.Size = UDim2.new(0, 8, 0, 8)
                    Instance.new("UICorner", SliderCircle).CornerRadius = UDim.new(1, 0)

                    local SliderFunc = {Value = config.Default}
                    local Dragging = false

                    SliderFrame.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true end
                    end)

                    SliderFrame.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Dragging = false
                            config.Callback(SliderFunc.Value)
                        end
                    end)

                    UserInputService.InputChanged:Connect(function(input)
                        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            local SizeScale = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
                            SliderFunc.Value = math.floor(config.Min + ((config.Max - config.Min) * SizeScale) / config.Increment) * config.Increment
                            TweenService:Create(SliderDraggable, TweenInfo.new(0.1), {Size = UDim2.new(SizeScale, 0, 1, 0)}):Play()
                        end
                    end)

                    UpdateSettingsSize()
                    return SliderFunc
                end

                ToggleButton.MouseButton2Click:Connect(function()
                    SettingsBoard.Visible = not SettingsBoard.Visible
                end)

                CountItem = CountItem + 1
                CountDropdown = CountDropdown + 1
                return {
                    Value = ToggleFunc.Value,
                    AddSetting = function() return Settings end,
                    Set = function(value)
                        ToggleFunc.Value = value
                        OptionText.Text = table.concat(value, ", ") ~= "" and table.concat(value, ", ") or "None"
                        ToggleFunc:UpdateOptions()
                        ToggleConfig.Callback(ToggleFunc.Value)
                    end
                }
            end

            function Items:AddSlider(SliderConfig)
                SliderConfig = SliderConfig or {}
                SliderConfig.Title = SliderConfig.Title or "Slider"
                SliderConfig.Content = SliderConfig.Content or "Adjust me"
                SliderConfig.Min = SliderConfig.Min or 0
                SliderConfig.Max = SliderConfig.Max or 100
                SliderConfig.Increment = SliderConfig.Increment or 1
                SliderConfig.Default = SliderConfig.Default or 50
                SliderConfig.Callback = SliderConfig.Callback or function() end

                local Slider = Instance.new("Frame", SectionAdd)
                Slider.BackgroundColor3 = CurrentTheme.Background
                Slider.BackgroundTransparency = 0.935
                Slider.LayoutOrder = CountItem
                Slider.Size = UDim2.new(1, 0, 0, 46)
                Instance.new("UICorner", Slider).CornerRadius = UDim.new(0, 6)

                local Title = Instance.new("TextLabel", Slider)
                Title.Font = Enum.Font.GothamBold
                Title.Text = SliderConfig.Title
                Title.TextColor3 = CurrentTheme.Text
                Title.TextSize = 13
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 10, 0, 10)
                Title.Size = UDim2.new(1, -180, 0, 13)

                local Content = Instance.new("TextLabel", Slider)
                Content.Font = Enum.Font.GothamBold
                Content.Text = SliderConfig.Content
                Content.TextColor3 = CurrentTheme.SubText
                Content.TextSize = 12
                Content.TextXAlignment = Enum.TextXAlignment.Left
                Content.BackgroundTransparency = 1
                Content.Position = UDim2.new(0, 10, 0, 23)
                Content.Size = UDim2.new(1, -180, 0, 12)
                Content.TextWrapped = true

                Content.Size = UDim2.new(1, -180, 0, 12 + (12 * math.ceil(Content.TextBounds.X / Content.AbsoluteSize.X)))
                Slider.Size = UDim2.new(1, 0, 0, Content.AbsoluteSize.Y + 33)

                local SliderFrame = Instance.new("Frame", Slider)
                SliderFrame.AnchorPoint = Vector2.new(1, 0.5)
                SliderFrame.BackgroundColor3 = CurrentTheme.SubText
                SliderFrame.BackgroundTransparency = 0.8
                SliderFrame.Position = UDim2.new(1, -20, 0.5, 0)
                SliderFrame.Size = UDim2.new(0, 100, 0, 3)
                Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 2)

                local SliderDraggable = Instance.new("Frame", SliderFrame)
                SliderDraggable.BackgroundColor3 = GuiConfig.Color
                SliderDraggable.Size = UDim2.new((SliderConfig.Default - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 0, 1, 0)
                Instance.new("UICorner", SliderDraggable).CornerRadius = UDim.new(0, 2)

                local SliderCircle = Instance.new("Frame", SliderDraggable)
                SliderCircle.AnchorPoint = Vector2.new(1, 0.5)
                SliderCircle.BackgroundColor3 = GuiConfig.Color
                SliderCircle.Position = UDim2.new(1, 4, 0.5, 0)
                SliderCircle.Size = UDim2.new(0, 8, 0, 8)
                Instance.new("UICorner", SliderCircle).CornerRadius = UDim.new(1, 0)

                local TextBox = Instance.new("TextBox", Slider)
                TextBox.Font = Enum.Font.GothamBold
                TextBox.Text = tostring(SliderConfig.Default)
                TextBox.TextColor3 = CurrentTheme.Text
                TextBox.TextSize = 13
                TextBox.BackgroundColor3 = CurrentTheme.Background
                TextBox.BackgroundTransparency = 0.9
                TextBox.Position = UDim2.new(1, -155, 0.5, -10)
                TextBox.Size = UDim2.new(0, 28, 0, 20)
                Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)

                local SliderFunc = {Value = SliderConfig.Default}
                local Dragging = false

                SliderFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true end
                end)

                SliderFrame.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = false
                        SliderConfig.Callback(SliderFunc.Value)
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local SizeScale = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
                        SliderFunc.Value = math.floor(SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale) / SliderConfig.Increment) * SliderConfig.Increment
                        TextBox.Text = SliderFunc.Value
                        TweenService:Create(SliderDraggable, TweenInfo.new(0.1), {Size = UDim2.new(SizeScale, 0, 1, 0)}):Play()
                    end
                end)

                TextBox.FocusLost:Connect(function()
                    local val = tonumber(TextBox.Text) or SliderFunc.Value
                    SliderFunc.Value = math.clamp(math.floor(val / SliderConfig.Increment) * SliderConfig.Increment, SliderConfig.Min, SliderConfig.Max)
                    TextBox.Text = SliderFunc.Value
                    TweenService:Create(SliderDraggable, TweenInfo.new(0.1), {Size = UDim2.new((SliderFunc.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 0, 1, 0)}):Play()
                    SliderConfig.Callback(SliderFunc.Value)
                end)

                CountItem = CountItem + 1
                return {
                    Value = SliderFunc.Value,
                    Set = function(value)
                        SliderFunc.Value = math.clamp(math.floor(value / SliderConfig.Increment) * SliderConfig.Increment, SliderConfig.Min, SliderConfig.Max)
                        TextBox.Text = SliderFunc.Value
                        TweenService:Create(SliderDraggable, TweenInfo.new(0.1), {Size = UDim2.new((SliderFunc.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 0, 1, 0)}):Play()
                        SliderConfig.Callback(SliderFunc.Value)
                    end
                }
            end

            function Items:AddDropdown(DropdownConfig)
                DropdownConfig = DropdownConfig or {}
                DropdownConfig.Title = DropdownConfig.Title or "Dropdown"
                DropdownConfig.Content = DropdownConfig.Content or "Select an option"
                DropdownConfig.Options = DropdownConfig.Options or {"Option 1", "Option 2"}
                DropdownConfig.Default = DropdownConfig.Default or DropdownConfig.Options[1]
                DropdownConfig.Callback = DropdownConfig.Callback or function() end

                local Dropdown = Instance.new("Frame", SectionAdd)
                Dropdown.BackgroundColor3 = CurrentTheme.Background
                Dropdown.BackgroundTransparency = 0.935
                Dropdown.LayoutOrder = CountItem
                Dropdown.Size = UDim2.new(1, 0, 0, 46)
                Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 6)

                local Title = Instance.new("TextLabel", Dropdown)
                Title.Font = Enum.Font.GothamBold
                Title.Text = DropdownConfig.Title
                Title.TextColor3 = CurrentTheme.Text
                Title.TextSize = 13
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 10, 0, 10)
                Title.Size = UDim2.new(1, -180, 0, 13)

                local Content = Instance.new("TextLabel", Dropdown)
                Content.Font = Enum.Font.GothamBold
                Content.Text = DropdownConfig.Content
                Content.TextColor3 = CurrentTheme.SubText
                Content.TextSize = 12
                Content.TextXAlignment = Enum.TextXAlignment.Left
                Content.BackgroundTransparency = 1
                Content.Position = UDim2.new(0, 10, 0, 23)
                Content.Size = UDim2.new(1, -180, 0, 12)
                Content.TextWrapped = true

                Content.Size = UDim2.new(1, -180, 0, 12 + (12 * math.ceil(Content.TextBounds.X / Content.AbsoluteSize.X)))
                Dropdown.Size = UDim2.new(1, 0, 0, Content.AbsoluteSize.Y + 33)

                local DropdownButton = Instance.new("TextButton", Dropdown)
                DropdownButton.Text = ""
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Size = UDim2.new(1, 0, 1, 0)

                local SelectFrame = Instance.new("Frame", Dropdown)
                SelectFrame.AnchorPoint = Vector2.new(1, 0.5)
                SelectFrame.BackgroundColor3 = CurrentTheme.Background
                SelectFrame.BackgroundTransparency = 0.95
                SelectFrame.Position = UDim2.new(1, -7, 0.5, 0)
                SelectFrame.Size = UDim2.new(0, 148, 0, 30)
                SelectFrame.LayoutOrder = CountDropdown
                Instance.new("UICorner", SelectFrame).CornerRadius = UDim.new(0, 6)

                local OptionText = Instance.new("TextLabel", SelectFrame)
                OptionText.Font = Enum.Font.GothamBold
                OptionText.Text = DropdownConfig.Default
                OptionText.TextColor3 = CurrentTheme.SubText
                OptionText.TextSize = 12
                OptionText.TextXAlignment = Enum.TextXAlignment.Left
                OptionText.BackgroundTransparency = 1
                OptionText.Position = UDim2.new(0, 5, 0, 0)
                OptionText.Size = UDim2.new(1, -30, 1, 0)

                local ScrollSelect = Instance.new("ScrollingFrame", DropdownFolder)
                ScrollSelect.BackgroundTransparency = 1
                ScrollSelect.ScrollBarThickness = 0
                ScrollSelect.LayoutOrder = CountDropdown
                ScrollSelect.Size = UDim2.new(1, 0, 1, 0)

                local UIListLayout = Instance.new("UIListLayout", ScrollSelect)
                UIListLayout.Padding = UDim.new(0, 3)

                local DropdownFunc = {
                    Value = DropdownConfig.Default,
                    Options = DropdownConfig.Options,
                    UpdateOptions = function()
                        for _, child in ipairs(ScrollSelect:GetChildren()) do
                            if child:IsA("Frame") then child:Destroy() end
                        end
                        for _, option in ipairs(DropdownFunc.Options) do
                            local Option = Instance.new("Frame", ScrollSelect)
                            Option.BackgroundTransparency = 1
                            Option.Size = UDim2.new(1, 0, 0, 30)

                            local OptionButton = Instance.new("TextButton", Option)
                            OptionButton.Text = ""
                            OptionButton.BackgroundTransparency = 1
                            OptionButton.Size = UDim2.new(1, 0, 1, 0)

                            local OptionLabel = Instance.new("TextLabel", Option)
                            OptionLabel.Font = Enum.Font.GothamBold
                            OptionLabel.Text = option
                            OptionLabel.TextColor3 = CurrentTheme.Text
                            OptionLabel.TextSize = 13
                            OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
                            OptionLabel.BackgroundTransparency = 1
                            OptionLabel.Position = UDim2.new(0, 8, 0, 0)
                            OptionLabel.Size = UDim2.new(1, -8, 1, 0)

                            OptionButton.Activated:Connect(function()
                                CircleClick(OptionButton, Mouse.X, Mouse.Y)
                                DropdownFunc.Value = option
                                OptionText.Text = option
                                TweenService:Create(MoreBlur, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                                TweenService:Create(DropdownSelect, TweenInfo.new(0.3), {Position = UDim2.new(1, 172, 0.5, 0)}):Play()
                                task.wait(0.3)
                                MoreBlur.Visible = false
                                DropdownConfig.Callback(DropdownFunc.Value)
                            end)
                        end
                        ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, (#DropdownFunc.Options * 33))
                    end
                }
                DropdownFunc:UpdateOptions()

                DropdownButton.Activated:Connect(function()
                    MoreBlur.Visible = true
                    DropPageLayout:JumpToIndex(SelectFrame.LayoutOrder)
                    TweenService:Create(MoreBlur, TweenInfo.new(0.3), {BackgroundTransparency = 0.7}):Play()
                    TweenService:Create(DropdownSelect, TweenInfo.new(0.3), {Position = UDim2.new(1, -11, 0.5, 0)}):Play()
                end)

                CountItem = CountItem + 1
                CountDropdown = CountDropdown + 1
                return {
                    Value = DropdownFunc.Value,
                    Set = function(value)
                        if table.find(DropdownFunc.Options, value) then
                            DropdownFunc.Value = value
                            OptionText.Text = value
                            DropdownConfig.Callback(DropdownFunc.Value)
                        end
                    end,
                    AddOption = function(option)
                        table.insert(DropdownFunc.Options, option)
                        DropdownFunc:UpdateOptions()
                    end,
                    Clear = function()
                        DropdownFunc.Options = {}
                        DropdownFunc.Value = ""
                        OptionText.Text = ""
                        DropdownFunc:UpdateOptions()
                    end,
                    Refresh = function(options, default)
                        DropdownFunc.Options = options
                        DropdownFunc.Value = default or options[1] or ""
                        OptionText.Text = DropdownFunc.Value
                        DropdownFunc:UpdateOptions()
                        DropdownConfig.Callback(DropdownFunc.Value)
                    end
                }
            end

            function Items:AddMultiDropdown(DropdownConfig)
                DropdownConfig = DropdownConfig or {}
                DropdownConfig.Title = DropdownConfig.Title or "Multi Dropdown"
                DropdownConfig.Content = DropdownConfig.Content or "Select multiple options"
                DropdownConfig.Options = DropdownConfig.Options or {"Option 1", "Option 2"}
                DropdownConfig.Default = DropdownConfig.Default or {}
                DropdownConfig.Callback = DropdownConfig.Callback or function() end

                local Dropdown = Instance.new("Frame", SectionAdd)
                Dropdown.BackgroundColor3 = CurrentTheme.Background
                Dropdown.BackgroundTransparency = 0.935
                Dropdown.LayoutOrder = CountItem
                Dropdown.Size = UDim2.new(1, 0, 0, 46)
                Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 6)

                local Title = Instance.new("TextLabel", Dropdown)
                Title.Font = Enum.Font.GothamBold
                Title.Text = DropdownConfig.Title
                Title.TextColor3 = CurrentTheme.Text
                Title.TextSize = 13
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.BackgroundTransparency = 1
                Title.Position = UDim2.new(0, 10, 0, 10)
                Title.Size = UDim2.new(1, -180, 0, 13)

                local Content = Instance.new("TextLabel", Dropdown)
                Content.Font = Enum.Font.GothamBold
                Content.Text = DropdownConfig.Content
                Content.TextColor3 = CurrentTheme.SubText
                Content.TextSize = 12
                Content.TextXAlignment = Enum.TextXAlignment.Left
                Content.BackgroundTransparency = 1
                Content.Position = UDim2.new(0, 10, 0, 23)
                Content.Size = UDim2.new(1, -180, 0, 12)
                Content.TextWrapped = true

                Content.Size = UDim2.new(1, -180, 0, 12 + (12 * math.ceil(Content.TextBounds.X / Content.AbsoluteSize.X)))
                Dropdown.Size = UDim2.new(1, 0, 0, Content.AbsoluteSize.Y + 33)

                local DropdownButton = Instance.new("TextButton", Dropdown)
                DropdownButton.Text = ""
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Size = UDim2.new(1, 0, 1, 0)

                local SelectFrame = Instance.new("Frame", Dropdown)
                SelectFrame.AnchorPoint = Vector2.new(1, 0.5)
                SelectFrame.BackgroundColor3 = CurrentTheme.Background
                SelectFrame.BackgroundTransparency = 0.95
                SelectFrame.Position = UDim2.new(1, -7, 0.5, 0)
                SelectFrame.Size = UDim2.new(0, 148, 0, 30)
                SelectFrame.LayoutOrder = CountDropdown
                Instance.new("UICorner", SelectFrame).CornerRadius = UDim.new(0, 6)

                local OptionText = Instance.new("TextLabel", SelectFrame)
                OptionText.Font = Enum.Font.GothamBold
                OptionText.Text = table.concat(DropdownConfig.Default, ", ") ~= "" and table.concat(DropdownConfig.Default, ", ") or "None"
                OptionText.TextColor3 = CurrentTheme.SubText
                OptionText.TextSize = 12
                OptionText.TextXAlignment = Enum.TextXAlignment.Left
                OptionText.BackgroundTransparency = 1
                OptionText.Position = UDim2.new(0, 5, 0, 0)
                OptionText.Size = UDim2.new(1, -30, 1, 0)

                local ScrollSelect = Instance.new("ScrollingFrame", DropdownFolder)
                ScrollSelect.BackgroundTransparency = 1
                ScrollSelect.ScrollBarThickness = 0
                ScrollSelect.LayoutOrder = CountDropdown
                ScrollSelect.Size = UDim2.new(1, 0, 1, 0)

                local UIListLayout = Instance.new("UIListLayout", ScrollSelect)
                UIListLayout.Padding = UDim.new(0, 3)

                local DropdownFunc = {
                    Value = DropdownConfig.Default,
                    Options = DropdownConfig.Options,
                    UpdateOptions = function()
                        for _, child in ipairs(ScrollSelect:GetChildren()) do
                            if child:IsA("Frame") then child:Destroy() end
                        end
                        for _, option in ipairs(DropdownFunc.Options) do
                            local Option = Instance.new("Frame", ScrollSelect)
                            Option.BackgroundTransparency = 1
                            Option.Size = UDim2.new(1, 0, 0, 30)

                            local OptionButton = Instance.new("TextButton", Option)
                            OptionButton.Text = ""
                            OptionButton.BackgroundTransparency = 1
                            OptionButton.Size = UDim2.new(1, 0, 1, 0)

                            local OptionLabel = Instance.new("TextLabel", Option)
                            OptionLabel.Font = Enum.Font.GothamBold
                            OptionLabel.Text = option
                            OptionLabel.TextColor3 = CurrentTheme.Text
                            OptionLabel.TextSize = 13
                            OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
                            OptionLabel.BackgroundTransparency = 1
                            OptionLabel.Position = UDim2.new(0, 8, 0, 0)
                            OptionLabel.Size = UDim2.new(1, -30, 1, 0)

                            local CheckIcon = Instance.new("ImageLabel", Option)
                            CheckIcon.Image = "rbxassetid://7072706620"
                            CheckIcon.BackgroundTransparency = 1
                            CheckIcon.Position = UDim2.new(1, -25, 0, 5)
                            CheckIcon.Size = UDim2.new(0, 20, 0, 20)
                            CheckIcon.Visible = table.find(DropdownFunc.Value, option) ~= nil

                            OptionButton.Activated:Connect(function()
                                CircleClick(OptionButton, Mouse.X, Mouse.Y)
                                if table.find(DropdownFunc.Value, option) then
                                    table.remove(DropdownFunc.Value, table.find(DropdownFunc.Value, option))
                                else
                                    table.insert(DropdownFunc.Value, option)
                                end
                                CheckIcon.Visible = table.find(DropdownFunc.Value, option) ~= nil
                                OptionText.Text = table.concat(DropdownFunc.Value, ", ") ~= "" and table.concat(DropdownFunc.Value, ", ") or "None"
                                DropdownConfig.Callback(DropdownFunc.Value)
                            end)
                        end
                        ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, (#DropdownFunc.Options * 33))
                    end
                }
                DropdownFunc:UpdateOptions()

                DropdownButton.Activated:Connect(function()
                    MoreBlur.Visible = true
                    DropPageLayout:JumpToIndex(SelectFrame.LayoutOrder)
                    TweenService:Create(MoreBlur, TweenInfo.new(0.3), {BackgroundTransparency = 0.7}):Play()
                    TweenService:Create(DropdownSelect, TweenInfo.new(0.3), {Position = UDim2.new(1, -11, 0.5, 0)}):Play()
                end)

                CountItem = CountItem + 1
                CountDropdown = CountDropdown + 1
                return {
                    Value = DropdownFunc.Value,
                    Set = function(value)
                        DropdownFunc.Value = value
                        OptionText.Text = table.concat(value, ", ") ~= "" and table.concat(value, ", ") or "None"
                        DropdownFunc:UpdateOptions()
                        DropdownConfig.Callback(DropdownFunc.Value)
                    end,
                    AddOption = function(option)
                        table.insert(DropdownFunc.Options, option)
                        DropdownFunc:UpdateOptions()
                    end,
                    Clear = function()
                        DropdownFunc.Options = {}
                        DropdownFunc.Value = {}
                        OptionText.Text = "None"
                        DropdownFunc:UpdateOptions()
                    end,
                    Refresh = function(options, default)
                        DropdownFunc.Options = options
                        DropdownFunc.Value = default or {}
                        OptionText.Text = table.concat(DropdownFunc.Value, ", ") ~= "" and table.concat(DropdownFunc.Value, ", ") or "None"
                        DropdownFunc:UpdateOptions()
                        DropdownConfig.Callback(DropdownFunc.Value)
                    end
                }
            end

            CountSection = CountSection + 1
            return Items
        end

        CountTab = CountTab + 1
        return Sections
    end

    return {Tabs = Tabs, DestroyGui = function() HirimiGui:Destroy() end}
end

-- Theme Switcher
function CatLib:SetTheme(themeName)
    CurrentTheme = Themes[themeName] or Themes.Dark
end

return CatLib