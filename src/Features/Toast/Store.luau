--- Services ---
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--- Folders ---
const packages = ReplicatedStorage.Packages

--- Requires---
const Promise = require(packages.Promise)
const Reflex = require(packages.Reflex)
const Types = require(script.Parent.Types)

--- Variables ---
const initialState = {
	suscribers = {},
	toasts = {},
	dismissedToasts = {},
}

local toastCounter = 0
local Store: ToastStore

--- Types ---
export type ToastStore = Reflex.Producer<State, Actions>

export type State = {
	suscribers: { Types.ToastT },
	toasts: { Types.ToastT },
	dismissedToasts: { [string | number]: boolean },
}

export type Actions = {
	addToast: (data: Types.ToastT) -> (),
	create: (data: Types.ToastT & { message: string?, type: Types.ToastType?, promise: Promise.Class? }) -> (),
	dismiss: (id: number | string?) -> (),

	message: (message: string, data: Types.ToastT) -> (),
	error: (message: string, data: Types.ToastT) -> (),
	sucess: (message: string, data: Types.ToastT) -> (),
	info: (message: string, data: Types.ToastT) -> (),
	warning: (message: string, data: Types.ToastT) -> (),
	loading: (message: string, data: Types.ToastT) -> (),
	promise: (promise: Promise.Class, data: Types.ToastT) -> (),
}

--- Utils ---
const function find<T>(array: { T }, predicate: (T) -> boolean): T?
	for _, value in array do
		if predicate(value) then
			return value
		end
	end

	return nil
end

const function resolveToastWithType(message: string?, data: Types.ToastT?, type: Types.ToastType)
	const toast = table.clone(data or {})

	toast.message = message
	toast.type = type

	return toast
end

local function createToast(
	state: State,
	data: Types.ToastT & {
		message: string?,
		type: Types.ToastType?,
		promise: Promise.Class?,
	}
): State
	const message = data.message
	const rest = table.clone(data)

	rest.message = nil

	const hasStringId = typeof(data.id) == "string" and data.id:len() > 0

	const id: number | string = (function()
		if hasStringId then
			return data.id
		end

		toastCounter += 1
		return toastCounter
	end)()

	const alreadyExists = find(state.toasts, function(toast)
		return toast.id == id
	end)

	const dismissible = data.dismissible ~= false

	const newState = table.clone(state)

	if state.dismissedToasts[id] then
		newState.dismissedToasts[id] = nil
	end

	if alreadyExists then
		for _, toast in state.toasts do
			if toast.id == id then
				const updatedToast = table.clone(toast)

				for key, value in data do
					updatedToast[key] = value
				end

				updatedToast.id = id
				updatedToast.dismissible = dismissible
				updatedToast.title = message

				const index = table.find(newState.toasts, toast)

				if index then
					newState.toasts[index] = updatedToast
				end

				break
			end
		end
	else
		local newToast = table.clone(rest)

		newToast.id = id
		newToast.title = message
		newToast.dismissible = dismissible

		table.insert(newState.toasts, newToast)
	end

	return newState
end

Store = Reflex.createProducer(initialState, {
	create = function(
		state: State,
		data: Types.ToastT & { message: string?, type: Types.ToastType?, promise: Promise.Class? }
	)
		return createToast(state, data)
	end,

	addToast = function(state: State, data: Types.ToastT)
		const newState = table.clone(state)

		table.insert(newState.toasts, data)

		return newState
	end,

	dismiss = function(state: State, id: number | string?)
		const newState = table.clone(state)

		if id then
			newState.dismissedToasts[id] = true
		else
			for _, toast in state.toasts do
				newState.dismissedToasts[toast.id] = true
			end
		end

		return newState
	end,

	remove = function(state: State, id: number | string?)
		const newState = table.clone(state)

		for i, toast in newState.toasts do
			if toast.id == id then
				table.remove(newState.toasts, i)
				newState.dismissedToasts[id] = nil

				break
			end
		end

		return newState
	end,

	message = function(state: State, message: string, data: Types.ToastT)
		return createToast(state, resolveToastWithType(message, data, nil))
	end,

	error = function(state: State, message: string, data: Types.ToastT)
		return createToast(state, resolveToastWithType(message, data, "error"))
	end,

	success = function(state: State, message: string, data: Types.ToastT)
		return createToast(state, resolveToastWithType(message, data, "success"))
	end,

	info = function(state: State, message: string, data: Types.ToastT)
		return createToast(state, resolveToastWithType(message, data, "info"))
	end,

	warning = function(state: State, message: string, data: Types.ToastT)
		return createToast(state, resolveToastWithType(message, data, "warning"))
	end,

	loading = function(state: State, message: string, data: Types.ToastT)
		return createToast(state, resolveToastWithType(message, data, "loading"))
	end,
}) :: ToastStore

return Store
