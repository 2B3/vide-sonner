--- Services ---
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const Players = game:GetService("Players")

--- Folders ---
const packages = ReplicatedStorage.Packages

--- Player ---
const localPlayer = Players.LocalPlayer

--- Requires ---
const useEventListener = require("@self/useEventListener")
const Vide = require(packages.Vide)

--- Hook ---
const function useCharacter(): Vide.Source<Model?>
	const character = Vide.source(localPlayer.Character)

	useEventListener(localPlayer.CharacterAdded, character)

	useEventListener(localPlayer.CharacterRemoving, function()
		character(nil)
	end)

	return character
end

return useCharacter
