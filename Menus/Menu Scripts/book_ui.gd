extends CanvasLayer

@onready var panel: Control = $Panel
@onready var list_container: GridContainer = $Panel/ScrollContainer/GridContainer
@onready var upgrade_panel: CanvasLayer = $"../Upgrade_Panel"

const FISH_DIR := "res://Data/Fish/"

var is_open: bool = false

func _ready() -> void:
	panel.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("info"):
		if is_open:
			close_menu()
		else:
			open_menu()
			populate()
	if OS.is_debug_build() and event.is_action_pressed("debug_max_out_fish"):
		_debug_maxout_all_fish()

func _debug_maxout_all_fish() -> void:
	var all_fish := get_all_fish_data()
	for fish_data in all_fish:
		for i in Constants.max_photos:
			FishBook.debug_add_photo_by_id(fish_data.fish_id, fish_data.tier)
	DebugScript.show_debug("DEBUG: maxed out all fish")
	if is_open:
		populate()

func populate() -> void:
	var all_fish := get_all_fish_data()
	var rows := list_container.get_children()

	for i in range(rows.size()):
		var row = rows[i]
		if i < all_fish.size():
			if row.has_method("setup"):
				row.setup(all_fish[i])
			row.visible = true
		else:
			row.visible = false  # unused editor-placed slot
	await get_tree().process_frame
	list_container.queue_sort()
	list_container.get_parent().queue_sort()  # the ScrollContainer itself

func get_all_fish_data() -> Array[FishData]:
	var results: Array[FishData] = []
	var dir := DirAccess.open(FISH_DIR)
	if dir == null:
		DebugScript.show_debug("ERROR: " + " folder not found")
		return results
	for file_name in dir.get_files():
		if file_name.ends_with(".tres") or file_name.ends_with(".tres.remap"):
			var res_path := FISH_DIR + file_name.trim_suffix(".remap")
			var fish := load(res_path) as FishData
			if fish:
				results.append(fish)
	return results

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
