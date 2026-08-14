--!strict

--- Services ---
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const Players = game:GetService("Players")

--- Folders ---
const packages = ReplicatedStorage.Packages
const shared = ReplicatedStorage.shared
const core = shared.Core

--- Requires ---
const App = require(core.UI.App)
const Vide = require(packages.Vide)

--- Player ---
const localPlayer = Players.LocalPlayer
const playerGui = localPlayer.PlayerGui

--- Variables ---
const UIController = {}

const mount = Vide.mount

--- Startup Methods ---
function UIController:start()
	mount(App, playerGui)
end

return UIController
