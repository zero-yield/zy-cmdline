local getGlobalEnv = function(): { [string]: any }
	-- selene: allow(global_usage)
	return ((getgenv and getgenv()) or shared or _G)
end
local commandPrefix: string = getGlobalEnv()._NewPrefix or "'"
local useBetaRelease: boolean = getGlobalEnv()._UseBetaRelease or false

if not getGlobalEnv().ZY_LOADED then
	-- selene: allow(incorrect_standard_library_use)
	if useBetaRelease then
		loadstring(
			game:HttpGet("https://raw.githubusercontent.com/zero-yield/zero-yield/refs/heads/builds/source.min.luau")
		)()
	else
		loadstring(game:HttpGet("https://github.com/zero-yield/zero-yield/releases/latest/download/source.min.luau"))()
	end
end
do
	local createCommandBarUI = function(): Frame
		local mainFrame = Instance.new("Frame")
		local arrowLabel = Instance.new("TextLabel")
		local inputBox = Instance.new("TextBox")
		local predictLabel = Instance.new("TextLabel")
		local shadowImage = Instance.new("ImageLabel")

		mainFrame.Name = "CommandBar"
		mainFrame.Parent = nil
		mainFrame.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
		mainFrame.BorderSizePixel = 0
		mainFrame.Position = UDim2.new(0.5, -100, 1, 5)
		mainFrame.Size = UDim2.fromOffset(200, 35)
		mainFrame.ZIndex = 0

		arrowLabel.Name = "Arrow"
		arrowLabel.Parent = mainFrame
		arrowLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		arrowLabel.BackgroundTransparency = 1.000
		arrowLabel.BorderSizePixel = 0
		arrowLabel.Size = UDim2.new(0, 25, 1, 0)
		arrowLabel.ZIndex = 0
		arrowLabel.Font = Enum.Font.GothamMedium
		arrowLabel.Text = ">"
		arrowLabel.TextColor3 = Color3.fromRGB(220, 224, 234)
		arrowLabel.TextSize = 14.000
		arrowLabel.TextStrokeColor3 = Color3.fromRGB(220, 224, 234)
		arrowLabel.TextStrokeTransparency = 0.950

		inputBox.Name = "Input"
		inputBox.Parent = mainFrame
		inputBox.Active = false
		inputBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		inputBox.BackgroundTransparency = 1.000
		inputBox.BorderSizePixel = 0
		inputBox.Position = UDim2.fromOffset(20, 0)
		inputBox.Selectable = false
		inputBox.Size = UDim2.new(1, -25, 1, 0)
		inputBox.ZIndex = 5
		inputBox.Font = Enum.Font.Gotham
		inputBox.Text = ""
		inputBox.TextColor3 = Color3.fromRGB(220, 224, 234)
		inputBox.TextSize = 14.000
		inputBox.TextStrokeColor3 = Color3.fromRGB(220, 224, 234)
		inputBox.TextStrokeTransparency = 0.950
		inputBox.TextXAlignment = Enum.TextXAlignment.Left

		predictLabel.Name = "Predict"
		predictLabel.Parent = inputBox
		predictLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		predictLabel.BackgroundTransparency = 1.000
		predictLabel.BorderSizePixel = 0
		predictLabel.Size = UDim2.fromScale(1, 1)
		predictLabel.ZIndex = 0
		predictLabel.Font = Enum.Font.Gotham
		predictLabel.Text = ""
		predictLabel.TextColor3 = Color3.fromRGB(220, 224, 234)
		predictLabel.TextSize = 14.000
		predictLabel.TextStrokeColor3 = Color3.fromRGB(220, 224, 234)
		predictLabel.TextTransparency = 0.500
		predictLabel.TextXAlignment = Enum.TextXAlignment.Left

		shadowImage.Name = "Shadow"
		shadowImage.Parent = mainFrame
		shadowImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		shadowImage.BackgroundTransparency = 1.000
		shadowImage.Position = UDim2.fromOffset(-3, -3)
		shadowImage.Size = UDim2.new(1, 6, 1, 6)
		shadowImage.ZIndex = -5
		shadowImage.Image = "rbxassetid://222785823"
		shadowImage.ScaleType = Enum.ScaleType.Slice
		shadowImage.SliceCenter = Rect.new(100, 100, 100, 100)
		shadowImage.SliceScale = 0.250

		return mainFrame
	end

	local commandBar: Frame = createCommandBarUI()
	commandBar.Parent = PARENT

	local tweenTo = function(
		instance: Instance,
		easingStyle: string,
		easingDirection: string,
		duration: number,
		properties: { [string]: any }
	): Tween
		local tweenService = game:GetService("TweenService")
		local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle[easingStyle], Enum.EasingDirection[easingDirection])
		local tween = tweenService:Create(instance, tweenInfo, properties)
		tween:Play()
		return tween
	end

	local setCommandBarOpen = function(isOpen: boolean): ()
		if isOpen == true then
			commandBar.Input:CaptureFocus()
			task.spawn(function()
				repeat
					commandBar.Input.Text = ""
				until commandBar.Input.Text == ""
			end)
			task.spawn(function()
				tweenTo(commandBar, "Quint", "Out", 0.5, { Position = UDim2.new(0.5, -100, 1, -60) })
			end)
		end
		if isOpen == false then
			task.spawn(function()
				tweenTo(commandBar, "Quint", "Out", 0.5, { Position = UDim2.new(0.5, -100, 1, 5) })
			end)
		end
	end

	local startsWith = function(prefix: string, str: string): boolean
		return prefix == string.sub(str, 1, #prefix)
	end

	local findMatchInList = function(list: { string }?, query: string): string?
		if list == nil then
			return
		end
		if type(list) == "table" then
			for _, item in ipairs(list) do
				if startsWith(query, item) then
					return item
				end
			end
		end
		return nil
	end

	local resolvePlayerArg = function(argText: string): string?
		local lowerArg: string = string.lower(argText)
		local specialTargets: { string } = {
			"all",
			"others",
			"random",
			"me",
			"nearest",
			"farthest",
			"allies",
			"enemies",
			"team",
			"nonteam",
			"friends",
			"nonfriends",
			"bacons",
			"nearest",
			"farthest",
			"alive",
			"dead",
		}
		return findMatchInList(specialTargets, lowerArg)
			or (function(): string?
				for _, player in ipairs(Players:GetPlayers()) do
					local lowerName: string = string.lower(player.Name)
					if startsWith(lowerArg, lowerName) then
						return lowerName
					end
				end
				return nil
			end)()
	end

	local predictLabel: TextLabel = commandBar.Input.Predict
	local inputBeganConnection: RBXScriptConnection? = nil

	commandBar.Input.FocusLost:Connect(function(enterPressed: boolean)
		predictLabel.Text = ""
		if inputBeganConnection then
			inputBeganConnection:Disconnect()
		end
		if enterPressed then
			local commandText: string = commandBar.Input.Text:gsub("^" .. "%" .. commandPrefix, "")
			task.spawn(function()
				setCommandBarOpen(false)
			end)
			task.spawn(function()
				execCmd(commandText, Players.LocalPlayer, true)
			end)
		end
		task.wait()
		if not commandBar.Input:IsFocused() then
			commandBar.Input.Text = ""
		end
	end)

	commandBar.Input:GetPropertyChangedSignal("Text"):Connect(function()
		commandBar.Input.Text = string.lower(commandBar.Input.Text)
		predictLabel.Text = ""
		local currentText: string = commandBar.Input.Text
		local words: { string } = string.split(currentText, " ")
		local _currentArgs = cargs or {}
		if currentText == "" then
			return
		end
		for _, cmd in next, cmds do
			local cmdName: string = cmd.NAME
			local cmdAliases: { string } = cmd.ALIAS
			local matchedAlias: boolean = false
			if startsWith(currentText, cmdName) then
				predictLabel.Text = cmdName
				break
			end
			for _, alias in next, cmdAliases do
				if startsWith(currentText, alias) then
					matchedAlias = true
					predictLabel.Text = alias
					break
				end
				if matchedAlias then
					break
				end
			end
		end
		for wordIndex: number, word: string in next, words do
			if wordIndex > 1 and word ~= "" then
				local resolvedText: string = ""
				resolvedText = resolvePlayerArg(word) or resolvedText
				predictLabel.Text = string.sub(currentText, 1, #currentText - #words[#words]) .. resolvedText
				local subArgs: { string } = word:split(",")
				if next(subArgs) then
					for subIndex: number, subArg: string in next, subArgs do
						if subIndex > 1 and subArg ~= "" then
							local resolvedSubArg: string? = resolvePlayerArg(subArg)
							predictLabel.Text = string.sub(currentText, 1, #currentText - #subArgs[#subArgs])
								.. (resolvedSubArg or "")
						end
					end
				end
			end
		end
	end)

	commandBar.Input.Focused:Connect(function()
		local userInputService = game:GetService("UserInputService")
		inputBeganConnection = userInputService.InputBegan:Connect(
			function(inputObject: InputObject, _gameProcessed: boolean)
				if commandBar.Input:IsFocused() then
					if inputObject.KeyCode == Enum.KeyCode.Tab then
						if predictLabel.Text ~= "" then
							if string.match(predictLabel.Text, " ") then
								commandBar.Input.Text = predictLabel.Text
								task.wait()
								commandBar.Input.Text = commandBar.Input.Text:gsub("\t", "")
								commandBar.Input.CursorPosition = #commandBar.Input.Text + 1
							else
								commandBar.Input.Text = predictLabel.Text .. " "
								task.wait()
								commandBar.Input.Text = commandBar.Input.Text:gsub("\t", "")
								commandBar.Input.CursorPosition = #commandBar.Input.Text + 1
							end
						end
					end
				else
					inputBeganConnection:Disconnect()
				end
			end
		)
	end)

	ZYMouse.KeyDown:Connect(function(keyPressed: string)
		if tostring(string.lower(keyPressed)) == commandPrefix then
			task.spawn(function()
				setCommandBarOpen(true)
			end)
		end
	end)
end
