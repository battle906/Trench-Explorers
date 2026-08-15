extends HSlider

@export var bus_name: String = "Master"
@onready var bus_index: int = AudioServer.get_bus_index(bus_name)

func _ready() -> void:
	# Initialize slider position based on current bus volume
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func _on_value_changed(newValue: float) -> void:
	# Convert linear 0-1 slider value to decibels and apply to AudioServer
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(newValue))
