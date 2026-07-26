local HttpService = game:GetService("HttpService")

-- URL на сырое содержимое файла GitHub
local SCRIPT_URL = "https://raw.githubusercontent.com/agentasc003-max/Agent/main/Agent.003.lua"

-- Функция для загрузки скрипта через HTTPS
local function fetchAndLoadScript()
	local success, response = pcall(function()
		return HttpService:GetAsync(SCRIPT_URL)
	end)

	if success then
		print("✅ Скрипт успешно загружен!")
		print("=" .. string.rep("=", 60) .. "=")
		print(response)
		print("=" .. string.rep("=", 60) .. "=")
		
		-- Выполняем загруженный скрипт
		local loadSuccess, loadError = pcall(function()
			loadstring(response)()
		end)

		if loadSuccess then
			print("✅ Скрипт успешно выполнен!")
		else
			warn("❌ Ошибка при выполнении скрипта: " .. tostring(loadError))
		end
	else
		warn("❌ Ошибка загрузки: " .. tostring(response))
	end
end

-- Запускаем загрузку
fetchAndLoadScript()
