--- Services ---
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--- Folders ---
const packages = ReplicatedStorage.Packages
const features = ReplicatedStorage.shared.Features

--- Requires ---
const Toaster = require(features.Toast.UI.Components.Toaster)
const Vide = require(packages.Vide)

--- Variables ---
const create = Vide.create

--- Component ---
const function App()
	return create("ScreenGui")({
		Toaster({
			offset = 32,
			position = "bottom-left",
		}),
	})
end

return App
