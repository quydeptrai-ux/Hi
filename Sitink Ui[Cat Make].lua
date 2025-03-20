local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")

-- Hàm MakeDraggable (giữ nguyên và tối ưu)
local function MakeDraggable(topbarobject, object)
	local function CustomPos(topbarobject, object)
		local Dragging = nil
		local DragInput = nil
		local DragStart = nil
		local StartPosition = nil

		local function UpdatePos(input)
			local Delta = input.Position - DragStart
			local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
			local Tween = TweenService:Create(object, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = pos})
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

	local function CustomSize(object)
		local Dragging = false
		local DragInput = nil
		local DragStart = nil
		local StartSize = nil
		local maxSizeX = object.Size.X.Offset
		local maxSizeY = object.Size.Y.Offset
		object.Size = UDim2.new(0, maxSizeX, 0, maxSizeY)
		local changesizeobject = Instance.new("Frame")

		changesizeobject.AnchorPoint = Vector2.new(1, 1)
		changesizeobject.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		changesizeobject.BackgroundTransparency = 0.999
		changesizeobject.BorderColor3 = Color3.fromRGB(0, 0, 0)
		changesizeobject.BorderSizePixel = 0
		changesizeobject.Position = UDim2.new(1, 20, 1, 20)
		changesizeobject.Size = UDim2.new(0, 40, 0, 40)
		changesizeobject.Name = "changesizeobject"
		changesizeobject.Parent = object

		local function UpdateSize(input)
			local Delta = input.Position - DragStart
			local newWidth = math.max(StartSize.X.Offset + Delta.X, maxSizeX)
			local newHeight = math.max(StartSize.Y.Offset + Delta.Y, maxSizeY)
			local Tween = TweenService:Create(object, TweenInfo.new(0.2), {Size = UDim2.new(0, newWidth, 0, newHeight)})
			Tween:Play()
		end

		changesizeobject.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				DragStart = input.Position
				StartSize = object.Size
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						Dragging = false
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
			if input == DragInput and Dragging then
				UpdateSize(input)
			end
		end)
	end
	CustomSize(object)
	CustomPos(topbarobject, object)
end

-- Hiệu ứng click vòng tròn (giữ nguyên và cải thiện hiệu ứng)
local ClickGui = Instance.new("ScreenGui")
local ClickFrame = Instance.new("Frame")

ClickGui.DisplayOrder = 10
ClickGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ClickGui.Name = "ClickGui"
ClickGui.Parent = CoreGui

ClickFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ClickFrame.BackgroundTransparency = 0.999
ClickFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ClickFrame.BorderSizePixel = 0
ClickFrame.Size = UDim2.new(0, 30, 0, 30)
ClickFrame.ZIndex = 0
ClickFrame.Name = "ClickFrame"
ClickFrame.Parent = ClickGui

function CircleClick(ClickFrame, X, Y)
	spawn(function()
		local Circle = Instance.new("ImageLabel")
		Circle.Image = "rbxassetid://266543268"
		Circle.ImageColor3 = Color3.fromRGB(255, 255, 255)
		Circle.ImageTransparency = 0.8
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 1
		Circle.ZIndex = 10
		Circle.Name = "Circle"
		Circle.Parent = ClickFrame
		
		ClickFrame.Position = UDim2.new(0, X - ClickFrame.Size.X.Offset // 2, 0, Y - ClickFrame.Size.Y.Offset // 2)

		local NewX = X - Circle.AbsolutePosition.X
		local NewY = Y - Circle.AbsolutePosition.Y
		Circle.Position = UDim2.new(0, NewX, 0, NewY)
		local Size = math.max(ClickFrame.AbsoluteSize.X, ClickFrame.AbsoluteSize.Y) * 1.5

		local Time = 0.2
		Circle:TweenSizeAndPosition(
			UDim2.new(0, Size, 0, Size),
			UDim2.new(0.5, -Size/2, 0.5, -Size/2),
			"Out",
			"Quad",
			Time,
			false,
			nil
		)
		for i = 1, 10 do
			Circle.ImageTransparency = Circle.ImageTransparency + 0.02
			task.wait(Time / 10)
		end
		Circle:Destroy()
	end)
end

UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		CircleClick(ClickFrame, Mouse.X, Mouse.Y)
	end
end)

-- Hàm hỗ trợ cập nhật kích thước Scroll (giữ nguyên)
local function UpSize(Scroll)
	local OffsetY = 0
	for _, child in Scroll:GetChildren() do
		if child.Name ~= "UIListLayout" then
			OffsetY = OffsetY + Scroll.UIListLayout.Padding.Offset + child.Size.Y.Offset
		end
	end
	Scroll.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
end

local function AutoUp(Scroll)
	Scroll.ChildAdded:Connect(function()
		UpSize(Scroll)
	end)
	Scroll.ChildRemoved:Connect(function()
		UpSize(Scroll)
	end)
end

-- Hiệu ứng hover (giữ nguyên và thêm hiệu ứng mượt hơn)
local function EnterMouse(frameenter)
	local old = frameenter.BackgroundColor3
	if old == Color3.fromRGB(255, 255, 255) then
		local oldtrans = frameenter.BackgroundTransparency
		frameenter.MouseEnter:Connect(function()
			TweenService:Create(
				frameenter,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundTransparency = oldtrans - 0.035}
			):Play()
		end)
		frameenter.MouseLeave:Connect(function()
			TweenService:Create(
				frameenter,
				TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundTransparency = oldtrans}
			):Play()
		end)
	else
		frameenter.MouseEnter:Connect(function()
			TweenService:Create(
				frameenter,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = Color3.fromRGB((old.R * 255) + 8, (old.G * 255) + 8, (old.B * 255) + 8)}
			):Play()
		end)
		frameenter.MouseLeave:Connect(function()
			TweenService:Create(
				frameenter,
				TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = old}
			):Play()
		end)
	end
end

-- Thư viện chính
local sitinklib = {}

