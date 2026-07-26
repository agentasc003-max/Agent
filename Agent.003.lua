-- Agent.003 - Серверный скрипт спавна для Roblox Studio

local SpawnManager = {}
SpawnManager.spawnPoints = {}
SpawnManager.spawnedObjects = {}

local CONFIG = {
	spawnInterval = 5,
	maxObjects = 20,
	objectSize = Vector3.new(1, 1, 1),
	objectColor = Color3.fromRGB(0, 100, 255)
}

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
	newObject.Parent = workspace
	table.insert(SpawnManager.spawnedObjects, newObject)
	return newObject
end

local function spawnRandomObject()
	if #SpawnManager.spawnedObjects >= CONFIG.maxObjects then
		SpawnManager.spawnedObjects[1]:Destroy()
		table.remove(SpawnManager.spawnedObjects, 1)
	end
	local randomX = math.random(-50, 50)
	local randomY = 10
	local randomZ = math.random(-50, 50)
	createObject(Vector3.new(randomX, randomY, randomZ))
end

print("Agent.003 запущен!")
while true do
	wait(CONFIG.spawnInterval)
	spawnRandomObject()
	print("Объектов на карте: " .. #SpawnManager.spawnedObjects)
end
