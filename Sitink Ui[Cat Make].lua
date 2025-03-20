local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")

local Themes = {
	Names = {
		"Dark", "Darker", "Light", "Aqua", "Amethyst", "Rose", "Sakura", "Cat"
	},
	Cat = {
		Name = "Cat", Accent = Color3.fromRGB(0, 255, 0),
		AcrylicMain = Color3.fromRGB(0, 0, 0), AcrylicBorder = Color3.fromRGB(51, 153, 153),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(20, 20, 20), Color3.fromRGB(0, 0, 0)),
		TitleBarLine = Color3.fromRGB(51, 153, 153), Tab = Color3.fromRGB(51, 153, 153),
		Element = Color3.fromRGB(60, 60, 60), ElementBorder = Color3.fromRGB(80, 80, 80),
		InElementBorder = Color3.fromRGB(100, 100, 100), ElementTransparency = 0.85,
		ToggleSlider = Color3.fromRGB(0, 255, 0), ToggleCorner = Color3.fromRGB(96, 96, 99),
		ToggleToggled = Color3.fromRGB(0, 0, 0), SliderRail = Color3.fromRGB(80, 0, 160),
		DropdownFrame = Color3.fromRGB(50, 50, 50), DropdownHolder = Color3.fromRGB(30, 30, 30),
		DropdownBorder = Color3.fromRGB(60, 60, 60), DropdownOption = Color3.fromRGB(0, 255, 0),
		Keybind = Color3.fromRGB(0, 255, 0), Input = Color3.fromRGB(40, 40, 40),
		InputFocused = Color3.fromRGB(0, 0, 0), InputIndicator = Color3.fromRGB(80, 80, 80),
		Dialog = Color3.fromRGB(0, 0, 0), DialogHolder = Color3.fromRGB(20, 20, 20),
		DialogHolderLine = Color3.fromRGB(40, 40, 40), DialogButton = Color3.fromRGB(30, 30, 30),
		DialogButtonBorder = Color3.fromRGB(0, 255, 0), DialogBorder = Color3.fromRGB(0, 255, 0),
		DialogInput = Color3.fromRGB(40, 40, 40), DialogInputLine = Color3.fromRGB(0, 255, 0),
		Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(200, 200, 200),
		Hover = Color3.fromRGB(100, 0, 255), HoverChange = 0.1,
	},
	Dark = {
		Name = "Dark", Accent = Color3.fromRGB(96, 205, 255),
		AcrylicMain = Color3.fromRGB(60, 60, 60), AcrylicBorder = Color3.fromRGB(90, 90, 90),
		AcrylicGradient = ColorSequence.new(Color3.fromRGB(40, 40, 40), Color3.fromRGB(40, 40, 40)),
		AcrylicNoise = 0.9, TitleBarLine = Color3.fromRGB(75, 75, 75), Tab = Color3.fromRGB(120, 120, 120),
		Element = Color3.fromRGB(120, 120, 120), ElementBorder = Color3.fromRGB(35, 35, 35),
		InElementBorder = Color3.fromRGB(90, 90, 90), ElementTransparency = 0.87,
		ToggleSlider = Color3.fromRGB(120, 120, 120), ToggleToggled = Color3.fromRGB(0, 0, 0),
		SliderRail = Color3.fromRGB(120, 120, 120), DropdownFrame = Color3.fromRGB(160, 160, 160),
		DropdownHolder = Color3.fromRGB(45, 45, 45), DropdownBorder = Color3.fromRGB(35, 35, 35),
		DropdownOption = Color3.fromRGB(120, 120, 120), Keybind = Color3.fromRGB(120, 120, 120),
		Input = Color3.fromRGB(160, 160, 160), InputFocused = Color3.fromRGB(10, 10, 10),
		InputIndicator = Color3.fromRGB(150, 150, 150), Dialog = Color3.fromRGB(45, 45, 45),
		DialogHolder = Color3.fromRGB(35, 35, 35), DialogHolderLine = Color3.fromRGB(30, 30, 30),
		DialogButton = Color3.fromRGB(45, 45, 45), DialogButtonBorder = Color3.fromRGB(80, 80, 80),
		DialogBorder = Color3.fromRGB(70, 70, 70), DialogInput = Color3.fromRGB(55, 55, 55),
		DialogInputLine = Color3.fromRGB(160, 160, 160), Text = Color3.fromRGB(240, 240, 240),
		SubText = Color3.fromRGB(170, 170, 170), Hover = Color3.fromRGB(120, 120, 120), HoverChange = 0.07,
	},
	Darker = { Name = "Darker", Accent = Color3.fromRGB(72, 138, 182), AcrylicMain = Color3.fromRGB(30, 30, 30), AcrylicBorder = Color3.fromRGB(60, 60, 60), AcrylicGradient = ColorSequence.new(Color3.fromRGB(25, 25, 25), Color3.fromRGB(15, 15, 15)), AcrylicNoise = 0.94, TitleBarLine = Color3.fromRGB(65, 65, 65), Tab = Color3.fromRGB(100, 100, 100), Element = Color3.fromRGB(70, 70, 70), ElementBorder = Color3.fromRGB(25, 25, 25), InElementBorder = Color3.fromRGB(55, 55, 55), ElementTransparency = 0.82, DropdownFrame = Color3.fromRGB(120, 120, 120), DropdownHolder = Color3.fromRGB(35, 35, 35), DropdownBorder = Color3.fromRGB(25, 25, 25), Dialog = Color3.fromRGB(35, 35, 35), DialogHolder = Color3.fromRGB(25, 25, 25), DialogHolderLine = Color3.fromRGB(20, 20, 20), DialogButton = Color3.fromRGB(35, 35, 35), DialogButtonBorder = Color3.fromRGB(55, 55, 55), DialogBorder = Color3.fromRGB(50, 50, 50), DialogInput = Color3.fromRGB(45, 45, 45), DialogInputLine = Color3.fromRGB(120, 120, 120) },
	Light = { Name = "Light", Accent = Color3.fromRGB(0, 103, 192), AcrylicMain = Color3.fromRGB(200, 200, 200), AcrylicBorder = Color3.fromRGB(120, 120, 120), AcrylicGradient = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255)), AcrylicNoise = 0.96, TitleBarLine = Color3.fromRGB(160, 160, 160), Tab = Color3.fromRGB(90, 90, 90), Element = Color3.fromRGB(255, 255, 255), ElementBorder = Color3.fromRGB(180, 180, 180), InElementBorder = Color3.fromRGB(150, 150, 150), ElementTransparency = 0.65, ToggleSlider = Color3.fromRGB(40, 40, 40), ToggleToggled = Color3.fromRGB(255, 255, 255), SliderRail = Color3.fromRGB(40, 40, 40), DropdownFrame = Color3.fromRGB(200, 200, 200), DropdownHolder = Color3.fromRGB(240, 240, 240), DropdownBorder = Color3.fromRGB(200, 200, 200), DropdownOption = Color3.fromRGB(150, 150, 150), Keybind = Color3.fromRGB(120, 120, 120), Input = Color3.fromRGB(200, 200, 200), InputFocused = Color3.fromRGB(100, 100, 100), InputIndicator = Color3.fromRGB(80, 80, 80), Dialog = Color3.fromRGB(255, 255, 255), DialogHolder = Color3.fromRGB(240, 240, 240), DialogHolderLine = Color3.fromRGB(228, 228, 228), DialogButton = Color3.fromRGB(255, 255, 255), DialogButtonBorder = Color3.fromRGB(190, 190, 190), DialogBorder = Color3.fromRGB(140, 140, 140), DialogInput = Color3.fromRGB(250, 250, 250), DialogInputLine = Color3.fromRGB(160, 160, 160), Text = Color3.fromRGB(0, 0, 0), SubText = Color3.fromRGB(40, 40, 40), Hover = Color3.fromRGB(50, 50, 50), HoverChange = 0.16 },
	Aqua = { Name = "Aqua", Accent = Color3.fromRGB(60, 165, 165), AcrylicMain = Color3.fromRGB(20, 20, 20), AcrylicBorder = Color3.fromRGB(50, 100, 100), AcrylicGradient = ColorSequence.new(Color3.fromRGB(60, 140, 140), Color3.fromRGB(40, 80, 80)), AcrylicNoise = 0.92, TitleBarLine = Color3.fromRGB(60, 120, 120), Tab = Color3.fromRGB(140, 180, 180), Element = Color3.fromRGB(110, 160, 160), ElementBorder = Color3.fromRGB(40, 70, 70), InElementBorder = Color3.fromRGB(80, 110, 110), ElementTransparency = 0.84, ToggleSlider = Color3.fromRGB(110, 160, 160), ToggleToggled = Color3.fromRGB(0, 0, 0), SliderRail = Color3.fromRGB(110, 160, 160), DropdownFrame = Color3.fromRGB(160, 200, 200), DropdownHolder = Color3.fromRGB(40, 80, 80), DropdownBorder = Color3.fromRGB(40, 65, 65), DropdownOption = Color3.fromRGB(110, 160, 160), Keybind = Color3.fromRGB(110, 160, 160), Input = Color3.fromRGB(110, 160, 160), InputFocused = Color3.fromRGB(20, 10, 30), InputIndicator = Color3.fromRGB(130, 170, 170), Dialog = Color3.fromRGB(40, 80, 80), DialogHolder = Color3.fromRGB(30, 60, 60), DialogHolderLine = Color3.fromRGB(25, 50, 50), DialogButton = Color3.fromRGB(40, 80, 80), DialogButtonBorder = Color3.fromRGB(80, 110, 110), DialogBorder = Color3.fromRGB(50, 100, 100), DialogInput = Color3.fromRGB(45, 90, 90), DialogInputLine = Color3.fromRGB(130, 170, 170), Text = Color3.fromRGB(240, 240, 240), SubText = Color3.fromRGB(170, 170, 170), Hover = Color3.fromRGB(110, 160, 160), HoverChange = 0.04 },
	Amethyst = { Name = "Amethyst", Accent = Color3.fromRGB(97, 62, 167), AcrylicMain = Color3.fromRGB(20, 20, 20), AcrylicBorder = Color3.fromRGB(110, 90, 130), AcrylicGradient = ColorSequence.new(Color3.fromRGB(85, 57, 139), Color3.fromRGB(40, 25, 65)), AcrylicNoise = 0.92, TitleBarLine = Color3.fromRGB(95, 75, 110), Tab = Color3.fromRGB(160, 140, 180), Element = Color3.fromRGB(140, 120, 160), ElementBorder = Color3.fromRGB(60, 50, 70), InElementBorder = Color3.fromRGB(100, 90, 110), ElementTransparency = 0.87, ToggleSlider = Color3.fromRGB(140, 120, 160), ToggleToggled = Color3.fromRGB(0, 0, 0), SliderRail = Color3.fromRGB(140, 120, 160), DropdownFrame = Color3.fromRGB(170, 160, 200), DropdownHolder = Color3.fromRGB(60, 45, 80), DropdownBorder = Color3.fromRGB(50, 40, 65), DropdownOption = Color3.fromRGB(140, 120, 160), Keybind = Color3.fromRGB(140, 120, 160), Input = Color3.fromRGB(140, 120, 160), InputFocused = Color3.fromRGB(20, 10, 30), InputIndicator = Color3.fromRGB(170, 150, 190), Dialog = Color3.fromRGB(60, 45, 80), DialogHolder = Color3.fromRGB(45, 30, 65), DialogHolderLine = Color3.fromRGB(40, 25, 60), DialogButton = Color3.fromRGB(60, 45, 80), DialogButtonBorder = Color3.fromRGB(95, 80, 110), DialogBorder = Color3.fromRGB(85, 70, 100), DialogInput = Color3.fromRGB(70, 55, 85), DialogInputLine = Color3.fromRGB(175, 160, 190), Text = Color3.fromRGB(240, 240, 240), SubText = Color3.fromRGB(170, 170, 170), Hover = Color3.fromRGB(140, 120, 160), HoverChange = 0.04 },
	Rose = { Name = "Rose", Accent = Color3.fromRGB(180, 55, 90), AcrylicMain = Color3.fromRGB(40, 40, 40), AcrylicBorder = Color3.fromRGB(130, 90, 110), AcrylicGradient = ColorSequence.new(Color3.fromRGB(190, 60, 135), Color3.fromRGB(165, 50, 70)), AcrylicNoise = 0.92, TitleBarLine = Color3.fromRGB(140, 85, 105), Tab = Color3.fromRGB(180, 140, 160), Element = Color3.fromRGB(200, 120, 170), ElementBorder = Color3.fromRGB(110, 70, 85), InElementBorder = Color3.fromRGB(120, 90, 90), ElementTransparency = 0.86, ToggleSlider = Color3.fromRGB(200, 120, 170), ToggleToggled = Color3.fromRGB(0, 0, 0), SliderRail = Color3.fromRGB(200, 120, 170), DropdownFrame = Color3.fromRGB(200, 160, 180), DropdownHolder = Color3.fromRGB(120, 50, 75), DropdownBorder = Color3.fromRGB(90, 40, 55), DropdownOption = Color3.fromRGB(200, 120, 170), Keybind = Color3.fromRGB(200, 120, 170), Input = Color3.fromRGB(200, 120, 170), InputFocused = Color3.fromRGB(20, 10, 30), InputIndicator = Color3.fromRGB(170, 150, 190), Dialog = Color3.fromRGB(120, 50, 75), DialogHolder = Color3.fromRGB(95, 40, 60), DialogHolderLine = Color3.fromRGB(90, 35, 55), DialogButton = Color3.fromRGB(120, 50, 75), DialogButtonBorder = Color3.fromRGB(155, 90, 115), DialogBorder = Color3.fromRGB(100, 70, 90), DialogInput = Color3.fromRGB(135, 55, 80), DialogInputLine = Color3.fromRGB(190, 160, 180), Text = Color3.fromRGB(240, 240, 240), SubText = Color3.fromRGB(170, 170, 170), Hover = Color3.fromRGB(200, 120, 170), HoverChange = 0.04 },
	Sakura = { Name = "Sakura", Accent = Color3.fromRGB(252, 209, 215), AcrylicMain = Color3.fromRGB(40, 40, 40), AcrylicBorder = Color3.fromRGB(130, 90, 110), AcrylicGradient = ColorSequence.new{ ColorSequenceKeypoint.new(0, Color3.fromRGB(252, 209, 215)), ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 231, 222)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(233, 177, 205)), ColorSequenceKeypoint.new(0.75, Color3.fromRGB(195, 130, 158)), ColorSequenceKeypoint.new(1, Color3.fromRGB(86, 33, 53)) }, AcrylicNoise = 0.92, TitleBarLine = Color3.fromRGB(140, 85, 105), Tab = Color3.fromRGB(132, 89, 95), Element = Color3.fromRGB(220, 140, 190), ElementBorder = Color3.fromRGB(110, 70, 85), InElementBorder = Color3.fromRGB(120, 90, 90), ElementTransparency = 0.86, ToggleSlider = Color3.fromRGB(252, 209, 215), ToggleToggled = Color3.fromRGB(252, 209, 215), TransparenToggle = 0.5, SliderRail = Color3.fromRGB(252, 209, 215), DropdownFrame = Color3.fromRGB(252, 209, 215), DropdownHolder = Color3.fromRGB(156, 103, 123), DropdownBorder = Color3.fromRGB(90, 40, 55), DropdownOption = Color3.fromRGB(252, 209, 215), Keybind = Color3.fromRGB(200, 120, 170), Input = Color3.fromRGB(200, 120, 170), InputFocused = Color3.fromRGB(200, 200, 200), InputIndicator = Color3.fromRGB(170, 150, 190), Dialog = Color3.fromRGB(120, 50, 75), DialogHolder = Color3.fromRGB(95, 40, 60), DialogHolderLine = Color3.fromRGB(90, 35, 55), DialogButton = Color3.fromRGB(120, 50, 75), DialogButtonBorder = Color3.fromRGB(155, 90, 115), DialogBorder = Color3.fromRGB(100, 70, 90), DialogInput = Color3.fromRGB(135, 55, 80), DialogInputLine = Color3.fromRGB(190, 160, 180), Text = Color3.fromRGB(240, 240, 240), SubText = Color3.fromRGB(220, 220, 220), Hover = Color3.fromRGB(200, 120, 170), HoverChange = 0.04 }
}

