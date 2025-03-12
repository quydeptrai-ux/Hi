
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = LocalPlayer.PlayerGui

-- Utility Functions
local function MakeDraggable(topbar, object)
	local Dragging, DragInput, DragStart, StartPos

	local function Update(input)
		local delta = input.Position - DragStart
		local newPos = UDim2.new(
			StartPos.X.Scale,
			StartPos.X.Offset + delta.X,
			StartPos.Y.Scale,
			StartPos.Y.Offset + delta.Y
		)
		TweenService:Create(object, TweenInfo.new(0.15), {Position = newPos}):Play()
	end

	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPos = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

local function CircleClick(button, x, y)
	task.spawn(function()
		local circle = Instance.new("ImageLabel")
		circle.Image = "rbxassetid://266543268"
		circle.ImageColor3 = Color3.fromRGB(80, 80, 80)
		circle.ImageTransparency = 0.9
		circle.BackgroundTransparency = 1
		circle.ZIndex = 10
		circle.Parent = button

		local newX = x - circle.AbsolutePosition.X
		local newY = y - circle.AbsolutePosition.Y
		circle.Position = UDim2.new(0, newX, 0, newY)
		local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.5

		TweenService:Create(circle, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
			Size = UDim2.new(0, size, 0, size),
			Position = UDim2.new(0.5, -size/2, 0.5, -size/2),
			ImageTransparency = 1
		}):Play()
		task.wait(0.5)
		circle:Destroy()
	end)
end

-- CatLib Main
local CatLib = {}

function CatLib:MakeNotify(config)
	config = config or {}
	config.Title = config.Title or "Cat Hub"
	config.Description = config.Description or "Notification"
	config.Content = config.Content or "Content"
	config.Color = config.Color or Color3.fromRGB(255, 0, 255)
	config.Time = config.Time or 0.5
	config.Delay = config.Delay or 5

	local notifyGui = CoreGui:FindFirstChild("NotifyGui") or Instance.new("ScreenGui", CoreGui)
	notifyGui.Name = "NotifyGui"
	notifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local layout = notifyGui:FindFirstChild("NotifyLayout") or Instance.new("Frame", notifyGui)
	layout.Name = "NotifyLayout"
	layout.AnchorPoint = Vector2.new(1, 1)
	layout.BackgroundTransparency = 1
	layout.Position = UDim2.new(1, -30, 1, -30)
	layout.Size = UDim2.new(0, 320, 1, 0)

	local notifyFrame = Instance.new("Frame", layout)
	notifyFrame.BackgroundTransparency = 1
	notifyFrame.Size = UDim2.new(1, 0, 0, 150)
	notifyFrame.AnchorPoint = Vector2.new(0, 1)

	local notifyReal = Instance.new("Frame", notifyFrame)
	notifyReal.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	notifyReal.Size = UDim2.new(1, 0, 1, 0)
	Instance.new("UICorner", notifyReal).CornerRadius = UDim.new(0, 8)

	local top = Instance.new("Frame", notifyReal)
	top.BackgroundTransparency = 1
	top.Size = UDim2.new(1, 0, 0, 36)

	local title = Instance.new("TextLabel", top)
	title.Text = config.Title
	title.Font = Enum.Font.GothamBold
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0, 10, 0, 0)
	title.Size = UDim2.new(1, -40, 1, 0)

	local desc = Instance.new("TextLabel", top)
	desc.Text = config.Description
	desc.Font = Enum.Font.GothamBold
	desc.TextColor3 = config.Color
	desc.TextSize = 14
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.BackgroundTransparency = 1
	desc.Position = UDim2.new(0, title.TextBounds.X + 15, 0, 0)
	desc.Size = UDim2.new(1, -title.TextBounds.X - 20, 1, 0)

	local content = Instance.new("TextLabel", notifyReal)
	content.Text = config.Content
	content.Font = Enum.Font.Gotham
	content.TextColor3 = Color3.fromRGB(200, 200, 200)
	content.TextSize = 13
	content.TextXAlignment = Enum.TextXAlignment.Left
	content.TextYAlignment = Enum.TextYAlignment.Top
	content.BackgroundTransparency = 1
	content.Position = UDim2.new(0, 10, 0, 40)
	content.Size = UDim2.new(1, -20, 0, 0)
	content.TextWrapped = true
	content.Size = UDim2.new(1, -20, 0, content.TextBounds.Y)
	notifyFrame.Size = UDim2.new(1, 0, 0, content.TextBounds.Y + 50)

	local function updatePosition()
		local posY = 0
		for _, child in ipairs(layout:GetChildren()) do
			if child:IsA("Frame") then
				TweenService:Create(child, TweenInfo.new(0.3), {
					Position = UDim2.new(0, 0, 1, -posY)
				}):Play()
				posY = posY + child.Size.Y.Offset + 10
			end
		end
	end

	notifyFrame.Position = UDim2.new(0, 400, 1, 0)
	TweenService:Create(notifyReal, TweenInfo.new(config.Time), {
		Position = UDim2.new(0, 0, 0, 0)
	}):Play()
	updatePosition()

	local notifyFunc = {}
	function notifyFunc:Close()
		TweenService:Create(notifyReal, TweenInfo.new(config.Time), {
			Position = UDim2.new(0, 400, 0, 0)
		}):Play()
		task.wait(config.Time)
		notifyFrame:Destroy()
		updatePosition()
	end

	task.delay(config.Delay, notifyFunc.Close)
	return notifyFunc
