local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = LocalPlayer.PlayerGui

local CatLib = {}

-- Cải tiến MakeDraggable với hiệu ứng mượt hơn
local function MakeDraggable(topbarobject, object)
	local function CustomPos(topbarobject, object)
		local Dragging, DragInput, DragStart, StartPosition
		local function UpdatePos(input)
			local Delta = input.Position - DragStart
			local pos = UDim2.new(
				StartPosition.X.Scale, 
				StartPosition.X.Offset + Delta.X, 
				StartPosition.Y.Scale, 
				StartPosition.Y.Offset + Delta.Y
			)
			TweenService:Create(object, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {Position = pos}):Play()
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

	local function CustomSize(object)
		local Dragging, DragInput, DragStart, StartSize
		local minSizeX, minSizeY = 450, 350  -- Tăng kích thước tối thiểu
		local changesizeobject = Instance.new("ImageLabel")
		changesizeobject.Image = "rbxassetid://1316045217"  -- Thêm icon resize
		changesizeobject.ImageTransparency = 0.3
		changesizeobject.BackgroundTransparency = 1
		changesizeobject.AnchorPoint = Vector2.new(1, 1)
		changesizeobject.Position = UDim2.new(1, 0, 1, 0)
		changesizeobject.Size = UDim2.new(0, 24, 0, 24)
		changesizeobject.Name = "ResizeHandle"
		changesizeobject.Parent = object

		local function UpdateSize(input)
			local Delta = input.Position - DragStart
			local newWidth = math.max(StartSize.X.Offset + Delta.X, minSizeX)
			local newHeight = math.max(StartSize.Y.Offset + Delta.Y, minSizeY)
			TweenService:Create(object, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
				Size = UDim2.new(0, newWidth, 0, newHeight)
			}):Play()
		end

		changesizeobject.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				DragStart = input.Position
				StartSize = object.Size
				changesizeobject.ImageTransparency = 0
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then 
						Dragging = false 
						changesizeobject.ImageTransparency = 0.3
					end
				end)
			end
		end)
		
		changesizeobject.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then 
				DragInput = input 
			end
		end)
		
		UserInputService.InputChanged:Connect(function(input)
			if input == DragInput and Dragging then UpdateSize(input) end
		end)
	end
	
	CustomSize(object)
	CustomPos(topbarobject, object)
end

-- Hiệu ứng Click Circle cải tiến
local function CircleClick(Button, X, Y)
	spawn(function()
		Button.ClipsDescendants = true
		local Circle = Instance.new("ImageLabel")
		Circle.Image = "rbxassetid://266543268"
		Circle.ImageColor3 = Color3.fromRGB(150, 150, 150)
		Circle.BackgroundTransparency = 1
		Circle.ZIndex = 10
		Circle.Parent = Button
		
		local NewX = X - Circle.AbsolutePosition.X
		local NewY = Y - Circle.AbsolutePosition.Y
		Circle.Position = UDim2.new(0, NewX, 0, NewY)
		local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 1.8
		Circle:TweenSizeAndPosition(
			UDim2.new(0, Size, 0, Size),
			UDim2.new(0.5, -Size/2, 0.5, -Size/2),
			"Out",
			"Exponential",
			0.3,
			false,
			function()
				for i = 1, 8 do
					Circle.ImageTransparency = Circle.ImageTransparency + 0.125
					wait(0.02)
				end
				Circle:Destroy()
			end
		)
	end)
end

