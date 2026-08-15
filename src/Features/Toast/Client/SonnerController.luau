--- Services ---
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const UserInputService = game:GetService("UserInputService")

const Toast = require(ReplicatedStorage.shared.Features.Toast)

--- Variables ---

--- Variables ---
const SonnerController = {}

--- Startup Methods ---
function SonnerController:start()
	UserInputService.InputBegan:Connect(function(input: InputObject)
		if input.KeyCode == Enum.KeyCode.I then
			Toast.info("Sonner", {
				description = "Sonner is a toast component for Vide",
			})
		elseif input.KeyCode == Enum.KeyCode.E then
			Toast.error("Fatal error")
		elseif input.KeyCode == Enum.KeyCode.M then
			Toast("Hello world")
		elseif input.KeyCode == Enum.KeyCode.G then
			Toast.message("Hello world", {
				description = "or Goodbye?",
			})
		elseif input.KeyCode == Enum.KeyCode.W then
			Toast.warning("Something failed")
		elseif input.KeyCode == Enum.KeyCode.S then
			Toast.success("Complete the transaction")
		elseif input.KeyCode == Enum.KeyCode.Q then
			Toast.dismiss()
		end
	end)
end

return SonnerController
