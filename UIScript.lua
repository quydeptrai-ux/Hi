local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = LocalPlayer.PlayerGui

-- Hàm hỗ trợ
local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition
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
end

local function CircleClick(Button, X, Y)
    task.spawn(function()
        Button.ClipsDescendants = true
        local Circle = Instance.new("ImageLabel")
        Circle.Image = "rbxassetid://266543268"
        Circle.ImageColor3 = Color3.fromRGB(100, 100, 100)
        Circle.ImageTransparency = 0.6
        Circle.BackgroundTransparency = 1
        Circle.ZIndex = 10
        Circle.Parent = Button
        
        local NewX = X - Circle.AbsolutePosition.X
        local NewY = Y - Circle.AbsolutePosition.Y
        Circle.Position = UDim2.new(0, NewX, 0, NewY)
        local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 2
        
        TweenService:Create(Circle, TweenInfo.new(0.35, Enum.EasingStyle.Elastic), {
            Size = UDim2.new(0, Size, 0, Size),
            Position = UDim2.new(0.5, -Size/2, 0.5, -Size/2),
            ImageTransparency = 1
        }):Play():Wait()
        Circle:Destroy()
    end)
end

local CatLib = {}

function CatLib:MakeGui(GuiConfig)
    local GuiConfig = GuiConfig or {}
    GuiConfig.NameHub = GuiConfig.NameHub or "Cat Hub"
    GuiConfig.Color = GuiConfig.Color or Color3.fromRGB(255, 0, 255)
    GuiConfig["Tab Width"] = GuiConfig["Tab Width"] or 130
    local GuiFunc = {}

    local HirimiGui = Instance.new("ScreenGui")
    HirimiGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    HirimiGui.Name = "HirimiGui"
    HirimiGui.Parent = CoreGui

    local Main = Instance.new("Frame")
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.Size = UDim2.new(0, 550, 0, 450)
    Main.Position = UDim2.new(0.5, -275, 0.5, -225)
    Main.Parent = HirimiGui

    local UICorner = Instance.new("UICorner", Main)
    UICorner.CornerRadius = UDim.new(0, 10)
    
    local UIGradient = Instance.new("UIGradient", Main)
    UIGradient.Color = ColorSequence.new{GuiConfig.Color, Color3.fromRGB(30, 30, 30)}
    UIGradient.Rotation = 45

    local Top = Instance.new("Frame", Main)
    Top.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Top.Size = UDim2.new(1, 0, 0, 40)
    Top.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", Top)
    Title.Text = GuiConfig.NameHub
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1

    local Close = Instance.new("TextButton", Top)
    Close.Text = "X"
    Close.Font = Enum.Font.Gotham
    Close.TextColor3 = Color3.fromRGB(255, 100, 100)
    Close.TextSize = 14
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -35, 0.5, -15)
    Close.BackgroundTransparency = 1
    Close.Activated:Connect(function()
        CircleClick(Close, Mouse.X, Mouse.Y)
        HirimiGui:Destroy()
    end)

    MakeDraggable(Top, Main)

    local TabsContainer = Instance.new("Frame", Main)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Size = UDim2.new(0, GuiConfig["Tab Width"], 1, -50)
    TabsContainer.Position = UDim2.new(0, 10, 0, 40)

    local TabsScroll = Instance.new("ScrollingFrame", TabsContainer)
    TabsScroll.Size = UDim2.new(1, 0, 1, 0)
    TabsScroll.BackgroundTransparency = 1
    TabsScroll.ScrollBarThickness = 0

    local UIListLayout = Instance.new("UIListLayout", TabsScroll)
    UIListLayout.Padding = UDim.new(0, 5)

    local Pages = Instance.new("Frame", Main)
    Pages.BackgroundTransparency = 1
    Pages.Size = UDim2.new(1, -GuiConfig["Tab Width"] - 20, 1, -50)
    Pages.Position = UDim2.new(0, GuiConfig["Tab Width"] + 20, 0, 40)

    local PageFolder = Instance.new("Folder", Pages)
    local PageLayout = Instance.new("UIPageLayout", PageFolder)
    PageLayout.TweenTime = 0.3
    PageLayout.EasingStyle = Enum.EasingStyle.Sine

    local Tabs = {}
    local TabCount = 0

    function Tabs:CreateTab(TabConfig)
        TabConfig = TabConfig or {}
        TabConfig.Name = TabConfig.Name or "Tab"
        TabConfig.Icon = TabConfig.Icon or "rbxassetid://6034830835"

        local TabButton = Instance.new("TextButton", TabsScroll)
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
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
        TabName.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabName.TextSize = 14
        TabName.Size = UDim2.new(1, -30, 1, 0)
        TabName.Position = UDim2.new(0, 30, 0, 0)
        TabName.BackgroundTransparency = 1

        local Page = Instance.new("ScrollingFrame", PageFolder)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 0
        Page.LayoutOrder = TabCount

        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, 8)

        if TabCount == 0 then
            TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            PageLayout:JumpTo(Page)
        end

        TabButton.Activated:Connect(function()
            CircleClick(TabButton, Mouse.X, Mouse.Y)
            for _, tab in TabsScroll:GetChildren() do
                if tab:IsA("TextButton") then
                    TweenService:Create(tab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                end
            end
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            PageLayout:JumpTo(Page)
        end)

        local Sections = {}
        local SectionCount = 0

        function Sections:AddSection(SectionName)
            SectionName = SectionName or "Section"

            local Section = Instance.new("Frame", Page)
            Section.Size = UDim2.new(1, -10, 0, 0)
            Section.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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

            function Items:AddDropdown(DropdownConfig)
                DropdownConfig = DropdownConfig or {}
                DropdownConfig.Title = DropdownConfig.Title or "Dropdown"
                DropdownConfig.Content = DropdownConfig.Content or "Select an option"
                DropdownConfig.Multi = DropdownConfig.Multi or false
                DropdownConfig.Options = DropdownConfig.Options or {"Option 1", "Option 2", "Option 3"}
                DropdownConfig.Default = DropdownConfig.Default or (DropdownConfig.Multi and {} or DropdownConfig.Options[1])
                DropdownConfig.Callback = DropdownConfig.Callback or function(value) print(value) end

                local DropdownFunc = {Value = DropdownConfig.Default, Options = DropdownConfig.Options}

                local Dropdown = Instance.new("Frame", ItemsContainer)
                Dropdown.Size = UDim2.new(1, 0, 0, 60)
                Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                Dropdown.LayoutOrder = ItemCount

                local UICorner = Instance.new("UICorner", Dropdown)
                UICorner.CornerRadius = UDim.new(0, 6)

                local Title = Instance.new("TextLabel", Dropdown)
                Title.Text = DropdownConfig.Title
                Title.Font = Enum.Font.GothamBold
                Title.TextColor3 = Color3.fromRGB(230, 230, 230)
                Title.TextSize = 14
                Title.Size = UDim2.new(1, -150, 0, 20)
                Title.Position = UDim2.new(0, 10, 0, 5)
                Title.BackgroundTransparency = 1

                local Content = Instance.new("TextLabel", Dropdown)
                Content.Text = DropdownConfig.Content
                Content.Font = Enum.Font.Gotham
                Content.TextColor3 = Color3.fromRGB(150, 150, 150)
                Content.TextSize = 12
                Content.Size = UDim2.new(1, -150, 0, 15)
                Content.Position = UDim2.new(0, 10, 0, 25)
                Content.BackgroundTransparency = 1

                local DropdownButton = Instance.new("TextButton", Dropdown)
                DropdownButton.Size = UDim2.new(1, 0, 1, 0)
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Text = ""

                local SelectedText = Instance.new("TextLabel", Dropdown)
                SelectedText.Text = DropdownConfig.Multi and table.concat(DropdownConfig.Default, ", ") or DropdownConfig.Default
                SelectedText.Font = Enum.Font.Gotham
                SelectedText.TextColor3 = Color3.fromRGB(255, 255, 255)
                SelectedText.TextSize = 12
                SelectedText.Size = UDim2.new(0, 130, 0, 25)
                SelectedText.Position = UDim2.new(1, -140, 0.5, -12)
                SelectedText.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                SelectedText.TextTruncate = Enum.TextTruncate.AtEnd

                local DropdownIcon = Instance.new("ImageLabel", Dropdown)
                DropdownIcon.Image = "rbxassetid://16851841101"
                DropdownIcon.Size = UDim2.new(0, 20, 0, 20)
                DropdownIcon.Position = UDim2.new(1, -25, 0.5, -10)
                DropdownIcon.BackgroundTransparency = 1

                local DropdownMenu = Instance.new("Frame", Main)
                DropdownMenu.Size = UDim2.new(0, 200, 0, 0)
                DropdownMenu.Position = UDim2.new(0, Dropdown.AbsolutePosition.X, 0, Dropdown.AbsolutePosition.Y + 60)
                DropdownMenu.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                DropdownMenu.Visible = false
                DropdownMenu.ClipsDescendants = true

                local MenuCorner = Instance.new("UICorner", DropdownMenu)
                MenuCorner.CornerRadius = UDim.new(0, 6)

                local SearchBox = Instance.new("TextBox", DropdownMenu)
                SearchBox.Size = UDim2.new(1, -10, 0, 25)
                SearchBox.Position = UDim2.new(0, 5, 0, 5)
                SearchBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                SearchBox.Text = ""
                SearchBox.PlaceholderText = "Search..."
                SearchBox.Font = Enum.Font.Gotham
                SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                SearchBox.TextSize = 12

                local OptionsScroll = Instance.new("ScrollingFrame", DropdownMenu)
                OptionsScroll.Size = UDim2.new(1, -10, 1, -60)
                OptionsScroll.Position = UDim2.new(0, 5, 0, 35)
                OptionsScroll.BackgroundTransparency = 1
                OptionsScroll.ScrollBarThickness = 2

                local OptionsList = Instance.new("UIListLayout", OptionsScroll)
                OptionsList.Padding = UDim.new(0, 3)

                local SelectAllButton = Instance.new("TextButton", DropdownMenu)
                SelectAllButton.Size = UDim2.new(0, 80, 0, 20)
                SelectAllButton.Position = UDim2.new(0, 5, 1, -25)
                SelectAllButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                SelectAllButton.Text = "Select All"
                SelectAllButton.Font = Enum.Font.Gotham
                SelectAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                SelectAllButton.TextSize = 12
                SelectAllButton.Visible = DropdownConfig.Multi

                local ClearAllButton = Instance.new("TextButton", DropdownMenu)
                ClearAllButton.Size = UDim2.new(0, 80, 0, 20)
                ClearAllButton.Position = UDim2.new(1, -85, 1, -25)
                ClearAllButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                ClearAllButton.Text = "Clear All"
                ClearAllButton.Font = Enum.Font.Gotham
                ClearAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                ClearAllButton.TextSize = 12
                ClearAllButton.Visible = DropdownConfig.Multi

                local function UpdateMenuSize()
                    local height = 60 + #DropdownConfig.Options * 33
                    if height > 200 then height = 200 end
                    OptionsScroll.CanvasSize = UDim2.new(0, 0, 0, #DropdownConfig.Options * 33)
                    return height
                end

                local function RefreshOptions(filter)
                    filter = filter or ""
                    OptionsScroll:ClearAllChildren()
                    OptionsList.Parent = nil
                    OptionsList.Parent = OptionsScroll

                    for _, option in pairs(DropdownConfig.Options) do
                        if string.find(string.lower(option), string.lower(filter)) then
                            local OptionButton = Instance.new("TextButton")
                            OptionButton.Size = UDim2.new(1, 0, 0, 30)
                            OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                            OptionButton.Text = ""
                            OptionButton.Parent = OptionsScroll

                            local OptionCorner = Instance.new("UICorner", OptionButton)
                            OptionCorner.CornerRadius = UDim.new(0, 4)

                            local OptionText = Instance.new("TextLabel", OptionButton)
                            OptionText.Text = option
                            OptionText.Font = Enum.Font.Gotham
                            OptionText.TextColor3 = Color3.fromRGB(200, 200, 200)
                            OptionText.TextSize = 12
                            OptionText.Size = UDim2.new(1, -30, 1, 0)
                            OptionText.Position = UDim2.new(0, 5, 0, 0)
                            OptionText.BackgroundTransparency = 1

                            local Checkmark = Instance.new("ImageLabel", OptionButton)
                            Checkmark.Image = "rbxassetid://6031094678"
                            Checkmark.Size = UDim2.new(0, 20, 0, 20)
                            Checkmark.Position = UDim2.new(1, -25, 0.5, -10)
                            Checkmark.BackgroundTransparency = 1
                            Checkmark.Visible = DropdownConfig.Multi and table.find(DropdownFunc.Value, option) or DropdownFunc.Value == option

                            OptionButton.MouseEnter:Connect(function()
                                TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                            end)
                            OptionButton.MouseLeave:Connect(function()
                                TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                            end)

                            OptionButton.Activated:Connect(function()
                                CircleClick(OptionButton, Mouse.X, Mouse.Y)
                                if DropdownConfig.Multi then
                                    if table.find(DropdownFunc.Value, option) then
                                        table.remove(DropdownFunc.Value, table.find(DropdownFunc.Value, option))
                                    else
                                        table.insert(DropdownFunc.Value, option)
                                    end
                                    Checkmark.Visible = table.find(DropdownFunc.Value, option) ~= nil
                                    SelectedText.Text = table.concat(DropdownFunc.Value, ", ")
                                else
                                    DropdownFunc.Value = option
                                    SelectedText.Text = option
                                    DropdownMenu.Visible = false
                                    TweenService:Create(DropdownMenu, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 200, 0, 0)}):Play()
                                end
                                DropdownConfig.Callback(DropdownFunc.Value)
                            end)
                        end
                    end
                end

                SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                    RefreshOptions(SearchBox.Text)
                end)

                SelectAllButton.Activated:Connect(function()
                    CircleClick(SelectAllButton, Mouse.X, Mouse.Y)
                    DropdownFunc.Value = table.clone(DropdownConfig.Options)
                    SelectedText.Text = table.concat(DropdownFunc.Value, ", ")
                    RefreshOptions()
                    DropdownConfig.Callback(DropdownFunc.Value)
                end)

                ClearAllButton.Activated:Connect(function()
                    CircleClick(ClearAllButton, Mouse.X, Mouse.Y)
                    DropdownFunc.Value = {}
                    SelectedText.Text = ""
                    RefreshOptions()
                    DropdownConfig.Callback(DropdownFunc.Value)
                end)

                DropdownButton.Activated:Connect(function()
                    CircleClick(DropdownButton, Mouse.X, Mouse.Y)
                    DropdownMenu.Visible = not DropdownMenu.Visible
                    if DropdownMenu.Visible then
                        DropdownMenu.Position = UDim2.new(0, Dropdown.AbsolutePosition.X, 0, Dropdown.AbsolutePosition.Y + 60)
                        TweenService:Create(DropdownMenu, TweenInfo.new(0.3, Enum.EasingStyle.Elastic), {Size = UDim2.new(0, 200, 0, UpdateMenuSize())}):Play()
                        RefreshOptions()
                    else
                        TweenService:Create(DropdownMenu, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 200, 0, 0)}):Play()
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

                ItemCount = ItemCount + 1
                return DropdownFunc
            end

            function Items:AddButton(ButtonConfig)
                ButtonConfig = ButtonConfig or {}
                ButtonConfig.Title = ButtonConfig.Title or "Button"
                ButtonConfig.Callback = ButtonConfig.Callback or function() end

                local Button = Instance.new("TextButton", ItemsContainer)
                Button.Size = UDim2.new(1, 0, 0, 35)
                Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                Button.Text = ButtonConfig.Title
                Button.Font = Enum.Font.GothamBold
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.TextSize = 14
                Button.LayoutOrder = ItemCount

                local UICorner = Instance.new("UICorner", Button)
                UICorner.CornerRadius = UDim.new(0, 6)

                Button.MouseEnter:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = GuiConfig.Color}):Play()
                end)
                Button.MouseLeave:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
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
                ToggleConfig.Callback = ToggleConfig.Callback or function(value) print(value) end

                local ToggleFunc = {Value = ToggleConfig.Default}

                local Toggle = Instance.new("Frame", ItemsContainer)
                Toggle.Size = UDim2.new(1, 0, 0, 35)
                Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                Toggle.LayoutOrder = ItemCount

                local UICorner = Instance.new("UICorner", Toggle)
                UICorner.CornerRadius = UDim.new(0, 6)

                local Title = Instance.new("TextLabel", Toggle)
                Title.Text = ToggleConfig.Title
                Title.Font = Enum.Font.GothamBold
                Title.TextColor3 = Color3.fromRGB(230, 230, 230)
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
                Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Circle.CornerRadius = UDim.new(0, 8)

                local ToggleButton = Instance.new("TextButton", Toggle)
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Text = ""

                ToggleButton.Activated:Connect(function()
                    CircleClick(ToggleButton, Mouse.X, Mouse.Y)
                    ToggleFunc.Value = not ToggleFunc.Value
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = ToggleFunc.Value and GuiConfig.Color or Color3.fromRGB(80, 80, 80)}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Position = ToggleFunc.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                    ToggleConfig.Callback(ToggleFunc.Value)
                end)

                function ToggleFunc:Set(value)
                    ToggleFunc.Value = value
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = value and GuiConfig.Color or Color3.fromRGB(80, 80, 80)}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Position = value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                    ToggleConfig.Callback(value)
                end

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
                SliderConfig.Callback = SliderConfig.Callback or function(value) print(value) end

                local SliderFunc = {Value = SliderConfig.Default}

                local Slider = Instance.new("Frame", ItemsContainer)
                Slider.Size = UDim2.new(1, 0, 0, 50)
                Slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                Slider.LayoutOrder = ItemCount

                local UICorner = Instance.new("UICorner", Slider)
                UICorner.CornerRadius = UDim.new(0, 6)

                local Title = Instance.new("TextLabel", Slider)
                Title.Text = SliderConfig.Title
                Title.Font = Enum.Font.GothamBold
                Title.TextColor3 = Color3.fromRGB(230, 230, 230)
                Title.TextSize = 14
                Title.Size = UDim2.new(1, -150, 0, 20)
                Title.Position = UDim2.new(0, 10, 0, 5)
                Title.BackgroundTransparency = 1

                local SliderBar = Instance.new("Frame", Slider)
                SliderBar.Size = UDim2.new(1, -20, 0, 5)
                SliderBar.Position = UDim2.new(0, 10, 1, -15)
                SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

                local Fill = Instance.new("Frame", SliderBar)
                Fill.Size = UDim2.new((SliderConfig.Default - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 0, 1, 0)
                Fill.BackgroundColor3 = GuiConfig.Color

                local Circle = Instance.new("Frame", Fill)
                Circle.Size = UDim2.new(0, 12, 0, 12)
                Circle.Position = UDim2.new(1, -6, 0.5, -6)
                Circle.BackgroundColor3 = GuiConfig.Color
                Circle.CornerRadius = UDim.new(0, 6)

                local ValueLabel = Instance.new("TextLabel", Slider)
                ValueLabel.Text = tostring(SliderConfig.Default)
                ValueLabel.Font = Enum.Font.Gotham
                ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ValueLabel.TextSize = 12
                ValueLabel.Size = UDim2.new(0, 50, 0, 20)
                ValueLabel.Position = UDim2.new(1, -60, 0, 5)
                ValueLabel.BackgroundTransparency = 1

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
                        Fill.Size = UDim2.new(pos, 0, 1, 0)
                        ValueLabel.Text = tostring(SliderFunc.Value)
                    end
                end)

                function SliderFunc:Set(value)
                    SliderFunc.Value = math.clamp(value, SliderConfig.Min, SliderConfig.Max)
                    Fill.Size = UDim2.new((SliderFunc.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 0, 1, 0)
                    ValueLabel.Text = tostring(SliderFunc.Value)
                    SliderConfig.Callback(SliderFunc.Value)
                end

                ItemCount = ItemCount + 1
                return SliderFunc
            end

            function Items:AddColorPicker(ColorConfig)
                ColorConfig = ColorConfig or {}
                ColorConfig.Title = ColorConfig.Title or "Color Picker"
                ColorConfig.Default = ColorConfig.Default or Color3.fromRGB(255, 255, 255)
                ColorConfig.Callback = ColorConfig.Callback or function(color) print(color) end

                local ColorFunc = {Value = ColorConfig.Default}

                local ColorPicker = Instance.new("Frame", ItemsContainer)
                ColorPicker.Size = UDim2.new(1, 0, 0, 35)
                ColorPicker.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                ColorPicker.LayoutOrder = ItemCount

                local UICorner = Instance.new("UICorner", ColorPicker)
                UICorner.CornerRadius = UDim.new(0, 6)

                local Title = Instance.new("TextLabel", ColorPicker)
                Title.Text = ColorConfig.Title
                Title.Font = Enum.Font.GothamBold
                Title.TextColor3 = Color3.fromRGB(230, 230, 230)
                Title.TextSize = 14
                Title.Size = UDim2.new(1, -50, 1, 0)
                Title.Position = UDim2.new(0, 10, 0, 0)
                Title.BackgroundTransparency = 1

                local ColorPreview = Instance.new("Frame", ColorPicker)
                ColorPreview.Size = UDim2.new(0, 30, 0, 20)
                ColorPreview.Position = UDim2.new(1, -40, 0.5, -10)
                ColorPreview.BackgroundColor3 = ColorConfig.Default
                ColorPreview.CornerRadius = UDim.new(0, 4)

                local PickerMenu = Instance.new("Frame", Main)
                PickerMenu.Size = UDim2.new(0, 150, 0, 0)
                PickerMenu.Position = UDim2.new(0, ColorPicker.AbsolutePosition.X, 0, ColorPicker.AbsolutePosition.Y + 35)
                PickerMenu.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                PickerMenu.Visible = false

                local PickerCorner = Instance.new("UICorner", PickerMenu)
                PickerCorner.CornerRadius = UDim.new(0, 6)

                local HueBar = Instance.new("Frame", PickerMenu)
                HueBar.Size = UDim2.new(1, -10, 0, 10)
                HueBar.Position = UDim2.new(0, 5, 0, 5)
                HueBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

                local SaturationValue = Instance.new("Frame", PickerMenu)
                SaturationValue.Size = UDim2.new(1, -10, 0, 100)
                SaturationValue.Position = UDim2.new(0, 5, 0, 20)
                SaturationValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

                local ColorPickerButton = Instance.new("TextButton", ColorPicker)
                ColorPickerButton.Size = UDim2.new(1, 0, 1, 0)
                ColorPickerButton.BackgroundTransparency = 1
                ColorPickerButton.Text = ""

                ColorPickerButton.Activated:Connect(function()
                    CircleClick(ColorPickerButton, Mouse.X, Mouse.Y)
                    PickerMenu.Visible = not PickerMenu.Visible
                    if PickerMenu.Visible then
                        TweenService:Create(PickerMenu, TweenInfo.new(0.3, Enum.EasingStyle.Elastic), {Size = UDim2.new(0, 150, 0, 130)}):Play()
                    else
                        TweenService:Create(PickerMenu, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 150, 0, 0)}):Play()
                    end
                end)

                function ColorFunc:Set(color)
                    ColorFunc.Value = color
                    ColorPreview.BackgroundColor3 = color
                    ColorConfig.Callback(color)
                end

                ItemCount = ItemCount + 1
                return ColorFunc
            end

            SectionCount = SectionCount + 1
            return Items
        end

        TabCount = TabCount + 1
        return Sections
    end

    function GuiFunc:DestroyGui()
        HirimiGui:Destroy()
    end

    return Tabs, GuiFunc
end

return CatLib