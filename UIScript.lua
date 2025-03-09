
-- Cat Library UI
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local CatLibrary = {}
CatLibrary.__index = CatLibrary

-- Cài đặt màu sắc 
local THEME = {
    Background = Color3.fromRGB(40, 40, 45),
    Primary = Color3.fromRGB(70, 130, 220),
    Secondary = Color3.fromRGB(50, 50, 55),
    Text = Color3.fromRGB(240, 240, 240),
    Accent = Color3.fromRGB(255, 120, 120),
    Success = Color3.fromRGB(100, 200, 100),
    Shadow = Color3.fromRGB(20, 20, 25)
}

function CatLibrary.new(title)
    local self = setmetatable({}, CatLibrary)
    
    -- Tạo ScreenGui chính
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "CatLibrary"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Tạo MainFrame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 500, 0, 350)
    self.MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    self.MainFrame.BackgroundColor3 = THEME.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Parent = self.ScreenGui
    
    -- Làm tròn góc cho MainFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.MainFrame
    
    -- Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = THEME.Shadow
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.Parent = self.MainFrame
    
    -- Tạo Titlebar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.BackgroundColor3 = THEME.Primary
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    -- Làm tròn góc cho TitleBar
    local cornerTitle = Instance.new("UICorner")
    cornerTitle.CornerRadius = UDim.new(0, 8)
    cornerTitle.Parent = self.TitleBar
    
    -- Đảm bảo góc dưới không bị bo
    local fixCorner = Instance.new("Frame")
    fixCorner.Name = "FixCorner"
    fixCorner.Size = UDim2.new(1, 0, 0, 10)
    fixCorner.Position = UDim2.new(0, 0, 1, -10)
    fixCorner.BackgroundColor3 = THEME.Primary
    fixCorner.BorderSizePixel = 0
    fixCorner.ZIndex = 0
    fixCorner.Parent = self.TitleBar
    
    -- Tạo tiêu đề
    self.Title = Instance.new("TextLabel")
    self.Title.Name = "Title"
    self.Title.Size = UDim2.new(1, -40, 1, 0)
    self.Title.Position = UDim2.new(0, 15, 0, 0)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = title or "Cat Library"
    self.Title.TextColor3 = THEME.Text
    self.Title.TextSize = 18
    self.Title.Font = Enum.Font.GothamBold
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.TitleBar
    
    -- Icon Cat
    self.CatIcon = Instance.new("ImageLabel")
    self.CatIcon.Name = "CatIcon"
    self.CatIcon.Size = UDim2.new(0, 24, 0, 24)
    self.CatIcon.Position = UDim2.new(1, -35, 0.5, -12)
    self.CatIcon.BackgroundTransparency = 1
    self.CatIcon.Image = "rbxassetid://7072706318" -- ID hình con mèo
    self.CatIcon.Parent = self.TitleBar
    
    -- Close Button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    self.CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Text = "✖"
    self.CloseButton.TextColor3 = THEME.Text
    self.CloseButton.TextSize = 18
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.Parent = self.TitleBar
    
    -- Content Container
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Size = UDim2.new(1, -20, 1, -50)
    self.ContentFrame.Position = UDim2.new(0, 10, 0, 45)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.Parent = self.MainFrame
    
    -- Tab Container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(0, 120, 1, 0)
    self.TabContainer.BackgroundColor3 = THEME.Secondary
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Parent = self.ContentFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = self.TabContainer
    
    -- TabList
    self.TabList = Instance.new("ScrollingFrame")
    self.TabList.Name = "TabList"
    self.TabList.Size = UDim2.new(1, 0, 1, 0)
    self.TabList.BackgroundTransparency = 1
    self.TabList.ScrollBarThickness = 2
    self.TabList.ScrollingDirection = Enum.ScrollingDirection.Y
    self.TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.TabList.Parent = self.TabContainer
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.Parent = self.TabList
    
    local tabListPadding = Instance.new("UIPadding")
    tabListPadding.PaddingTop = UDim.new(0, 10)
    tabListPadding.PaddingLeft = UDim.new(0, 5)
    tabListPadding.PaddingRight = UDim.new(0, 5)
    tabListPadding.Parent = self.TabList
    
    -- Page Container
    self.PageContainer = Instance.new("Frame")
    self.PageContainer.Name = "PageContainer"
    self.PageContainer.Size = UDim2.new(1, -130, 1, 0)
    self.PageContainer.Position = UDim2.new(0, 130, 0, 0)
    self.PageContainer.BackgroundTransparency = 1
    self.PageContainer.Parent = self.ContentFrame
    
    -- Biến lưu trữ
    self.Pages = {}
    self.Tabs = {}
    self.CurrentTab = nil
    
    -- Xử lý kéo thả
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    self.TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Đóng UI
    self.CloseButton.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
    
    return self
end

