local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = LocalPlayer.PlayerGui

local CatLib = {}

-- Hàm tạo Draggable và Resizable
local function MakeDraggable(topbarobject, object)
	local function CustomPos(topbarobject, object)
		local Dragging, DragInput, DragStart, StartPosition
		local function UpdatePos(input)
			local Delta = input.Position - DragStart
			local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
			TweenService:Create(object, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = pos}):Play()
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
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then DragInput = input end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == DragInput and Dragging then UpdatePos(input) end
		end)
	end

	local function CustomSize(object)
		local Dragging, DragInput, DragStart, StartSize
		local minSizeX, minSizeY = 450, 350 -- Giới hạn kích thước tối thiểu
		local maxSizeX, maxSizeY = 800, 600 -- Giới hạn kích thước tối đa
		local changesizeobject = Instance.new("Frame")
		changesizeobject.AnchorPoint = Vector2.new(1, 1)
		changesizeobject.BackgroundTransparency = 0.9
		changesizeobject.Position = UDim2.new(1, 0, 1, 0)
		changesizeobject.Size = UDim2.new(0, 20, 0, 20)
		changesizeobject.Name = "ResizeHandle"
		changesizeobject.Parent = object

		local function UpdateSize(input)
			local Delta = input.Position - DragStart
			local newWidth = math.clamp(StartSize.X.Offset + Delta.X, minSizeX, maxSizeX)
			local newHeight = math.clamp(StartSize.Y.Offset + Delta.Y, minSizeY, maxSizeY)
			TweenService:Create(object, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(0, newWidth, 0, newHeight)}):Play()
			-- Căn chỉnh lại văn bản khi resize
			for _, child in object:GetDescendants() do
				if child:IsA("TextLabel") or child:IsA("TextButton") then
					child.TextScaled = true
					child.TextWrapped = true
				end
			end
		end

		changesizeobject.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				DragStart = input.Position
				StartSize = object.Size
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then Dragging = false end
				end)
			end
		end)
		changesizeobject.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then DragInput = input end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == DragInput and Dragging then UpdateSize(input) end
		end)
	end
	CustomSize(object)
	CustomPos(topbarobject, object)
end

-- Hiệu ứng Click Circle
local function CircleClick(Button, X, Y)
	spawn(function()
		Button.ClipsDescendants = true
		local Circle = Instance.new("ImageLabel")
		Circle.Image = "rbxassetid://266543268"
		Circle.ImageColor3 = Color3.fromRGB(100, 100, 100)
		Circle.BackgroundTransparency = 1
		Circle.ZIndex = 10
		Circle.Parent = Button
		
		local NewX = X - Circle.AbsolutePosition.X
		local NewY = Y - Circle.AbsolutePosition.Y
		Circle.Position = UDim2.new(0, NewX, 0, NewY)
		local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 1.5
		Circle:TweenSizeAndPosition(UDim2.new(0, Size, 0, Size), UDim2.new(0.5, -Size/2, 0.5, -Size/2), "Out", "Sine", 0.4, false, function()
			for i = 1, 10 do
				Circle.ImageTransparency = Circle.ImageTransparency + 0.1
				wait(0.04)
			end
			Circle:Destroy()
		end)
	end)
end

