extends CanvasLayer

var is_open: bool = false
@onready var panel: Panel = $Panel

func _ready() -> void:
	panel.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_open:
			close_menu()
		else:
			open_menu()



func _on_resume_pressed() -> void:
	close_menu()


func _on_quit_to_menu_pressed() -> void:
	GlobalWorldEnvironment.environment.adjustment_brightness = 1.0
	MenuManager.register_menu_close()
	get_tree().change_scene_to_file("res://Menus/main menu.tscn")


func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_save_pressed() -> void:
	SaveManager.save_game()
	ToastManager.show_toast("Game Saved")

func open_menu() -> void:
	if MenuManager.is_any_menu_open:
		return 
	
	panel.show()
	is_open = true
	
	MenuManager.register_menu_open()

func close_menu() -> void:
	panel.hide()
	is_open = false
	
	MenuManager.register_menu_close()
