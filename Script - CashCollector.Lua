----[ Este Codigo va dentro de un Script y va dentro del SeverScriptService ]----

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local function connectCashTouch(cash)

	local collected = false

	if not cash:IsA("BasePart") then return end
	cash.CanTouch = true 

	cash.Touched:Connect(function(hit)
		if collected then return end

		local character = hit.Parent
		if not character then return end

		local player = Players:GetPlayerFromCharacter(character)
		if not player then return end

		local leaderstats = player:FindFirstChild("leaderstats")
		local cashStat = leaderstats and leaderstats:FindFirstChild("Cash")
		if not cashStat then return end

		local value = cash:GetAttribute("CashValue")
		if not value then return end

		local ownerId = cash:GetAttribute("Owner")
		local protectUntil = cash:GetAttribute("ProtectUntil")

		if player.UserId == ownerId and os.time() < protectUntil then
			return
		end

		cashStat.Value += value
		collected = true
		cash:Destroy()
	end)
end

Workspace.ChildAdded:Connect(function(child)
	if child:IsA("Folder") and child.Name == "Data_Cash" then
		child.ChildAdded:Connect(connectCashTouch)
	else
		if child:IsA("BasePart") and child.Name == "Cash" then
			connectCashTouch(child)
		end
	end
end)

local dropContainer = Workspace:FindFirstChild("Data_Cash")
if dropContainer then
	for _, item in pairs(dropContainer:GetChildren()) do
		if item:IsA("BasePart") and item.Name == "Cash" then
			connectCashTouch(item)
		end
	end

	dropContainer.ChildAdded:Connect(function(child)
		if child:IsA("BasePart") and child.Name == "Cash" then
			connectCashTouch(child)
		end
	end)
end
