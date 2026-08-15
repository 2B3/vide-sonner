--- Folders ---
const features = script.Parent.Parent.Parent
const packages = script.Parent.Parent.Parent.Parent.roblox_packages

--- Requires ---
const Toast = require(script.Parent.Toast)
const Store = require(features.Store)
const Types = require(features.Types)
const Vide = require(packages.Vide)

--- Variables ---
const values = Vide.values
const source = Vide.source
const effect = Vide.effect
const create = Vide.create
const chanded = Vide.changed
const read = Vide.read

--- Component ---
const function Toaster(props: Types.ToasterProps)
	--> Default Props <--
	props.maxVisible = props.maxVisible or 3
	props.gap = props.gap or 8

	--> Toast State <--
	const toastStore = source(Store:getState())

	effect(function()
		return Store:subscribe(function(state)
			return state
		end, function(state)
			toastStore(state)
		end)
	end)

	--> Heights <--
	const heights = source({}) :: Vide.Source<{ [number | string]: number }>
	const expanded = source(true)

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
				offset += height + read(props.gap)
			end
		end

		return offset
	end

	return create("Frame")({
		Name = "Toaster",

		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,

		--> ToastList <--
		create("Frame")({
			Name = "ToastsList",

			BackgroundColor3 = Color3.fromHex("ff8800"),
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.one,
			BorderColor3 = Color3.fromHex("ff6600"),
			BorderSizePixel = 1,

			create("UIPadding")({
				PaddingBottom = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 4),
				PaddingLeft = UDim.new(0, 8),
				PaddingTop = UDim.new(0, 8),
			}),

			chanded("GuiState", function(state: Enum.GuiState)
				expanded(state ~= Enum.GuiState.Idle)
			end),

			--> Toasts <--
			values(function()
				return read(toastStore).toasts
			end, function(toast: () -> Types.ToastT, index: () -> number)
				return Toast({
					toast = toast,
					index = index,

					maxToasts = props.maxVisible,
					setHeight = setHeight,
					expanded = expanded,

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
