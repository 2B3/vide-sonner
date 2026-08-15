--- Services ---
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--- Folders ---
const packages = ReplicatedStorage.Packages

--- Requires ---
const Sonner = require(packages.Sonner)
const Vide = require(packages.Vide)

--- Variables ---
const create = Vide.create
const Toaster = Sonner.Toaster

--- Component ---
const function App()
	return create("ScreenGui")({
		Toaster({
			gap = 8,
			maxVisible = 4,
		}),
	})
end

return App
