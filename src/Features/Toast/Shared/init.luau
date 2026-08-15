--- Requires ---
const Store = require(script.Store)
const Toaster = require(script.UI.Components.Toaster)

--- Variables ---
const Toast = {}
Toast.__index = Toast

--- Methods ---
Toast.Toaster = Toaster

Toast.__call = function(...)
	const _, message, data = ...
	Store.message(message, data)
end

Toast.message = Store.message
Toast.error = Store.error
Toast.success = Store.success
Toast.info = Store.info
Toast.warning = Store.warning

return setmetatable({}, Toast)
