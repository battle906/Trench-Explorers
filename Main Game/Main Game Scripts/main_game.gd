extends Node2D

@onready var player: CharacterBody2D = $"player"
@onready var bg_layer: Sprite2D = $"ParallaxBackground/ParallaxLayer/SpriteBackground"

func _process(delta):
	#gets the player y pos
	var depth: float = player.global_position.y
	
	#the depths for the tint
	var start_depth := 50 * 50
	var max_depth := 6000 * 50
	
	#the code to start the tint after you go below 200m  
	var t: float = clamp((depth - start_depth) / (max_depth - start_depth), 0.0, 1.0)
	GlobalWorldEnvironment.environment.adjustment_brightness = 1.0 - t
