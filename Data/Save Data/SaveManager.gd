extends Node

const SAVE_FILENAME := "savegame.json"
const SAVE_VERSION := 1

signal load_completed
signal data_changed

var dirty: bool = false

func _ready() -> void:
	load_game()

func mark_dirty() -> void:
	dirty = true
	data_changed.emit()

func get_save_path() -> String:
	if OS.has_feature("editor"):
		return "user://" + SAVE_FILENAME
	else:
		# exported build — save next to the .exe
		var exe_dir := OS.get_executable_path().get_base_dir()
		return exe_dir.path_join(SAVE_FILENAME)

func save_game() -> void:
	var save_data := {
		"version": SAVE_VERSION,
		"photo_counts": FishBook.photo_counts,
		"money": Constants.money,
		"upgrade_level": Constants.upgrade_level,
		"max_depth": Constants.max_depth,
		"speed2": Constants.speed2,
	}
	var file := FileAccess.open(get_save_path(), FileAccess.WRITE)
	if file == null:
		push_error("SaveManager: failed to open save file (%s)" % FileAccess.get_open_error())
		return
	file.store_string(JSON.stringify(save_data, "\t"))
	file.close()
	dirty = false
	data_changed.emit()

func load_game() -> void:
	if not FileAccess.file_exists(get_save_path()):
		load_completed.emit() # let listeners init default state
		return

	var file := FileAccess.open(get_save_path(), FileAccess.READ)
	if file == null:
		push_error("SaveManager: failed to open save file (%s)" % FileAccess.get_open_error())
		return

	var text := file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(text)
	if parsed == null or typeof(parsed) != TYPE_DICTIONARY:
		push_error("SaveManager: save file corrupt, keeping defaults")
		load_completed.emit()
		return

	FishBook.load_data({
		"photo_counts": parsed.get("photo_counts", {}),
		"money": parsed.get("money", 0)
	})
	Constants.upgrade_level = parsed.get("upgrade_level", 0)
	Constants.max_depth = parsed.get("max_depth", Constants.max_depth)
	Constants.speed2 = parsed.get("speed2", Constants.speed2)

	load_completed.emit()

func has_save() -> bool:
	return FileAccess.file_exists(get_save_path())

func delete_save() -> void:
	if FileAccess.file_exists(get_save_path()):
		DirAccess.remove_absolute(get_save_path())
	_reset_runtime_state()

func _reset_runtime_state() -> void:
	FishBook.photo_counts = {}
	Constants.money = 0
	Constants.upgrade_level = 0
	Constants.max_depth = Constants.DEFAULT_MAX_DEPTH
	Constants.speed2 = Constants.DEFAULT_SPEED2
	Constants.Player = Constants.DefultPlayer