-- Hệ thống thông báo cải tiến
function CatLib:MakeNotify(NotifyConfig)
	NotifyConfig = NotifyConfig or {}
	NotifyConfig.Title = NotifyConfig.Title or "CatLib v0.4"
	NotifyConfig.Description = NotifyConfig.Description or "Notification"
	NotifyConfig.Content = NotifyConfig.Content or "Content"
	NotifyConfig.Color = NotifyConfig.Color or Color3.fromRGB(0, 170, 255)
	NotifyConfig.Time = NotifyConfig.Time or 0.4
	NotifyConfig.Delay = NotifyConfig.Delay or 5

	local NotifyFunction = {}
	local NotifyPool = NotifyPool or {}
	
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
			NotifyLayout.Position = UDim2.new(1, -20, 1, -20)
			NotifyLayout.Size = UDim2.new(0, 340, 1, 0)
			NotifyLayout.Name = "NotifyLayout"
			NotifyLayout.Parent = CoreGui.NotifyGui
			
			local Count = 0
			NotifyLayout.ChildRemoved:Connect(function()
				Count = 0
				for _, v in NotifyLayout:GetChildren() do
					TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
						Position = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 15) * Count))
					}):Play()
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
			NotifyFrame.Size = UDim2.new(1, 0, 0, 160)
			NotifyFrame.Name = "NotifyFrame"
			NotifyFrame.Parent = CoreGui.NotifyGui.NotifyLayout
			NotifyFrame.AnchorPoint = Vector2.new(0, 1)

			NotifyFrameReal.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			NotifyFrameReal.Position = UDim2.new(0, 400, 0, 0)
			NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
			NotifyFrameReal.Parent = NotifyFrame
			UICorner.CornerRadius = UDim.new(0, 10)
			UICorner.Parent = NotifyFrameReal
			
			Gradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
			}
			Gradient.Rotation = 45
			Gradient.Parent = NotifyFrameReal

			DropShadow.Image = "rbxassetid://6015897843"
			DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
			DropShadow.ImageTransparency = 0.3
			DropShadow.ScaleType = Enum.ScaleType.Slice
			DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
			DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
			DropShadow.BackgroundTransparency = 1
			DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
			DropShadow.Size = UDim2.new(1, 70, 1, 70)
			DropShadow.ZIndex = 0
			DropShadow.Parent = NotifyFrameReal

			Top.BackgroundTransparency = 1
			Top.Size = UDim2.new(1, 0, 0, 40)
			Top.Parent = NotifyFrameReal

			TitleLabel.Font = Enum.Font.GothamSemibold
			TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TitleLabel.TextSize = 15
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
			TitleLabel.BackgroundTransparency = 1
			TitleLabel.Position = UDim2.new(0, 15, 0, 5)
			TitleLabel.Size = UDim2.new(0.7, 0, 0, 20)
			TitleLabel.Parent = Top

			DescLabel.Font = Enum.Font.GothamSemibold
			DescLabel.TextSize = 13
			DescLabel.TextXAlignment = Enum.TextXAlignment.Left
			DescLabel.BackgroundTransparency = 1
			DescLabel.Position = UDim2.new(0, 15, 0, 25)
			DescLabel.Size = UDim2.new(0.7, 0, 0, 15)
			DescLabel.Parent = Top

			ContentLabel.Font = Enum.Font.Gotham
			ContentLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
			ContentLabel.TextSize = 13
			ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
			ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
			ContentLabel.BackgroundTransparency = 1
			ContentLabel.Position = UDim2.new(0, 15, 0, 45)
			ContentLabel.Size = UDim2.new(1, -30, 0, 0)
			ContentLabel.Parent = NotifyFrameReal

			Close.Text = ""
			Close.AnchorPoint = Vector2.new(1, 0.5)
			Close.BackgroundTransparency = 1
			Close.Position = UDim2.new(1, -10, 0.5, 0)
			Close.Size = UDim2.new(0, 25, 0, 25)
			Close.Parent = Top
			CloseImg.Image = "rbxassetid://9886659671"
			CloseImg.AnchorPoint = Vector2.new(0.5, 0.5)
			CloseImg.BackgroundTransparency = 1
			CloseImg.Position = UDim2.new(0.5, 0, 0.5, 0)
			CloseImg.Size = UDim2.new(0, 16, 0, 16)
			CloseImg.Parent = Close
		end

		local NotifyPosHeigh = 0
		for _, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
			if v ~= NotifyFrame then
				NotifyPosHeigh = -(v.Position.Y.Offset) + v.Size.Y.Offset + 15
			end
		end
		NotifyFrame.Position = UDim2.new(0, 0, 1, -NotifyPosHeigh)

		NotifyFrame.NotifyFrameReal.Top.TitleLabel.Text = NotifyConfig.Title
		NotifyFrame.NotifyFrameReal.Top.DescLabel.Text = NotifyConfig.Description
		NotifyFrame.NotifyFrameReal.Top.DescLabel.TextColor3 = NotifyConfig.Color
		NotifyFrame.NotifyFrameReal.ContentLabel.Text = NotifyConfig.Content
		
		local contentHeight = NotifyFrame.NotifyFrameReal.ContentLabel.TextBounds.Y
		NotifyFrame.NotifyFrameReal.ContentLabel.Size = UDim2.new(1, -30, 0, contentHeight)
		NotifyFrame.Size = UDim2.new(1, 0, 0, math.max(contentHeight + 60, 80))

		local waitbruh = false
		function NotifyFunction:Close()
			if waitbruh then return end
			waitbruh = true
			TweenService:Create(NotifyFrame.NotifyFrameReal, TweenInfo.new(NotifyConfig.Time, Enum.EasingStyle.Exponential), {
				Position = UDim2.new(0, 400, 0, 0)
			}):Play()
			task.wait(NotifyConfig.Time)
			NotifyFrame.Visible = false
			table.insert(NotifyPool, NotifyFrame)
		end

		Close.Activated:Connect(NotifyFunction.Close)
		TweenService:Create(NotifyFrame.NotifyFrameReal, TweenInfo.new(NotifyConfig.Time, Enum.EasingStyle.Exponential), {
			Position = UDim2.new(0, 0, 0, 0)
		}):Play()
		task.wait(NotifyConfig.Delay)
		NotifyFunction:Close()
	end)
	return NotifyFunction
