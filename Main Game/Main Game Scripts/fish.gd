extends CharacterBody2D

@export var swim_speed = 10
@export var flee_speed = 200
@export var wander_radius: float = 200
@export var wander_interval: float = 3
@export var data: FishData

var _origin: Vector2
var _target: Vector2
var _timer: float = 0.0 
var _flee_direction: Vector2

@onready var _screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


enum State {IDLE, SWIM, FLEE}
var current_state: State = State.IDLE

func _ready() -> void:
	_origin = position
	change_state(State.SWIM)
	_screen_notifier.screen_exited.connect(_on_screen_exited)
	add_to_group("fish")
	

func _process(delta):
	match current_state:
		State.IDLE: 
			idle(delta)
		State.SWIM: 
			swim(delta)
		State.FLEE: 
			flee(delta)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("photo"):
		change_state(State.FLEE)

func change_state(new_state: State) -> void:
	if new_state == current_state:
		return
	exit_state(current_state)
	current_state = new_state
	enter_state(current_state)

func enter_state(state: State) -> void:
	match state:
		State.SWIM:
			_pick_new_target()
		State.FLEE:
			_flee_direction = (position - _get_flee_source()).normalized()
			if _flee_direction == Vector2.ZERO:
				_flee_direction = Vector2.RIGHT.rotated(randf() * TAU)

func exit_state(state: State) -> void:
	match state:
		State.SWIM:
			velocity = Vector2.ZERO


func idle(delta: float) -> void:
	velocity = Vector2.ZERO

func swim(delta: float) -> void:
	_timer -= delta
	if _timer <= 0.0 or global_position.distance_to(_target) < 4.0:
		_pick_new_target()

	var direction := (_target - position).normalized()
	velocity = direction * swim_speed
	move_and_slide()

func flee(delta: float) -> void:
	velocity = _flee_direction * flee_speed
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		_on_collision(collision)

func _on_collision(collision: KinematicCollision2D):
	if current_state == State.FLEE:
		await get_tree().create_timer(0.5).timeout
		queue_free()

func _pick_new_target() -> void:
	var angle := randf() * TAU
	var dist := randf() *wander_radius
	_target = _origin + Vector2(cos(angle), sin(angle)) * dist
	_timer = wander_interval

func  _get_flee_source():
	return get_tree().get_first_node_in_group("player").global_position

func _on_screen_exited():
	if current_state == State.FLEE:
		await get_tree().create_timer(0.5).timeout
		queue_free()
