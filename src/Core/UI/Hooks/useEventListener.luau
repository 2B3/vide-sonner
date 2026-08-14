--- Services ---
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--- Folders ---
const packages = ReplicatedStorage.Packages

--- Requires ---
const Vide = require(packages.Vide)

--- Variables ---
const cleanup = Vide.cleanup

--- Hook ---
const function useEventListener<T>(event: RBXScriptSignal<T>, callback: (T) -> ()): ()
	cleanup(event:Connect(callback))
end

return useEventListener
