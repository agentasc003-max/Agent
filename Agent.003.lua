local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ====================== НАСТРОЙКИ ======================
local ADMIN_IDS = {
	123456789, -- <-- ЗАМЕНИ НА СВОЙ USER ID
	-- 987654321, -- можно добавить ещё админов
}

local BAN_REASON = "#@%#-+@"
-- =======================================================

-- Создаём RemoteEvent
local banRemote = Instance.new("RemoteEvent")
banRemote.Name = "BanPlayerRemote"
banRemote.Parent = ReplicatedStorage

-- Проверка, является ли игрок админом
local function isAdmin(player)
	for _, id in ipairs(ADMIN_IDS) do
		if player.UserId == id then
			return true
		end
	end
	return false
end

-- Создаём GUI для админа
local function createAdminPanel(player)
	local playerGui = player:WaitForChild("PlayerGui")

	-- Удаляем старую панель, если есть
	if playerGui:FindFirstChild("AdminBanPanel") then
		playerGui.AdminBanPanel:Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "AdminBanPanel"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 320, 0, 180)
	frame.Position = UDim2.new(0.5, -160, 0.3, 0)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BorderSizePixel = 0
	frame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = frame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	title.Text = "Панель бана"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.Parent = frame

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 10)
	titleCorner.Parent = title

	local textBox = Instance.new("TextBox")
	textBox.Size = UDim2.new(0.9, 0, 0, 35)
	textBox.Position = UDim2.new(0.05, 0, 0.35, 0)
	textBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	textBox.PlaceholderText = "Ник игрока..."
	textBox.Text = ""
	textBox.Font = Enum.Font.Gotham
	textBox.TextSize = 16
	textBox.ClearTextOnFocus = false
	textBox.Parent = frame

	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 6)
	boxCorner.Parent = textBox

	local banButton = Instance.new("TextButton")
	banButton.Size = UDim2.new(0.9, 0, 0, 40)
	banButton.Position = UDim2.new(0.05, 0, 0.65, 0)
	banButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
	banButton.Text = "Забанить навсегда"
	banButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	banButton.Font = Enum.Font.GothamBold
	banButton.TextSize = 16
	banButton.Parent = frame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = banButton

	-- Нажатие кнопки
	banButton.MouseButton1Click:Connect(function()
		local username = textBox.Text
		if username and username ~= "" then
			banRemote:FireServer(username)
			textBox.Text = ""
			banButton.Text = "Отправлено..."
			task.wait(1.5)
			banButton.Text = "Забанить навсегда"
		end
	end)
end

-- Когда игрок заходит
Players.PlayerAdded:Connect(function(player)
	if isAdmin(player) then
		-- Ждём PlayerGui
		player.CharacterAdded:Connect(function()
			task.wait(1)
			createAdminPanel(player)
		end)

		-- На случай если персонаж уже есть
		if player.Character then
			task.wait(1)
			createAdminPanel(player)
		end
	end
end)

-- Обработка бана на сервере
banRemote.OnServerEvent:Connect(function(player, username)
	-- Проверяем, что это админ
	if not isAdmin(player) then
		warn(player.Name .. " попытался использовать панель бана без прав!")
		return
	end

	if typeof(username) ~= "string" or username == "" then
		return
	end

	-- Получаем UserId по нику
	local success, userId = pcall(function()
		return Players:GetUserIdFromNameAsync(username)
	end)

	if not success or not userId then
		warn("Не удалось найти игрока: " .. username)
		return
	end

	-- Баним навсегда
	local banConfig = {
		UserIds = {userId},
		Duration = -1, -- -1 = навсегда
		DisplayReason = BAN_REASON,
		PrivateReason = BAN_REASON,
		ExcludeAltAccounts = false, -- false = банит и альты
		ApplyToUniverse = true
	}

	local banSuccess, banError = pcall(function()
		Players:BanAsync(banConfig)
	end)

	if banSuccess then
		print(player.Name .. " забанил игрока " .. username .. " (ID: " .. userId .. ") навсегда. Причина: " .. BAN_REASON)
	else
		warn("Ошибка бана: " .. tostring(banError))
	end
end)
