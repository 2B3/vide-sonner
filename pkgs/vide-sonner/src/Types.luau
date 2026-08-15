export type ToastType = "normal" | "success" | "info" | "warning" | "error" | "loading"

export type ToastT = {
	id: number | string,

	title: string?,
	description: string?,
	type: ToastType,

	duration: number,
	dismissible: boolean,
}

export type ToastProps = {
	toast: () -> ToastT,
	index: () -> number,

	maxToasts: () -> number,
	expanded: () -> boolean,
	offset: () -> number,
	toasts: () -> { ToastT },

	setHeight: (toastId: number | string, height: number) -> (),
	removeHeight: (toastId: number | string) -> (),

	removeToast: (toast: ToastT) -> (),
}

export type ToasterProps = {
	maxVisible: () -> number | number?,
	gap: () -> number | number?,
}

return {}