-- Hệ thống thông báo với Object Pooling
local NotifyPool = {}
function CatLib:MakeNotify(NotifyConfig)
	NotifyConfig = NotifyConfig or {}
	NotifyConfig.Title = NotifyConfig.Title or "CatLib v0.4"
	NotifyConfig.Description = NotifyConfig.Description or "Notification"
	NotifyConfig.Content = NotifyConfig.Content or "Content"
	NotifyConfig.Color = NotifyConfig.Color or Color3.fromRGB(0, 170, 255)
	NotifyConfig.Time = NotifyConfig.Time or 0.5
	NotifyConfig.Delay = NotifyConfig.Delay or 5

	local NotifyFunction = {}
	spawn(function()
		if not CoreGui:FindFirstChild("NotifyGui") then
			local NotifyGui = Instance.new("ScreenGui")
			NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			NotifyGui.Name = "NotifyGui"
			NotifyGui.Parent = CoreGui
		end

		if not CoreGui.NotifyGui:FindFirstChild("NotifyLayout") then
			local NotifyLayout = Instance.new("Frame")
			NotifyLayout.AnchorPoint = Vector2.new(1, 1)
			NotifyLayout.BackgroundTransparency = 1
			NotifyLayout.Position = UDim2.new(1, -30, 1, -30)
			NotifyLayout.Size = UDim2.new(0, 320, 1, 0)
			NotifyLayout.Name = "NotifyLayout"
			NotifyLayout.Parent = CoreGui.NotifyGui
			
			local Count = 0
			NotifyLayout.ChildRemoved:Connect(function()
				Count = 0
				for _, v in NotifyLayout:GetChildren() do
					TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Position = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 12) * Count))}):Play()
					Count = Count + 1
				end
			end)
		end

		local NotifyFrame
		if #NotifyPool > 0 then
			NotifyFrame = table.remove(NotifyPool)
			NotifyFrame.Visible = true
		else
			NotifyFrame = Instance.new("Frame")
			local NotifyFrameReal = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local Gradient = Instance.new("UIGradient")
			local DropShadow = Instance.new("ImageLabel")
			local Top = Instance.new("Frame")
			local TitleLabel = Instance.new("TextLabel")
			local DescLabel = Instance.new("TextLabel")
			local ContentLabel = Instance.new("TextLabel")
			local Close = Instance.new("TextButton")
			local CloseImg = Instance.new("ImageLabel")

			NotifyFrame.BackgroundTransparency = 1
			NotifyFrame.Size = UDim2.new(1, 0, 0, 150)
			NotifyFrame.Name = "NotifyFrame"
			NotifyFrame.Parent = CoreGui.NotifyGui.NotifyLayout
			NotifyFrame.AnchorPoint = Vector2.new(0, 1)

			NotifyFrameReal.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			NotifyFrameReal.Position = UDim2.new(0, 400, 0, 0)
			NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
			NotifyFrameReal.Parent = NotifyFrame
			UICorner.CornerRadius = UDim.new(0, 8)
			UICorner.Parent = NotifyFrameReal
			
			Gradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
			}
			Gradient.Rotation = 90
			Gradient.Parent = NotifyFrameReal

			DropShadow.Image = "rbxassetid://6015897843"
			DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
			DropShadow.ImageTransparency = 0.4
			DropShadow.ScaleType = Enum.ScaleType.Slice
			DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
			DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
			DropShadow.BackgroundTransparency = 1
			DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
			DropShadow.Size = UDim2.new(1, 60, 1, 60)
			DropShadow.ZIndex = 0
			DropShadow.Parent = NotifyFrameReal

			Top.BackgroundTransparency = 1
			Top.Size = UDim2.new(1, 0, 0, 36)
			Top.Parent = NotifyFrameReal

			TitleLabel.Font = Enum.Font.GothamBold
			TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TitleLabel.TextSize = 14
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
			TitleLabel.BackgroundTransparency = 1
			TitleLabel.Position = UDim2.new(0, 10, 0, 0)
			TitleLabel.Size = UDim2.new(1, -50, 1, 0)
			TitleLabel.TextScaled = true
			TitleLabel.TextWrapped = true
			TitleLabel.Parent = Top

			DescLabel.Font = Enum.Font.GothamBold
			DescLabel.TextSize = 14
			DescLabel.TextXAlignment = Enum.TextXAlignment.Left
			DescLabel.BackgroundTransparency = 1
			DescLabel.Size = UDim2.new(1, -50, 1, 0)
			DescLabel.TextScaled = true
			DescLabel.TextWrapped = true
			DescLabel.Parent = Top

			ContentLabel.Font = Enum.Font.Gotham
			ContentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
			ContentLabel.TextSize = 13
			ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
			ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
			ContentLabel.BackgroundTransparency = 1
			ContentLabel.Position = UDim2.new(0, 10, 0, 36)
			ContentLabel.TextScaled = true
			ContentLabel.TextWrapped = true
			ContentLabel.Parent = NotifyFrameReal

			Close.Text = ""
			Close.AnchorPoint = Vector2.new(1, 0.5)
			Close.BackgroundTransparency = 1
			Close.Position = UDim2.new(1, -5, 0.5, 0)
			Close.Size = UDim2.new(0, 25, 0, 25)
			Close.Parent = Top
			CloseImg.Image = "rbxassetid://9886659671"
			CloseImg.AnchorPoint = Vector2.new(0.5, 0.5)
			CloseImg.BackgroundTransparency = 1
			CloseImg.Position = UDim2.new(0.5, 0, 0.5, 0)
			CloseImg.Size = UDim2.new(1, -8, 1, -8)
			CloseImg.Parent = Close
		end

		local NotifyPosHeigh = 0
		for _, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
			if v ~= NotifyFrame then
				NotifyPosHeigh = -(v.Position.Y.Offset) + v.Size.Y.Offset + 12
			end
		end
		NotifyFrame.Position = UDim2.new(0, 0, 1, -NotifyPosHeigh)

		NotifyFrame.NotifyFrameReal.Top.TitleLabel.Text = NotifyConfig.Title
		NotifyFrame.NotifyFrameReal.Top.DescLabel.Text = NotifyConfig.Description
		NotifyFrame.NotifyFrameReal.Top.DescLabel.TextColor3 = NotifyConfig.Color
		NotifyFrame.NotifyFrameReal.Top.DescLabel.Position = UDim2.new(0, NotifyFrame.NotifyFrameReal.Top.TitleLabel.TextBounds.X + 15, 0, 0)
		NotifyFrame.NotifyFrameReal.ContentLabel.Text = NotifyConfig.Content
		NotifyFrame.NotifyFrameReal.ContentLabel.Size = UDim2.new(1, -20, 0, 13 + (13 * math.ceil(NotifyFrame.NotifyFrameReal.ContentLabel.TextBounds.X / NotifyFrame.NotifyFrameReal.ContentLabel.AbsoluteSize.X)))
		NotifyFrame.Size = UDim2.new(1, 0, 0, math.max(NotifyFrame.NotifyFrameReal.ContentLabel.AbsoluteSize.Y + 40, 65))

		local waitbruh = false
		function NotifyFunction:Close()
			if waitbruh then return end
			waitbruh = true
			TweenService:Create(NotifyFrame.NotifyFrameReal, TweenInfo.new(NotifyConfig.Time, Enum.EasingStyle.Sine), {Position = UDim2.new(0, 400, 0, 0)}):Play()
			task.wait(NotifyConfig.Time)
			NotifyFrame.Visible = false
			table.insert(NotifyPool, NotifyFrame)
		end

		Close.Activated:Connect(NotifyFunction.Close)
		TweenService:Create(NotifyFrame.NotifyFrameReal, TweenInfo.new(NotifyConfig.Time, Enum.EasingStyle.Sine), {Position = UDim2.new(0, 0, 0, 0)}):Play()
		task.wait(NotifyConfig.Delay)
		NotifyFunction:Close()
	end)
	return NotifyFunction
