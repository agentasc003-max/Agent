-- Agent.003 - Серверный скрипт для спавна объектов в Roblox Studio
-- Этот скрипт управляет созданием и спавном объектов на карте

local SpawnManager = {}
SpawnManager.spawnPoints = {}
SpawnManager.spawnedObjects = {}

-- Конфигурация
local CONFIG = {
	objectToSpawn = "Part", -- Тип объекта для спавна
	spawnInterval = 5, -- Интервал спавна в секундах
	maxObjects = 20, -- Максимальное количество объектов
	objectSize = Vector3.new(1, 1, 1), -- Размер объекта
	objectColor = Color3.fromRGB(0, 100, 255) -- Цвет объекта (синий)
}

-- Функция для создания объекта
local function createObject(position)
	local newObject = Instance.new("Part")
	newObject.Shape = Enum.PartType.Ball
	newObject.Size = CONFIG.objectSize
	newObject.Color = CONFIG.objectColor
	newObject.Material = Enum.Material.Neon
	newObject.CanCollide = true
	newObject.CFrame = CFrame.new(position)
	newObject.TopSurface = Enum.SurfaceType.Smooth
	newObject.BottomSurface = Enum.SurfaceType.Smooth
	newObject.Name = "SpawnedObject_" .. tostring(#SpawnManager.spawnedObjects + 1)
	
	-- Добавляем физику
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.Parent = newObject
	
	newObject.Parent = workspace
	table.insert(SpawnManager.spawnedObjects, newObject)
	
	return newObject
end

-- Функция для удаления объекта
local function removeObject(object)
	if object and object.Parent then
		object:Destroy()
	end
end

-- Функция для очистки всех объектов
local function clearAllObjects()
	for _, object in ipairs(SpawnManager.spawnedObjects) do
		removeObject(object)
	end
	SpawnManager.spawnedObjects = {}
end

-- Функция для спавна объекта в случайное место
local function spawnRandomObject()
	if #SpawnManager.spawnedObjects >= CONFIG.maxObjects then
		-- Удаляем самый старый объект
		removeObject(SpawnManager.spawnedObjects[1])
		table.remove(SpawnManager.spawnedObjects, 1)
	end
	
	-- Генерируем случайную позицию
	local randomX = math.random(-50, 50)
	local randomY = 10 -- Высота спавна
	local randomZ = math.random(-50, 50)
	local position = Vector3.new(randomX, randomY, randomZ)
	
	createObject(position)
end

-- Функция для спавна объекта в конкретной точке
function SpawnManager:spawnAt(position)
	if #SpawnManager.spawnedObjects < CONFIG.maxObjects then
		createObject(position)
		print("Объект спавнен в позиции: " .. tostring(position))
	else
		print("Достигнут лимит объектов!")
	end
end

-- Функция для изменения конфигурации
function SpawnManager:setConfig(key, value)
	if CONFIG[key] ~= nil then
		CONFIG[key] = value
		print("Конфиг обновлён: " .. key .. " = " .. tostring(value))
	end
end

-- Основной цикл спавна
local function mainLoop()
	print("Agent.003 запущен!")
	
	while true do
		wait(CONFIG.spawnInterval)
		spawnRandomObject()
		print("Объектов на карте: " .. #SpawnManager.spawnedObjects)
	end
end

-- События и команды
local function setupCommands()
	-- Ты можешь добавить сюда команды для управления спавном
	-- Например, через RemoteEvent или RemoteFunction
end

-- Запуск скрипта
setupCommands()
mainLoop()

-- Экспортируем API для управления
return SpawnManager
