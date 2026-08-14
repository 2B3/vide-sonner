const ReplicatedStorage = game:GetService("ReplicatedStorage")

--- Folders ---
const features = ReplicatedStorage.shared.Features
const packages = ReplicatedStorage.Packages

--- Requires ---
const Toast = require(script.Parent.Toast)
const Store = require(features.Toast.Store)
const Types = require(features.Toast.Types)
const Vide = require(packages.Vide)

--- Variables ---
const values = Vide.values
const source = Vide.source
const effect = Vide.effect
const create = Vide.create
const chanded = Vide.changed
const read = Vide.read

const GAP = 8

--- Component ---
const function Toaster()
	const heights = source({}) :: Vide.Source<{ [number | string]: number }>
	const expanded = source(true)

	const toastStore = source(Store:getState())
	effect(function()
		return Store:subscribe(function(state)
			return state
		end, function(state)
			toastStore(state)
		end)
	end)

	const function setHeight(id: number | string, height: number)
		const current = table.clone(read(heights))
		current[id] = height

		heights(current)
	end

	const function getOffset(index: number)
		const currentHeights = read(heights)
		const toasts = read(toastStore).toasts

		local offset = 0

		for i = 1, index - 1 do
			const height = currentHeights[toasts[i].id]

			if height then
				offset += height + GAP
			end
		end

		return offset
	end

	return create("Frame")({
		Name = "Toaster",

		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,

		create("Frame")({
			Name = "Toasts",

			BackgroundColor3 = Color3.fromHex("ff8800"),
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.one,

			create("UIPadding")({
				PaddingBottom = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 4),
				PaddingLeft = UDim.new(0, 8),
				PaddingTop = UDim.new(0, 8),
			}),

			chanded("GuiState", function(state: Enum.GuiState)
				expanded(state ~= Enum.GuiState.Idle)
			end),

			values(function()
				return read(toastStore).toasts
			end, function(toast: () -> Types.ToastT, index: number)
				return Toast({
					toast = toast,
					index = index,

					expanded = expanded,
					maxToasts = 3,

					setHeight = setHeight,

					offset = function()
						return getOffset(read(index))
					end,

					toasts = function()
						return read(toastStore).toasts
					end,

					removeToast = function(removedToast: Types.ToastT)
						Store.remove(removedToast.id)
					end,
				})
			end),
		}),
	})
end

return Toaster
