----[ Este Codigo va dentro de un Script y va dentro del SeverScriptService ]----

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local CashStore = DataStoreService:GetDataStore("PlayerCash")

local function setupLeaderstats(player, amount)
	local stats = Instance.new("Folder")
	stats.Name = "leaderstats"
	stats.Parent = player

	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Value = amount or 0
	cash.Parent = stats
end

Players.PlayerAdded:Connect(function(player)
	local success, result = pcall(function()
		return CashStore:GetAsync("Cash_" .. player.UserId)
	end)

	if success then
		setupLeaderstats(player, result or 1000)
	else
		warn("Error al cargar dinero de " .. player.Name)
		setupLeaderstats(player, 1000)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	local stats = player:FindFirstChild("leaderstats")
	local cash = stats and stats:FindFirstChild("Cash")
	if not cash then return end

	pcall(function()
		CashStore:SetAsync("Cash_" .. player.UserId, cash.Value)
	end)
end)