function CatLibrary:CreateTab(name, icon)
    -- Tab Button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(1, 0, 0, 35)
    tabButton.BackgroundColor3 = THEME.Secondary
    tabButton.BorderSizePixel = 0
    tabButton.Text = ""
    tabButton.AutoButtonColor = false
    tabButton.Parent = self.TabList
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabButton
    
    -- Tab Icon
    if icon then
        local tabIcon = Instance.new("ImageLabel")
        tabIcon.Name = "Icon"
        tabIcon.Size = UDim2.new(0, 20, 0, 20)
        tabIcon.Position = UDim2.new(0, 10, 0.5, -10)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Image = icon
        tabIcon.Parent = tabButton
    end
    
    -- Tab Text
    local tabText = Instance.new("TextLabel")
    tabText.Name = "Title"
    tabText.Size = UDim2.new(1, icon and -40 or -20, 1, 0)
    tabText.Position = UDim2.new(0, icon and 40 or 10, 0, 0)
    tabText.BackgroundTransparency = 1
    tabText.Text = name
    tabText.TextColor3 = THEME.Text
    tabText.TextSize = 14
    tabText.Font = Enum.Font.GothamMedium
    tabText.TextXAlignment = Enum.TextXAlignment.Left
    tabText.Parent = tabButton
    
    -- Indicator
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 3, 0.7, 0)
    indicator.Position = UDim2.new(0, 0, 0.15, 0)
    indicator.BackgroundColor3 = THEME.Primary
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    indicator.Parent = tabButton
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 2)
    indicatorCorner.Parent = indicator
    
    -- Page
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    page.Parent = self.PageContainer
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 10)
    pageLayout.Parent = page
    
    local pagePadding = Instance.new("UIPadding")
    pagePadding.PaddingTop = UDim.new(0, 10)
    pagePadding.PaddingLeft = UDim.new(0, 5)
    pagePadding.PaddingRight = UDim.new(0, 5)
    pagePadding.PaddingBottom = UDim.new(0, 10)
    pagePadding.Parent = page
    
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Lưu trữ trang và nút
    self.Pages[name] = page
    self.Tabs[name] = {
        Button = tabButton,
        Page = page,
        Indicator = indicator
    }
    
    -- Handle click
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)
    
    -- Nếu đây là tab đầu tiên, hiển thị
    if self.CurrentTab == nil then
        self:SelectTab(name)
    end
    
    -- Hover effect
    tabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= name then
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(tabButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 65)})
            tween:Play()
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= name then
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(tabButton, tweenInfo, {BackgroundColor3 = THEME.Secondary})
            tween:Play()
        end
    end)
    
    -- Tab functions object
    local tab = {}
    
    function tab:AddButton(text, callback)
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Name = text .. "ButtonFrame"
        buttonFrame.Size = UDim2.new(1, 0, 0, 40)
        buttonFrame.BackgroundColor3 = THEME.Secondary
        buttonFrame.BorderSizePixel = 0
        buttonFrame.Parent = page
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = buttonFrame
        
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundTransparency = 1
        button.Text = text
        button.TextColor3 = THEME.Text
        button.TextSize = 14
        button.Font = Enum.Font.GothamMedium
        button.Parent = buttonFrame
        
        button.MouseButton1Click:Connect(function()
            if typeof(callback) == "function" then
                callback()
            end
        end)
        
        -- Hover effect
        button.MouseEnter:Connect(function()
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(buttonFrame, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 65)})
            tween:Play()
        end)
        
        button.MouseLeave:Connect(function()
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(buttonFrame, tweenInfo, {BackgroundColor3 = THEME.Secondary})
            tween:Play()
        end)
        
        return button
    end
    
    function tab:AddToggle(text, default, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = text .. "ToggleFrame"
        toggleFrame.Size = UDim2.new(1, 0, 0, 40)
        toggleFrame.BackgroundColor3 = THEME.Secondary
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Parent = page
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 6)
        toggleCorner.Parent = toggleFrame
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Name = "Label"
        toggleLabel.Size = UDim2.new(1, -50, 1, 0)
        toggleLabel.Position = UDim2.new(0, 10, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = text
        toggleLabel.TextColor3 = THEME.Text
        toggleLabel.TextSize = 14
        toggleLabel.Font = Enum.Font.GothamMedium
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame
        
        local toggleButton = Instance.new("Frame")
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = UDim2.new(0, 40, 0, 20)
        toggleButton.Position = UDim2.new(1, -50, 0.5, -10)
        toggleButton.BackgroundColor3 = default and THEME.Primary or Color3.fromRGB(100, 100, 100)
        toggleButton.BorderSizePixel = 0
        toggleButton.Parent = toggleFrame
        
        local toggleButtonCorner = Instance.new("UICorner")
        toggleButtonCorner.CornerRadius = UDim.new(1, 0)
        toggleButtonCorner.Parent = toggleButton
        
        local toggleCircle = Instance.new("Frame")
        toggleCircle.Name = "Circle"
        toggleCircle.Size = UDim2.new(0, 16, 0, 16)
        toggleCircle.Position = UDim2.new(default and 1 or 0, default and -18 or 2, 0.5, -8)
        toggleCircle.BackgroundColor3 = THEME.Text
        toggleCircle.BorderSizePixel = 0
        toggleCircle.Parent = toggleButton
        
        local toggleCircleCorner = Instance.new("UICorner")
        toggleCircleCorner.CornerRadius = UDim.new(1, 0)
        toggleCircleCorner.Parent = toggleCircle
        
        local toggled = default or false
        
        local function updateToggle()
            if toggled then
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local buttonTween = TweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = THEME.Primary})
                local circleTween = TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(1, -18, 0.5, -8)})
                buttonTween:Play()
                circleTween:Play()
            else
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local buttonTween = TweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(100, 100, 100)})
                local circleTween = TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(0, 2, 0.5, -8)})
                buttonTween:Play()
                circleTween:Play()
            end
            
            if typeof(callback) == "function" then
                callback(toggled)
            end
        end
        
        toggleButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                toggled = not toggled
                updateToggle()
            end
        end)
        
        toggleFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                toggled = not toggled
                updateToggle()
            end
        end)
        
        return {
            Frame = toggleFrame,
            SetValue = function(self, value)
                toggled = value
                updateToggle()
            end,
            GetValue = function(self)
                return toggled
            end
        }
    end
    
    function tab:AddSlider(text, options, callback)
        options = options or {}
        local min = options.min or 0
        local max = options.max or 100
        local default = options.default and math.clamp(options.default, min, max) or min
        
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = text .. "SliderFrame"
        sliderFrame.Size = UDim2.new(1, 0, 0, 60)
        sliderFrame.BackgroundColor3 = THEME.Secondary
        sliderFrame.BorderSizePixel = 0
        sliderFrame.Parent = page
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 6)
        sliderCorner.Parent = sliderFrame
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Name = "Label"
        sliderLabel.Size = UDim2.new(1, -20, 0, 25)
        sliderLabel.Position = UDim2.new(0, 10, 0, 5)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = text
        sliderLabel.TextColor3 = THEME.Text
        sliderLabel.TextSize = 14
        sliderLabel.Font = Enum.Font.GothamMedium
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = sliderFrame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Name = "Value"
        valueLabel.Size = UDim2.new(0, 70, 0, 25)
        valueLabel.Position = UDim2.new(1, -80, 0, 5)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default)
        valueLabel.TextColor3 = THEME.Text
        valueLabel.TextSize = 14
        valueLabel.Font = Enum.Font.GothamMedium
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = sliderFrame
        
        local sliderBack = Instance.new("Frame")
        sliderBack.Name = "SliderBack"
        sliderBack.Size = UDim2.new(1, -20, 0, 6)
        sliderBack.Position = UDim2.new(0, 10, 0, 40)
        sliderBack.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
        sliderBack.BorderSizePixel = 0
        sliderBack.Parent = sliderFrame
        
        local sliderBackCorner = Instance.new("UICorner")
        sliderBackCorner.CornerRadius = UDim.new(1, 0)
        sliderBackCorner.Parent = sliderBack
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Name = "SliderFill"
        sliderFill.BackgroundColor3 = THEME.Primary
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBack
        
        local sliderFillCorner = Instance.new("UICorner")
        sliderFillCorner.CornerRadius = UDim.new(1, 0)
        sliderFillCorner.Parent = sliderFill
        
        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Name = "SliderButton"
        sliderBtn.Size = UDim2.new(0, 16, 0, 16)
        sliderBtn.BackgroundColor3 = THEME.Text
        sliderBtn.Text = ""
        sliderBtn.BorderSizePixel = 0
        sliderBtn.AutoButtonColor = false
        sliderBtn.Parent = sliderBack
        
        local sliderBtnCorner = Instance.new("UICorner")
        sliderBtnCorner.CornerRadius = UDim.new(1, 0)
        sliderBtnCorner.Parent = sliderBtn
        
        local value = default
        
        local function updateSlider(input)
            local sizeX = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
            local newValue = math.floor(min + ((max - min) * sizeX))
            value = newValue
            
            valueLabel.Text = tostring(value)
            sliderFill.Size = UDim2.new(sizeX, 0, 1, 0)
            sliderBtn.Position = UDim2.new(sizeX, -8, 0.5, -8)
            
            if typeof(callback) == "function" then
                callback(value)
            end
        end
        
        local function setSliderValue(val)
            val = math.clamp(val, min, max)
            local percent = (val - min) / (max - min)
            
            value = val
            valueLabel.Text = tostring(value)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderBtn.Position = UDim2.new(percent, -8, 0.5, -8)
            
            if typeof(callback) == "function" then
                callback(value)
            end
        end
        
        -- Set default value
        setSliderValue(default)
        
        -- Handle slider
        local dragging = false
        
        sliderBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        sliderBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        sliderBack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                updateSlider(input)
                dragging = true
            end
        end)
        
        sliderBack.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        return {
            Frame = sliderFrame,
            SetValue = function(self, val)
                setSliderValue(val)
            end,
            GetValue = function(self)
                return value
            end
        }
    end
    
    function tab:AddDropdown(text, options, callback)
        options = options or {}
        local items = options.items or {}
        local default = options.default or (items[1] or "")
        
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Name = text .. "DropdownFrame"
        dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
        dropdownFrame.BackgroundColor3 = THEME.Secondary
        dropdownFrame.BorderSizePixel = 0
        dropdownFrame.Parent = page
        
        local dropdownCorner = Instance.new("UICorner")
        dropdownCorner.CornerRadius = UDim.new(0, 6)
        dropdownCorner.Parent = dropdownFrame
        
        local dropdownLabel = Instance.new("TextLabel")
        dropdownLabel.Name = "Label"
        dropdownLabel.Size = UDim2.new(1, -20, 0.5, 0)
        dropdownLabel.Position = UDim2.new(0, 10, 0, 0)
        dropdownLabel.BackgroundTransparency = 1
        dropdownLabel.Text = text
        dropdownLabel.TextColor3 = THEME.Text
        dro
        dropdownLabel.TextSize = 14
        dropdownLabel.Font = Enum.Font.GothamMedium
        dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropdownLabel.Parent = dropdownFrame
        
        local dropdownBtn = Instance.new("TextButton")
        dropdownBtn.Name = "DropdownButton"
        dropdownBtn.Size = UDim2.new(1, -20, 0.5, 0)
        dropdownBtn.Position = UDim2.new(0, 10, 0.5, 0)
        dropdownBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
        dropdownBtn.Text = default
        dropdownBtn.TextColor3 = THEME.Text
        dropdownBtn.TextSize = 14
        dropdownBtn.Font = Enum.Font.GothamMedium
        dropdownBtn.Parent = dropdownFrame
        
        local dropdownBtnCorner = Instance.new("UICorner")
        dropdownBtnCorner.CornerRadius = UDim.new(0, 4)
        dropdownBtnCorner.Parent = dropdownBtn
        
        local dropdownIcon = Instance.new("ImageLabel")
        dropdownIcon.Name = "Icon"
        dropdownIcon.Size = UDim2.new(0, 20, 0, 20)
        dropdownIcon.Position = UDim2.new(1, -25, 0.5, -10)
        dropdownIcon.BackgroundTransparency = 1
        dropdownIcon.Image = "rbxassetid://6031091004" -- Arrow down icon
        dropdownIcon.Parent = dropdownBtn
        
        local dropdownContainer = Instance.new("Frame")
        dropdownContainer.Name = "DropdownContainer"
        dropdownContainer.Size = UDim2.new(1, -20, 0, 0)
        dropdownContainer.Position = UDim2.new(0, 10, 1, 5)
        dropdownContainer.BackgroundColor3 = THEME.Secondary
        dropdownContainer.BorderSizePixel = 0
        dropdownContainer.ClipsDescendants = true
        dropdownContainer.Visible = false
        dropdownContainer.ZIndex = 5
        dropdownContainer.Parent = dropdownFrame
        
        local dropdownContainerCorner = Instance.new("UICorner")
        dropdownContainerCorner.CornerRadius = UDim.new(0, 4)
        dropdownContainerCorner.Parent = dropdownContainer
        
        local dropdownItemList = Instance.new("ScrollingFrame")
        dropdownItemList.Name = "ItemList"
        dropdownItemList.Size = UDim2.new(1, 0, 1, 0)
        dropdownItemList.BackgroundTransparency = 1
        dropdownItemList.BorderSizePixel = 0
        dropdownItemList.ScrollBarThickness = 2
        dropdownItemList.ZIndex = 5
        dropdownItemList.Parent = dropdownContainer
        
        local dropdownItemLayout = Instance.new("UIListLayout")
        dropdownItemLayout.SortOrder = Enum.SortOrder.LayoutOrder
        dropdownItemLayout.Padding = UDim.new(0, 5)
        dropdownItemLayout.Parent = dropdownItemList
        
        local dropdownItemPadding = Instance.new("UIPadding")
        dropdownItemPadding.PaddingTop = UDim.new(0, 5)
        dropdownItemPadding.PaddingLeft = UDim.new(0, 5)
        dropdownItemPadding.PaddingRight = UDim.new(0, 5)
        dropdownItemPadding.PaddingBottom = UDim.new(0, 5)
        dropdownItemPadding.Parent = dropdownItemList
        
        local selectedItem = default
        local dropdownOpen = false
        
        local function updateDropdown()
            if dropdownOpen then
                dropdownContainer.Visible = true
                local contentHeight = dropdownItemLayout.AbsoluteContentSize.Y + 10
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tween = TweenService:Create(dropdownContainer, tweenInfo, {Size = UDim2.new(1, -20, 0, contentHeight)})
                tween:Play()
                
                local iconTween = TweenService:Create(dropdownIcon, tweenInfo, {Rotation = 180})
                iconTween:Play()
            else
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tween = TweenService:Create(dropdownContainer, tweenInfo, {Size = UDim2.new(1, -20, 0, 0)})
                tween:Play()
                
                local iconTween = TweenService:Create(dropdownIcon, tweenInfo, {Rotation = 0})
                iconTween:Play()
                
                tween.Completed:Connect(function()
                    if not dropdownOpen then
                        dropdownContainer.Visible = false
                    end
                end)
            end
        end
        
        -- Add dropdown items
        local function refreshItems()
            -- Clear existing items
            for _, child in pairs(dropdownItemList:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            
            -- Add new items
            for i, item in ipairs(items) do
                local itemButton = Instance.new("TextButton")
                itemButton.Name = "Item_" .. i
                itemButton.Size = UDim2.new(1, 0, 0, 30)
                itemButton.BackgroundColor3 = THEME.Secondary
                itemButton.BackgroundTransparency = 0.5
                itemButton.Text = item
                itemButton.TextColor3 = THEME.Text
                itemButton.TextSize = 14
                itemButton.Font = Enum.Font.GothamMedium
                itemButton.ZIndex = 6
                itemButton.Parent = dropdownItemList
                
                local itemCorner = Instance.new("UICorner")
                itemCorner.CornerRadius = UDim.new(0, 4)
                itemCorner.Parent = itemButton
                
                itemButton.MouseButton1Click:Connect(function()
                    selectedItem = item
                    dropdownBtn.Text = item
                    dropdownOpen = false
                    updateDropdown()
                    
                    if typeof(callback) == "function" then
                        callback(item)
                    end
                end)
                
                -- Hover effect
                itemButton.MouseEnter:Connect(function()
                    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tween = TweenService:Create(itemButton, tweenInfo, {BackgroundColor3 = THEME.Primary})
                    tween:Play()
                end)
                
                itemButton.MouseLeave:Connect(function()
                    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tween = TweenService:Create(itemButton, tweenInfo, {BackgroundColor3 = THEME.Secondary})
                    tween:Play()
                end)
            end
            
            dropdownItemList.CanvasSize = UDim2.new(0, 0, 0, dropdownItemLayout.AbsoluteContentSize.Y + 10)
        end
        
        refreshItems()
        
        dropdownBtn.MouseButton1Click:Connect(function()
            dropdownOpen = not dropdownOpen
            updateDropdown()
        end)
        
        return {
            Frame = dropdownFrame,
            SetValue = function(self, item)
                if table.find(items, item) then
                    selectedItem = item
                    dropdownBtn.Text = item
                    
                    if typeof(callback) == "function" then
                        callback(item)
                    end
                end
            end,
            GetValue = function(self)
                return selectedItem
            end,
            SetItems = function(self, newItems)
                items = newItems
                refreshItems()
            end,
            AddItem = function(self, item)
                table.insert(items, item)
                refreshItems()
            end,
            RemoveItem = function(self, item)
                local index = table.find(items, item)
                if index then
                    table.remove(items, index)
                    refreshItems()
                end
            end
        }
    end
    
    function tab:AddTextbox(text, placeholder, callback)
        local textboxFrame = Instance.new("Frame")
        textboxFrame.Name = text .. "TextboxFrame"
        textboxFrame.Size = UDim2.new(1, 0, 0, 60)
        textboxFrame.BackgroundColor3 = THEME.Secondary
        textboxFrame.BorderSizePixel = 0
        textboxFrame.Parent = page
        
        local textboxCorner = Instance.new("UICorner")
        textboxCorner.CornerRadius = UDim.new(0, 6)
        textboxCorner.Parent = textboxFrame
        
        local textboxLabel = Instance.new("TextLabel")
        textboxLabel.Name = "Label"
        textboxLabel.Size = UDim2.new(1, -20, 0, 25)
        textboxLabel.Position = UDim2.new(0, 10, 0, 5)
        textboxLabel.BackgroundTransparency = 1
        textboxLabel.Text = text
        textboxLabel.TextColor3 = THEME.Text
        textboxLabel.TextSize = 14
        textboxLabel.Font = Enum.Font.GothamMedium
        textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        textboxLabel.Parent = textboxFrame
        
        local textbox = Instance.new("TextBox")
        textbox.Name = "Textbox"
        textbox.Size = UDim2.new(1, -20, 0, 25)
        textbox.Position = UDim2.new(0, 10, 0.5, 5)
        textbox.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
        textbox.PlaceholderText = placeholder or "Nhập văn bản..."
        textbox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
        textbox.Text = ""
        textbox.TextColor3 = THEME.Text
        textbox.TextSize = 14
        textbox.Font = Enum.Font.GothamMedium
        textbox.ClearTextOnFocus = false
        textbox.Parent = textboxFrame
        
        local textboxInputCorner = Instance.new("UICorner")
        textboxInputCorner.CornerRadius = UDim.new(0, 4)
        textboxInputCorner.Parent = textbox
        
        textbox.FocusLost:Connect(function(enterPressed)
            if typeof(callback) == "function" then
                callback(textbox.Text, enterPressed)
            end
        end)
        
        return {
            Frame = textboxFrame,
            SetValue = function(self, value)
                textbox.Text = value
            end,
            GetValue = function(self)
                return textbox.Text
            end
        }
    end
    
    function tab:AddColorPicker(text, default, callback)
        default = default or Color3.fromRGB(255, 255, 255)
        
        local colorPickerFrame = Instance.new("Frame")
        colorPickerFrame.Name = text .. "ColorPickerFrame"
        colorPickerFrame.Size = UDim2.new(1, 0, 0, 40)
        colorPickerFrame.BackgroundColor3 = THEME.Secondary
        colorPickerFrame.BorderSizePixel = 0
        colorPickerFrame.Parent = page
        
        local colorPickerCorner = Instance.new("UICorner")
        colorPickerCorner.CornerRadius = UDim.new(0, 6)
        colorPickerCorner.Parent = colorPickerFrame
        
        local colorPickerLabel = Instance.new("TextLabel")
        colorPickerLabel.Name = "Label"
        colorPickerLabel.Size = UDim2.new(1, -60, 1, 0)
        colorPickerLabel.Position = UDim2.new(0, 10, 0, 0)
        colorPickerLabel.BackgroundTransparency = 1
        colorPickerLabel.Text = text
        colorPickerLabel.TextColor3 = THEME.Text
        colorPickerLabel.TextSize = 14
        colorPickerLabel.Font = Enum.Font.GothamMedium
        colorPickerLabel.TextXAlignment = Enum.TextXAlignment.Left
        colorPickerLabel.Parent = colorPickerFrame
        
        local colorDisplay = Instance.new("Frame")
        colorDisplay.Name = "ColorDisplay"
        colorDisplay.Size = UDim2.new(0, 30, 0, 30)
        colorDisplay.Position = UDim2.new(1, -40, 0.5, -15)
        colorDisplay.BackgroundColor3 = default
        colorDisplay.BorderSizePixel = 0
        colorDisplay.Parent = colorPickerFrame
        
        local colorDisplayCorner = Instance.new("UICorner")
        colorDisplayCorner.CornerRadius = UDim.new(0, 4)
        colorDisplayCorner.Parent = colorDisplay
        
        local colorContainer = Instance.new("Frame")
        colorContainer.Name = "ColorContainer"
        colorContainer.Size = UDim2.new(1, -20, 0, 150)
        colorContainer.Position = UDim2.new(0, 10, 1, 5)
        colorContainer.BackgroundColor3 = THEME.Secondary
        colorContainer.BorderSizePixel = 0
        colorContainer.ClipsDescendants = true
        colorContainer.Visible = false
        colorContainer.ZIndex = 10
        colorContainer.Parent = colorPickerFrame
        
        local colorContainerCorner = Instance.new("UICorner")
        colorContainerCorner.CornerRadius = UDim.new(0, 6)
        colorContainerCorner.Parent = colorContainer
        
        -- H (Hue) Slider
        local hueFrame = Instance.new("Frame")
        hueFrame.Name = "HueFrame"
        hueFrame.Size = UDim2.new(1, -20, 0, 20)
        hueFrame.Position = UDim2.new(0, 10, 0, 10)
        hueFrame.BackgroundTransparency = 1
        hueFrame.ZIndex = 11
        hueFrame.Parent = colorContainer
        
        local hueLabel = Instance.new("TextLabel")
        hueLabel.Name = "HueLabel"
        hueLabel.Size = UDim2.new(0, 15, 1, 0)
        hueLabel.BackgroundTransparency = 1
        hueLabel.Text = "H:"
        hueLabel.TextColor3 = THEME.Text
        hueLabel.TextSize = 14
        hueLabel.Font = Enum.Font.GothamMedium
        hueLabel.ZIndex = 11
        hueLabel.Parent = hueFrame
        
        local hueSlider = Instance.new("Frame")
        hueSlider.Name = "HueSlider"
        hueSlider.Size = UDim2.new(1, -25, 0, 20)
        hueSlider.Position = UDim2.new(0, 25, 0, 0)
        hueSlider.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        hueSlider.BorderSizePixel = 0
        hueSlider.ZIndex = 11
        hueSlider.Parent = hueFrame
        
        local hueSliderCorner = Instance.new("UICorner")
        hueSliderCorner.CornerRadius = UDim.new(0, 4)
        hueSliderCorner.Parent = hueSlider
        
        local hueSliderGradient = Instance.new("UIGradient")
        hueSliderGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        })
        hueSliderGradient.Parent = hueSlider
        
        local hueSliderBtn = Instance.new("TextButton")
        hueSliderBtn.Name = "HueSliderButton"
        hueSliderBtn.Size = UDim2.new(0, 10, 1, 4)
        hueSliderBtn.Position = UDim2.new(0, 0, 0, -2)
        hueSliderBtn.BackgroundColor3 = THEME.Text
        hueSliderBtn.Text = ""
        hueSliderBtn.BorderSizePixel = 0
        hueSliderBtn.AutoButtonColor = false
        hueSliderBtn.ZIndex = 12
        hueSliderBtn.Parent = hueSlider
        
        local hueSliderBtnCorner = Instance.new("UICorner")
        hueSliderBtnCorner.CornerRadius = UDim.new(0, 2)
        hueSliderBtnCorner.Parent = hueSliderBtn
        
        -- SV (Saturation-Value) Picker
        local svFrame = Instance.new("Frame")
        svFrame.Name = "SVFrame"
        svFrame.Size = UDim2.new(1, -20, 0, 100)
        svFrame.Position = UDim2.new(0, 10, 0, 40)
        svFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        svFrame.BorderSizePixel = 0
        svFrame.ZIndex = 11
        svFrame.Parent = colorContainer
        
        local svFrameCorner = Instance.new("UICorner")
        svFrameCorner.CornerRadius = UDim.new(0, 4)
        svFrameCorner.Parent = svFrame
        
        local svGradient1 = Instance.new("UIGradient")
        svGradient1.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255, 0))
        })
        svGradient1.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        svGradient1.Rotation = 90
        svGradient1.Parent = svFrame
        
        local svGradient2 = Instance.new("Frame")
        svGradient2.Name = "SVGradient2"
        svGradient2.Size = UDim2.new(1, 0, 1, 0)
        svGradient2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        svGradient2.BackgroundTransparency = 0
        svGradient2.BorderSizePixel = 0
        svGradient2.ZIndex = 11
        svGradient2.Parent = svFrame
        
        local svGradient2Corner = Instance.new("UICorner")
        svGradient2Corner.CornerRadius = UDim.new(0, 4)
        svGradient2Corner.Parent = svGradient2
        
        local svGradient2Gradient = Instance.new("UIGradient")
        svGradient2Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        })
        svGradient2Gradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 0)
        })
        svGradient2Gradient.Rotation = 0
        svGradient2Gradient.Parent = svGradient2
        
        local svPicker = Instance.new("TextButton")
        svPicker.Name = "SVPicker"
        svPicker.Size = UDim2.new(0, 10, 0, 10)
        svPicker.BackgroundColor3 = THEME.Text
        svPicker.Text = ""
        svPicker.BorderSizePixel = 0
        svPicker.AutoButtonColor = false
        svPicker.ZIndex = 12
        svPicker.Parent = svFrame
        
        local svPickerCorner = Instance.new("UICorner")
        svPickerCorner.CornerRadius = UDim.new(1, 0)
        svPickerCorner.Parent = svPicker
        
        -- RGB Inputs
        local rgbFrame = Instance.new("Frame")
        rgbFrame.Name = "RGBFrame"
        rgbFrame.Size = UDim2.new(1, -20, 0, 25)
        rgbFrame.Position = UDim2.new(0, 10, 1, -35)
        rgbFrame.BackgroundTransparency = 1
        rgbFrame.ZIndex = 11
        rgbFrame.Parent = colorContainer
        
        local rgbLabel = Instance.new("TextLabel")
        rgbLabel.Name = "RGBLabel"
        rgbLabel.Size = UDim2.new(0, 30, 1, 0)
        rgbLabel.BackgroundTransparency = 1
        rgbLabel.Text = "RGB:"
        rgbLabel.TextColor3 = THEME.Text
        rgbLabel.TextSize = 14
        rgbLabel.Font = Enum.Font.GothamMedium
        rgbLabel.ZIndex = 11
        rgbLabel.Parent = rgbFrame
        
        local rgbInput = Instance.new("TextBox")
        rgbInput.Name = "RGBInput"
        rgbInput.Size = UDim2.new(1, -40, 1, 0)
        rgbInput.Position = UDim2.new(0, 40, 0, 0)
        rgbInput.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
        rgbInput.Text = table.concat({math.floor(default.R * 255), math.floor(default.G * 255), math.floor(default.B * 255)}, ", ")
        rgbInput.TextColor3 = THEME.Text
        rgbInput.PlaceholderText = "R, G, B"
        rgbInput.TextSize = 14
        rgbInput.Font = Enum.Font.GothamMedium
        rgbInput.ClearTextOnFocus = false
        rgbInput.ZIndex = 11
        rgbInput.Parent = rgbFrame
        
        local rgbInputCorner = Instance.new("UICorner")
        rgbInputCorner.CornerRadius = UDim.new(0, 4)
        rgbInputCorner.Parent = rgbInput
        
        -- Variables and functions
        local selectedColor = default
        local hue, sat, val = 0, 0, 1
        local pickerOpen = false
        
        local function updateColor()
            -- Update color based on HSV
            local currentColor = Color3.fromHSV(hue, sat, val)
            selectedColor = currentColor
            
            -- Update display
            colorDisplay.BackgroundColor3 = currentColor
            
            -- Update SV frame color (based on hue)
            svFrame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            
            -- Update RGB input
            rgbInput.Text = table.concat({
                math.floor(currentColor.R * 255),
                math.floor(currentColor.G * 255),
                math.floor(currentColor.B * 255)
            }, ", ")
            
            -- Callback
            if typeof(callback) == "function" then
                callback(currentColor)
            end
        end
        
        local function RGBToHSV(r, g, b)
            r, g, b = r / 255, g / 255, b / 255
            local max, min = math.max(r, g, b), math.min(r, g, b)
            local h, s, v
            
            v = max
            
            local d = max - min
            if max == 0 then
                s = 0
            else
                s = d / max
            end
            
            if max == min then
                h = 0
            else
                if max == r then
                    h = (g - b) / d
                    if g < b then
                        h = h + 6
                    end
                elseif max == g then
                    h = (b - r) / d + 2
                else
                    h = (r - g) / d + 4
                end
                h = h / 6
            end
            
            return h, s, v
        end
        
        local function updateColorFromRGB(rgbString)
            local r, g, b = rgbString:match("(%d+),%s*(%d+),%s*(%d+)")
            if r and g and b then
                r, g, b = tonumber(r), tonumber(g), tonumber(b)
                if r <= 255 and g <= 255 and b <= 255 then
                    local newColor = Color3.fromRGB(r, g, b)
                    selectedColor = newColor
                    colorDisplay.BackgroundColor3 = newColor
                    
                    -- Update HSV
                    hue, sat, val = RGBToHSV(r, g, b)
                    
                    -- Update hue slider
                    hueSliderBtn.Position = UDim2.new(hue, -5, 0, -2)
                    
                    -- Update SV picker
                    svFrame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                    svPicker.Position = UDim2.new(sat, -5, 1 - val, -5)
                    
                    -- Callback
                    if typeof(callback) == "function" then
                        callback(newColor)
                    end
                end
            end
        end
        
        local function updatePicker()
            if pickerOpen then
                colorContainer.Visible = true
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tween = TweenService:Create(colorContainer, tweenInfo, {Size = UDim2.new(1, -20, 0, 180)})
                tween:Play()
            else
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tween = TweenService:Create(colorContainer, tweenInfo, {Size = UDim2.new(1, -20, 0, 0)})
                tween:Play()
                
                tween.Completed:Connect(function()
                    if not pickerOpen then
                        colorContainer.Visible = false
                    end
                end)
            end
        end
        
        -- Convert default color to HSV
        do
            local r, g, b = default.R * 255, default.G * 255, default.B * 255
            hue, sat, val = RGBToHSV(r, g, b)
            
            -- Initialize positions
            hueSliderBtn.Position = UDim2.new(hue, -5, 0, -2)
            svPicker.Position = UDim2.new(sat, -5, 1 - val, -5)
            svFrame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        end
        
        -- Handle hue slider
        local draggingHue = false
        
        hueSliderBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingHue = true
            end
        end)
        
        hueSliderBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingHue = false
            end
        end)
        
        hueSlider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local relativeX = math.clamp((input.Position.X - hueSlider.AbsolutePosition.X) / hueSlider.AbsoluteSize.X, 0, 1)
                hue = relativeX
                hueSliderBtn.Position = UDim2.new(relativeX, -5, 0, -2)
                updateColor()
                draggingHue = true
            end
        end)
        
        -- Handle SV picker
        local draggingSV = false
        
        svPicker.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingSV = true
            end
        end)
        
        svPicker.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingSV = false
            end
        end)
        
        svFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local relativeX = math.clamp((input.Position.X - svFrame.AbsolutePosition.X) / svFrame.AbsoluteSize.X, 0, 1)
                local relativeY = math.clamp((input.Position.Y - svFrame.AbsolutePosition.Y) / svFrame.AbsoluteSize.Y, 0, 1)
                
                sat = relativeX
                val = 1 - relativeY
                
                svPicker.Position = UDim2.new(relativeX, -5, relativeY, -5)
                updateColor()
                draggingSV = true
            end
        end)
        
        -- Update on input changed
        UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
                         local relativeX = math.clamp((input.Position.X - svFrame.AbsolutePosition.X) / svFrame.AbsoluteSize.X, 0, 1)
                local relativeY = math.clamp((input.Position.Y - svFrame.AbsolutePosition.Y) / svFrame.AbsoluteSize.Y, 0, 1)
                
                sat = relativeX
                val = 1 - relativeY
                
                svPicker.Position = UDim2.new(relativeX, -5, relativeY, -5)
                updateColor()
            end
        end)
        
        if draggingHue and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp((input.Position.X - hueSlider.AbsolutePosition.X) / hueSlider.AbsoluteSize.X, 0, 1)
            hue = relativeX
            hueSliderBtn.Position = UDim2.new(relativeX, -5, 0, -2)
            updateColor()
        end
    end)
    
    -- RGB input handling
    rgbInput.FocusLost:Connect(function()
        updateColorFromRGB(rgbInput.Text)
    end)
    
    -- Toggle color picker
    colorDisplay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            pickerOpen = not pickerOpen
            updatePicker()
        end
    end)
    
    return {
        Frame = colorPickerFrame,
        SetValue = function(self, color)
            selectedColor = color
            colorDisplay.BackgroundColor3 = color
            
            local r, g, b = color.R * 255, color.G * 255, color.B * 255
            rgbInput.Text = table.concat({math.floor(r), math.floor(g), math.floor(b)}, ", ")
            
            hue, sat, val = RGBToHSV(r, g, b)
            hueSliderBtn.Position = UDim2.new(hue, -5, 0, -2)
            svPicker.Position = UDim2.new(sat, -5, 1 - val, -5)
            svFrame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            
            if typeof(callback) == "function" then
                callback(color)
            end
        end,
        GetValue = function(self)
            return selectedColor
        end
    }