end

-- GUI chính cải tiến
function CatLib:MakeGui(GuiConfig)
	GuiConfig = GuiConfig or {}
	GuiConfig.NameHub = GuiConfig.NameHub or "CatLib v0.4"
	GuiConfig.Description = GuiConfig.Description or "by: catdzs1vn"
	GuiConfig.Color = GuiConfig.Color or Color3.fromRGB(0, 170, 255)
	GuiConfig["Logo Player"] = GuiConfig["Logo Player"] or "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
	GuiConfig["Name Player"] = GuiConfig["Name Player"] or LocalPlayer.Name
	GuiConfig["Tab Width"] = GuiConfig["Tab Width"] or 140

	local GuiFunc = {}
	local HirimiGui = Instance.new("ScreenGui")
	HirimiGui.Name = "HirimiGui"
	HirimiGui.Parent = CoreGui

	local DropShadowHolder = Instance.new("Frame")
	DropShadowHolder.BackgroundTransparency = 1
	DropShadowHolder.Size = UDim2.new(0, 600, 0, 400)
	DropShadowHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadowHolder.Parent = HirimiGui

	local DropShadow = Instance.new("ImageLabel")
	DropShadow.Image = "rbxassetid://6015897843"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.35
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 70, 1, 70)
	DropShadow.ZIndex = 0
	DropShadow.Parent = DropShadowHolder

	local Main = Instance.new("Frame")
	Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size = UDim2.new(1, -20, 1, -20)
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.Parent = DropShadowHolder
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = Main
	local UIGradient = Instance.new("UIGradient")
	UIGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
	}
	UIGradient.Rotation = 45
	UIGradient.Parent = Main

	local Top = Instance.new("Frame")
	Top.BackgroundTransparency = 0.9
	Top.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Top.Size = UDim2.new(1, 0, 0, 45)
	Top.Parent = Main
	local TopCorner = Instance.new("UICorner")
	TopCorner.CornerRadius = UDim.new(0, 10)
	TopCorner.Parent = Top
	
	local NameLabel = Instance.new("TextLabel")
	NameLabel.Font = Enum.Font.GothamSemibold
	NameLabel.Text = GuiConfig.NameHub
	NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	NameLabel.TextSize = 16
	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.BackgroundTransparency = 1
	NameLabel.Position = UDim2.new(0, 15, 0, 5)
	NameLabel.Size = UDim2.new(0.5, 0, 0, 20)
	NameLabel.Parent = Top
	
	local DescLabel = Instance.new("TextLabel")
	DescLabel.Font = Enum.Font.Gotham
	DescLabel.Text = GuiConfig.Description
	DescLabel.TextColor3 = GuiConfig.Color
	DescLabel.TextSize = 13
	DescLabel.TextXAlignment = Enum.TextXAlignment.Left
	DescLabel.BackgroundTransparency = 1
	DescLabel.Position = UDim2.new(0, 15, 0, 25)
	DescLabel.Size = UDim2.new(0.5, 0, 0, 15)
	DescLabel.Parent = Top

	local Min = Instance.new("TextButton")
	Min.Text = ""
	Min.AnchorPoint = Vector2.new(1, 0.5)
	Min.BackgroundTransparency = 1
	Min.Position = UDim2.new(1, -90, 0.5, 0)
	Min.Size = UDim2.new(0, 30, 0, 30)
	Min.Parent = Top
	local MinImg = Instance.new("ImageLabel")
	MinImg.Image = "rbxassetid://9886659276"
	MinImg.AnchorPoint = Vector2.new(0.5, 0.5)
	MinImg.BackgroundTransparency = 1
	MinImg.Position = UDim2.new(0.5, 0, 0.5, 0)
	MinImg.Size = UDim2.new(0, 18, 0, 18)
	MinImg.Parent = Min

	local MaxRestore = Instance.new("TextButton")
	MaxRestore.Text = ""
	MaxRestore.AnchorPoint = Vector2.new(1, 0.5)
	MaxRestore.BackgroundTransparency = 1
	MaxRestore.Position = UDim2.new(1, -50, 0.5, 0)
	MaxRestore.Size = UDim2.new(0, 30, 0, 30)
	MaxRestore.Parent = Top
	local MaxImg = Instance.new("ImageLabel")
	MaxImg.Image = "rbxassetid://9886659406"
	MaxImg.AnchorPoint = Vector2.new(0.5, 0.5)
	MaxImg.BackgroundTransparency = 1
	MaxImg.Position = UDim2.new(0.5, 0, 0.5, 0)
	MaxImg.Size = UDim2.new(0, 18, 0, 18)
	MaxImg.Parent = MaxRestore

	local Close = Instance.new("TextButton")
	Close.Text = ""
	Close.AnchorPoint = Vector2.new(1, 0.5)
	Close.BackgroundTransparency = 1
	Close.Position = UDim2.new(1, -10, 0.5, 0)
	Close.Size = UDim2.new(0, 30, 0, 30)
	Close.Parent = Top
	local CloseImg = Instance.new("ImageLabel")
	CloseImg.Image = "rbxassetid://9886659671"
	CloseImg.AnchorPoint = Vector2.new(0.5, 0.5)
	CloseImg.BackgroundTransparency = 1
	CloseImg.Position = UDim2.new(0.5, 0, 0.5, 0)
	CloseImg.Size = UDim2.new(0, 18, 0, 18)
	CloseImg.Parent = Close

	local LayersTab = Instance.new("Frame")
	LayersTab.BackgroundTransparency = 0.95
	LayersTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	LayersTab.Position = UDim2.new(0, 10, 0, 55)
	LayersTab.Size = UDim2.new(0, GuiConfig["Tab Width"], 1, -65)
	LayersTab.Parent = Main
	local TabCorner = Instance.new("UICorner")
	TabCorner.CornerRadius = UDim.new(0, 8)
	TabCorner.Parent = LayersTab

	local Layers = Instance.new("Frame")
	Layers.BackgroundTransparency = 1
	Layers.Position = UDim2.new(0, GuiConfig["Tab Width"] + 20, 0, 55)
	Layers.Size = UDim2.new(1, -(GuiConfig["Tab Width"] + 30), 1, -65)
	Layers.Parent = Main

	local SearchBar = Instance.new("TextBox")
	SearchBar.Size = UDim2.new(1, -20, 0, 25)
	SearchBar.Position = UDim2.new(0, 10, 0, 10)
	SearchBar.PlaceholderText = "Search Tabs..."
	SearchBar.Font = Enum.Font.Gotham
	SearchBar.TextSize = 13
	SearchBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	SearchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
	SearchBar.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
	SearchBar.Parent = LayersTab
	local SearchCorner = Instance.new("UICorner")
	SearchCorner.CornerRadius = UDim.new(0, 6)
	SearchCorner.Parent = SearchBar

	local ScrollTab = Instance.new("ScrollingFrame")
	ScrollTab.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollTab.ScrollBarThickness = 2
	ScrollTab.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
	ScrollTab.BackgroundTransparency = 1
	ScrollTab.Size = UDim2.new(1, 0, 1, -80)
	ScrollTab.Position = UDim2.new(0, 0, 0, 45)
	ScrollTab.Parent = LayersTab
	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Padding = UDim.new(0, 5)
	UIListLayout.Parent = ScrollTab

	local Info = Instance.new("Frame")
	Info.AnchorPoint = Vector2.new(0.5, 1)
	Info.BackgroundTransparency = 0.9
	Info.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Info.Position = UDim2.new(0.5, 0, 1, -5)
	Info.Size = UDim2.new(1, -10, 0, 50)
	Info.Parent = LayersTab
	local InfoCorner = Instance.new("UICorner")
	InfoCorner.CornerRadius = UDim.new(0, 8)
	InfoCorner.Parent = Info
	
	local LogoPlayer = Instance.new("ImageLabel")
	LogoPlayer.Image = GuiConfig["Logo Player"]
	LogoPlayer.AnchorPoint = Vector2.new(0, 0.5)
	LogoPlayer.BackgroundTransparency = 1
	LogoPlayer.Position = UDim2.new(0, 10, 0.5, 0)
	LogoPlayer.Size = UDim2.new(0, 35, 0, 35)
	LogoPlayer.Parent = Info
	local LogoCorner = Instance.new("UICorner")
	LogoCorner.CornerRadius = UDim.new(1, 0)
	LogoCorner.Parent = LogoPlayer
	
	local NamePlayer = Instance.new("TextLabel")
	NamePlayer.Font = Enum.Font.GothamSemibold
	NamePlayer.Text = GuiConfig["Name Player"]
	NamePlayer.TextColor3 = Color3.fromRGB(240, 240, 240)
	NamePlayer.TextSize = 14
	NamePlayer.TextXAlignment = Enum.TextXAlignment.Left
	NamePlayer.BackgroundTransparency = 1
	NamePlayer.Position = UDim2.new(0, 50, 0.5, -10)
	NamePlayer.Size = UDim2.new(1, -60, 0, 20)
	NamePlayer.Parent = Info

	local NameTab = Instance.new("TextLabel")
	NameTab.Font = Enum.Font.GothamBold
	NameTab.Text = ""
	NameTab.TextColor3 = Color3.fromRGB(255, 255, 255)
	NameTab.TextSize = 26
	NameTab.BackgroundTransparency = 1
	NameTab.Position = UDim2.new(0, 10, 0, 0)
	NameTab.Size = UDim2.new(1, -20, 0, 35)
	NameTab.Parent = Layers
	
	local LayersReal = Instance.new("Frame")
	LayersReal.AnchorPoint = Vector2.new(0, 1)
	LayersReal.BackgroundTransparency = 1
	LayersReal.ClipsDescendants = true
	LayersReal.Position = UDim2.new(0, 0, 1, 0)
	LayersReal.Size = UDim2.new(1, 0, 1, -45)
	LayersReal.Parent = Layers
	
	local LayersFolder = Instance.new("Folder")
	LayersFolder.Parent = LayersReal
	local LayersPageLayout = Instance.new("UIPageLayout")
	LayersPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	LayersPageLayout.TweenTime = 0.3
	LayersPageLayout.EasingStyle = Enum.EasingStyle.Exponential
	LayersPageLayout.Parent = LayersFolder

	local function UpdateTabSize()
		local OffsetY = 0
		for _, child in ScrollTab:GetChildren() do
			if child:IsA("Frame") then OffsetY = OffsetY + child.Size.Y.Offset + 5 end
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
	Min.Activated:Connect(function() 
		CircleClick(Min, Mouse.X, Mouse.Y) 
		DropShadowHolder.Visible = false 
	end)
	
	MaxRestore.Activated:Connect(function()
		CircleClick(MaxRestore, Mouse.X, Mouse.Y)
		if MaxImg.Image == "rbxassetid://9886659406" then
			MaxImg.Image = "rbxassetid://9886659001"
			OldPos, OldSize = DropShadowHolder.Position, DropShadowHolder.Size
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
				Position = UDim2.new(0, 0, 0, 0), 
				Size = UDim2.new(1, 0, 1, 0)
			}):Play()
		else
			MaxImg.Image = "rbxassetid://9886659406"
			TweenService:Create(DropShadowHolder, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
				Position = OldPos, 
				Size = OldSize
			}):Play()
		end
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

	-- Tab System cải tiến
	local Tabs = {}
	local CountTab = 0
	function Tabs:CreateTab(TabConfig)
		TabConfig = TabConfig or {}
		TabConfig.Name = TabConfig.Name or "Tab"
		TabConfig.Icon = TabConfig.Icon or "rbxassetid://7072706620"

		local ScrolLayers = Instance.new("ScrollingFrame")
		ScrolLayers.ScrollBarThickness = 2
		ScrolLayers.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
		ScrolLayers.BackgroundTransparency = 1
		ScrolLayers.LayoutOrder = CountTab
		ScrolLayers.Size = UDim2.new(1, -10, 1, 0)
		ScrolLayers.Position = UDim2.new(0, 5, 0, 0)
		ScrolLayers.Parent = LayersFolder
		local UIListLayout = Instance.new("UIListLayout")
		UIListLayout.Padding = UDim.new(0, 8)
		UIListLayout.Parent = ScrolLayers

		local Tab = Instance.new("Frame")
		Tab.BackgroundTransparency = CountTab == 0 and 0.85 or 1
		Tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		Tab.LayoutOrder = CountTab
		Tab.Size = UDim2.new(1, -10, 0, 35)
		Tab.Parent = ScrollTab
		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(0, 6)
		UICorner.Parent = Tab
		
		local TabButton = Instance.new("TextButton")
		TabButton.Text = ""
		TabButton.BackgroundTransparency = 1
		TabButton.Size = UDim2.new(1, 0, 1, 0)
		TabButton.Parent = Tab
		
		local FeatureImg = Instance.new("ImageLabel")
		FeatureImg.Image = TabConfig.Icon
		FeatureImg.BackgroundTransparency = 1
		FeatureImg.Position = UDim2.new(0, 10, 0.5, -8)
		FeatureImg.Size = UDim2.new(0, 18, 0, 18)
		FeatureImg.Parent = Tab
		
		local TabName = Instance.new("TextLabel")
		TabName.Name = "TabName"
		TabName.Font = Enum.Font.GothamSemibold
		TabName.Text = TabConfig.Name
		TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabName.TextSize = 14
		TabName.TextXAlignment = Enum.TextXAlignment.Left
		TabName.BackgroundTransparency = 1
		TabName.Position = UDim2.new(0, 35, 0.5, -8)
		TabName.Size = UDim2.new(1, -40, 0, 16)
		TabName.Parent = Tab

		if CountTab == 0 then
			LayersPageLayout:JumpToIndex(0)
			NameTab.Text = TabConfig.Name
			local ChooseFrame = Instance.new("Frame")
			ChooseFrame.BackgroundColor3 = GuiConfig.Color
			ChooseFrame.Position = UDim2.new(0, 0, 0, 0)
			ChooseFrame.Size = UDim2.new(0, 3, 1, 0)
			ChooseFrame.Parent = Tab
			ChooseFrame.Name = "ChooseFrame"
		end

		TabButton.Activated:Connect(function()
			CircleClick(TabButton, Mouse.X, Mouse.Y)
			local FrameChoose = ScrollTab:GetChildren()[1].ChooseFrame
			if FrameChoose and Tab.LayoutOrder ~= LayersPageLayout.CurrentPage.LayoutOrder then
				for _, TabFrame in ScrollTab:GetChildren() do
					if TabFrame:IsA("Frame") then
						TweenService:Create(TabFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
							BackgroundTransparency = 1
						}):Play()
					end
				end
				TweenService:Create(Tab, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
					BackgroundTransparency = 0.85
				}):Play()
				TweenService:Create(FrameChoose, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
					Position = UDim2.new(0, 0, 0, 40 * Tab.LayoutOrder)
				}):Play()
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
			Section.Size = UDim2.new(1, 0, 0, 35)
			Section.Parent = ScrolLayers

			local SectionReal = Instance.new("Frame")
			SectionReal.BackgroundTransparency = 0.9
			SectionReal.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			SectionReal.Position = UDim2.new(0.5, 0, 0, 0)
			SectionReal.Size = UDim2.new(1, -20, 0, 35)
			SectionReal.AnchorPoint = Vector2.new(0.5, 0)
			SectionReal.Parent = Section
			local UICorner = Instance.new("UICorner")
			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = SectionReal
			
			local SectionButton = Instance.new("TextButton")
			SectionButton.Text = ""
			SectionButton.BackgroundTransparency = 1
			SectionButton.Size = UDim2.new(1, 0, 1, 0)
			SectionButton.Parent = SectionReal
			
			local SectionTitle = Instance.new("TextLabel")
			SectionTitle.Font = Enum.Font.GothamSemibold
			SectionTitle.Text = Title
			SectionTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
			SectionTitle.TextSize = 15
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			SectionTitle.BackgroundTransparency = 1
			SectionTitle.Position = UDim2.new(0, 15, 0.5, -8)
			SectionTitle.Size = UDim2.new(1, -50, 0, 16)
			SectionTitle.Parent = SectionReal
			
			local Arrow = Instance.new("ImageLabel")
			Arrow.Image = "rbxassetid://7072706620"
			Arrow.BackgroundTransparency = 1
			Arrow.Position = UDim2.new(1, -25, 0.5, -8)
			Arrow.Size = UDim2.new(0, 16, 0, 16)
			Arrow.Rotation = 90
			Arrow.Parent = SectionReal

			local SectionAdd = Instance.new("Frame")
			SectionAdd.BackgroundTransparency = 1
			SectionAdd.Position = UDim2.new(0.5, 0, 0, 43)
			SectionAdd.Size = UDim2.new(1, -20, 0, 0)
			SectionAdd.AnchorPoint = Vector2.new(0.5, 0)
			SectionAdd.Parent = Section
			local UIListLayout = Instance.new("UIListLayout")
			UIListLayout.Padding = UDim.new(0, 6)
			UIListLayout.Parent = SectionAdd

			local OpenSection = false
			local function UpdateSize()
				local OffsetY = 43
				for _, v in SectionAdd:GetChildren() do
					if v:IsA("Frame") then OffsetY = OffsetY + v.Size.Y.Offset + 6 end
				end
				if OpenSection then
					TweenService:Create(Section, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
						Size = UDim2.new(1, 0, 0, OffsetY)
					}):Play()
					TweenService:Create(SectionAdd, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
						Size = UDim2.new(1, -20, 0, OffsetY - 43)
					}):Play()
				end
				ScrolLayers.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
			end

			SectionButton.Activated:Connect(function()
				CircleClick(SectionButton, Mouse.X, Mouse.Y)
				OpenSection = not OpenSection
				TweenService:Create(Arrow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
					Rotation = OpenSection and 270 or 90
				}):Play()
				TweenService:Create(Section, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
					Size = UDim2.new(1, 0, 0, OpenSection and ScrolLayers.CanvasSize.Y.Offset or 35)
				}):Play()
				TweenService:Create(SectionAdd, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
					Size = UDim2.new(1, -20, 0, OpenSection and (ScrolLayers.CanvasSize.Y.Offset - 43) or 0)
				}):Play()
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
				Toggle.BackgroundTransparency = 0.9
				Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				Toggle.LayoutOrder = CountItem
				Toggle.Size = UDim2.new(1, 0, 0, 60)
				Toggle.Parent = SectionAdd
				local UICorner = Instance.new("UICorner")
				UICorner.CornerRadius = UDim.new(0, 6)
				UICorner.Parent = Toggle

				local ToggleTitle = Instance.new("TextLabel")
				ToggleTitle.Font = Enum.Font.GothamSemibold
				ToggleTitle.Text = ToggleConfig.Title
				ToggleTitle.TextColor3 = ToggleConfig.Default and GuiConfig.Color or Color3.fromRGB(240, 240, 240)
				ToggleTitle.TextSize = 14
				ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
				ToggleTitle.BackgroundTransparency = 1
				ToggleTitle.Position = UDim2.new(0, 15, 0, 10)
				ToggleTitle.Size = UDim2.new(1, -100, 0, 16)
				ToggleTitle.Parent = Toggle

				local ToggleContent = Instance.new("TextLabel")
				ToggleContent.Font = Enum.Font.Gotham
				ToggleContent.Text = ToggleConfig.Content
				ToggleContent.TextColor3 = Color3.fromRGB(200, 200, 200)
				ToggleContent.TextSize = 12
				ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
				ToggleContent.BackgroundTransparency = 1
				ToggleContent.Position = UDim2.new(0, 15, 0, 28)
				ToggleContent.Size = UDim2.new(1, -100, 0, ToggleContent.TextBounds.Y)
				ToggleContent.TextWrapped = true
				ToggleContent.Parent = Toggle
				Toggle.Size = UDim2.new(1, 0, 0, math.max(ToggleContent.TextBounds.Y + 40, 60))

				local ToggleButton = Instance.new("TextButton")
				ToggleButton.Text = ""
				ToggleButton.BackgroundTransparency = 1
				ToggleButton.Size = UDim2.new(1, 0, 1, 0)
				ToggleButton.Parent = Toggle

				local FeatureFrame = Instance.new("Frame")
				FeatureFrame.BackgroundTransparency = 1
				FeatureFrame.Position = UDim2.new(1, -40, 0.5, 0)
				FeatureFrame.Size = UDim2.new(0, 35, 0, 20)
				FeatureFrame.AnchorPoint = Vector2.new(1, 0.5)
				FeatureFrame.Parent = Toggle
				
				local ToggleBG = Instance.new("Frame")
				ToggleBG.BackgroundColor3 = ToggleConfig.Default and GuiConfig.Color or Color3.fromRGB(60, 60, 60)
				ToggleBG.Size = UDim2.new(1, 0, 1, 0)
				ToggleBG.Parent = FeatureFrame
				local BGCorner = Instance.new("UICorner")
				BGCorner.CornerRadius = UDim.new(0, 10)
				BGCorner.Parent = ToggleBG
				
				local ToggleCircle = Instance.new("Frame")
				ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleCircle.Position = UDim2.new(ToggleConfig.Default and 0.55 or 0.05, 0, 0.5, 0)
				ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
				ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
				ToggleCircle.Parent = FeatureFrame
				local CircleCorner = Instance.new("UICorner")
				CircleCorner.CornerRadius = UDim.new(1, 0)
				CircleCorner.Parent = ToggleCircle

				local KeybindLabel = Instance.new("TextLabel")
				KeybindLabel.Text = ToggleConfig.Keybind.Name
				KeybindLabel.Font = Enum.Font.Gotham
				KeybindLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
				KeybindLabel.TextSize = 12
				KeybindLabel.Position = UDim2.new(1, -85, 0.5, -6)
				KeybindLabel.Size = UDim2.new(0, 40, 0, 12)
				KeybindLabel.BackgroundTransparency = 1
				KeybindLabel.TextXAlignment = Enum.TextXAlignment.Right
				KeybindLabel.Parent = Toggle

				local SettingKey = false
				KeybindLabel.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						SettingKey = true
						KeybindLabel.Text = "..."
					end
				end)
				
				UserInputService.InputBegan:Connect(function(input)
					if SettingKey and input.UserInputType == Enum.UserInputType.Keyboard then
						ToggleFunc.Keybind = input.KeyCode
						KeybindLabel.Text = input.KeyCode.Name
						SettingKey = false
					elseif input.KeyCode == ToggleFunc.Keybind and not SettingKey then
						ToggleFunc.Value = not ToggleFunc.Value
						ToggleFunc:Set(ToggleFunc.Value)
					end
				end)

				function ToggleFunc:Set(Value)
					ToggleFunc.Value = Value
					TweenService:Create(ToggleTitle, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
						TextColor3 = Value and GuiConfig.Color or Color3.fromRGB(240, 240, 240)
					}):Play()
					TweenService:Create(ToggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
						Position = UDim2.new(Value and 0.55 or 0.05, 0, 0.5, 0)
					}):Play()
					TweenService:Create(ToggleBG, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
						BackgroundColor3 = Value and GuiConfig.Color or Color3.fromRGB(60, 60, 60)
					}):Play()
					ToggleConfig.Callback(Value)
				end
				
				ToggleButton.Activated:Connect(function() 
					CircleClick(ToggleButton, Mouse.X, Mouse.Y) 
					ToggleFunc:Set(not ToggleFunc.Value) 
				end)
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
				Button.BackgroundTransparency = 0.9
				Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				Button.LayoutOrder = CountItem
				Button.Size = UDim2.new(1, 0, 0, 60)
				Button.Parent = SectionAdd
				local UICorner = Instance.new("UICorner")
				UICorner.CornerRadius = UDim.new(0, 6)
				UICorner.Parent = Button

				local ButtonTitle = Instance.new("TextLabel")
				ButtonTitle.Font = Enum.Font.GothamSemibold
				ButtonTitle.Text = ButtonConfig.Title
				ButtonTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
				ButtonTitle.TextSize = 14
				ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
				ButtonTitle.BackgroundTransparency = 1
				ButtonTitle.Position = UDim2.new(0, 15, 0, 10)
				ButtonTitle.Size = UDim2.new(1, -100, 0, 16)
				ButtonTitle.Parent = Button

				local ButtonContent = Instance.new("TextLabel")
				ButtonContent.Font = Enum.Font.Gotham
				ButtonContent.Text = ButtonConfig.Content
				ButtonContent.TextColor3 = Color3.fromRGB(200, 200, 200)
				ButtonContent.TextSize = 12
				ButtonContent.TextXAlignment = Enum.TextXAlignment.Left
				ButtonContent.BackgroundTransparency = 1
				ButtonContent.Position = UDim2.new(0, 15, 0, 28)
				ButtonContent.Size = UDim2.new(1, -100, 0, ButtonContent.TextBounds.Y)
				ButtonContent.TextWrapped = true
				ButtonContent.Parent = Button
				Button.Size = UDim2.new(1, 0, 0, math.max(ButtonContent.TextBounds.Y + 40, 60))

				local ButtonButton = Instance.new("TextButton")
				ButtonButton.Text = ""
				ButtonButton.BackgroundTransparency = 1
				ButtonButton.Size = UDim2.new(1, 0, 1, 0)
				ButtonButton.Parent = Button

				local FeatureButton = Instance.new("Frame")
				FeatureButton.BackgroundColor3 = GuiConfig.Color
				FeatureButton.BackgroundTransparency = 0.7
				FeatureButton.Position = UDim2.new(1, -40, 0.5, 0)
				FeatureButton.Size = UDim2.new(0, 25, 0, 25)
				FeatureButton.AnchorPoint = Vector2.new(1, 0.5)
				FeatureButton.Parent = Button
				local ButtonCorner = Instance.new("UICorner")
				ButtonCorner.CornerRadius = UDim.new(0, 6)
				ButtonCorner.Parent = FeatureButton
				
				local FeatureImg = Instance.new("ImageLabel")
				FeatureImg.Image = "rbxassetid://7072706620"
				FeatureImg.BackgroundTransparency = 1
				FeatureImg.Position = UDim2.new(0.5, 0, 0.5, 0)
				FeatureImg.Size = UDim2.new(0, 16, 0, 16)
				FeatureImg.AnchorPoint = Vector2.new(0.5, 0.5)
				FeatureImg.Parent = FeatureButton

				ButtonButton.Activated:Connect(function() 
					CircleClick(ButtonButton, Mouse.X, Mouse.Y)
					TweenService:Create(FeatureButton, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
						BackgroundTransparency = 0
					}):Play()
					task.wait(0.1)
					TweenService:Create(FeatureButton, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
						BackgroundTransparency = 0.7
					}):Play()
					ButtonConfig.Callback() 
				end)
				
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