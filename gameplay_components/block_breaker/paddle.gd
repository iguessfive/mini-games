extends CharacterBody2D

@export var speed: float = 300.0

@onready var sprite_width: float = $Sprite2D.scale.x

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var direction_x: float = 0.0
	var mouse_x = get_global_mouse_position().x

	var active_zone_left = global_position.x - sprite_width / 2
	var active_zone_right = global_position.x + sprite_width / 2

	if mouse_x > active_zone_right:
		direction_x = 1.0
	elif mouse_x < active_zone_left:
		direction_x = -1.0

	var bounds = Vector2(sprite_width/2, get_viewport().size.x - sprite_width/2)
	global_position.x = clamp(global_position.x, bounds.x, bounds.y)

	velocity.x = direction_x * speed
	move_and_slide()
