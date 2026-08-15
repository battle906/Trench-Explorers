
extends CanvasLayer

const Debug := preload("res://Menus/debug.tscn")

var active_toasts: Array[Control] = []
const TOAST_SPACING := 20
const MAX_VISIBLE := 5

func show_debug(text: String, duration: float = 1.0) -> void:
	var debug_toast: Control = Debug.instantiate()
	add_child(debug_toast)

	# stack new toasts above older ones
	debug_toast.position = Vector2(20, 20 + active_toasts.size() * TOAST_SPACING)
	active_toasts.append(debug_toast)

	debug_toast.debug_message(text, duration)
	debug_toast.tree_exiting.connect(func(): active_toasts.erase(debug_toast))

	if active_toasts.size() > MAX_VISIBLE:
		var oldest: Control = active_toasts[0]
		oldest.queue_free()
