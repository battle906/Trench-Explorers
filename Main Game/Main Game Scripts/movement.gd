extends CharacterBody2D
#variables
@export var PIXELS_PER_METER = 50
@export var speed = 400
@onready var borders: StaticBody2D = $Borders



#takes your inputs and multiples speed
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
func _physics_process(_delta):
	get_input()
	move_and_slide()

#depth label
@onready var height_label: Label = $CanvasLayer/HeightLabel

func _process(delta):
	var depth := int(global_position.y / PIXELS_PER_METER)
	height_label.text = "Depth: " + str(depth) + "m"
	var t: float = clamp(float(depth) / 6000.0, 0.0, 1.0)
	var shallow_color := Color(0.49, 0.91, 1)
	var mid_color := Color(0.0, 0.35, 0.7)
	var deep_color := Color(0.0, 0.2, 0.4)
	var mid_blend := shallow_color.lerp(mid_color, t)
	var final_color := mid_blend.lerp(deep_color, t)
	height_label.modulate = final_color
	
	borders.global_position.y = global_position.y
	borders.global_position.x = -462
