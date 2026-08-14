--- Services ---
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const UserInputService = game:GetService("UserInputService")

--- Variables ---
const Store = require(ReplicatedStorage.shared.Features.Toast.Store)

--- Variables ---
const SonnerController = {}

--- Startup Methods ---
function SonnerController:start()
	UserInputService.InputBegan:Connect(function(input: InputObject)
		if input.KeyCode == Enum.KeyCode.E then
			Store.message("Sonner", {
				description = "An opinionated toast component for Vide.",
			})
		elseif input.KeyCode == Enum.KeyCode.Q then
			Store.dismiss()
		end
	end)
end

return SonnerController