end

function tab:AddLabel(text)
    local labelFrame = Instance.new("Frame")
    labelFrame.Name = "LabelFrame"
    labelFrame.Size = UDim2.new(1, 0, 0, 30)
    labelFrame.BackgroundTransparency = 1
    labelFrame.Parent = page
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = THEME.Text
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.Parent = labelFrame
    
    return {
        Frame = labelFrame,
        SetText = function(self, newText)
            label.Text = newText
        end
    }
end

function tab:AddDivider()
    local dividerFrame = Instance.new("Frame")
    dividerFrame.Name = "DividerFrame"
    dividerFrame.Size = UDim2.new(1, 0, 0, 10)
    dividerFrame.BackgroundTransparency = 1
    dividerFrame.Parent = page
    
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.Position = UDim2.new(0, 0, 0.5, 0)
    divider.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
    divider.BorderSizePixel = 0
    divider.Parent = dividerFrame
    
    return dividerFrame
end

function tab:AddKeybind(text, default, callback, changedCallback)
    local keybindFrame = Instance.new("Frame")
    keybindFrame.Name = text .. "KeybindFrame"
    keybindFrame.Size = UDim2.new(1, 0, 0, 40)
    keybindFrame.BackgroundColor3 = THEME.Secondary
    keybindFrame.BorderSizePixel = 0
    keybindFrame.Parent = page
    
    local keybindCorner = Instance.new("UICorner")
    keybindCorner.CornerRadius = UDim.new(0, 6)
    keybindCorner.Parent = keybindFrame
    
    local keybindLabel = Instance.new("TextLabel")
    keybindLabel.Name = "Label"
    keybindLabel.Size = UDim2.new(1, -80, 1, 0)
    keybindLabel.Position = UDim2.new(0, 10, 0, 0)
    keybindLabel.BackgroundTransparency = 1
    keybindLabel.Text = text
    keybindLabel.TextColor3 = THEME.Text
    keybindLabel.TextSize = 14
    keybindLabel.Font = Enum.Font.GothamMedium
    keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
    keybindLabel.Parent = keybindFrame
    
    local keybindButton = Instance.new("TextButton")
    keybindButton.Name = "KeybindButton"
    keybindButton.Size = UDim2.new(0, 70, 0, 25)
    keybindButton.Position = UDim2.new(1, -80, 0.5, -12.5)
    keybindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    keybindButton.Text = default and default.Name or "None"
    keybindButton.TextColor3 = THEME.Text
    keybindButton.TextSize = 14
    keybindButton.Font = Enum.Font.GothamMedium
    keybindButton.Parent = keybindFrame
    
    local keybindButtonCorner = Instance.new("UICorner")
    keybindButtonCorner.CornerRadius = UDim.new(0, 4)
    keybindButtonCorner.Parent = keybindButton
    
    local currentKey = default
    local listening = false
    
    keybindButton.MouseButton1Click:Connect(function()
        if listening then return end
        
        listening = true
        keybindButton.Text = "..."
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode
                keybindButton.Text = input.KeyCode.Name
                
                if typeof(changedCallback) == "function" then
                    changedCallback(input.KeyCode)
                end
                
                listening = false
                connection:Disconnect()
            end
        end)
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKey and not listening then
            if typeof(callback) == "function" then
                callback(currentKey)
            end
        end
    end)
    
    return {
        Frame = keybindFrame,
        SetBind = function(self, key)
            currentKey = key
            keybindButton.Text = key.Name
        end,
        GetBind = function(self)
            return currentKey
        end
    }
