--- Services ---
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const UserInputService = game:GetService("UserInputService")

--- Folders ---
const packages = ReplicatedStorage.Packages

--- Requires ---
const Sonner = require(packages.Sonner)

--- Variables ---
const ToastController = {}

--- Statup Methods ---
function ToastController:start()
	UserInputService.InputBegan:Connect(function(input: InputObject)
		if input.KeyCode ~= Enum.KeyCode.E then
			return
		end

		Sonner.message("Hello world!")
	end)
end

return ToastController
