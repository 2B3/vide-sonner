--- Services ---
const ServerScriptService = game:GetService("ServerScriptService")
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--- Folders ---
const packages = ReplicatedStorage.Packages

--- Requires ---
const Bootstrapper = require(packages.Bootstrapper)

--- Variables ---
const services = Bootstrapper.loadDescendants(ServerScriptService.server, Bootstrapper.byName("Service$"))

Bootstrapper.run(services, "init")
Bootstrapper.runAsync(services, "start")
Bootstrapper.bindToHeartbeat(services, "heartbeat")
