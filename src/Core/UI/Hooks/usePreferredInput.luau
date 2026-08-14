--- Services ---
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const UserInputService = game:GetService("UserInputService")

--- Folders ---
const packages = ReplicatedStorage.Packages

--- Requires ---
const useEventListener = require("@self/useEventListener")
const Vide = require(packages.Vide)

--- Hook ---
const function usePreferredInput(): Vide.Source<Enum.PreferredInput>
	const preferredInput = Vide.source(UserInputService.PreferredInput)

	useEventListener(UserInputService:GetPropertyChangedSignal("PreferredInput"), function()
		preferredInput(UserInputService.PreferredInput)
	end)

	return preferredInput
end

return usePreferredInput
