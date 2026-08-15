extends Node2D

@export var fish_entries: Array[FishSpawnEntry]   # each entry pairs a scene with its y-range
@export var spawn_x_min: float = 0.0
@export var spawn_x_max: float = 256.0
@export var spawn_interval: float = 2.0           # seconds between spawns
@export var max_fish: int = 10
@export var autostart: bool = true

var _timer: float = 0.0
var _active_fish: Array[Node] = []

func _ready() -> void:
	_timer = spawn_interval
	if not autostart:
		set_process(false)

func _process(delta: float) -> void:
	_active_fish = _active_fish.filter(func(f): return is_instance_valid(f))

	_timer -= delta
	if _timer <= 0.0:
		_timer = spawn_interval
		if _active_fish.size() < max_fish:
			_spawn_fish()

func _spawn_fish() -> void:
	if fish_entries.is_empty():
		push_warning("fish_entries is empty on FishSpawner")
		return

	var entry: FishSpawnEntry = fish_entries[randi() % fish_entries.size()]
	if not entry.scene:
		push_warning("FishSpawnEntry has no scene assigned")
		return

	var fish := entry.scene.instantiate()

	var spawn_x := randf_range(spawn_x_min, spawn_x_max)
	var spawn_y := randf_range(entry.spawn_y_min * Constants.PIXELS_PER_METER, entry.spawn_y_max * Constants.PIXELS_PER_METER)
	fish.position = Vector2(spawn_x, spawn_y)

	add_child(fish)

	_active_fish.append(fish)