end

-- Tạo GUI chính
function CatLib:MakeGui(GuiConfig)
	GuiConfig = GuiConfig or {}
	GuiConfig.NameHub = GuiConfig.NameHub or "CatLib v0.4"
	GuiConfig.Description = GuiConfig.Description or "by: catdzs1vn"
	GuiConfig.Color = GuiConfig.Color or Color3.fromRGB(0, 170, 255)
	GuiConfig["Logo Player"] = GuiConfig["Logo Player"] or "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
	GuiConfig["Name Player"] = GuiConfig["Name Player"] or LocalPlayer.Name
	GuiConfig["Tab Width"] = GuiConfig["Tab Width"] or 130

	local GuiFunc = {}
	local HirimiGui = Instance.new("ScreenGui")
	HirimiGui.Name = "HirimiGui"
	HirimiGui.Parent = CoreGui

	local DropShadowHolder = Instance.new("Frame")
	DropShadowHolder.BackgroundTransparency = 1
	DropShadowHolder.Size = UDim2.new(0, 500, 0, 400) -- Kích thước mặc định lớn hơn
	DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadowHolder.Parent = HirimiGui

	local DropShadow = Instance.new("ImageLabel")
	DropShadow.Image = "rbxassetid://6015897843"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
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
	Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size = UDim2.new(1, -20, 1, -20)
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.Parent = DropShadowHolder
	local UICorner = Instance.new("UICorner")
	UICorner.Parent = Main
	local UIGradient = Instance.new("UIGradient")
	UIGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
	}
	UIGradient.Rotation = 90
	UIGradient.Parent = Main

	local Top = Instance.new("Frame")
	Top.BackgroundTransparency = 1
	Top.Size = UDim2.new(1, 0, 0, 38)
	Top.Parent = Main
	local NameLabel = Instance.new("TextLabel")
	NameLabel.Font = Enum.Font.GothamBold
	NameLabel.Text = GuiConfig.NameHub
	NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	NameLabel.TextSize = 14
	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.BackgroundTransparency = 1
	NameLabel.Position = UDim2.new(0, 10, 0, 0)
	NameLabel.Size = UDim2.new(0.5, 0, 1, 0)
	NameLabel.TextScaled = true
	NameLabel.TextWrapped = true
	NameLabel.Parent = Top
	local DescLabel = Instance.new("TextLabel")
	DescLabel.Font = Enum.Font.GothamBold
	DescLabel.Text = GuiConfig.Description
	DescLabel.TextColor3 = GuiConfig.Color
	DescLabel.TextSize = 14
	DescLabel.TextXAlignment = Enum.TextXAlignment.Left
	DescLabel.BackgroundTransparency = 1
	DescLabel.Position = UDim2.new(0, NameLabel.TextBounds.X + 15, 0, 0)
	DescLabel.Size = UDim2.new(0.5, -NameLabel.TextBounds.X - 15, 1, 0)
	DescLabel.TextScaled = true
	DescLabel.TextWrapped = true
	DescLabel.Parent = Top

	local Min = Instance.new("TextButton")
	Min.Text = ""
	Min.AnchorPoint = Vector2.new(1, 0.5)
	Min.BackgroundTransparency = 1
	Min.Position = UDim2.new(1, -78, 0.5, 0)
	Min.Size = UDim2.new(0, 25, 0, 25)
	Min.Parent = Top
	local MinImg = Instance.new("ImageLabel")
	MinImg.Image = "rbxassetid://9886659276"
	MinImg.AnchorPoint = Vector2.new(0.5, 0.5)
	MinImg.BackgroundTransparency = 1
	MinImg.Position = UDim2.new(0.5, 0, 0.5, 0)
	MinImg.Size = UDim2.new(1, -9, 1, -9)
	MinImg.Parent = Min

	local MaxRestore = Instance.new("TextButton")
	MaxRestore.Text = ""
	MaxRestore.AnchorPoint = Vector2.new(1, 0.5)
	MaxRestore.BackgroundTransparency = 1
	MaxRestore.Position = UDim2.new(1, -42, 0.5, 0)
	MaxRestore.Size = UDim2.new(0, 25, 0, 25)
	MaxRestore.Parent = Top
	local MaxImg = Instance.new("ImageLabel")
	MaxImg.Image = "rbxassetid://9886659406"
	MaxImg.AnchorPoint = Vector2.new(0.5, 0.5)
	MaxImg.BackgroundTransparency = 1
	MaxImg.Position = UDim2.new(0.5, 0, 0.5, 0)
	MaxImg.Size = UDim2.new(1, -8, 1, -8)
	MaxImg.Parent = MaxRestore

	local Close = Instance.new("TextButton")
	Close.Text = ""
	Close.AnchorPoint = Vector2.new(1, 0.5)
	Close.BackgroundTransparency = 1
	Close.Position = UDim2.new(1, -8, 0.5, 0)
	Close.Size = UDim2.new(0, 25, 0, 25)
	Close.Parent = Top
	local CloseImg = Instance.new("ImageLabel")
	CloseImg.Image = "rbxassetid://9886659671"
	CloseImg.AnchorPoint = Vector2.new(0.5, 0.5)
	CloseImg.BackgroundTransparency = 1
	CloseImg.Position = UDim2.new(0.5, 0, 0.5, 0)
	CloseImg.Size = UDim2.new(1, -8, 1, -8)
	CloseImg.Parent = Close

	local LayersTab = Instance.new("Frame")
	LayersTab.BackgroundTransparency = 1
	LayersTab.Position = UDim2.new(0, 9, 0, 50)
	LayersTab.Size = UDim2.new(0, GuiConfig["Tab Width"], 1, -59)
	LayersTab.Parent = Main
	local Layers = Instance.new("Frame")
	Layers.BackgroundTransparency = 1
	Layers.Position = UDim2.new(0, GuiConfig["Tab Width"] + 18, 0, 50)
	Layers.Size = UDim2.new(1, -(GuiConfig["Tab Width"] + 27), 1, -59)
	Layers.Parent = Main

	local SearchBar = Instance.new("TextBox")
	SearchBar.Size = UDim2.new(0, 100, 0, 20)
	SearchBar.Position = UDim2.new(0, 10, 0, 5)
	SearchBar.PlaceholderText = "Search Tabs..."
	SearchBar.Font = Enum.Font.Gotham
	SearchBar.TextSize = 12
	SearchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	SearchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
	SearchBar.Parent = LayersTab
	local SearchCorner = Instance.new("UICorner")
	SearchCorner.Parent = SearchBar

	local ScrollTab = Instance.new("ScrollingFrame")
	ScrollTab.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollTab.ScrollBarThickness = 0
	ScrollTab.BackgroundTransparency = 1
	ScrollTab.Size = UDim2.new(1, 0, 1, -60)
	ScrollTab.Position = UDim2.new(0, 0, 0, 30)
	ScrollTab.Parent = LayersTab
	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Padding = UDim.new(0, 3)
	UIListLayout.Parent = ScrollTab

	local Info = Instance.new("Frame")
	Info.AnchorPoint = Vector2.new(1, 1)
	Info.BackgroundTransparency = 0.95
	Info.Position = UDim2.new(1, 0, 1, 0)
	Info.Size = UDim2.new(1, 0, 0, 40)
	Info.Parent = LayersTab
	local InfoCorner = Instance.new("UICorner")
	InfoCorner.Parent = Info
	local LogoPlayer = Instance.new("ImageLabel")
	LogoPlayer.Image = GuiConfig["Logo Player"]
	LogoPlayer.AnchorPoint = Vector2.new(0.5, 0.5)
	LogoPlayer.BackgroundTransparency = 1
	LogoPlayer.Position = UDim2.new(0, 20, 0.5, 0)
	LogoPlayer.Size = UDim2.new(0, 30, 0, 30)
	LogoPlayer.Parent = Info
	local LogoCorner = Instance.new("UICorner")
	LogoCorner.CornerRadius = UDim.new(1, 0)
	LogoCorner.Parent = LogoPlayer
	local NamePlayer = Instance.new("TextLabel")
	NamePlayer.Font = Enum.Font.GothamBold
	NamePlayer.Text = GuiConfig["Name Player"]
	NamePlayer.TextColor3 = Color3.fromRGB(230, 230, 230)
	NamePlayer.TextSize = 12
	NamePlayer.TextXAlignment = Enum.TextXAlignment.Left
	NamePlayer.BackgroundTransparency = 1
	NamePlayer.Position = UDim2.new(0, 40, 0, 0)
	NamePlayer.Size = UDim2.new(1, -45, 1, 0)
	NamePlayer.TextScaled = true
	NamePlayer.TextWrapped = true
	NamePlayer.Parent = Info

	local NameTab = Instance.new("TextLabel")
	NameTab.Font = Enum.Font.GothamBold
	NameTab.Text = ""
	NameTab.TextColor3 = Color3.fromRGB(255, 255, 255)
	NameTab.TextSize = 24
	NameTab.BackgroundTransparency = 1
	NameTab.Size = UDim2.new(1, 0, 0, 30)
	NameTab.TextScaled = true
	NameTab.TextWrapped = true
	NameTab.Parent = Layers
	local LayersReal = Instance.new("Frame")
	LayersReal.AnchorPoint = Vector2.new(0, 1)
	LayersReal.BackgroundTransparency = 1
	LayersReal.ClipsDescendants = true
	LayersReal.Position = UDim2.new(0, 0, 1, 0)
	LayersReal.Size = UDim2.new(1, 0, 1, -33)
	LayersReal.Parent = Layers
	local LayersFolder = Instance.new("Folder")
	LayersFolder.Parent = LayersReal
	local LayersPageLayout = Instance.new("UIPageLayout")
	LayersPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	LayersPageLayout.TweenTime = 0.5
	LayersPageLayout.EasingStyle = Enum.EasingStyle.Sine
	LayersPageLayout.Parent = LayersFolder

	local function UpdateTabSize()
		local OffsetY = 0
		for _, child in ScrollTab:GetChildren() do
			if child:IsA("Frame") then OffsetY = OffsetY + child.Size.Y.Offset + 3 end
		end
		ScrollTab.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
	end
	ScrollTab.ChildAdded:Connect(UpdateTabSize)
	ScrollTab.ChildRemoved:Connect(UpdateTabSize)

	SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
		local searchText = SearchBar.Text:lower()
		for _, tab in pairs(ScrollTab:GetChildren()) do
			if tab:IsA("Frame") then
				tab.Visible = searchText == "" or tab.TabName.Text:lower():find(searchText) ~= nil
			end
		end
		UpdateTabSize()
	end)

	local OldPos, OldSize = DropShadowHolder.Position, DropShadowHolder.Size
	Min.Activated:Connect(function() CircleClick(Min, Mouse.X, Mouse.Y) DropShadowHolder.Visible = false end)
	MaxRestore.Activated:Connect(function()
		CircleClick(MaxRestore, Mouse.X, Mouse.Y)
		if MaxImg.Image == "rbxassetid://9886659406" then
			MaxImg.Image = "rbxassetid://9886659001"
			OldPos, OldSize = DropShadowHolder.Position, DropShadowHolder.Size
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 1, 0)}):Play()
		else
			MaxImg.Image = "rbxassetid://9886659406"
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Position = OldPos, Size = OldSize}):Play()
		end
	end)
	Close.Activated:Connect(function() CircleClick(Close, Mouse.X, Mouse.Y) HirimiGui:Destroy() end)
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.RightShift then
			DropShadowHolder.Visible = not DropShadowHolder.Visible
		end
	end)
	MakeDraggable(Top, DropShadowHolder)

	-- Tab System
	local Tabs = {}
	local CountTab = 0
	function Tabs:CreateTab(TabConfig)
		TabConfig = TabConfig or {}
		TabConfig.Name = TabConfig.Name or "Tab"
		TabConfig.Icon = TabConfig.Icon or ""

		local ScrolLayers = Instance.new("ScrollingFrame")
		ScrolLayers.ScrollBarThickness = 0
		ScrolLayers.BackgroundTransparency = 1
		ScrolLayers.LayoutOrder = CountTab
		ScrolLayers.Size = UDim2.new(1, 0, 1, 0)
		ScrolLayers.Parent = LayersFolder
		local UIListLayout = Instance.new("UIListLayout")
		UIListLayout.Padding = UDim.new(0, 3)
		UIListLayout.Parent = ScrolLayers

		local Tab = Instance.new("Frame")
		Tab.BackgroundTransparency = CountTab == 0 and 0.92 or 1
		Tab.LayoutOrder = CountTab
		Tab.Size = UDim2.new(1, 0, 0, 30)
		Tab.Parent = ScrollTab
		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Tab
		local TabButton = Instance.new("TextButton")
		TabButton.Text = ""
		TabButton.BackgroundTransparency = 1
		TabButton.Size = UDim2.new(1, 0, 1, 0)
		TabButton.Parent = Tab
		local TabName = Instance.new("TextLabel")
		TabName.Font = Enum.Font.GothamBold
		TabName.Text = TabConfig.Name
		TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabName.TextSize = 13
		TabName.TextXAlignment = Enum.TextXAlignment.Left
		TabName.BackgroundTransparency = 1
		TabName.Position = UDim2.new(0, 30, 0, 0)
		TabName.Size = UDim2.new(1, -30, 1, 0)
		TabName.TextScaled = true
		TabName.TextWrapped = true
		TabName.Parent = Tab
		local FeatureImg = Instance.new("ImageLabel")
		FeatureImg.Image = TabConfig.Icon
		FeatureImg.BackgroundTransparency = 1
		FeatureImg.Position = UDim2.new(0, 9, 0, 7)
		FeatureImg.Size = UDim2.new(0, 16, 0, 16)
		FeatureImg.Parent = Tab

		if CountTab == 0 then
			LayersPageLayout:JumpToIndex(0)
			NameTab.Text = TabConfig.Name
			local ChooseFrame = Instance.new("Frame")
			ChooseFrame.BackgroundColor3 = GuiConfig.Color
			ChooseFrame.Position = UDim2.new(0, 2, 0, 9)
			ChooseFrame.Size = UDim2.new(0, 1, 0, 12)
			ChooseFrame.Parent = Tab
		end

		TabButton.MouseEnter:Connect(function()
			if Tab.LayoutOrder ~= LayersPageLayout.CurrentPage.LayoutOrder then
				TweenService:Create(Tab, TweenInfo.new(0.2), {BackgroundTransparency = 0.95}):Play()
			end
		end)
		TabButton.MouseLeave:Connect(function()
			if Tab.LayoutOrder ~= LayersPageLayout.CurrentPage.LayoutOrder then
				TweenService:Create(Tab, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
			end
		end)

		TabButton.Activated:Connect(function()
			CircleClick(TabButton, Mouse.X, Mouse.Y)
			local FrameChoose = ScrollTab:GetChildren()[1].ChooseFrame
			if FrameChoose and Tab.LayoutOrder ~= LayersPageLayout.CurrentPage.LayoutOrder then
				for _, TabFrame in ScrollTab:GetChildren() do
					if TabFrame:IsA("Frame") then
						TweenService:Create(TabFrame, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundTransparency = 1}):Play()
					end
				end
				TweenService:Create(Tab, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.92}):Play()
				TweenService:Create(FrameChoose, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Position = UDim2.new(0, 2, 0, 9 + (33 * Tab.LayoutOrder))}):Play()
				LayersPageLayout:JumpToIndex(Tab.LayoutOrder)
				NameTab.Text = TabConfig.Name
			end
		end)

		local Sections = {}
		local CountSection = 0
		function Sections:AddSection(Title)
			Title = Title or "Section"
			local Section = Instance.new("Frame")
			Section.BackgroundTransparency = 1
			Section.LayoutOrder = CountSection
			Section.Size = UDim2.new(1, 0, 0, 30)
			Section.Parent = ScrolLayers

			local SectionReal = Instance.new("Frame")
			SectionReal.BackgroundTransparency = 0.93
			SectionReal.Position = UDim2.new(0.5, 0, 0, 0)
			SectionReal.Size = UDim2.new(1, -10, 0, 30)
			SectionReal.AnchorPoint = Vector2.new(0.5, 0)
			SectionReal.Parent = Section
			local UICorner = Instance.new("UICorner")
			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = SectionReal
			local SectionButton = Instance.new("TextButton")
			SectionButton.Text = ""
			SectionButton.BackgroundTransparency = 1
			SectionButton.Size = UDim2.new(1, 0, 1, 0)
			SectionButton.Parent = SectionReal
			local SectionTitle = Instance.new("TextLabel")
			SectionTitle.Font = Enum.Font.GothamBold
			SectionTitle.Text = Title
			SectionTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
			SectionTitle.TextSize = 13
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			SectionTitle.BackgroundTransparency = 1
			SectionTitle.Position = UDim2.new(0, 10, 0, 0)
			SectionTitle.Size = UDim2.new(1, -50, 1, 0)
			SectionTitle.TextScaled = true
			SectionTitle.TextWrapped = true
			SectionTitle.Parent = SectionReal

			local SectionAdd = Instance.new("Frame")
			SectionAdd.BackgroundTransparency = 1
			SectionAdd.Position = UDim2.new(0.5, 0, 0, 38)
			SectionAdd.Size = UDim2.new(1, -10, 0, 0)
			SectionAdd.AnchorPoint = Vector2.new(0.5, 0)
			SectionAdd.Parent = Section
			local UIListLayout = Instance.new("UIListLayout")
			UIListLayout.Padding = UDim.new(0, 3)
			UIListLayout.Parent = SectionAdd

			local OpenSection = false
			local function UpdateSize()
				local OffsetY = 38
				for _, v in SectionAdd:GetChildren() do
					if v:IsA("Frame") then OffsetY = OffsetY + v.Size.Y.Offset + 3 end
				end
				if OpenSection then
					TweenService:Create(Section, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Size = UDim2.new(1, 0, 0, OffsetY)}):Play()
					TweenService:Create(SectionAdd, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Size = UDim2.new(1, -10, 0, OffsetY - 38)}):Play()
				end
				ScrolLayers.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
			end

			SectionButton.Activated:Connect(function()
				CircleClick(SectionButton, Mouse.X, Mouse.Y)
				OpenSection = not OpenSection
				TweenService:Create(Section, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Size = UDim2.new(1, 0, 0, OpenSection and ScrolLayers.CanvasSize.Y.Offset or 30)}):Play()
				TweenService:Create(SectionAdd, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Size = UDim2.new(1, -10, 0, OpenSection and (ScrolLayers.CanvasSize.Y.Offset - 38) or 0)}):Play()
			end)

			local Items = {}
			local CountItem = 0
			function Items:AddToggle(ToggleConfig)
				ToggleConfig = ToggleConfig or {}
				ToggleConfig.Title = ToggleConfig.Title or "Toggle"
				ToggleConfig.Content = ToggleConfig.Content or "Description"
				ToggleConfig.Default = ToggleConfig.Default or false
				ToggleConfig.Keybind = ToggleConfig.Keybind or Enum.KeyCode.Unknown
				ToggleConfig.Callback = ToggleConfig.Callback or function() end

				local ToggleFunc = {Value = ToggleConfig.Default, Keybind = ToggleConfig.Keybind}
				local Toggle = Instance.new("Frame")
				Toggle.BackgroundTransparency = 0.93
				Toggle.LayoutOrder = CountItem
				Toggle.Size = UDim2.new(1, 0, 0, 46)
				Toggle.Parent = SectionAdd
				local UICorner = Instance.new("UICorner")
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = Toggle

				local ToggleTitle = Instance.new("TextLabel")
				ToggleTitle.Font = Enum.Font.GothamBold
				ToggleTitle.Text = ToggleConfig.Title
				ToggleTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
				ToggleTitle.TextSize = 13
				ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
				ToggleTitle.BackgroundTransparency = 1
				ToggleTitle.Position = UDim2.new(0, 10, 0, 10)
				ToggleTitle.Size = UDim2.new(0.7, 0, 0, 13)
				ToggleTitle.TextScaled = true
				ToggleTitle.TextWrapped = true
				ToggleTitle.Parent = Toggle

				local ToggleContent = Instance.new("TextLabel")
				ToggleContent.Font = Enum.Font.Gotham
				ToggleContent.Text = ToggleConfig.Content
				ToggleContent.TextColor3 = Color3.fromRGB(200, 200, 200)
				ToggleContent.TextSize = 12
				ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
				ToggleContent.BackgroundTransparency = 1
				ToggleContent.Position = UDim2.new(0, 10, 0, 23)
				ToggleContent.Size = UDim2.new(0.7, 0, 0, 12 + (12 * math.ceil(ToggleContent.TextBounds.X / ToggleContent.AbsoluteSize.X)))
				ToggleContent.TextScaled = true
				ToggleContent.TextWrapped = true
				ToggleContent.Parent = Toggle
				Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 33)

				local ToggleButton = Instance.new("TextButton")
				ToggleButton.Text = ""
				ToggleButton.BackgroundTransparency = 1
				ToggleButton.Size = UDim2.new(1, 0, 1, 0)
				ToggleButton.Parent = Toggle

				local FeatureFrame = Instance.new("Frame")
				FeatureFrame.BackgroundTransparency = ToggleConfig.Default and 0 or 0.92
				FeatureFrame.BackgroundColor3 = ToggleConfig.Default and GuiConfig.Color or Color3.fromRGB(255, 255, 255)
				FeatureFrame.Position = UDim2.new(1, -30, 0.5, 0)
				FeatureFrame.Size = UDim2.new(0, 30, 0, 15)
				FeatureFrame.AnchorPoint = Vector2.new(1, 0.5)
				FeatureFrame.Parent = Toggle
				local FeatureCorner = Instance.new("UICorner")
				FeatureCorner.Parent = FeatureFrame
				local ToggleCircle = Instance.new("Frame")
				ToggleCircle.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
				ToggleCircle.Position = UDim2.new(0, ToggleConfig.Default and 15 or 0, 0, 0)
				ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
				ToggleCircle.Parent = FeatureFrame
				local CircleCorner = Instance.new("UICorner")
				CircleCorner.CornerRadius = UDim.new(1, 0)
				CircleCorner.Parent = ToggleCircle

				local KeybindLabel = Instance.new("TextLabel")
				KeybindLabel.Text = "Key: " .. ToggleConfig.Keybind.Name
				KeybindLabel.Font = Enum.Font.Gotham
				KeybindLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
				KeybindLabel.TextSize = 12
				KeybindLabel.Position = UDim2.new(1, -80, 0, 5)
				KeybindLabel.Size = UDim2.new(0, 50, 0, 20)
				KeybindLabel.BackgroundTransparency = 1
				KeybindLabel.TextScaled = true
				KeybindLabel.TextWrapped = true
				KeybindLabel.Parent = Toggle

				ToggleButton.MouseEnter:Connect(function()
					TweenService:Create(Toggle, TweenInfo.new(0.2), {BackgroundTransparency = 0.85}):Play()
				end)
				ToggleButton.MouseLeave:Connect(function()
					TweenService:Create(Toggle, TweenInfo.new(0.2), {BackgroundTransparency = 0.93}):Play()
				end)

				local SettingKey = false
				KeybindLabel.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						SettingKey = true
						KeybindLabel.Text = "Press a key..."
					end
				end)
				UserInputService.InputBegan:Connect(function(input)
					if SettingKey and input.UserInputType == Enum.UserInputType.Keyboard then
						ToggleFunc.Keybind = input.KeyCode
						KeybindLabel.Text = "Key: " .. input.KeyCode.Name
						SettingKey = false
					elseif input.KeyCode == ToggleFunc.Keybind and not SettingKey then
						ToggleFunc.Value = not ToggleFunc.Value
						ToggleFunc:Set(ToggleFunc.Value)
					end
				end)

				function ToggleFunc:Set(Value)
					ToggleFunc.Value = Value
					TweenService:Create(ToggleTitle, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {TextColor3 = Value and GuiConfig.Color or Color3.fromRGB(230, 230, 230)}):Play()
					TweenService:Create(ToggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Position = UDim2.new(0, Value and 15 or 0, 0, 0)}):Play()
					TweenService:Create(FeatureFrame, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundColor3 = Value and GuiConfig.Color or Color3.fromRGB(255, 255, 255), BackgroundTransparency = Value and 0 or 0.92}):Play()
					ToggleConfig.Callback(Value)
				end
				ToggleButton.Activated:Connect(function() CircleClick(ToggleButton, Mouse.X, Mouse.Y) ToggleFunc:Set(not ToggleFunc.Value) end)
				ToggleFunc:Set(ToggleFunc.Value)
				CountItem = CountItem + 1
				UpdateSize()
				return ToggleFunc
			end

			function Items:AddButton(ButtonConfig)
				ButtonConfig = ButtonConfig or {}
				ButtonConfig.Title = ButtonConfig.Title or "Button"
				ButtonConfig.Content = ButtonConfig.Content or "Click me"
				ButtonConfig.Callback = ButtonConfig.Callback or function() end

				local Button = Instance.new("Frame")
				Button.BackgroundTransparency = 0.93
				Button.LayoutOrder = CountItem
				Button.Size = UDim2.new(1, 0, 0, 46)
				Button.Parent = SectionAdd
				local UICorner = Instance.new("UICorner")
				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = Button

				local ButtonTitle = Instance.new("TextLabel")
				ButtonTitle.Font = Enum.Font.GothamBold
				ButtonTitle.Text = ButtonConfig.Title
				ButtonTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
				ButtonTitle.TextSize = 13
				ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
				ButtonTitle.BackgroundTransparency = 1
				ButtonTitle.Position = UDim2.new(0, 10, 0, 10)
				ButtonTitle.Size = UDim2.new(0.7, 0, 0, 13)
				ButtonTitle.TextScaled = true
				ButtonTitle.TextWrapped = true
				ButtonTitle.Parent = Button

				local ButtonContent = Instance.new("TextLabel")
				ButtonContent.Font = Enum.Font.Gotham
				ButtonContent.Text = ButtonConfig.Content
				ButtonContent.TextColor3 = Color3.fromRGB(200, 200, 200)
				ButtonContent.TextSize = 12
				ButtonContent.TextXAlignment = Enum.TextXAlignment.Left
				ButtonContent.BackgroundTransparency = 1
				ButtonContent.Position = UDim2.new(0, 10, 0, 23)
				ButtonContent.Size = UDim2.new(0.7, 0, 0, 12 + (12 * math.ceil(ButtonContent.TextBounds.X / ButtonContent.AbsoluteSize.X)))
				ButtonContent.TextScaled = true
				ButtonContent.TextWrapped = true
				ButtonContent.Parent = Button
				Button.Size = UDim2.new(1, 0, 0, ButtonContent.AbsoluteSize.Y + 33)

				local ButtonButton = Instance.new("TextButton")
				ButtonButton.Text = ""
				ButtonButton.BackgroundTransparency = 1
				ButtonButton.Size = UDim2.new(1, 0, 1, 0)
				ButtonButton.Parent = Button

				local FeatureImg = Instance.new("ImageLabel")
				FeatureImg.Image = "rbxassetid://16932740082"
				FeatureImg.AnchorPoint = Vector2.new(1, 0.5)
				FeatureImg.BackgroundTransparency = 1
				FeatureImg.Position = UDim2.new(1, -15, 0.5, 0)
				FeatureImg.Size = UDim2.new(0, 25, 0, 25)
				FeatureImg.Parent = Button

				ButtonButton.MouseEnter:Connect(function()
					TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.85}):Play()
				end)
				ButtonButton.MouseLeave:Connect(function()
					TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.93}):Play()
				end)

				ButtonButton.Activated:Connect(function() CircleClick(ButtonButton, Mouse.X, Mouse.Y) ButtonConfig.Callback() end)
				CountItem = CountItem + 1
				UpdateSize()
				return {}
			end

			CountSection = CountSection + 1
			return Items
		end
		CountTab = CountTab + 1
		return Sections
	end
	return Tabs
end

return CatLib