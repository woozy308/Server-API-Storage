-- Note: this script should be placed in ServerScriptStorage, it also does not need to be a Local script either --
local DataStoreService = game:GetService("DataStoreService")
local playerInventoryData = DataStoreService:GetDataStore("PlayerInventory") -- creating a unique name
local ServerStorage = game:GetService("ServerStorage")

game.Players.PlayerRemoving:Connect(function(player)
	local itemsToSave = {}
	for _, item in pairs(player.Backpack:GetChildren()) do
		if item:IsA("Tool") then
			table.insert(itemsToSave, item.Name)
		end
	end
	-- Save the table using the player's UserID as the key
	playerInventoryData:SetAsync(player.UserId, itemsToSave)
end)

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		-- Give a small delay to ensure character and backpack are ready
		wait(0.1)
		local success, data = pcall(function()
			return playerInventoryData:GetAsync(player.UserId)
		end)

		if success and data then -- If data was retrieved successfully
			for _, itemName in pairs(data) do
				local toolTemplate = ServerStorage.InventorySaving:FindFirstChild(itemName) -- change "InventorSaving" to the tool folder name in ServerStorage --
				if toolTemplate then
					local newTool = toolTemplate:Clone()
					newTool.Parent = player.Backpack
				end
			end
		end
	end)
end)
