extends CharacterBody2D
#variables
@onready var borders: StaticBody2D = $Borders
#depth label
@onready var height_label: Label = $CanvasLayer/HeightLabel
@onready var money_label: Label = $CanvasLayer/MoneyLabel
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("idle")
	sprite_2d.texture = Constants.Player

#takes your inputs and multiples speed
func get_input():
	if MenuManager.is_any_menu_open == false:
		var input_direction = Input.get_vector("left", "right", "up", "down")
		velocity = input_direction * Constants.speed2
	else:
		return
func _physics_process(_delta):
	get_input()
	move_and_slide()
	borders.global_position.y = global_position.y
	borders.global_position.x = 128

#does label things
func _process(delta):
	sprite_2d.texture = Constants.Player
	money_label.text = "$" + str(Constants.money)
	var depth := int(global_position.y / Constants.PIXELS_PER_METER)
	height_label.text = "Depth: " + str(depth) + "m"
	var t: float = clamp(float(depth) / 4000.0, 0.0, 1.0)
	var shallow_color := Color(0.49, 0.91, 1)
	var mid_color := Color(0.0, 0.35, 0.7)
	var deep_color := Color(0.0, 0.2, 0.4)
	var mid_blend := shallow_color.lerp(mid_color, t)
	var final_color := mid_blend.lerp(deep_color, t)
	height_label.modulate = final_color
	money_label.modulate = final_color
