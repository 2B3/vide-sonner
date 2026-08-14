--- Services ---
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const Players = game:GetService("Players")

--- player ---
const localPlayer = Players.LocalPlayer

--- Folders ---
const packages = ReplicatedStorage.Packages
const playerScripts = localPlayer.PlayerScripts

--- Requires ---
const Bootstrapper = require(packages.Bootstrapper)

--- Variables ---
const controllers = Bootstrapper.loadDescendants(playerScripts.client, Bootstrapper.byName("Controller$"))

Bootstrapper.run(controllers, "init")
Bootstrapper.runAsync(controllers, "start")
Bootstrapper.bindToRenderStep(controllers, "renderStep")
