# Toast.gd — attach to the Toast scene root
extends Control

@onready var label: Label = $VBoxContainer/Label

func show_message(text: String, duration: float = 1.0) -> void:
	label.text = text
	modulate.a = 0.0
	show()

	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.2)   # fade in
	tween.tween_interval(duration)
	tween.tween_property(self, "modulate:a", 0.0, 0.4)   # fade out
	tween.tween_callback(queue_free)