end

function CatLib:MakeGui(config)
	config = config or {}
	config.NameHub = config.NameHub or "Cat Hub"
	config.Description = config.Description or "by: catdzs1vn"
	config.Color = config.Color or Color3.fromRGB(255, 0, 255)
	config.LogoPlayer = config.LogoPlayer or "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
	config.NamePlayer = config.NamePlayer or LocalPlayer.Name
	config.TabWidth = config.TabWidth or 120

	local gui = Instance.new("ScreenGui", CoreGui)
	gui.Name = "CatGui_v03"
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local main = Instance.new("Frame", gui)
	main.Size = UDim2.new(0, 500, 0, 350)
	main.Position = UDim2.new(0.5, -250, 0.5, -175)
	main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	main.BackgroundTransparency = 0.1
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

	local top = Instance.new("Frame", main)
	top.Size = UDim2.new(1, 0, 0, 40)
	top.BackgroundTransparency = 1

	local title = Instance.new("TextLabel", top)
	title.Text = config.NameHub
	title.Font = Enum.Font.GothamBold
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 16
	title.Position = UDim2.new(0, 10, 0, 0)
	title.Size = UDim2.new(0.5, 0, 1, 0)
	title.BackgroundTransparency = 1

	local desc = Instance.new("TextLabel", top)
	desc.Text = config.Description
	desc.Font = Enum.Font.Gotham
	desc.TextColor3 = config.Color
	desc.TextSize = 14
	desc.Position = UDim2.new(0, title.TextBounds.X + 15, 0, 0)
	desc.Size = UDim2.new(0.5, -title.TextBounds.X - 20, 1, 0)
	desc.BackgroundTransparency = 1

	local tabs = Instance.new("Frame", main)
	tabs.Position = UDim2.new(0, 10, 0, 50)
	tabs.Size = UDim2.new(0, config.TabWidth, 1, -60)
	tabs.BackgroundTransparency = 1

	local content = Instance.new("Frame", main)
	content.Position = UDim2.new(0, config.TabWidth + 20, 0, 50)
	content.Size = UDim2.new(1, -config.TabWidth - 30, 1, -60)
	content.BackgroundTransparency = 1

	MakeDraggable(top, main)

	local guiFunc = {}
	local tabsModule = {}
	local currentTab = nil

	function tabsModule:CreateTab(tabConfig)
		tabConfig = tabConfig or {}
		tabConfig.Name = tabConfig.Name or "Tab"
		tabConfig.Icon = tabConfig.Icon or ""

		local tabButton = Instance.new("TextButton", tabs)
		tabButton.Size = UDim2.new(1, 0, 0, 40)
		tabButton.BackgroundTransparency = 0.9
		tabButton.Text = ""
		Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 6)

		local tabName = Instance.new("TextLabel", tabButton)
		tabName.Text = tabConfig.Name
		tabName.Font = Enum.Font.GothamBold
		tabName.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabName.TextSize = 14
		tabName.Position = UDim2.new(0, 40, 0, 0)
		tabName.Size = UDim2.new(1, -40, 1, 0)
		tabName.BackgroundTransparency = 1

		local tabContent = Instance.new("ScrollingFrame", content)
		tabContent.Size = UDim2.new(1, 0, 1, 0)
		tabContent.BackgroundTransparency = 1
		tabContent.ScrollBarThickness = 2
		tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
		tabContent.Visible = false

		local layout = Instance.new("UIListLayout", tabContent)
		layout.Padding = UDim.new(0, 5)

		local sections = {}
		function sections:AddSection(title)
			local section = Instance.new("Frame", tabContent)
			section.Size = UDim2.new(1, 0, 0, 30)
			section.BackgroundTransparency = 1

			local sectionTitle = Instance.new("TextLabel", section)
			sectionTitle.Text = title or "Section"
			sectionTitle.Font = Enum.Font.GothamBold
			sectionTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
			sectionTitle.TextSize = 14
			sectionTitle.Size = UDim2.new(1, 0, 0, 30)
			sectionTitle.BackgroundTransparency = 1

			local items = {}
			local sectionItems = Instance.new("Frame", section)
			sectionItems.Position = UDim2.new(0, 0, 0, 30)
			sectionItems.Size = UDim2.new(1, 0, 0, 0)
			sectionItems.BackgroundTransparency = 1
			local itemLayout = Instance.new("UIListLayout", sectionItems)
			itemLayout.Padding = UDim.new(0, 5)

			local function updateSize()
				local height = 30
				for _, item in ipairs(sectionItems:GetChildren()) do
					if item:IsA("Frame") then
						height = height + item.Size.Y.Offset + 5
					end
				end
				section.Size = UDim2.new(1, 0, 0, height)
				tabContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
			end

			function items:AddToggle(toggleConfig)
				toggleConfig = toggleConfig or {}
				toggleConfig.Title = toggleConfig.Title or "Toggle"
				toggleConfig.Default = toggleConfig.Default or false
				toggleConfig.Callback = toggleConfig.Callback or function() end

				local toggle = Instance.new("Frame", sectionItems)
				toggle.Size = UDim2.new(1, 0, 0, 40)
				toggle.BackgroundTransparency = 0.9
				Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

				local toggleTitle = Instance.new("TextLabel", toggle)
				toggleTitle.Text = toggleConfig.Title
				toggleTitle.Font = Enum.Font.GothamBold
				toggleTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
				toggleTitle.TextSize = 14
				toggleTitle.Position = UDim2.new(0, 10, 0, 0)
				toggleTitle.Size = UDim2.new(1, -50, 1, 0)
				toggleTitle.BackgroundTransparency = 1

				local toggleSwitch = Instance.new("Frame", toggle)
				toggleSwitch.Size = UDim2.new(0, 40, 0, 20)
				toggleSwitch.Position = UDim2.new(1, -45, 0.5, -10)
				toggleSwitch.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
				Instance.new("UICorner", toggleSwitch).CornerRadius = UDim.new(0, 10)

				local toggleCircle = Instance.new("Frame", toggleSwitch)
				toggleCircle.Size = UDim2.new(0, 18, 0, 18)
				toggleCircle.Position = UDim2.new(0, 2, 0, 1)
				toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(0, 10)

				local toggleFunc = {Value = toggleConfig.Default}
				local function updateToggle(value)
					toggleFunc.Value = value
					TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
						Position = value and UDim2.new(1, -20, 0, 1) or UDim2.new(0, 2, 0, 1),
						BackgroundColor3 = value and config.Color or Color3.fromRGB(255, 255, 255)
					}):Play()
					toggleConfig.Callback(value)
				end

				toggle.MouseButton1Click:Connect(function()
					updateToggle(not toggleFunc.Value)
				end)
				updateToggle(toggleConfig.Default)
				updateSize()

				return toggleFunc
			end

			-- Thêm các thành phần khác (Slider, Dropdown, Keybind, ColorPicker) ở đây nếu cần

			return items
		end

		tabButton.MouseButton1Click:Connect(function()
			if currentTab ~= tabContent then
				if currentTab then
					currentTab.Visible = false
				end
				tabContent.Visible = true
				currentTab = tabContent
				TweenService:Create(tabButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.7}):Play()
			end
		end)

		return sections
	end

	return guiFunc, tabsModule
end

return CatLib