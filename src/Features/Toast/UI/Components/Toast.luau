const ReplicatedStorage = game:GetService("ReplicatedStorage")

--- Folders ---
const features = ReplicatedStorage.shared.Features
const packages = ReplicatedStorage.Packages

--- Requires ---
const Ripple = require(packages.Ripple)
const Types = require(features.Toast.Types)
const Vide = require(packages.Vide)

--- Variables ---
const useSpring = Ripple.useSpring
const create = Vide.create
const effect = Vide.effect
const changed = Vide.changed
const show = Vide.show
const read = Vide.read
const source = Vide.source
const action = Vide.action

const SWIPE_THRESHOLD = 0.3

const TIME_BEFORE_UNMOUNT = 0.2
const TOAST_LIFETIME = 4

--- Utils ---
const function MoveDragger(
	progressPercent: (number?) -> number | number,
	sliderAbsSize: (Vector2?) -> Vector2 | Vector2,
	mousePosX: (number?) -> number | number
)
	local dragStartMouseX = 0
	local dragStartProgress = 0

	const function start(x: number)
		dragStartMouseX = x
		dragStartProgress = read(progressPercent) or 0
	end

	const function move(x: number?)
		const sliderAbsWidth = (read(sliderAbsSize) or Vector2.zero).X

		if sliderAbsWidth <= 0 then
			return
		end

		const currentMouseX = x or read(mousePosX) or dragStartMouseX
		const delta = (currentMouseX - dragStartMouseX) / sliderAbsWidth

		progressPercent(math.clamp(dragStartProgress + delta, 0, 1))
	end

	return start, move
end

--- Component ---
const function Toast(props: Types.ToastProps)
	const function onAbsSizeChanged(newSize: Vector2)
		local height = newSize.Y

		if height <= 0 then
			return
		end

		props.setHeight(read(props.toast).id, height)
	end

	const function isVisible()
		return (#read(props.toasts) - read(props.index)) < props.maxToasts
	end

	const removed = source(false)
	const function deleteToast()
		if read(removed) then
			return
		end

		removed(true)

		task.delay(TIME_BEFORE_UNMOUNT, function()
			props.removeToast(read(props.toast))
		end)
	end
	task.delay(TOAST_LIFETIME, deleteToast)

	const swiping = source(false)
	const swipeOut = source(false)

	const progressPercent = source(0)
	const toastAbsSize = source(0)
	const toastAbsPos = source(0)
	const mousePosX = source(0)

	const startDragging, moveDragger = MoveDragger(progressPercent, toastAbsSize, mousePosX)

	const progressSmooth, progressSmoothSpring = useSpring(progressPercent(), Ripple.config.stiff)
	effect(function()
		const currentProgressPercent = read(progressPercent)
		progressSmoothSpring:setGoal(currentProgressPercent)
	end)

	const function stopDragging()
		if not read(swiping) then
			return
		end

		const currentPercent = read(progressPercent)

		mousePosX(0)
		moveDragger(0)
		swiping(false)

		if read(removed) or currentPercent <= SWIPE_THRESHOLD then
			return
		end

		swipeOut(true)
		deleteToast()
	end

	const getOffset, offsetSpring = useSpring(0, Ripple.config.stiff)
	const getScale, scaleSpring = useSpring(0.6, Ripple.config.stiff)

	const getAnchor, anchorSpring = useSpring(Vector2.new(0.5, 0), Ripple.config.stiff)
	const getPosition, positionSpring = useSpring(UDim2.fromScale(0.5, 1), Ripple.config.stiff)

	positionSpring:setGoal(UDim2.fromScale(0.5, 0.5))
	anchorSpring:setGoal(Vector2.one * 0.5)

	effect(function()
		anchorSpring:setGoal(read(swipeOut) and Vector2.new(0, 0.5) or Vector2.one * 0.5)
		positionSpring:setGoal(read(swipeOut) and UDim2.fromScale(1, 0.5) or UDim2.fromScale(0.5, 0.5))

		const scale = if read(swipeOut)
			then 1
			elseif read(removed) then 0
			elseif isVisible() and read(props.expanded) then 1
			elseif isVisible() then 1 - (#read(props.toasts) - read(props.index)) * 0.05
			else 0

		offsetSpring:setGoal(
			if read(removed) and not read(swipeOut)
				then 0
				elseif read(props.expanded) then read(props.offset)
				else read(props.offset) * 0.08 + 16
		)

		scaleSpring:setGoal(scale)
	end)

	return show(isVisible, function()
		return create("TextLabel")({
			Name = function()
				return "Toast " .. read(props.toast).id .. (read(removed) and " Removed" or "")
			end,

			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromOffset(356, 0),
			BackgroundTransparency = 1,

			ZIndex = function()
				return read(props.index) - #read(props.toasts)
			end,

			Position = function()
				return UDim2.fromOffset(0, getOffset())
			end,

			create("UIPadding")({
				PaddingBottom = UDim.new(0, 16),
				PaddingRight = UDim.new(0, 16),
				PaddingLeft = UDim.new(0, 16),
				PaddingTop = UDim.new(0, 16),
			}),

			create("TextButton")({
				Name = "Content",
				Text = "",

				BackgroundColor3 = Color3.fromHex("eeeeee"),
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0),
				Position = getPosition,
				AnchorPoint = function()
					return getAnchor() + Vector2.xAxis * -read(progressSmooth)
				end,

				MouseMoved = function(x)
					if not read(swiping) then
						return
					end

					mousePosX(x)
					moveDragger(x)
				end,

				MouseButton1Down = function(x: number)
					startDragging(x)
					swiping(true)
				end,

				MouseButton1Up = stopDragging,
				MouseLeave = stopDragging,

				action(function(ref: TextButton)
					toastAbsPos(ref.AbsolutePosition)
					toastAbsSize(ref.AbsoluteSize)
				end),

				changed("AbsolutePosition", toastAbsPos),
				changed("AbsoluteSize", toastAbsSize),

				changed("AbsoluteSize", onAbsSizeChanged),

				create("UIPadding")({
					PaddingBottom = UDim.new(0, 16),
					PaddingRight = UDim.new(0, 16),
					PaddingLeft = UDim.new(0, 16),
					PaddingTop = UDim.new(0, 16),
				}),

				create("UIListLayout")({
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, 4),
				}),

				create("UIShadow")({
					BlurRadius = UDim.new(0, 16),
					Transparency = 0.8,
				}),

				create("UIStroke")({
					BorderStrokePosition = Enum.BorderStrokePosition.Center,
					Color = Color3.fromHex("#a4a4a4"),
				}),

				create("UIScale")({
					Scale = getScale,
				}),

				create("UICorner")({
					CornerRadius = UDim.new(0, 8),
				}),

				create("TextLabel")({
					Name = "Title",

					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = function()
						return read(props.toast).title or ""
					end,
					BackgroundTransparency = 1,
					TextSize = 14,

					FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium),
					TextColor3 = Color3.fromHex("121212"),
				}),

				show(function()
					return read(props.toast).description
				end, function(description: () -> string)
					return create("TextLabel")({
						Name = "Description",

						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 1,
						Text = description or "",
						TextWrapped = true,
						TextSize = 14,

						FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular),
						TextColor3 = Color3.fromHex("121212"),
					})
				end),
			}),
		})
	end)
end

return Toast
