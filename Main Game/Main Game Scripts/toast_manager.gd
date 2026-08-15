# ToastManager.gd — Autoload, named "ToastManager"
extends CanvasLayer

const TOAST_SCENE := preload("res://Menus/toast.tscn")  # adjust path

var active_toasts: Array[Control] = []
const TOAST_SPACING := 60
const MAX_VISIBLE := 5

func show_toast(text: String, duration: float = 2.0) -> void:
	var toast: Control = TOAST_SCENE.instantiate()
	add_child(toast)

	# stack new toasts above older ones
	toast.position = Vector2(20, 20 + active_toasts.size() * TOAST_SPACING)
	active_toasts.append(toast)

	toast.show_message(text, duration)
	toast.tree_exiting.connect(func(): active_toasts.erase(toast))

	if active_toasts.size() > MAX_VISIBLE:
		var oldest: Control = active_toasts[0]
		oldest.queue_free()
