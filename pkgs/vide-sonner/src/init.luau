--- Requires ---
local Toaster = require(script.UI.Components.Toaster)
local Store = require(script.Store)

--- Variables ---
local Toast = {}
Toast.__index = Toast

--- Methods ---
Toast.Toaster = Toaster

Toast.__call = function(...)
	local _, message, data = ...
	Store.message(message, data)
end

Toast.message = Store.message
Toast.error = Store.error
Toast.success = Store.success
Toast.info = Store.info
Toast.warning = Store.warning

return setmetatable({}, Toast)
