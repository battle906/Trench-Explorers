extends Control

@onready var main_game = preload("res://Main Game/main_game.tscn") as PackedScene
@onready var progress_bar: ProgressBar = $ProgressBar

func _process(delta: float) -> void:
	if progress_bar.value < progress_bar.max_value:
		progress_bar.value += 20 * delta

func _ready() -> void:
	progress_bar.value = 0
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_packed(main_game)
	