local sitinklib = {}
local CurrentTheme

-- Hàm kéo thả
local function MakeDraggable(topbar, frame)
	local dragging, dragInput, startPos, startFramePos
	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			startPos = input.Position
			startFramePos = frame.Position
		end
	end)
	topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - startPos
			frame.Position = UDim2.new(startFramePos.X.Scale, startFramePos.X.Offset + delta.X, startFramePos.Y.Scale, startFramePos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

-- Khởi tạo GUI
function sitinklib:Start(GuiConfig)
	GuiConfig = GuiConfig or {}
	GuiConfig.Name = GuiConfig.Name or "sitink Hub"
	GuiConfig.Description = GuiConfig.Description or ""
	GuiConfig.Theme = GuiConfig.Theme or Themes.Dark
	CurrentTheme = GuiConfig.Theme

	local SitinkGui = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIGradient = Instance.new("UIGradient")
	local Top = Instance.new("Frame")
	local TopTitle = Instance.new("TextLabel")
	local TopDescription = Instance.new("TextLabel")
	local MinimizeButton = Instance.new("TextButton")
	local CloseButton = Instance.new("TextButton")
	local DropShadowHolder = Instance.new("Frame")
	local DropShadow = Instance.new("ImageLabel")

	SitinkGui.Name = "SitinkGui"
	SitinkGui.Parent = CoreGui
	SitinkGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	Main.Name = "Main"
	Main.Parent = SitinkGui
	Main.BackgroundColor3 = CurrentTheme.AcrylicMain
	Main.BackgroundTransparency = CurrentTheme.ElementTransparency or 0
	Main.BorderColor3 = CurrentTheme.AcrylicBorder
	Main.Size = UDim2.new(0, 500, 0, 300)
	Main.Position = UDim2.new(0.5, -250, 0.5, -150)
	UICorner.CornerRadius = UDim.new(0, 5)
	UICorner.Parent = Main
	UIGradient.Color = CurrentTheme.AcrylicGradient
	UIGradient.Parent = Main

	Top.Name = "Top"
	Top.Parent = Main
	Top.BackgroundColor3 = CurrentTheme.TitleBarLine
	Top.BackgroundTransparency = 0.999
	Top.Size = UDim2.new(1, 0, 0, 34)

	TopTitle.Name = "TopTitle"
	TopTitle.Parent = Top
	TopTitle.BackgroundTransparency = 1
	TopTitle.Position = UDim2.new(0, 12, 0, 10)
	TopTitle.Size = UDim2.new(0, 0, 0, 14)
	TopTitle.Font = Enum.Font.GothamBold
	TopTitle.Text = GuiConfig.Name
	TopTitle.TextColor3 = CurrentTheme.Accent
	TopTitle.TextSize = 14
	TopTitle.TextXAlignment = Enum.TextXAlignment.Left

	TopDescription.Name = "TopDescription"
	TopDescription.Parent = Top
	TopDescription.BackgroundTransparency = 1
	TopDescription.Position = UDim2.new(0, 16 + TopTitle.TextBounds.X, 0, 10)
	TopDescription.Size = UDim2.new(0, 0, 0, 14)
	TopDescription.Font = Enum.Font.GothamBold
	TopDescription.Text = GuiConfig.Description
	TopDescription.TextColor3 = CurrentTheme.SubText
	TopDescription.TextSize = 14
	TopDescription.TextXAlignment = Enum.TextXAlignment.Left

	MinimizeButton.Name = "MinimizeButton"
	MinimizeButton.Parent = Top
	MinimizeButton.BackgroundTransparency = 1
	MinimizeButton.Position = UDim2.new(1, -68, 0, 0)
	MinimizeButton.Size = UDim2.new(0, 34, 0, 34)
	MinimizeButton.Font = Enum.Font.SourceSans
	MinimizeButton.Text = "-"
	MinimizeButton.TextColor3 = CurrentTheme.Text
	MinimizeButton.TextSize = 24
	MinimizeButton.MouseButton1Click:Connect(function()
		if Main.Size.Y.Offset > 34 then
			TweenService:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0, 500, 0, 34)}):Play()
		else
			TweenService:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0, 500, 0, 300)}):Play()
		end
	end)

	CloseButton.Name = "CloseButton"
	CloseButton.Parent = Top
	CloseButton.BackgroundTransparency = 1
	CloseButton.Position = UDim2.new(1, -34, 0, 0)
	CloseButton.Size = UDim2.new(0, 34, 0, 34)
	CloseButton.Font = Enum.Font.SourceSans
	CloseButton.Text = "X"
	CloseButton.TextColor3 = CurrentTheme.Text
	CloseButton.TextSize = 24

	DropShadowHolder.Name = "DropShadowHolder"
	DropShadowHolder.Parent = Main
	DropShadowHolder.BackgroundTransparency = 1
	DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
	DropShadowHolder.ZIndex = 0
	DropShadow.Name = "DropShadow"
	DropShadow.Parent = DropShadowHolder
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.Image = "rbxassetid://6014261993"
	DropShadow.ImageColor3 = CurrentTheme.AcrylicBorder
	DropShadow.ImageTransparency = 0.6

	MakeDraggable(Top, Main)

	local LayersTab = Instance.new("Frame")
	local ScrollTab = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")

	LayersTab.Name = "LayersTab"
	LayersTab.Parent = Main
	LayersTab.BackgroundColor3 = CurrentTheme.Tab
	LayersTab.BackgroundTransparency = 0.999
	LayersTab.Position = UDim2.new(0, 10, 0, 34)
	LayersTab.Size = UDim2.new(0, 135, 1, -44)

	ScrollTab.Name = "ScrollTab"
	ScrollTab.Parent = LayersTab
	ScrollTab.BackgroundTransparency = 1
	ScrollTab.Position = UDim2.new(0, 0, 0, 5)
	ScrollTab.Size = UDim2.new(1, 0, 1, -10)
	ScrollTab.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollTab.ScrollBarThickness = 2

	UIListLayout.Parent = ScrollTab
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	local Tabs = {}
	local firstTab = true

	function Tabs:MakeTab(NameTab)
		local Tab = Instance.new("Frame")
		local TabButton = Instance.new("TextButton")
		local ScrollLayer = Instance.new("ScrollingFrame")
		local UIListLayoutLayer = Instance.new("UIListLayout")

		Tab.Name = NameTab
		Tab.Parent = Main
		Tab.BackgroundColor3 = CurrentTheme.Element
		Tab.BackgroundTransparency = CurrentTheme.ElementTransparency
		Tab.BorderColor3 = CurrentTheme.ElementBorder
		Tab.Position = UDim2.new(0, 155, 0, 44)
		Tab.Size = UDim2.new(1, -165, 1, -54)
		Tab.Visible = firstTab

		ScrollLayer.Name = "ScrollLayer"
		ScrollLayer.Parent = Tab
		ScrollLayer.BackgroundTransparency = 1
		ScrollLayer.Position = UDim2.new(0, 0, 0, 5)
		ScrollLayer.Size = UDim2.new(1, 0, 1, -10)
		ScrollLayer.CanvasSize = UDim2.new(0, 0, 0, 0)
		ScrollLayer.ScrollBarThickness = 2

		UIListLayoutLayer.Parent = ScrollLayer
		UIListLayoutLayer.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayoutLayer.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayoutLayer.Padding = UDim.new(0, 5)

		TabButton.Name = "TabButton"
		TabButton.Parent = ScrollTab
		TabButton.BackgroundColor3 = CurrentTheme.Element
		TabButton.BorderColor3 = CurrentTheme.ElementBorder
		TabButton.Size = UDim2.new(1, -10, 0, 30)
		TabButton.Font = Enum.Font.Gotham
		TabButton.Text = NameTab
		TabButton.TextColor3 = CurrentTheme.Text
		TabButton.TextSize = 14
		TabButton.MouseButton1Click:Connect(function()
			for _, v in pairs(Main:GetChildren()) do
				if v.Name ~= "Top" and v.Name ~= "LayersTab" and v.Name ~= "DropShadowHolder" then
					v.Visible = false
				end
			end
			Tab.Visible = true
		end)

		local UICornerTab = Instance.new("UICorner")
		UICornerTab.CornerRadius = UDim.new(0, 3)
		UICornerTab.Parent = TabButton

		ScrollTab.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
		ScrollLayer.CanvasSize = UDim2.new(0, 0, 0, UIListLayoutLayer.AbsoluteContentSize.Y + 10)
		firstTab = false

		local Sections = {}
		local Items = {}

		function Sections:Section(SectionConfig)
			local Section = Instance.new("Frame")
			local SectionTitle = Instance.new("TextLabel")
			local SectionContent = Instance.new("Frame")
			local UIListLayoutSection = Instance.new("UIListLayout")

			Section.Name = SectionConfig.Name or "Section"
			Section.Parent = ScrollLayer
			Section.BackgroundColor3 = CurrentTheme.Element
			Section.BorderColor3 = CurrentTheme.ElementBorder
			Section.Size = UDim2.new(1, -10, 0, 30)

			SectionTitle.Name = "SectionTitle"
			SectionTitle.Parent = Section
			SectionTitle.BackgroundTransparency = 1
			SectionTitle.Position = UDim2.new(0, 10, 0, 5)
			SectionTitle.Size = UDim2.new(1, -20, 0, 20)
			SectionTitle.Font = Enum.Font.GothamBold
			SectionTitle.Text = SectionConfig.Name or "Section"
			SectionTitle.TextColor3 = CurrentTheme.Text
			SectionTitle.TextSize = 14
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

			SectionContent.Name = "SectionContent"
			SectionContent.Parent = Section
			SectionContent.BackgroundTransparency = 1
			SectionContent.Position = UDim2.new(0, 5, 0, 25)
			SectionContent.Size = UDim2.new(1, -10, 0, 0)

			UIListLayoutSection.Parent = SectionContent
			UIListLayoutSection.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayoutSection.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayoutSection.Padding = UDim.new(0, 5)

			local function UpdateSize()
				Section.Size = UDim2.new(1, -10, 0, UIListLayoutSection.AbsoluteContentSize.Y + 30)
				ScrollLayer.CanvasSize = UDim2.new(0, 0, 0, UIListLayoutLayer.AbsoluteContentSize.Y + 10)
			end
			UIListLayoutSection:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize)

			function Items:Button(ButtonConfig)
				local Button = Instance.new("TextButton")
				Button.Parent = SectionContent
				Button.BackgroundColor3 = CurrentTheme.Element
				Button.BorderColor3 = CurrentTheme.ElementBorder
				Button.Size = UDim2.new(1, -10, 0, 30)
				Button.Font = Enum.Font.Gotham
				Button.Text = ButtonConfig.Name or "Button"
				Button.TextColor3 = CurrentTheme.Text
				Button.TextSize = 14
				Button.MouseButton1Click:Connect(ButtonConfig.Callback or function() end)
				local UICornerButton = Instance.new("UICorner")
				UICornerButton.CornerRadius = UDim.new(0, 3)
				UICornerButton.Parent = Button
				UpdateSize()
			end

			function Items:Toggle(ToggleConfig)
				local Toggle = Instance.new("Frame")
				local ToggleTitle = Instance.new("TextLabel")
				local ToggleSwitch = Instance.new("Frame")
				local ToggleButton = Instance.new("TextButton")
				local ToggleFunc = {Value = ToggleConfig.Default or false}

				Toggle.Parent = SectionContent
				Toggle.BackgroundColor3 = CurrentTheme.Element
				Toggle.BorderColor3 = CurrentTheme.ElementBorder
				Toggle.Size = UDim2.new(1, -10, 0, 30)

				ToggleTitle.Parent = Toggle
				ToggleTitle.BackgroundTransparency = 1
				ToggleTitle.Position = UDim2.new(0, 10, 0, 5)
				ToggleTitle.Size = UDim2.new(1, -60, 0, 20)
				ToggleTitle.Font = Enum.Font.Gotham
				ToggleTitle.Text = ToggleConfig.Name or "Toggle"
				ToggleTitle.TextColor3 = CurrentTheme.Text
				ToggleTitle.TextSize = 14
				ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

				ToggleSwitch.Parent = Toggle
				ToggleSwitch.BackgroundColor3 = ToggleFunc.Value and CurrentTheme.Accent or CurrentTheme.ToggleSlider
				ToggleSwitch.Position = UDim2.new(1, -40, 0, 5)
				ToggleSwitch.Size = UDim2.new(0, 30, 0, 20)
				local UICornerSwitch = Instance.new("UICorner")
				UICornerSwitch.CornerRadius = UDim.new(0, 10)
				UICornerSwitch.Parent = ToggleSwitch

				ToggleButton.Parent = ToggleSwitch
				ToggleButton.BackgroundTransparency = 1
				ToggleButton.Size = UDim2.new(1, 0, 1, 0)
				ToggleButton.Text = ""
				ToggleButton.MouseButton1Click:Connect(function()
					ToggleFunc.Value = not ToggleFunc.Value
					TweenService:Create(ToggleSwitch, TweenInfo.new(0.2), {BackgroundColor3 = ToggleFunc.Value and CurrentTheme.Accent or CurrentTheme.ToggleSlider}):Play()
					if ToggleConfig.Callback then
						ToggleConfig.Callback(ToggleFunc.Value)
					end
				end)

				function ToggleFunc:Set(Value)
					ToggleFunc.Value = Value
					TweenService:Create(ToggleSwitch, TweenInfo.new(0.2), {BackgroundColor3 = ToggleFunc.Value and CurrentTheme.Accent or CurrentTheme.ToggleSlider}):Play()
					if ToggleConfig.Callback then
						ToggleConfig.Callback(ToggleFunc.Value)
					end
				end

				UpdateSize()
				return ToggleFunc
			end

			function Items:Slider(SliderConfig)
				local Slider = Instance.new("Frame")
				local SliderTitle = Instance.new("TextLabel")
				local SliderBar = Instance.new("Frame")
				local SliderFill = Instance.new("Frame")
				local SliderButton = Instance.new("TextButton")
				local SliderValue = Instance.new("TextLabel")
				local SliderFunc = {Value = SliderConfig.Default or SliderConfig.Min or 0}

				Slider.Parent = SectionContent
				Slider.BackgroundColor3 = CurrentTheme.Element
				Slider.BorderColor3 = CurrentTheme.ElementBorder
				Slider.Size = UDim2.new(1, -10, 0, 40)

				SliderTitle.Parent = Slider
				SliderTitle.BackgroundTransparency = 1
				SliderTitle.Position = UDim2.new(0, 10, 0, 5)
				SliderTitle.Size = UDim2.new(1, -60, 0, 20)
				SliderTitle.Font = Enum.Font.Gotham
				SliderTitle.Text = SliderConfig.Name or "Slider"
				SliderTitle.TextColor3 = CurrentTheme.Text
				SliderTitle.TextSize = 14
				SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

				SliderBar.Parent = Slider
				SliderBar.BackgroundColor3 = CurrentTheme.SliderRail
				SliderBar.Position = UDim2.new(0, 10, 0, 25)
				SliderBar.Size = UDim2.new(1, -20, 0, 5)
				local UICornerBar = Instance.new("UICorner")
				UICornerBar.CornerRadius = UDim.new(0, 3)
				UICornerBar.Parent = SliderBar

				SliderFill.Parent = SliderBar
				SliderFill.BackgroundColor3 = CurrentTheme.Accent
				SliderFill.Size = UDim2.new((SliderFunc.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 0, 1, 0)
				local UICornerFill = Instance.new("UICorner")
				UICornerFill.CornerRadius = UDim.new(0, 3)
				UICornerFill.Parent = SliderFill

				SliderButton.Parent = SliderBar
				SliderButton.BackgroundTransparency = 1
				SliderButton.Size = UDim2.new(1, 0, 1, 0)
				SliderButton.Text = ""

				SliderValue.Parent = Slider
				SliderValue.BackgroundTransparency = 1
				SliderValue.Position = UDim2.new(1, -50, 0, 5)
				SliderValue.Size = UDim2.new(0, 40, 0, 20)
				SliderValue.Font = Enum.Font.Gotham
				SliderValue.Text = tostring(SliderFunc.Value)
				SliderValue.TextColor3 = CurrentTheme.Text
				SliderValue.TextSize = 14

				local dragging = false
				SliderButton.MouseButton1Down:Connect(function()
					dragging = true
				end)
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
					end
				end)
				UserInputService.InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						local relativeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
						SliderFunc.Value = math.floor(SliderConfig.Min + relativeX * (SliderConfig.Max - SliderConfig.Min))
						SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
						SliderValue.Text = tostring(SliderFunc.Value)
						if SliderConfig.Callback then
							SliderConfig.Callback(SliderFunc.Value)
						end
					end
				end)

				function SliderFunc:Set(Value)
					SliderFunc.Value = math.clamp(Value, SliderConfig.Min, SliderConfig.Max)
					SliderFill.Size = UDim2.new((SliderFunc.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 0, 1, 0)
					SliderValue.Text = tostring(SliderFunc.Value)
					if SliderConfig.Callback then
						SliderConfig.Callback(SliderFunc.Value)
					end
				end

				UpdateSize()
				return SliderFunc
			end

			function Items:Dropdown(DropdownConfig)
				local Dropdown = Instance.new("Frame")
				local DropdownTitle = Instance.new("TextLabel")
				local DropdownButton = Instance.new("TextButton")
				local DropdownList = Instance.new("Frame")
				local UIListLayoutDropdown = Instance.new("UIListLayout")
				local DropdownFunc = {Value = DropdownConfig.Default or DropdownConfig.Options[1]}

				Dropdown.Parent = SectionContent
				Dropdown.BackgroundColor3 = CurrentTheme.Element
				Dropdown.BorderColor3 = CurrentTheme.ElementBorder
				Dropdown.Size = UDim2.new(1, -10, 0, 30)

				DropdownTitle.Parent = Dropdown
				DropdownTitle.BackgroundTransparency = 1
				DropdownTitle.Position = UDim2.new(0, 10, 0, 5)
				DropdownTitle.Size = UDim2.new(1, -60, 0, 20)
				DropdownTitle.Font = Enum.Font.Gotham
				DropdownTitle.Text = DropdownConfig.Name or "Dropdown"
				DropdownTitle.TextColor3 = CurrentTheme.Text
				DropdownTitle.TextSize = 14
				DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left

				DropdownButton.Parent = Dropdown
				DropdownButton.BackgroundColor3 = CurrentTheme.DropdownFrame
				DropdownButton.BorderColor3 = CurrentTheme.DropdownBorder
				DropdownButton.Position = UDim2.new(1, -100, 0, 5)
				DropdownButton.Size = UDim2.new(0, 90, 0, 20)
				DropdownButton.Font = Enum.Font.Gotham
				DropdownButton.Text = DropdownFunc.Value
				DropdownButton.TextColor3 = CurrentTheme.Text
				DropdownButton.TextSize = 14
				local UICornerButton = Instance.new("UICorner")
				UICornerButton.CornerRadius = UDim.new(0, 3)
				UICornerButton.Parent = DropdownButton

				DropdownList.Parent = Dropdown
				DropdownList.BackgroundColor3 = CurrentTheme.DropdownHolder
				DropdownList.BorderColor3 = CurrentTheme.DropdownBorder
				DropdownList.Position = UDim2.new(1, -100, 0, 25)
				DropdownList.Size = UDim2.new(0, 90, 0, 0)
				DropdownList.Visible = false
				DropdownList.ClipsDescendants = true

				UIListLayoutDropdown.Parent = DropdownList
				UIListLayoutDropdown.SortOrder = Enum.SortOrder.LayoutOrder

				for _, option in pairs(DropdownConfig.Options) do
					local OptionButton = Instance.new("TextButton")
					OptionButton.Parent = DropdownList
					OptionButton.BackgroundColor3 = CurrentTheme.DropdownOption
					OptionButton.BorderColor3 = CurrentTheme.DropdownBorder
					OptionButton.Size = UDim2.new(1, 0, 0, 20)
					OptionButton.Font = Enum.Font.Gotham
					OptionButton.Text = option
					OptionButton.TextColor3 = CurrentTheme.Text
					OptionButton.TextSize = 14
					OptionButton.MouseButton1Click:Connect(function()
						DropdownFunc.Value = option
						DropdownButton.Text = option
						DropdownList.Visible = false
						Dropdown.Size = UDim2.new(1, -10, 0, 30)
						if DropdownConfig.Callback then
							DropdownConfig.Callback(option)
						end
					end)
					local UICornerOption = Instance.new("UICorner")
					UICornerOption.CornerRadius = UDim.new(0, 3)
					UICornerOption.Parent = OptionButton
				end

				DropdownButton.MouseButton1Click:Connect(function()
					DropdownList.Visible = not DropdownList.Visible
					Dropdown.Size = DropdownList.Visible and UDim2.new(1, -10, 0, 30 + #DropdownConfig.Options * 20) or UDim2.new(1, -10, 0, 30)
					DropdownList.Size = UDim2.new(0, 90, 0, #DropdownConfig.Options * 20)
				end)

				function DropdownFunc:Set(Value)
					if table.find(DropdownConfig.Options, Value) then
						DropdownFunc.Value = Value
						DropdownButton.Text = Value
						if DropdownConfig.Callback then
							DropdownConfig.Callback(Value)
						end
					end
				end

				UpdateSize()
				return DropdownFunc
			end

			function Items:Keybind(KeybindConfig)
				local Keybind = Instance.new("Frame")
				local KeybindTitle = Instance.new("TextLabel")
				local KeybindButton = Instance.new("TextButton")
				local KeybindFunc = {Value = KeybindConfig.Default or Enum.KeyCode.E}

				Keybind.Parent = SectionContent
				Keybind.BackgroundColor3 = CurrentTheme.Element
				Keybind.BorderColor3 = CurrentTheme.ElementBorder
				Keybind.Size = UDim2.new(1, -10, 0, 30)

				KeybindTitle.Parent = Keybind
				KeybindTitle.BackgroundTransparency = 1
				KeybindTitle.Position = UDim2.new(0, 10, 0, 5)
				KeybindTitle.Size = UDim2.new(1, -60, 0, 20)
				KeybindTitle.Font = Enum.Font.Gotham
				KeybindTitle.Text = KeybindConfig.Name or "Keybind"
				KeybindTitle.TextColor3 = CurrentTheme.Text
				KeybindTitle.TextSize = 14
				KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left

				KeybindButton.Parent = Keybind
				KeybindButton.BackgroundColor3 = CurrentTheme.Keybind
				KeybindButton.BorderColor3 = CurrentTheme.ElementBorder
				KeybindButton.Position = UDim2.new(1, -60, 0, 5)
				KeybindButton.Size = UDim2.new(0, 50, 0, 20)
				KeybindButton.Font = Enum.Font.Gotham
				KeybindButton.Text = KeybindFunc.Value.Name
				KeybindButton.TextColor3 = CurrentTheme.Text
				KeybindButton.TextSize = 14
				local UICornerKeybind = Instance.new("UICorner")
				UICornerKeybind.CornerRadius = UDim.new(0, 3)
				UICornerKeybind.Parent = KeybindButton

				local waiting = false
				KeybindButton.MouseButton1Click:Connect(function()
					waiting = true
					KeybindButton.Text = "..."
				end)

				UserInputService.InputBegan:Connect(function(input)
					if waiting and input.UserInputType == Enum.UserInputType.Keyboard then
						KeybindFunc.Value = input.KeyCode
						KeybindButton.Text = input.KeyCode.Name
						waiting = false
						if KeybindConfig.Callback then
							KeybindConfig.Callback(input.KeyCode)
						end
					end
				end)

				function KeybindFunc:Set(Value)
					KeybindFunc.Value = Value
					KeybindButton.Text = Value.Name
					if KeybindConfig.Callback then
						KeybindConfig.Callback(Value)
					end
				end

				UpdateSize()
				return KeybindFunc
			end

			function Items:ColorPicker(ColorPickerConfig)
				local ColorPicker = Instance.new("Frame")
				local ColorPickerTitle = Instance.new("TextLabel")
				local ColorPreview = Instance.new("Frame")
				local ColorPickerButton = Instance.new("TextButton")
				local ColorPickerFrame = Instance.new("Frame")
				local HueBar = Instance.new("Frame")
				local SaturationValue = Instance.new("Frame")
				local ColorPickerFunc = {Value = ColorPickerConfig.Default or Color3.fromRGB(255, 255, 255)}

				ColorPicker.Parent = SectionContent
				ColorPicker.BackgroundColor3 = CurrentTheme.Element
				ColorPicker.BorderColor3 = CurrentTheme.ElementBorder
				ColorPicker.Size = UDim2.new(1, -10, 0, 30)

				ColorPickerTitle.Parent = ColorPicker
				ColorPickerTitle.BackgroundTransparency = 1
				ColorPickerTitle.Position = UDim2.new(0, 10, 0, 5)
				ColorPickerTitle.Size = UDim2.new(1, -60, 0, 20)
				ColorPickerTitle.Font = Enum.Font.Gotham
				ColorPickerTitle.Text = ColorPickerConfig.Name or "ColorPicker"
				ColorPickerTitle.TextColor3 = CurrentTheme.Text
				ColorPickerTitle.TextSize = 14
				ColorPickerTitle.TextXAlignment = Enum.TextXAlignment.Left

				ColorPreview.Parent = ColorPicker
				ColorPreview.BackgroundColor3 = ColorPickerFunc.Value
				ColorPreview.Position = UDim2.new(1, -40, 0, 5)
				ColorPreview.Size = UDim2.new(0, 30, 0, 20)
				local UICornerPreview = Instance.new("UICorner")
				UICornerPreview.CornerRadius = UDim.new(0, 3)
				UICornerPreview.Parent = ColorPreview

				ColorPickerButton.Parent = ColorPicker
				ColorPickerButton.BackgroundTransparency = 1
				ColorPickerButton.Size = UDim2.new(1, 0, 1, 0)
				ColorPickerButton.Text = ""

				ColorPickerFrame.Parent = ColorPicker
				ColorPickerFrame.BackgroundColor3 = CurrentTheme.DropdownHolder
				ColorPickerFrame.BorderColor3 = CurrentTheme.DropdownBorder
				ColorPickerFrame.Position = UDim2.new(1, -150, 0, 25)
				ColorPickerFrame.Size = UDim2.new(0, 140, 0, 100)
				ColorPickerFrame.Visible = false

				HueBar.Parent = ColorPickerFrame
				HueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				HueBar.Position = UDim2.new(0, 5, 0, 5)
				HueBar.Size = UDim2.new(0, 20, 1, -10)
				local HueGradient = Instance.new("UIGradient")
				HueGradient.Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
					ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
					ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
					ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
					ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
					ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
				}
				HueGradient.Parent = HueBar

				SaturationValue.Parent = ColorPickerFrame
				SaturationValue.BackgroundColor3 = ColorPickerFunc.Value
				SaturationValue.Position = UDim2.new(0, 30, 0, 5)
				SaturationValue.Size = UDim2.new(1, -35, 1, -10)

				local draggingHue, draggingSV = false, false
				HueBar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						draggingHue = true
					end
				end)
				SaturationValue.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						draggingSV = true
					end
				end)
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						draggingHue = false
						draggingSV = false
					end
				end)
				UserInputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						if draggingHue then
							local hue = math.clamp((input.Position.Y - HueBaroki Bar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
							local h, s, v = ColorPickerFunc.Value:ToHSV()
							ColorPickerFunc.Value = Color3.fromHSV(hue, s, v)
							ColorPreview.BackgroundColor3 = ColorPickerFunc.Value
							SaturationValue.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
							if ColorPickerConfig.Callback then
								ColorPickerConfig.Callback(ColorPickerFunc.Value)
							end
						end
						if draggingSV then
							local s = math.clamp((input.Position.X - SaturationValue.AbsolutePosition.X) / SaturationValue.AbsoluteSize.X, 0, 1)
							local v = math.clamp(1 - (input.Position.Y - SaturationValue.AbsolutePosition.Y) / SaturationValue.AbsoluteSize.Y, 0, 1)
							local h = ColorPickerFunc.Value:ToHSV()
							ColorPickerFunc.Value = Color3.fromHSV(h, s, v)
							ColorPreview.BackgroundColor3 = ColorPickerFunc.Value
							if ColorPickerConfig.Callback then
								ColorPickerConfig.Callback(ColorPickerFunc.Value)
							end
						end
					end
				end)

				ColorPickerButton.MouseButton1Click:Connect(function()
					ColorPickerFrame.Visible = not ColorPickerFrame.Visible
					ColorPicker.Size = ColorPickerFrame.Visible and UDim2.new(1, -10, 0, 130) or UDim2.new(1, -10, 0, 30)
				end)

				function ColorPickerFunc:Set(Value)
					ColorPickerFunc.Value = Value
					ColorPreview.BackgroundColor3 = Value
					SaturationValue.BackgroundColor3 = Color3.fromHSV(Value:ToHSV())
					if ColorPickerConfig.Callback then
						ColorPickerConfig.Callback(Value)
					end
				end

				UpdateSize()
				return ColorPickerFunc
			end

			return Items
		end
		return Sections
	end

	CloseButton.MouseButton1Click:Connect(function()
		SitinkGui:Destroy()
		if GuiConfig.CloseCallBack then
			GuiConfig.CloseCallBack()
		end
	end)

	return Tabs
end

return sitinklib