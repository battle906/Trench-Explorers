extends Node2D

#Variables 
@onready var player: CharacterBody2D = $"player"
@onready var color: Label = $player/CanvasLayer2/Label2
@export var start_depth := 10

@onready var label: Label = $player/CanvasLayer2/Label
@export var scan_range: float = 100
@export var max_angle_deg: float = 25
@export var facing_direction: Vector2 = Vector2.RIGHT


var start_depth_px := start_depth * 50
var label_fixed_x = 0
var input_locked := false

func _process(delta):
	var max_depth_px := Constants.max_depth * 50
	label.global_position.x = 128
	var depth: float = player.global_position.y
	var t: float = clamp((depth - start_depth_px) / (max_depth_px - start_depth_px), 0.0, 1.0)
	GlobalWorldEnvironment.environment.adjustment_brightness = 1.0 - t
	if Input.is_action_just_pressed("photo") and not input_locked:
		show_color()
		input_locked = true
		await get_tree().create_timer(1).timeout
		input_locked = false



func show_color():
	color.show()
	await get_tree().create_timer(0.2).timeout
	color.hide()
	show_label()

func show_label():
	_show_message("Photo Taken!")
	take_photo()

func take_photo():
	var fish_nodes := get_tree().get_nodes_in_group("fish")
	var best_fish: Node2D = null
	var best_dist := scan_range

	var my_pos := player.global_position

	for node in fish_nodes:
		var fish := node as Node2D
		if fish == null:
			continue
		var dist := my_pos.distance_to(fish.global_position)
		if dist < best_dist:
			best_dist = dist
			best_fish = fish

	if best_fish == null:
		_show_message("No fish in frame.")
		return

	_photograph(best_fish)

func _photograph(fish: Node) -> void:
	var was_new := FishBook.add_photo(fish)
	if not was_new:
		_show_message(fish.data.display_name + " — already fully documented.")
		return

	var count := FishBook.get_count(fish.data.fish_id)
	var reward: int = Constants.TIER_MONEY[fish.data.tier]
	_show_message("%s photographed (%d/%d) — +%d coins" % [
		fish.data.display_name, count, Constants.max_photos, reward
	])

func _show_message(text: String) -> void:
	ToastManager.show_toast(text)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if SaveManager.dirty:
			# show your confirm dialog here instead, if you have one
			SaveManager.save_game()
		get_tree().quit()