end

    return tab
end

function CatLibrary:SelectTab(tabName)
    if self.Tabs[tabName] then
        -- Deselect current tab
        if self.CurrentTab and self.Tabs[self.CurrentTab] then
            self.Tabs[self.CurrentTab].Page.Visible = false
            self.Tabs[self.CurrentTab].Indicator.Visible = false
            self.Tabs[self.CurrentTab].Button.BackgroundColor3 = THEME.Secondary
        end
        
        -- Select new tab
        self.Tabs[tabName].Page.Visible = true
        self.Tabs[tabName].Indicator.Visible = true
        self.Tabs[tabName].Button.BackgroundColor3 = THEME.Primary
        
        self.CurrentTab = tabName
    end
end

function CatLibrary:Notification(title, text, duration)
    duration = duration or 3
    
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "CatNotification"
    notifGui.ResetOnSpawn = false
    notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    notifGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "NotificationFrame"
    notifFrame.Size = UDim2.new(0, 300, 0, 80)
    notifFrame.Position = UDim2.new(1, 10, 0.85, 0)
    notifFrame.BackgroundColor3 = THEME.Secondary
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = notifGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 6)
    notifCorner.Parent = notifFrame
    
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Name = "Title"
    notifTitle.Size = UDim2.new(1, -20, 0, 30)
    notifTitle.Position = UDim2.new(0, 10, 0, 5)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.TextColor3 = THEME.Primary
    notifTitle.TextSize = 16
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    notifTitle.Parent = notifFrame
    
    local notifText = Instance.new("TextLabel")
    notifText.Name = "Message"
    notifText.Size = UDim2.new(1, -20, 0, 40)
    notifText.Position = UDim2.new(0, 10, 0, 35)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = THEME.Text
    notifText.TextSize = 14
    notifText.Font = Enum.Font.GothamMedium
    notifText.TextXAlignment = Enum.TextXAlignment.Left
    notifText.TextWrapped = true
    notifText.Parent = notifFrame
    
    local notifBar = Instance.new("Frame")
    notifBar.Name = "ProgressBar"
    notifBar.Size = UDim2.new(1, 0, 0, 3)
    notifBar.Position = UDim2.new(0, 0, 1, -3)
    notifBar.BackgroundColor3 = THEME.Primary
    notifBar.BorderSizePixel = 0
    notifBar.Parent = notifFrame
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = THEME.Shadow
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.Parent = notifFrame
    
    -- Animation
    local function fadeIn()
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local tween = TweenService:Create(notifFrame, tweenInfo, {Position = UDim2.new(1, -310, 0.85, 0)})
        tween:Play()
    end
    
    local function fadeOut()
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local tween = TweenService:Create(notifFrame, tweenInfo, {Position = UDim2.new(1, 10, 0.85, 0)})
        tween:Play()
        
        tween.Completed:Connect(function()
            notifGui:Destroy()
        end)
    end
    
    -- Progress bar
    local function updateBar()
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tween = TweenService:Create(notifBar, tweenInfo, {Size = UDim2.new(0, 0, 0, 3)})
        tween:Play()
    end
    
    fadeIn()
    updateBar()
    
    task.delay(duration, fadeOut)
end

return CatLibrary

