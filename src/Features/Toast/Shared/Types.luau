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
	toast: ToastT,
	index: number,

	expanded: boolean,

	gap: number,

	getOffset: (toastId: number | string) -> number,
	setHeight: (toastId: number | string, height: number) -> (),
	removeHeight: (toastId: number | string) -> (),

	removeToast: (toast: ToastT) -> (),
}

export type ToasterProps = {
	gap: number?,
	duration: number?,
	maxVisible: number?,
}

return {}