-- Notify (giữ nguyên và cải tiến hiệu ứng đóng/mở)
function sitinklib:Notify(NotifyConfig)
	local NotifyConfig = NotifyConfig or {}
	NotifyConfig.Title = NotifyConfig.Title or "sitink Hub"
	NotifyConfig.Description = NotifyConfig.Description or ""
	NotifyConfig.Content = NotifyConfig.Content or ""
	NotifyConfig.Color = NotifyConfig.Color or Color3.fromRGB(127, 146, 242)
	NotifyConfig.Time = NotifyConfig.Time or 0.5
	NotifyConfig.Delay = NotifyConfig.Delay or 5
	local NotifyFunc = {}

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
			NotifyLayout.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NotifyLayout.BackgroundTransparency = 0.999
			NotifyLayout.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NotifyLayout.BorderSizePixel = 0
			NotifyLayout.Position = UDim2.new(1, -30, 1, -30)
			NotifyLayout.Size = UDim2.new(0, 300, 1, -30)
			NotifyLayout.Name = "NotifyLayout"
			NotifyLayout.Parent = CoreGui.NotifyGui

			local Count = 0
			CoreGui.NotifyGui.NotifyLayout.ChildRemoved:Connect(function()
				Count = 0
				for i, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
					TweenService:Create(
						v,
						TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
						{Position = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 12) * Count))}
					):Play()
					Count = Count + 1
				end
			end)
		end

		local NotifyPosHeigh = 0
		for i, v in CoreGui.NotifyGui.NotifyLayout:GetChildren() do
			NotifyPosHeigh = -(v.Position.Y.Offset) + v.Size.Y.Offset + 12
		end

		local NotifyFrame = Instance.new("Frame")
		local NotifyFrameReal = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local DropShadowHolder = Instance.new("Frame")
		local DropShadow = Instance.new("ImageLabel")
		local NotifyContent = Instance.new("TextLabel")
		local Top = Instance.new("Frame")
		local NotifyTitle = Instance.new("TextLabel")
		local NotifyDescription = Instance.new("TextLabel")
		local NotifyClose = Instance.new("TextButton")
		local NotifyCloseImage = Instance.new("ImageLabel")

		NotifyFrame.AnchorPoint = Vector2.new(0, 1)
		NotifyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrame.BackgroundTransparency = 1
		NotifyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrame.BorderSizePixel = 0
		NotifyFrame.Position = UDim2.new(0, 0, 1, -NotifyPosHeigh)
		NotifyFrame.Size = UDim2.new(1, 0, 0, 65)
		NotifyFrame.Name = "NotifyFrame"
		NotifyFrame.Parent = CoreGui.NotifyGui.NotifyLayout

		NotifyFrameReal.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		NotifyFrameReal.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrameReal.BorderSizePixel = 0
		NotifyFrameReal.Position = UDim2.new(0, 330, 0, 0)
		NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
		NotifyFrameReal.Name = "NotifyFrameReal"
		NotifyFrameReal.Parent = NotifyFrame

		UICorner.CornerRadius = UDim.new(0, 5)
		UICorner.Parent = NotifyFrameReal

		DropShadowHolder.BackgroundTransparency = 1
		DropShadowHolder.BorderSizePixel = 0
		DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
		DropShadowHolder.ZIndex = 0
		DropShadowHolder.Name = "DropShadowHolder"
		DropShadowHolder.Parent = NotifyFrameReal

		DropShadow.Image = "rbxassetid://6015897843"
		DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
		DropShadow.ImageTransparency = 0.5
		DropShadow.ScaleType = Enum.ScaleType.Slice
		DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
		DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
		DropShadow.BackgroundTransparency = 1
		DropShadow.BorderSizePixel = 0
		DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
		DropShadow.Size = UDim2.new(1, 47, 1, 47)
		DropShadow.ZIndex = 0
		DropShadow.Name = "DropShadow"
		DropShadow.Parent = DropShadowHolder

		NotifyContent.Font = Enum.Font.GothamBold
		NotifyContent.Text = NotifyConfig.Content
		NotifyContent.TextColor3 = Color3.fromRGB(140, 140, 140)
		NotifyContent.TextSize = 13
		NotifyContent.TextXAlignment = Enum.TextXAlignment.Left
		NotifyContent.TextYAlignment = Enum.TextYAlignment.Top
		NotifyContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyContent.BackgroundTransparency = 0.999
		NotifyContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyContent.BorderSizePixel = 0
		NotifyContent.Position = UDim2.new(0, 12, 0, 27)
		NotifyContent.Size = UDim2.new(1, -24, 0, 13)
		NotifyContent.Name = "NotifyContent"
		NotifyContent.Parent = NotifyFrameReal

		Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Top.BackgroundTransparency = 0.999
		Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Top.BorderSizePixel = 0
		Top.Size = UDim2.new(1, 0, 0, 34)
		Top.Name = "Top"
		Top.Parent = NotifyFrameReal

		NotifyTitle.Font = Enum.Font.GothamBold
		NotifyTitle.Text = NotifyConfig.Title
		NotifyTitle.TextColor3 = NotifyConfig.Color
		NotifyTitle.TextSize = 14
		NotifyTitle.TextXAlignment = Enum.TextXAlignment.Left
		NotifyTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyTitle.BackgroundTransparency = 0.999
		NotifyTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyTitle.BorderSizePixel = 0
		NotifyTitle.Position = UDim2.new(0, 12, 0, 10)
		NotifyTitle.Size = UDim2.new(0, 0, 0, 14)
		NotifyTitle.Name = "NotifyTitle"
		NotifyTitle.Parent = Top

		NotifyDescription.Font = Enum.Font.GothamBold
		NotifyDescription.Text = NotifyConfig.Description
		NotifyDescription.TextColor3 = Color3.fromRGB(230, 230, 230)
		NotifyDescription.TextSize = 14
		NotifyDescription.TextXAlignment = Enum.TextXAlignment.Left
		NotifyDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyDescription.BackgroundTransparency = 0.999
		NotifyDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyDescription.BorderSizePixel = 0
		NotifyDescription.Position = UDim2.new(0, 16 + NotifyTitle.TextBounds.X, 0, 10)
		NotifyDescription.Size = UDim2.new(0, 0, 0, 14)
		NotifyDescription.Name = "NotifyDescription"
		NotifyDescription.Parent = Top

		NotifyClose.Font = Enum.Font.SourceSans
		NotifyClose.Text = ""
		NotifyClose.TextColor3 = Color3.fromRGB(0, 0, 0)
		NotifyClose.TextSize = 14
		NotifyClose.AnchorPoint = Vector2.new(1, 0)
		NotifyClose.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyClose.BackgroundTransparency = 0.999
		NotifyClose.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyClose.BorderSizePixel = 0
		NotifyClose.Position = UDim2.new(1, 0, 0, 0)
		NotifyClose.Size = UDim2.new(0, 34, 0, 34)
		NotifyClose.Name = "NotifyClose"
		NotifyClose.Parent = Top

		NotifyCloseImage.Image = "rbxassetid://18328658828"
		NotifyCloseImage.AnchorPoint = Vector2.new(0.5, 0.5)
		NotifyCloseImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyCloseImage.BackgroundTransparency = 0.999
		NotifyCloseImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyCloseImage.BorderSizePixel = 0
		NotifyCloseImage.Position = UDim2.new(0.5, 0, 0.5, 0)
		NotifyCloseImage.Size = UDim2.new(1, -15, 1, -15)
		NotifyCloseImage.Name = "NotifyCloseImage"
		NotifyCloseImage.Parent = NotifyClose

		NotifyContent.Size = UDim2.new(1, -24, 0, 13 + (13 * (NotifyContent.TextBounds.X // NotifyContent.AbsoluteSize.X)))
		NotifyContent.TextWrapped = true

		if NotifyContent.AbsoluteSize.Y < 27 then
			NotifyFrame.Size = UDim2.new(1, 0, 0, 65)
		else
			NotifyFrame.Size = UDim2.new(1, 0, 0, NotifyContent.AbsoluteSize.Y + 40)
		end
		if NotifyContent.Text == "" then
			DropShadow.Size = UDim2.new(1, 30, 1, 30)
			NotifyFrame.Size = UDim2.new(1, 0, 0, 35)
		end

		local waitbruh = false
		function NotifyFunc:Close()
			if waitbruh then return false end
			waitbruh = true
			TweenService:Create(
				NotifyFrameReal,
				TweenInfo.new(NotifyConfig.Time, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
				{Position = UDim2.new(0, 330, 0, 0)}
			):Play()
			task.wait(NotifyConfig.Time / 1.2)
			NotifyFrame:Destroy()
		end

		NotifyClose.Activated:Connect(function()
			NotifyFunc:Close()
		end)

		TweenService:Create(
			NotifyFrameReal,
			TweenInfo.new(NotifyConfig.Time, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
			{Position = UDim2.new(0, 0, 0, 0)}
		):Play()
		task.wait(NotifyConfig.Delay)
		NotifyFunc:Close()
	end)
	return NotifyFunc
end

-- Start GUI (giữ nguyên và nâng cấp)
function sitinklib:Start(GuiConfig)
	local GuiConfig = GuiConfig or {}
	GuiConfig.Name = GuiConfig.Name or "sitink Hub"
	GuiConfig.Description = GuiConfig.Description or ""
	GuiConfig["Info Color"] = GuiConfig["Info Color"] or Color3.fromRGB(5, 59, 113)
	GuiConfig["Logo Info"] = GuiConfig["Logo Info"] or "rbxassetid://18243105495"
	GuiConfig["Logo Player"] = GuiConfig["Logo Player"] or "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
	GuiConfig["Name Info"] = GuiConfig["Name Info"] or "sitink Hub Info"
	GuiConfig["Name Player"] = GuiConfig["Name Player"] or tostring(LocalPlayer.Name)
	GuiConfig["Info Description"] = GuiConfig["Info Description"] or "discord.gg/3Aatp4Nhjp"
	GuiConfig["Tab Width"] = GuiConfig["Tab Width"] or 135
	GuiConfig["Color"] = GuiConfig["Color"] or Color3.fromRGB(127, 146, 242)
	GuiConfig["CloseCallBack"] = GuiConfig["CloseCallBack"] or function() end

	-- GUI chính
	local SitinkGui = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local Top = Instance.new("Frame")
	local TopTitle = Instance.new("TextLabel")
	local TopDescription = Instance.new("TextLabel")
	local CloseButton = Instance.new("TextButton")
	local CloseImage = Instance.new("ImageLabel")
	local DropShadowHolder = Instance.new("Frame")
	local DropShadow = Instance.new("ImageLabel")

	SitinkGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SitinkGui.Name = "SitinkGui"
	SitinkGui.Parent = CoreGui

	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Main.BorderSizePixel = 0
	Main.Size = UDim2.new(0, 500, 0, 300)
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Name = "Main"
	Main.Parent = SitinkGui

	UICorner.CornerRadius = UDim.new(0, 5)
	UICorner.Parent = Main

	Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Top.BackgroundTransparency = 0.999
	Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Top.BorderSizePixel = 0
	Top.Size = UDim2.new(1, 0, 0, 34)
	Top.Name = "Top"
	Top.Parent = Main

	TopTitle.Font = Enum.Font.GothamBold
	TopTitle.Text = GuiConfig.Name
	TopTitle.TextColor3 = GuiConfig.Color
	TopTitle.TextSize = 14
	TopTitle.TextXAlignment = Enum.TextXAlignment.Left
	TopTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TopTitle.BackgroundTransparency = 0.999
	TopTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TopTitle.BorderSizePixel = 0
	TopTitle.Position = UDim2.new(0, 12, 0, 10)
	TopTitle.Size = UDim2.new(0, 0, 0, 14)
	TopTitle.Name = "TopTitle"
	TopTitle.Parent = Top

	TopDescription.Font = Enum.Font.GothamBold
	TopDescription.Text = GuiConfig.Description
	TopDescription.TextColor3 = Color3.fromRGB(230, 230, 230)
	TopDescription.TextSize = 14
	TopDescription.TextXAlignment = Enum.TextXAlignment.Left
	TopDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TopDescription.BackgroundTransparency = 0.999
	TopDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TopDescription.BorderSizePixel = 0
	TopDescription.Position = UDim2.new(0, 16 + TopTitle.TextBounds.X, 0, 10)
	TopDescription.Size = UDim2.new(0, 0, 0, 14)
	TopDescription.Name = "TopDescription"
	TopDescription.Parent = Top

	CloseButton.Font = Enum.Font.SourceSans
	CloseButton.Text = ""
	CloseButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	CloseButton.TextSize = 14
	CloseButton.AnchorPoint = Vector2.new(1, 0)
	CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CloseButton.BackgroundTransparency = 0.999
	CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CloseButton.BorderSizePixel = 0
	CloseButton.Position = UDim2.new(1, 0, 0, 0)
	CloseButton.Size = UDim2.new(0, 34, 0, 34)
	CloseButton.Name = "CloseButton"
	CloseButton.Parent = Top

	CloseImage.Image = "rbxassetid://18328658828"
	CloseImage.AnchorPoint = Vector2.new(0.5, 0.5)
	CloseImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CloseImage.BackgroundTransparency = 0.999
	CloseImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CloseImage.BorderSizePixel = 0
	CloseImage.Position = UDim2.new(0.5, 0, 0.5, 0)
	CloseImage.Size = UDim2.new(1, -15, 1, -15)
	CloseImage.Name = "CloseImage"
	CloseImage.Parent = CloseButton

	DropShadowHolder.BackgroundTransparency = 1
	DropShadowHolder.BorderSizePixel = 0
	DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
	DropShadowHolder.ZIndex = 0
	DropShadowHolder.Name = "DropShadowHolder"
	DropShadowHolder.Parent = Main

	DropShadow.Image = "rbxassetid://6015897843"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.6
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 0
	DropShadow.Name = "DropShadow"
	DropShadow.Parent = DropShadowHolder

	MakeDraggable(Top, Main)

	function sitinklib:ToggleUI()
		Main.Visible = not Main.Visible
	end

	function sitinklib:CloseUI()
		SitinkGui:Destroy()
	end

	CloseButton.Activated:Connect(function()
		sitinklib:ToggleUI()
		GuiConfig.CloseCallBack()
	end)

	-- Tab Layer
	local LayersTab = Instance.new("Frame")
	local ScrollTab = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")

	LayersTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LayersTab.BackgroundTransparency = 0.999
	LayersTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LayersTab.BorderSizePixel = 0
	LayersTab.Position = UDim2.new(0, 10, 0, 34)
	LayersTab.Size = UDim2.new(0, GuiConfig["Tab Width"], 1, -44)
	LayersTab.Name = "LayersTab"
	LayersTab.Parent = Main

	ScrollTab.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollTab.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
	ScrollTab.ScrollBarThickness = 0
	ScrollTab.Active = true
	ScrollTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollTab.BackgroundTransparency = 0.999
	ScrollTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollTab.BorderSizePixel = 0
	ScrollTab.Position = UDim2.new(0, 0, 0, 40)
	ScrollTab.Size = UDim2.new(1, 0, 1, -40)
	ScrollTab.Name = "ScrollTab"
	ScrollTab.Parent = LayersTab

	UIListLayout.Padding = UDim.new(0, 3)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = ScrollTab

	AutoUp(ScrollTab)

	-- Info Section
	local Info = Instance.new("Frame")
	local UICorner5 = Instance.new("UICorner")
	local NamePlayer = Instance.new("TextLabel")
	local LogoFrame = Instance.new("Frame")
	local LogoPlayer = Instance.new("ImageLabel")
	local UICorner6 = Instance.new("UICorner")
	local UICorner7 = Instance.new("UICorner")
	local InfoButton = Instance.new("TextButton")

	Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Info.BackgroundTransparency = 0.999
	Info.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Info.BorderSizePixel = 0
	Info.Size = UDim2.new(1, 0, 0, 35)
	Info.Name = "Info"
	Info.Parent = LayersTab

	EnterMouse(Info)

	UICorner5.CornerRadius = UDim.new(0, 3)
	UICorner5.Parent = Info

	NamePlayer.Font = Enum.Font.GothamBold
	NamePlayer.Text = GuiConfig["Name Info"]
	NamePlayer.TextColor3 = Color3.fromRGB(230, 230, 230)
	NamePlayer.TextSize = 12
	NamePlayer.TextWrapped = true
	NamePlayer.TextXAlignment = Enum.TextXAlignment.Left
	NamePlayer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NamePlayer.BackgroundTransparency = 0.999
	NamePlayer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NamePlayer.BorderSizePixel = 0
	NamePlayer.Position = UDim2.new(0, 35, 0, 0)
	NamePlayer.Size = UDim2.new(1, -35, 1, 0)
	NamePlayer.Name = "NamePlayer"
	NamePlayer.Parent = Info

	LogoFrame.AnchorPoint = Vector2.new(0, 0.5)
	LogoFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogoFrame.BackgroundTransparency = 0.999
	LogoFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoFrame.BorderSizePixel = 0
	LogoFrame.Position = UDim2.new(0, 5, 0.5, 0)
	LogoFrame.Size = UDim2.new(0, 25, 0, 25)
	LogoFrame.Name = "LogoFrame"
	LogoFrame.Parent = Info

	LogoPlayer.Image = GuiConfig["Logo Info"]
	LogoPlayer.AnchorPoint = Vector2.new(0.5, 0.5)
	LogoPlayer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogoPlayer.BackgroundTransparency = 0.999
	LogoPlayer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoPlayer.BorderSizePixel = 0
	LogoPlayer.Position = UDim2.new(0.5, 0, 0.5, 0)
	LogoPlayer.Size = UDim2.new(1, 0, 1, 0)
	LogoPlayer.Name = "LogoPlayer"
	LogoPlayer.Parent = LogoFrame

	UICorner6.CornerRadius = UDim.new(0, 1000)
	UICorner6.Parent = LogoPlayer

	UICorner7.CornerRadius = UDim.new(0, 1000)
	UICorner7.Parent = LogoFrame

	InfoButton.Font = Enum.Font.SourceSans
	InfoButton.Text = ""
	InfoButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	InfoButton.TextSize = 14
	InfoButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	InfoButton.BackgroundTransparency = 0.999
	InfoButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	InfoButton.BorderSizePixel = 0
	InfoButton.Size = UDim2.new(1, 0, 1, 0)
	InfoButton.Name = "InfoButton"
	InfoButton.Parent = Info

	-- Info Popup
	local AnotherFrame = Instance.new("Frame")
	local UICorner30 = Instance.new("UICorner")
	local AnotherButton = Instance.new("TextButton")
	local LogFrame = Instance.new("Frame")
	local UICorner31 = Instance.new("UICorner")
	local LogUnder = Instance.new("Frame")
	local UICorner32 = Instance.new("UICorner")
	local LogTitle = Instance.new("TextLabel")
	local LogDescription = Instance.new("TextLabel")
	local LogoInfo = Instance.new("ImageLabel")
	local UICorner33 = Instance.new("UICorner")
	local UIStroke5 = Instance.new("UIStroke")

	AnotherFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	AnotherFrame.BackgroundTransparency = 0.5
	AnotherFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AnotherFrame.BorderSizePixel = 0
	AnotherFrame.Size = UDim2.new(1, 0, 1, 0)
	AnotherFrame.Visible = false
	AnotherFrame.ZIndex = 2
	AnotherFrame.Name = "AnotherFrame"
	AnotherFrame.Parent = Main

	UICorner30.CornerRadius = UDim.new(0, 3)
	UICorner30.Parent = AnotherFrame

	AnotherButton.Font = Enum.Font.SourceSans
	AnotherButton.Text = ""
	AnotherButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	AnotherButton.TextSize = 14
	AnotherButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AnotherButton.BackgroundTransparency = 0.999
	AnotherButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AnotherButton.BorderSizePixel = 0
	AnotherButton.Size = UDim2.new(1, 0, 1, 0)
	AnotherButton.Name = "AnotherButton"
	AnotherButton.Parent = AnotherFrame

	LogFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	LogFrame.BackgroundColor3 = GuiConfig["Info Color"]
	LogFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogFrame.BorderSizePixel = 0
	LogFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	LogFrame.Size = UDim2.new(0, 0, 0, 0)
	LogFrame.Name = "LogFrame"
	LogFrame.ClipsDescendants = true
	LogFrame.Parent = AnotherFrame

	UICorner31.CornerRadius = UDim.new(0, 5)
	UICorner31.Parent = LogFrame

	LogUnder.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	LogUnder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogUnder.BorderSizePixel = 0
	LogUnder.Position = UDim2.new(0, 0, 0, 50)
	LogUnder.Size = UDim2.new(1, 0, 1, -50)
	LogUnder.Name = "LogUnder"
	LogUnder.Parent = LogFrame

	UICorner32.CornerRadius = UDim.new(0, 3)
	UICorner32.Parent = LogUnder

	LogTitle.Font = Enum.Font.GothamBold
	LogTitle.Text = GuiConfig["Name Player"]
	LogTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
	LogTitle.TextSize = 18
	LogTitle.TextXAlignment = Enum.TextXAlignment.Left
	LogTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogTitle.BackgroundTransparency = 0.999
	LogTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogTitle.BorderSizePixel = 0
	LogTitle.Position = UDim2.new(0, 12, 0, 34)
	LogTitle.Size = UDim2.new(0, 35, 0, 16)
	LogTitle.Name = "LogTitle"
	LogTitle.Parent = LogUnder

	LogDescription.Font = Enum.Font.GothamBold
	LogDescription.Text = GuiConfig["Info Description"]
	LogDescription.TextColor3 = Color3.fromRGB(230, 230, 230)
	LogDescription.TextSize = 12
	LogDescription.TextTransparency = 0.5
	LogDescription.TextXAlignment = Enum.TextXAlignment.Left
	LogDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogDescription.BackgroundTransparency = 0.999
	LogDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogDescription.BorderSizePixel = 0
	LogDescription.Position = UDim2.new(0, 12, 0, 50)
	LogDescription.Size = UDim2.new(0, 35, 0, 14)
	LogDescription.Name = "LogDescription"
	LogDescription.Parent = LogUnder

	LogoInfo.Image = GuiConfig["Logo Player"]
	LogoInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogoInfo.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoInfo.BorderSizePixel = 0
	LogoInfo.Position = UDim2.new(0, 15, 0, 25)
	LogoInfo.Size = UDim2.new(0, 50, 0, 50)
	LogoInfo.Name = "LogoInfo"
	LogoInfo.Parent = LogFrame

	UICorner33.CornerRadius = UDim.new(0, 100)
	UICorner33.Parent = LogoInfo

	UIStroke5.Color = Color3.fromRGB(10, 10, 10)
	UIStroke5.Thickness = 4
	UIStroke5.Parent = LogoInfo

	InfoButton.Activated:Connect(function()
		AnotherFrame.Visible = true
		TweenService:Create(
			LogFrame,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
			{Size = UDim2.new(0, 250, 0, 125)}
		):Play()
	end)

	AnotherButton.Activated:Connect(function()
		TweenService:Create(
			LogFrame,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
			{Size = UDim2.new(0, 0, 0, 0)}
		):Play()
		task.wait(0.3)
		AnotherFrame.Visible = false
	end)

	-- Layers
	local Layers = Instance.new("Frame")
	local RealLayers = Instance.new("Frame")
	local LayersFolder = Instance.new("Folder")
	local UIPageLayout = Instance.new("UIPageLayout")

	Layers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Layers.BackgroundTransparency = 0.999
	Layers.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Layers.BorderSizePixel = 0
	Layers.Position = UDim2.new(0, GuiConfig["Tab Width"] + 23, 0, 34)
	Layers.Size = UDim2.new(1, -(GuiConfig["Tab Width"] + 31), 1, -44)
	Layers.Name = "Layers"
	Layers.Parent = Main

	RealLayers.AnchorPoint = Vector2.new(1, 1)
	RealLayers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	RealLayers.BackgroundTransparency = 0.999
	RealLayers.BorderColor3 = Color3.fromRGB(0, 0, 0)
	RealLayers.BorderSizePixel = 0
	RealLayers.ClipsDescendants = true
	RealLayers.Position = UDim2.new(1, 0, 1, 0)
	RealLayers.Size = UDim2.new(1, 0, 1, -25)
	RealLayers.Name = "RealLayers"
	RealLayers.Parent = Layers

	LayersFolder.Name = "LayersFolder"
	LayersFolder.Parent = RealLayers

	UIPageLayout.EasingDirection = Enum.EasingDirection.InOut
	UIPageLayout.EasingStyle = Enum.EasingStyle.Quad
	UIPageLayout.TweenTime = 0.3
	UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIPageLayout.Parent = LayersFolder

	-- Back Button
	local TopLayers = Instance.new("Frame")
	local NameBack = Instance.new("Frame")
	local BackButton = Instance.new("TextButton")
	local NameBack1 = Instance.new("Frame")
	local BackButton1 = Instance.new("TextButton")
	local ForwardImage = Instance.new("ImageLabel")

	TopLayers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TopLayers.BackgroundTransparency = 0.999
	TopLayers.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TopLayers.BorderSizePixel = 0
	TopLayers.Size = UDim2.new(1, 0, 0, 25)
	TopLayers.Name = "TopLayers"
	TopLayers.Parent = Layers

	NameBack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NameBack.BackgroundTransparency = 0.999
	NameBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NameBack.BorderSizePixel = 0
	NameBack.Size = UDim2.new(0, 34, 1, 0)
	NameBack.Name = "NameBack"
	NameBack.Parent = TopLayers

	BackButton.Font = Enum.Font.GothamBold
	BackButton.Text = ""
	BackButton.TextColor3 = Color3.fromRGB(230, 230, 230)
	BackButton.TextSize = 13
	BackButton.TextTransparency = 0
	BackButton.TextXAlignment = Enum.TextXAlignment.Left
	BackButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	BackButton.BackgroundTransparency = 0.999
	BackButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	BackButton.BorderSizePixel = 0
	BackButton.LayoutOrder = 0
	BackButton.Size = UDim2.new(0, 0, 1, 0)
	BackButton.Name = "BackButton"
	BackButton.Parent = NameBack

	NameBack1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NameBack1.BackgroundTransparency = 0.999
	NameBack1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NameBack1.BorderSizePixel = 0
	NameBack1.Position = UDim2.new(0, 30, 0, 0)
	NameBack1.Size = UDim2.new(1, 0, 1, 0)
	NameBack1.Name = "NameBack1"
	NameBack1.Parent = TopLayers

	BackButton1.Font = Enum.Font.GothamBold
	BackButton1.Text = ""
	BackButton1.TextColor3 = Color3.fromRGB(230, 230, 230)
	BackButton1.TextTransparency = 0.999
	BackButton1.TextSize = 13
	BackButton1.TextXAlignment = Enum.TextXAlignment.Left
	BackButton1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	BackButton1.BackgroundTransparency = 0.999
	BackButton1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	BackButton1.BorderSizePixel = 0
	BackButton1.Position = UDim2.new(0, 25, 0, 0)
	BackButton1.Size = UDim2.new(1, -25, 1, 0)
	BackButton1.Name = "BackButton1"
	BackButton1.Parent = NameBack1

	ForwardImage.Image = "rbxassetid://16851841101"
	ForwardImage.ImageColor3 = Color3.fromRGB(230, 230, 230)
	ForwardImage.ImageTransparency = 0.999
	ForwardImage.AnchorPoint = Vector2.new(0, 0.5)
	ForwardImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ForwardImage.BackgroundTransparency = 0.999
	ForwardImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ForwardImage.BorderSizePixel = 0
	ForwardImage.Position = UDim2.new(0, -1, 0.5, 1)
	ForwardImage.Rotation = -90
	ForwardImage.Size = UDim2.new(0, 22, 0, 22)
	ForwardImage.Name = "ForwardImage"
	ForwardImage.Parent = NameBack1

	local function JumpTo(TabOrder, TabName)
		BackButton.LayoutOrder = TabOrder
		BackButton.Text = TabName
		UIPageLayout:JumpToIndex(TabOrder)
		TweenService:Create(BackButton, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
		TweenService:Create(BackButton1, TweenInfo.new(0.3), {TextTransparency = 0.999}):Play()
		TweenService:Create(ForwardImage, TweenInfo.new(0.3), {ImageTransparency = 0.999}):Play()
		BackButton.Size = UDim2.new(0, BackButton.TextBounds.X + 3, 1, 0)
		NameBack.Size = UDim2.new(0, BackButton.Size.X.Offset, 1, 0)
		NameBack1.Position = UDim2.new(0, NameBack.Size.X.Offset, 0, 0)
		NameBack1.Size = UDim2.new(1, -(NameBack1.Position.X.Offset), 1, 0)
	end

	BackButton.Activated:Connect(function()
		JumpTo(BackButton.LayoutOrder, BackButton.Text)
	end)

	-- Tabs
	local Tabs = {}
	local CountTab = 0

	function Tabs:MakeTab(NameTab)
		local NameTab = NameTab or ""
		local ScrollLayer = Instance.new("ScrollingFrame")
		local UIListLayout1 = Instance.new("UIListLayout")

		ScrollLayer.ScrollBarImageColor3 = Color3.fromRGB(55, 55, 55)
		ScrollLayer.ScrollBarThickness = 3
		ScrollLayer.Active = true
		ScrollLayer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ScrollLayer.BackgroundTransparency = 0.999
		ScrollLayer.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ScrollLayer.BorderSizePixel = 0
		ScrollLayer.Size = UDim2.new(1, 0, 1, 0)
		ScrollLayer.Name = "ScrollLayer"
		ScrollLayer.LayoutOrder = CountTab
		ScrollLayer.Parent = LayersFolder

		UIListLayout1.Padding = UDim.new(0, 4)
		UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout1.Parent = ScrollLayer

		AutoUp(ScrollLayer)

		local Tab = Instance.new("Frame")
		local UICorner1 = Instance.new("UICorner")
		local ChoosingFrame = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner2 = Instance.new("UICorner")
		local TabName = Instance.new("TextLabel")
		local TabButton = Instance.new("TextButton")

		Tab.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
		Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tab.BorderSizePixel = 0
		Tab.Size = UDim2.new(1, 0, 0, 25)
		Tab.Name = "Tab"
		Tab.LayoutOrder = CountTab
		Tab.Parent = ScrollTab

		UICorner1.CornerRadius = UDim.new(0, 3)
		UICorner1.Parent = Tab

		ChoosingFrame.AnchorPoint = Vector2.new(0, 1)
		ChoosingFrame.BackgroundColor3 = GuiConfig.Color
		ChoosingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ChoosingFrame.BorderSizePixel = 0
		ChoosingFrame.Position = UDim2.new(0, 5, 1, -6)
		ChoosingFrame.Size = UDim2.new(0, 2, 0, 0)
		ChoosingFrame.Name = "ChoosingFrame"
		ChoosingFrame.Parent = Tab

		UIStroke.Color = GuiConfig.Color
		UIStroke.Thickness = 0.8
		UIStroke.Transparency = 0.999
		UIStroke.Parent = ChoosingFrame

		UICorner2.CornerRadius = UDim.new(0, 3)
		UICorner2.Parent = ChoosingFrame

		TabName.Font = Enum.Font.GothamBold
		TabName.LineHeight = 0.9
		TabName.Text = NameTab
		TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabName.TextSize = 12
		TabName.TextWrapped = true
		TabName.TextXAlignment = Enum.TextXAlignment.Left
		TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabName.BackgroundTransparency = 0.999
		TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabName.BorderSizePixel = 0
		TabName.Position = UDim2.new(0, 14, 0, 0)
		TabName.Size = UDim2.new(1, -25, 1, 0)
		TabName.Name = "TabName"
		TabName.Parent = Tab

		TabButton.Font = Enum.Font.SourceSans
		TabButton.Text = ""
		TabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		TabButton.TextSize = 14
		TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabButton.BackgroundTransparency = 0.999
		TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(1, 0, 1, 0)
		TabButton.Name = "TabButton"
		TabButton.Parent = Tab

		if CountTab == 0 then
			UIPageLayout:JumpToIndex(0)
			BackButton.Text = TabName.Text
			BackButton.Size = UDim2.new(0, BackButton.TextBounds.X, 1, 0)
			NameBack.Size = UDim2.new(0, BackButton.Size.X.Offset + 3, 1, 0)
			NameBack1.Position = UDim2.new(0, NameBack.Size.X.Offset, 0, 0)
			NameBack1.Size = UDim2.new(1, -(NameBack1.Position.X.Offset), 1, 0)
			ChoosingFrame.AnchorPoint = Vector2.new(0, 0)
			ChoosingFrame.Position = UDim2.new(0, 5, 0, 6)
			ChoosingFrame.Size = UDim2.new(0, 2, 0, 14)
			Tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			UIStroke.Transparency = 0
		end

		TabButton.Activated:Connect(function()
			if Tab.LayoutOrder ~= UIPageLayout.CurrentPage.LayoutOrder then
				for _, TabFrame in ScrollTab:GetChildren() do
					if TabFrame.Name ~= "UIListLayout" then
						TabFrame.ChoosingFrame.AnchorPoint = Vector2.new(0, 1)
						TabFrame.ChoosingFrame.Position = UDim2.new(0, 5, 1, -6)
						TweenService:Create(TabFrame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}):Play()
						TweenService:Create(TabFrame.ChoosingFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 2, 0, 0), Transparency = 0.999}):Play()
						TweenService:Create(TabFrame.ChoosingFrame.UIStroke, TweenInfo.new(0.3), {Transparency = 0.999}):Play()
					end
				end
				ChoosingFrame.AnchorPoint = Vector2.new(0, 0)
				ChoosingFrame.Position = UDim2.new(0, 5, 0, 6)
				TweenService:Create(Tab, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
				TweenService:Create(ChoosingFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 2, 0, 14), Transparency = 0}):Play()
				TweenService:Create(UIStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
				JumpTo(Tab.LayoutOrder, TabName.Text)
			end
		end)

		local Sections = {}
		local CountSection = 0

		function Sections:Section(SectionConfig)
			local SectionConfig = SectionConfig or {}
			SectionConfig.Title = SectionConfig.Title or "Title"
			SectionConfig.Content = SectionConfig.Content or ""

			local Section = Instance.new("Frame")
			local UICorner29 = Instance.new("UICorner")
			local SectionName = Instance.new("TextLabel")
			local SectionDescription = Instance.new("TextLabel")

			Section.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
			Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Section.BorderSizePixel = 0
			Section.Size = UDim2.new(1, -8, 0, 44)
			Section.Name = "Section"
			Section.LayoutOrder = CountSection
			Section.Parent = ScrollLayer

			UICorner29.CornerRadius = UDim.new(0, 3)
			UICorner29.Parent = Section

			SectionName.Font = Enum.Font.GothamBold
			SectionName.Text = SectionConfig.Title
			SectionName.TextColor3 = Color3.fromRGB(255, 255, 255)
			SectionName.TextSize = 13
			SectionName.TextXAlignment = Enum.TextXAlignment.Left
			SectionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionName.BackgroundTransparency = 0.999
			SectionName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionName.BorderSizePixel = 0
			SectionName.Position = UDim2.new(0, 10, 0, 10)
			SectionName.Size = UDim2.new(1, -70, 0, 13)
			SectionName.Name = "SectionName"
			SectionName.Parent = Section

			SectionDescription.Font = Enum.Font.GothamBold
			SectionDescription.Text = SectionConfig.Content
			SectionDescription.TextColor3 = Color3.fromRGB(230, 230, 230)
			SectionDescription.TextSize = 11
			SectionDescription.TextXAlignment = Enum.TextXAlignment.Left
			SectionDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionDescription.BackgroundTransparency = 0.999
			SectionDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionDescription.BorderSizePixel = 0
			SectionDescription.Position = UDim2.new(0, 10, 0, 23)
			SectionDescription.Size = UDim2.new(1, -70, 0, 11)
			SectionDescription.Name = "SectionDescription"
			SectionDescription.Parent = Section

			local Items = {}
			local CountItem = 0

			-- Button
			function Items:Button(ButtonConfig)
				local ButtonConfig = ButtonConfig or {}
				ButtonConfig.Title = ButtonConfig.Title or "Button"
				ButtonConfig.Content = ButtonConfig.Content or ""
				ButtonConfig.Callback = ButtonConfig.Callback or function() end
				local ButtonFunc = {}

				local Button = Instance.new("Frame")
				local UICorner14 = Instance.new("UICorner")
				local ButtonContent = Instance.new("TextLabel")
				local ButtonTitle = Instance.new("TextLabel")
				local ButtonButton = Instance.new("TextButton")
				local ClickFrame = Instance.new("Frame")
				local UICorner15 = Instance.new("UICorner")
				local ClickText = Instance.new("TextLabel")

				Button.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
				Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Button.BorderSizePixel = 0
				Button.LayoutOrder = CountItem
				Button.Size = UDim2.new(1, -8, 0, 44)
				Button.Name = "Button"
				Button.Parent = ScrollLayer

				UICorner14.CornerRadius = UDim.new(0, 3)
				UICorner14.Parent = Button

				ButtonContent.Font = Enum.Font.GothamBold
				ButtonContent.Text = ButtonConfig.Content
				ButtonContent.TextColor3 = Color3.fromRGB(230, 230, 230)
				ButtonContent.TextSize = 11
				ButtonContent.TextTransparency = 0.5
				ButtonContent.TextXAlignment = Enum.TextXAlignment.Left
				ButtonContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ButtonContent.BackgroundTransparency = 0.999
				ButtonContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ButtonContent.BorderSizePixel = 0
				ButtonContent.Position = UDim2.new(0, 10, 0, 22)
				ButtonContent.Size = UDim2.new(1, -150, 0, 11)
				ButtonContent.Name = "ButtonContent"
				ButtonContent.Parent = Button

				if ButtonContent.Text == "" then
					Button.Size = UDim2.new(1, -8, 0, 33)
				else
					ButtonContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
						ButtonContent.TextWrapped = false
						ButtonContent.Size = UDim2.new(1, -150, 0, 11 + (11 * (ButtonContent.TextBounds.X // ButtonContent.AbsoluteSize.X)))
						Button.Size = UDim2.new(1, -8, 0, ButtonContent.AbsoluteSize.Y + 33)
						ButtonContent.TextWrapped = true
						UpSize(ScrollLayer)
					end)
					ButtonContent.TextWrapped = false
					ButtonContent.Size = UDim2.new(1, -150, 0, 11 + (11 * (ButtonContent.TextBounds.X // ButtonContent.AbsoluteSize.X)))
					Button.Size = UDim2.new(1, -8, 0, ButtonContent.AbsoluteSize.Y + 33)
					ButtonContent.TextWrapped = true
					UpSize(ScrollLayer)
				end

				ButtonTitle.Font = Enum.Font.GothamBold
				ButtonTitle.Text = ButtonConfig.Title
				ButtonTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				ButtonTitle.TextSize = 12
				ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
				ButtonTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ButtonTitle.BackgroundTransparency = 0.999
				ButtonTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ButtonTitle.BorderSizePixel = 0
				ButtonTitle.Position = UDim2.new(0, 10, 0, 10)
				ButtonTitle.Size = UDim2.new(1, -150, 0, 12)
				ButtonTitle.Name = "ButtonTitle"
				ButtonTitle.Parent = Button

				ButtonButton.Font = Enum.Font.SourceSans
				ButtonButton.Text = ""
				ButtonButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				ButtonButton.TextSize = 14
				ButtonButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ButtonButton.BackgroundTransparency = 0.999
				ButtonButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ButtonButton.BorderSizePixel = 0
				ButtonButton.Size = UDim2.new(1, 0, 1, 0)
				ButtonButton.Name = "ButtonButton"
				ButtonButton.Parent = Button

				ClickFrame.AnchorPoint = Vector2.new(1, 0.5)
				ClickFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				ClickFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ClickFrame.BorderSizePixel = 0
				ClickFrame.Position = UDim2.new(1, -10, 0.5, 0)
				ClickFrame.Size = UDim2.new(0, 120, 0, 26)
				ClickFrame.Name = "ClickFrame"
				ClickFrame.Parent = Button

				UICorner15.CornerRadius = UDim.new(0, 3)
				UICorner15.Parent = ClickFrame

				ClickText.Font = Enum.Font.GothamBold
				ClickText.Text = "Click"
				ClickText.TextColor3 = Color3.fromRGB(230, 230, 230)
				ClickText.TextSize = 12
				ClickText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ClickText.BackgroundTransparency = 0.999
				ClickText.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ClickText.BorderSizePixel = 0
				ClickText.Size = UDim2.new(1, 0, 1, 0)
				ClickText.Name = "ClickText"
				ClickText.Parent = ClickFrame

				ButtonButton.Activated:Connect(function()
					TweenService:Create(ClickFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
					task.wait(0.1)
					TweenService:Create(ClickFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
					ButtonConfig.Callback()
				end)
				EnterMouse(Button)
				CountItem = CountItem + 1
				return ButtonFunc
			end

			-- TextInput
			function Items:TextInput(TextInputConfig)
				local TextInputConfig = TextInputConfig or {}
				TextInputConfig.Title = TextInputConfig.Title or "Text Input"
				TextInputConfig.Content = TextInputConfig.Content or ""
				TextInputConfig["Place Holder Text"] = TextInputConfig["Place Holder Text"] or "Enter text..."
				TextInputConfig["Clear Text On Focus"] = TextInputConfig["Clear Text On Focus"] or true
				TextInputConfig.Default = TextInputConfig.Default or ""
				TextInputConfig.Callback = TextInputConfig.Callback or function() end
				local TextInputFunc = {Value = TextInputConfig.Default}

				local TextInput = Instance.new("Frame")
				local UICorner16 = Instance.new("UICorner")
				local TextInputContent = Instance.new("TextLabel")
				local TextInputTitle = Instance.new("TextLabel")
				local InputFrame = Instance.new("Frame")
				local UICorner17 = Instance.new("UICorner")
				local InputBox = Instance.new("TextBox")

				TextInput.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
				TextInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextInput.BorderSizePixel = 0
				TextInput.LayoutOrder = CountItem
				TextInput.Size = UDim2.new(1, -8, 0, 44)
				TextInput.Name = "TextInput"
				TextInput.Parent = ScrollLayer

				UICorner16.CornerRadius = UDim.new(0, 3)
				UICorner16.Parent = TextInput

				TextInputContent.Font = Enum.Font.GothamBold
				TextInputContent.Text = TextInputConfig.Content
				TextInputContent.TextColor3 = Color3.fromRGB(230, 230, 230)
				TextInputContent.TextSize = 11
				TextInputContent.TextTransparency = 0.5
				TextInputContent.TextXAlignment = Enum.TextXAlignment.Left
				TextInputContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextInputContent.BackgroundTransparency = 0.999
				TextInputContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextInputContent.BorderSizePixel = 0
				TextInputContent.Position = UDim2.new(0, 10, 0, 22)
				TextInputContent.Size = UDim2.new(1, -150, 0, 11)
				TextInputContent.Name = "TextInputContent"
				TextInputContent.Parent = TextInput

				if TextInputContent.Text == "" then
					TextInput.Size = UDim2.new(1, -8, 0, 33)
				else
					TextInputContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
						TextInputContent.TextWrapped = false
						TextInputContent.Size = UDim2.new(1, -150, 0, 11 + (11 * (TextInputContent.TextBounds.X // TextInputContent.AbsoluteSize.X)))
						TextInput.Size = UDim2.new(1, -8, 0, TextInputContent.AbsoluteSize.Y + 33)
						TextInputContent.TextWrapped = true
						UpSize(ScrollLayer)
					end)
					TextInputContent.TextWrapped = false
					TextInputContent.Size = UDim2.new(1, -150, 0, 11 + (11 * (TextInputContent.TextBounds.X // TextInputContent.AbsoluteSize.X)))
					TextInput.Size = UDim2.new(1, -8, 0, TextInputContent.AbsoluteSize.Y + 33)
					TextInputContent.TextWrapped = true
					UpSize(ScrollLayer)
				end

				TextInputTitle.Font = Enum.Font.GothamBold
				TextInputTitle.Text = TextInputConfig.Title
				TextInputTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextInputTitle.TextSize = 12
				TextInputTitle.TextXAlignment = Enum.TextXAlignment.Left
				TextInputTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextInputTitle.BackgroundTransparency = 0.999
				TextInputTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextInputTitle.BorderSizePixel = 0
				TextInputTitle.Position = UDim2.new(0, 10, 0, 10)
				TextInputTitle.Size = UDim2.new(1, -150, 0, 12)
				TextInputTitle.Name = "TextInputTitle"
				TextInputTitle.Parent = TextInput

				InputFrame.AnchorPoint = Vector2.new(1, 0.5)
				InputFrame.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
				InputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputFrame.BorderSizePixel = 0
				InputFrame.ClipsDescendants = true
				InputFrame.Position = UDim2.new(1, -10, 0.5, 0)
				InputFrame.Size = UDim2.new(0, 120, 0, 26)
				InputFrame.Name = "InputFrame"
				InputFrame.Parent = TextInput

				UICorner17.CornerRadius = UDim.new(0, 3)
				UICorner17.Parent = InputFrame

				InputBox.Font = Enum.Font.GothamBold
				InputBox.PlaceholderText = TextInputConfig["Place Holder Text"]
				InputBox.Text = TextInputConfig.Default
				InputBox.TextColor3 = Color3.fromRGB(230, 230, 230)
				InputBox.TextSize = 11
				InputBox.TextXAlignment = Enum.TextXAlignment.Left
				InputBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				InputBox.BackgroundTransparency = 0.999
				InputBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
				InputBox.BorderSizePixel = 0
				InputBox.Position = UDim2.new(0, 5, 0, 0)
				InputBox.Size = UDim2.new(1, -10, 1, 0)
				InputBox.Name = "InputBox"
				InputBox.ClearTextOnFocus = TextInputConfig["Clear Text On Focus"]
				InputBox.Parent = InputFrame

				function TextInputFunc:Set(Value)
					InputBox.Text = Value
					TextInputFunc.Value = Value
					TextInputConfig.Callback(Value)
				end

				InputBox.FocusLost:Connect(function()
					TextInputFunc:Set(InputBox.Text)
				end)

				EnterMouse(TextInput)
				CountItem = CountItem + 1
				return TextInputFunc
			end

			-- Toggle
			function Items:Toggle(ToggleConfig)
				local ToggleConfig = ToggleConfig or {}
				ToggleConfig.Title = ToggleConfig.Title or "Toggle"
				ToggleConfig.Content = ToggleConfig.Content or ""
				ToggleConfig.Default = ToggleConfig.Default or false
				ToggleConfig.Callback = ToggleConfig.Callback or function() end
				local ToggleFunc = {Value = ToggleConfig.Default}

				local Toggle = Instance.new("Frame")
				local UICorner8 = Instance.new("UICorner")
				local ToggleContent = Instance.new("TextLabel")
				local ToggleTitle = Instance.new("TextLabel")
				local ToggleSwitch = Instance.new("Frame")
				local UICorner9 = Instance.new("UICorner")
				local ToggleSwitch2 = Instance.new("Frame")
				local UICorner10 = Instance.new("UICorner")
				local SwitchImage = Instance.new("ImageLabel")
				local ToggleButton = Instance.new("TextButton")

								Toggle.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
				Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Toggle.BorderSizePixel = 0
				Toggle.LayoutOrder = CountItem
				Toggle.Size = UDim2.new(1, -8, 0, 44)
				Toggle.Name = "Toggle"
				Toggle.Parent = ScrollLayer

				UICorner8.CornerRadius = UDim.new(0, 3)
				UICorner8.Parent = Toggle

				ToggleContent.Font = Enum.Font.GothamBold
				ToggleContent.Text = ToggleConfig.Content
				ToggleContent.TextColor3 = Color3.fromRGB(230, 230, 230)
				ToggleContent.TextSize = 11
				ToggleContent.TextTransparency = 0.5
				ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
				ToggleContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleContent.BackgroundTransparency = 0.999
				ToggleContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleContent.BorderSizePixel = 0
				ToggleContent.Position = UDim2.new(0, 10, 0, 22)
				ToggleContent.Size = UDim2.new(1, -70, 0, 11)
				ToggleContent.Name = "ToggleContent"
				ToggleContent.Parent = Toggle

				if ToggleContent.Text == "" then
					Toggle.Size = UDim2.new(1, -8, 0, 33)
				else
					ToggleContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
						ToggleContent.TextWrapped = false
						ToggleContent.Size = UDim2.new(1, -70, 0, 11 + (11 * (ToggleContent.TextBounds.X // ToggleContent.AbsoluteSize.X)))
						Toggle.Size = UDim2.new(1, -8, 0, ToggleContent.AbsoluteSize.Y + 33)
						ToggleContent.TextWrapped = true
						UpSize(ScrollLayer)
					end)
					ToggleContent.TextWrapped = false
					ToggleContent.Size = UDim2.new(1, -70, 0, 11 + (11 * (ToggleContent.TextBounds.X // ToggleContent.AbsoluteSize.X)))
					Toggle.Size = UDim2.new(1, -8, 0, ToggleContent.AbsoluteSize.Y + 33)
					ToggleContent.TextWrapped = true
					UpSize(ScrollLayer)
				end

				ToggleTitle.Font = Enum.Font.GothamBold
				ToggleTitle.Text = ToggleConfig.Title
				ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				ToggleTitle.TextSize = 12
				ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
				ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleTitle.BackgroundTransparency = 0.999
				ToggleTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleTitle.BorderSizePixel = 0
				ToggleTitle.Position = UDim2.new(0, 10, 0, 10)
				ToggleTitle.Size = UDim2.new(1, -70, 0, 12)
				ToggleTitle.Name = "ToggleTitle"
				ToggleTitle.Parent = Toggle

				ToggleSwitch.AnchorPoint = Vector2.new(1, 0.5)
				ToggleSwitch.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
				ToggleSwitch.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleSwitch.BorderSizePixel = 0
				ToggleSwitch.Position = UDim2.new(1, -10, 0.5, 0)
				ToggleSwitch.Size = UDim2.new(0, 40, 0, 20)
				ToggleSwitch.Name = "ToggleSwitch"
				ToggleSwitch.Parent = Toggle

				UICorner9.CornerRadius = UDim.new(0, 10)
				UICorner9.Parent = ToggleSwitch

				ToggleSwitch2.AnchorPoint = Vector2.new(0, 0.5)
				ToggleSwitch2.BackgroundColor3 = ToggleConfig.Default and Color3.fromRGB(127, 146, 242) or Color3.fromRGB(80, 80, 80)
				ToggleSwitch2.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleSwitch2.BorderSizePixel = 0
				ToggleSwitch2.Position = ToggleConfig.Default and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
				ToggleSwitch2.Size = UDim2.new(0, 16, 0, 16)
				ToggleSwitch2.Name = "ToggleSwitch2"
				ToggleSwitch2.Parent = ToggleSwitch

				UICorner10.CornerRadius = UDim.new(0, 10)
				UICorner10.Parent = ToggleSwitch2

				ToggleButton.Font = Enum.Font.SourceSans
				ToggleButton.Text = ""
				ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				ToggleButton.TextSize = 14
				ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleButton.BackgroundTransparency = 0.999
				ToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ToggleButton.BorderSizePixel = 0
				ToggleButton.Size = UDim2.new(1, 0, 1, 0)
				ToggleButton.Name = "ToggleButton"
				ToggleButton.Parent = Toggle

				local function UpdateToggle(Value)
					ToggleFunc.Value = Value
					TweenService:Create(
						ToggleSwitch2,
						TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{
							BackgroundColor3 = Value and Color3.fromRGB(127, 146, 242) or Color3.fromRGB(80, 80, 80),
							Position = Value and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
						}
					):Play()
					ToggleConfig.Callback(Value)
				end

				ToggleButton.Activated:Connect(function()
					UpdateToggle(not ToggleFunc.Value)
				end)

				function ToggleFunc:Set(Value)
					UpdateToggle(Value)
				end

				EnterMouse(Toggle)
				CountItem = CountItem + 1
				return ToggleFunc
			end

			-- Slider
			function Items:Slider(SliderConfig)
				local SliderConfig = SliderConfig or {}
				SliderConfig.Title = SliderConfig.Title or "Slider"
				SliderConfig.Content = SliderConfig.Content or ""
				SliderConfig.Min = SliderConfig.Min or 0
				SliderConfig.Max = SliderConfig.Max or 100
				SliderConfig.Default = SliderConfig.Default or 50
				SliderConfig.Callback = SliderConfig.Callback or function() end
				local SliderFunc = {Value = SliderConfig.Default}

				local Slider = Instance.new("Frame")
				local UICorner11 = Instance.new("UICorner")
				local SliderContent = Instance.new("TextLabel")
				local SliderTitle = Instance.new("TextLabel")
				local SliderFrame = Instance.new("Frame")
				local UICorner12 = Instance.new("UICorner")
				local SliderBar = Instance.new("Frame")
				local UICorner13 = Instance.new("UICorner")
				local SliderButton = Instance.new("TextButton")
				local SliderValue = Instance.new("TextLabel")

				Slider.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
				Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Slider.BorderSizePixel = 0
				Slider.LayoutOrder = CountItem
				Slider.Size = UDim2.new(1, -8, 0, 60)
				Slider.Name = "Slider"
				Slider.Parent = ScrollLayer

				UICorner11.CornerRadius = UDim.new(0, 3)
				UICorner11.Parent = Slider

				SliderContent.Font = Enum.Font.GothamBold
				SliderContent.Text = SliderConfig.Content
				SliderContent.TextColor3 = Color3.fromRGB(230, 230, 230)
				SliderContent.TextSize = 11
				SliderContent.TextTransparency = 0.5
				SliderContent.TextXAlignment = Enum.TextXAlignment.Left
				SliderContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderContent.BackgroundTransparency = 0.999
				SliderContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderContent.BorderSizePixel = 0
				SliderContent.Position = UDim2.new(0, 10, 0, 22)
				SliderContent.Size = UDim2.new(1, -70, 0, 11)
				SliderContent.Name = "SliderContent"
				SliderContent.Parent = Slider

				if SliderContent.Text == "" then
					Slider.Size = UDim2.new(1, -8, 0, 50)
				else
					SliderContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
						SliderContent.TextWrapped = false
						SliderContent.Size = UDim2.new(1, -70, 0, 11 + (11 * (SliderContent.TextBounds.X // SliderContent.AbsoluteSize.X)))
						Slider.Size = UDim2.new(1, -8, 0, SliderContent.AbsoluteSize.Y + 40)
						SliderContent.TextWrapped = true
						UpSize(ScrollLayer)
					end)
					SliderContent.TextWrapped = false
					SliderContent.Size = UDim2.new(1, -70, 0, 11 + (11 * (SliderContent.TextBounds.X // SliderContent.AbsoluteSize.X)))
					Slider.Size = UDim2.new(1, -8, 0, SliderContent.AbsoluteSize.Y + 40)
					SliderContent.TextWrapped = true
					UpSize(ScrollLayer)
				end

				SliderTitle.Font = Enum.Font.GothamBold
				SliderTitle.Text = SliderConfig.Title
				SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderTitle.TextSize = 12
				SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
				SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderTitle.BackgroundTransparency = 0.999
				SliderTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderTitle.BorderSizePixel = 0
				SliderTitle.Position = UDim2.new(0, 10, 0, 10)
				SliderTitle.Size = UDim2.new(1, -70, 0, 12)
				SliderTitle.Name = "SliderTitle"
				SliderTitle.Parent = Slider

				SliderFrame.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
				SliderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderFrame.BorderSizePixel = 0
				SliderFrame.Position = UDim2.new(0, 10, 1, -20)
				SliderFrame.Size = UDim2.new(1, -20, 0, 6)
				SliderFrame.Name = "SliderFrame"
				SliderFrame.Parent = Slider

				UICorner12.CornerRadius = UDim.new(0, 3)
				UICorner12.Parent = SliderFrame

				SliderBar.BackgroundColor3 = Color3.fromRGB(127, 146, 242)
				SliderBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderBar.BorderSizePixel = 0
				SliderBar.Size = UDim2.new((SliderConfig.Default - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 0, 1, 0)
				SliderBar.Name = "SliderBar"
				SliderBar.Parent = SliderFrame

				UICorner13.CornerRadius = UDim.new(0, 3)
				UICorner13.Parent = SliderBar

				SliderButton.Font = Enum.Font.SourceSans
				SliderButton.Text = ""
				SliderButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				SliderButton.TextSize = 14
				SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderButton.BackgroundTransparency = 0.999
				SliderButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderButton.BorderSizePixel = 0
				SliderButton.Size = UDim2.new(1, 0, 1, 0)
				SliderButton.Name = "SliderButton"
				SliderButton.Parent = SliderFrame

				SliderValue.Font = Enum.Font.GothamBold
				SliderValue.Text = tostring(SliderConfig.Default)
				SliderValue.TextColor3 = Color3.fromRGB(230, 230, 230)
				SliderValue.TextSize = 11
				SliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderValue.BackgroundTransparency = 0.999
				SliderValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderValue.BorderSizePixel = 0
				SliderValue.Position = UDim2.new(1, -50, 0, -15)
				SliderValue.Size = UDim2.new(0, 40, 0, 11)
				SliderValue.Name = "SliderValue"
				SliderValue.Parent = SliderFrame

				local Dragging = false
				local function UpdateSlider(input)
					local SliderSize = SliderFrame.AbsoluteSize.X
					local Position = math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderSize, 0, 1)
					local Value = SliderConfig.Min + (SliderConfig.Max - SliderConfig.Min) * Position
					SliderFunc.Value = math.floor(Value)
					SliderBar.Size = UDim2.new(Position, 0, 1, 0)
					SliderValue.Text = tostring(SliderFunc.Value)
					SliderConfig.Callback(SliderFunc.Value)
				end

				SliderButton.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Dragging = true
						UpdateSlider(input)
					end
				end)

				SliderButton.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Dragging = false
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						UpdateSlider(input)
					end
				end)

				function SliderFunc:Set(Value)
					local ClampedValue = math.clamp(Value, SliderConfig.Min, SliderConfig.Max)
					SliderFunc.Value = ClampedValue
					SliderBar.Size = UDim2.new((ClampedValue - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 0, 1, 0)
					SliderValue.Text = tostring(ClampedValue)
					SliderConfig.Callback(ClampedValue)
				end

				EnterMouse(Slider)
				CountItem = CountItem + 1
				return SliderFunc
			end

			-- Dropdown
			function Items:Dropdown(DropdownConfig)
				local DropdownConfig = DropdownConfig or {}
				DropdownConfig.Title = DropdownConfig.Title or "Dropdown"
				DropdownConfig.Content = DropdownConfig.Content or ""
				DropdownConfig.Options = DropdownConfig.Options or {"Option 1", "Option 2", "Option 3"}
				DropdownConfig.Default = DropdownConfig.Default or DropdownConfig.Options[1]
				DropdownConfig.Callback = DropdownConfig.Callback or function() end
				local DropdownFunc = {Value = DropdownConfig.Default}

				local Dropdown = Instance.new("Frame")
				local UICorner18 = Instance.new("UICorner")
				local DropdownContent = Instance.new("TextLabel")
				local DropdownTitle = Instance.new("TextLabel")
				local DropdownFrame = Instance.new("Frame")
				local UICorner19 = Instance.new("UICorner")
				local DropdownButton = Instance.new("TextButton")
				local DropdownText = Instance.new("TextLabel")
				local DropdownArrow = Instance.new("ImageLabel")
				local DropdownList = Instance.new("Frame")
				local UICorner20 = Instance.new("UICorner")
				local DropdownScroll = Instance.new("ScrollingFrame")
				local UIListLayout2 = Instance.new("UIListLayout")

				Dropdown.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
				Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Dropdown.BorderSizePixel = 0
				Dropdown.LayoutOrder = CountItem
				Dropdown.Size = UDim2.new(1, -8, 0, 44)
				Dropdown.Name = "Dropdown"
				Dropdown.Parent = ScrollLayer

				UICorner18.CornerRadius = UDim.new(0, 3)
				UICorner18.Parent = Dropdown

				DropdownContent.Font = Enum.Font.GothamBold
				DropdownContent.Text = DropdownConfig.Content
				DropdownContent.TextColor3 = Color3.fromRGB(230, 230, 230)
				DropdownContent.TextSize = 11
				DropdownContent.TextTransparency = 0.5
				DropdownContent.TextXAlignment = Enum.TextXAlignment.Left
				DropdownContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownContent.BackgroundTransparency = 0.999
				DropdownContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownContent.BorderSizePixel = 0
				DropdownContent.Position = UDim2.new(0, 10, 0, 22)
				DropdownContent.Size = UDim2.new(1, -150, 0, 11)
				DropdownContent.Name = "DropdownContent"
				DropdownContent.Parent = Dropdown

				if DropdownContent.Text == "" then
					Dropdown.Size = UDim2.new(1, -8, 0, 33)
				else
					DropdownContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
						DropdownContent.TextWrapped = false
						DropdownContent.Size = UDim2.new(1, -150, 0, 11 + (11 * (DropdownContent.TextBounds.X // DropdownContent.AbsoluteSize.X)))
						Dropdown.Size = UDim2.new(1, -8, 0, DropdownContent.AbsoluteSize.Y + 33)
						DropdownContent.TextWrapped = true
						UpSize(ScrollLayer)
					end)
					DropdownContent.TextWrapped = false
					DropdownContent.Size = UDim2.new(1, -150, 0, 11 + (11 * (DropdownContent.TextBounds.X // DropdownContent.AbsoluteSize.X)))
					Dropdown.Size = UDim2.new(1, -8, 0, DropdownContent.AbsoluteSize.Y + 33)
					DropdownContent.TextWrapped = true
					UpSize(ScrollLayer)
				end

				DropdownTitle.Font = Enum.Font.GothamBold
				DropdownTitle.Text = DropdownConfig.Title
				DropdownTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				DropdownTitle.TextSize = 12
				DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
				DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownTitle.BackgroundTransparency = 0.999
				DropdownTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownTitle.BorderSizePixel = 0
				DropdownTitle.Position = UDim2.new(0, 10, 0, 10)
				DropdownTitle.Size = UDim2.new(1, -150, 0, 12)
				DropdownTitle.Name = "DropdownTitle"
				DropdownTitle.Parent = Dropdown

				DropdownFrame.AnchorPoint = Vector2.new(1, 0.5)
				DropdownFrame.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
				DropdownFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownFrame.BorderSizePixel = 0
				DropdownFrame.Position = UDim2.new(1, -10, 0.5, 0)
				DropdownFrame.Size = UDim2.new(0, 120, 0, 26)
				DropdownFrame.Name = "DropdownFrame"
				DropdownFrame.Parent = Dropdown

				UICorner19.CornerRadius = UDim.new(0, 3)
				UICorner19.Parent = DropdownFrame

				DropdownButton.Font = Enum.Font.SourceSans
				DropdownButton.Text = ""
				DropdownButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				DropdownButton.TextSize = 14
				DropdownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownButton.BackgroundTransparency = 0.999
				DropdownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownButton.BorderSizePixel = 0
				DropdownButton.Size = UDim2.new(1, 0, 1, 0)
				DropdownButton.Name = "DropdownButton"
				DropdownButton.Parent = DropdownFrame

				DropdownText.Font = Enum.Font.GothamBold
				DropdownText.Text = DropdownConfig.Default
				DropdownText.TextColor3 = Color3.fromRGB(230, 230, 230)
				DropdownText.TextSize = 11
				DropdownText.TextXAlignment = Enum.TextXAlignment.Left
				DropdownText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownText.BackgroundTransparency = 0.999
				DropdownText.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownText.BorderSizePixel = 0
				DropdownText.Position = UDim2.new(0, 5, 0, 0)
				DropdownText.Size = UDim2.new(1, -25, 1, 0)
				DropdownText.Name = "DropdownText"
				DropdownText.Parent = DropdownFrame

				DropdownArrow.Image = "rbxassetid://16851841101"
				DropdownArrow.ImageColor3 = Color3.fromRGB(230, 230, 230)
				DropdownArrow.AnchorPoint = Vector2.new(1, 0.5)
				DropdownArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownArrow.BackgroundTransparency = 0.999
				DropdownArrow.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownArrow.BorderSizePixel = 0
				DropdownArrow.Position = UDim2.new(1, -5, 0.5, 0)
				DropdownArrow.Size = UDim2.new(0, 15, 0, 15)
				DropdownArrow.Name = "DropdownArrow"
				DropdownArrow.Parent = DropdownFrame

				DropdownList.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
				DropdownList.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownList.BorderSizePixel = 0
				DropdownList.Position = UDim2.new(0, 0, 1, 5)
				DropdownList.Size = UDim2.new(1, 0, 0, 0)
				DropdownList.Visible = false
				DropdownList.Name = "DropdownList"
				DropdownList.Parent = DropdownFrame

				UICorner20.CornerRadius = UDim.new(0, 3)
				UICorner20.Parent = DropdownList

				DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
				DropdownScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
				DropdownScroll.ScrollBarThickness = 3
				DropdownScroll.Active = true
				DropdownScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DropdownScroll.BackgroundTransparency = 0.999
				DropdownScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DropdownScroll.BorderSizePixel = 0
				DropdownScroll.Size = UDim2.new(1, 0, 1, 0)
				DropdownScroll.Name = "DropdownScroll"
				DropdownScroll.Parent = DropdownList

				UIListLayout2.Padding = UDim.new(0, 2)
				UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout2.Parent = DropdownScroll

				local function UpdateDropdownSize()
					local height = math.min(#DropdownConfig.Options * 22, 100)
					DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, #DropdownConfig.Options * 22)
					DropdownList.Size = UDim2.new(1, 0, 0, height)
				end

				local function PopulateDropdown()
					for _, option in pairs(DropdownConfig.Options) do
						local OptionButton = Instance.new("TextButton")
						OptionButton.Font = Enum.Font.GothamBold
						OptionButton.Text = option
						OptionButton.TextColor3 = Color3.fromRGB(230, 230, 230)
						OptionButton.TextSize = 11
						OptionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
						OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
						OptionButton.BorderSizePixel = 0
						OptionButton.Size = UDim2.new(1, -6, 0, 20)
						OptionButton.Parent = DropdownScroll

						OptionButton.Activated:Connect(function()
							DropdownFunc.Value = option
							DropdownText.Text = option
							TweenService:Create(DropdownList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
							task.wait(0.2)
							DropdownList.Visible = false
							DropdownConfig.Callback(option)
						end)

						EnterMouse(OptionButton)
					end
					UpdateDropdownSize()
				end

				PopulateDropdown()

				DropdownButton.Activated:Connect(function()
					if DropdownList.Visible then
						TweenService:Create(DropdownList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
						task.wait(0.2)
						DropdownList.Visible = false
					else
						DropdownList.Visible = true
						TweenService:Create(DropdownList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, math.min(#DropdownConfig.Options * 22, 100))}):Play()
					end
				end)

				function DropdownFunc:Set(Value)
					if table.find(DropdownConfig.Options, Value) then
						DropdownFunc.Value = Value
						DropdownText.Text = Value
						DropdownConfig.Callback(Value)
					end
				end

				EnterMouse(Dropdown)
				CountItem = CountItem + 1
				return DropdownFunc
			end

			-- Label
			function Items:Label(LabelConfig)
				local LabelConfig = LabelConfig or {}
				LabelConfig.Text = LabelConfig.Text or "Label"

				local Label = Instance.new("Frame")
				local UICorner21 = Instance.new("UICorner")
				local LabelText = Instance.new("TextLabel")

				Label.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
				Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Label.BorderSizePixel = 0
				Label.LayoutOrder = CountItem
				Label.Size = UDim2.new(1, -8, 0, 30)
				Label.Name = "Label"
				Label.Parent = ScrollLayer

				UICorner21.CornerRadius = UDim.new(0, 3)
				UICorner21.Parent = Label

				LabelText.Font = Enum.Font.GothamBold
				LabelText.Text = LabelConfig.Text
				LabelText.TextColor3 = Color3.fromRGB(230, 230, 230)
				LabelText.TextSize = 12
				LabelText.TextXAlignment = Enum.TextXAlignment.Left
				LabelText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				LabelText.BackgroundTransparency = 0.999
				LabelText.BorderColor3 = Color3.fromRGB(0, 0, 0)
				LabelText.BorderSizePixel = 0
				LabelText.Position = UDim2.new(0, 10, 0, 0)
				LabelText.Size = UDim2.new(1, -20, 1, 0)
				LabelText.Name = "LabelText"
				LabelText.Parent = Label

				local LabelFunc = {}
				function LabelFunc:Set(Text)
					LabelText.Text = Text
				end

				CountItem = CountItem + 1
				return LabelFunc
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