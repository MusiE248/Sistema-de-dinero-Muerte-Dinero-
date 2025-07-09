----[ Este Codigo va dentro de un Script y va dentro del SeverScriptService ]----


local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local CashFolder = ServerStorage:WaitForChild("Cash_Player")
local CashModel = CashFolder:WaitForChild("Cash")
local DropContainer = Workspace:WaitForChild("Data_Cash")

local function getKiller(humanoid)
	local tag = humanoid:FindFirstChild("creator")
	if tag and tag.Value and tag.Value:IsA("Player") then
		return tag.Value
	end
end

local function dropCash(position, totalAmount, ownerId)
	local count = math.random(1, 5)
	local base = math.floor(totalAmount / count)
	local extra = totalAmount % count

	for i = 1, count do
		local bill = CashModel:Clone()
		local value = base
		if extra > 0 then
			value += 1
			extra -= 1
		end

		bill:SetAttribute("CashValue", value)
		bill:SetAttribute("Owner", ownerId)
		bill:SetAttribute("ProtectUntil", os.time() + 6)

		local gui = bill:FindFirstChild("BillboardGui")
		local label = gui and gui:FindFirstChild("ValueLabel")
		if label then
			label.Text = tostring(value)
		end

		bill.Anchored = false
		bill.CanCollide = true
		bill.Position = position + Vector3.new(math.random(-3, 3), 2, math.random(-3, 3))
		bill.Parent = DropContainer
		task.delay(60, function()
			if bill and bill.Parent then
				bill:Destroy()
			end
		end)
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		local rootPart = character:WaitForChild("HumanoidRootPart")

		humanoid.Died:Connect(function()
			local killer = getKiller(humanoid)

			if killer and killer ~= player then
				local cashValue = math.random(10, 400)
				local stats = player:FindFirstChild("leaderstats")
				local cash = stats and stats:FindFirstChild("Cash")

				if cash then
					if cashValue > cash.Value then
						cashValue = cash.Value
					end

					cash.Value -= cashValue
					dropCash(rootPart.Position, cashValue, player.UserId)
				end
			end
		end)
	end)
end)
