extends Node

# Tracks if ANY menu scene is currently open anywhere in the game
var is_any_menu_open: bool = false

func _ready() -> void:
	register_menu_close()

# Call this when a menu successfully opens
func register_menu_open() -> void:
	is_any_menu_open = true

# Call this when a menu closes
func register_menu_close() -> void:
	is_any_menu_open = false
