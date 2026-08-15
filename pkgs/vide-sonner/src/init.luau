--- Requires ---
local Toaster = require(script.UI.Components.Toaster)
local Store = require(script.Store)
const Types = require(script.Types)

--- Types ---
export type ToastT = Types.ToastT
export type ToastType = Types.ToastType
export type ToastProps = Types.ToastProps
export type ToasterProps = Types.ToasterProps

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
