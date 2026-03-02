extends CharacterBody2D

@export var max_speed: float = 200.0
@export var acceleration: float = 100.0
@export var deceleration: float = 150.0
@export var turn_speed: float = 2.0
@export var brake_deceleration: float = 300.0
@export var turn_threshold: float = 10.0
@export var slow_down_effect_duration: float = 1.0

var current_speed: float = 0.0
var lap: int = 0
var has_touched_mud: bool = false
var time_tracker: float = 0.0

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	var input_accelerate := Input.is_key_pressed(KEY_SPACE)
	var input_brake := Input.is_action_pressed("direction_down")

	var multiplier := 0.5 if has_touched_mud else 1.0

	if has_touched_mud:
		time_tracker += delta
		if time_tracker >= slow_down_effect_duration:
			has_touched_mud = false
			time_tracker = 0.0

	var current_max_speed = max_speed * multiplier
	var current_acceleration := acceleration * multiplier
	var current_deceleration := deceleration * multiplier
	var current_turn_speed = turn_speed * multiplier

	if input_accelerate:
		current_speed += current_acceleration * delta
		current_speed = min(current_speed, current_max_speed)
	elif input_brake:
		current_speed = move_toward(current_speed, 0, brake_deceleration * delta)
	else:
		current_speed = move_toward(current_speed, 0, current_deceleration * delta)

	var turn_direction := 0.0
	if Input.is_action_pressed("direction_left"):
		turn_direction = -1.0
	elif Input.is_action_pressed("direction_right"):
		turn_direction = 1.0

	if abs(current_speed) > turn_threshold:
		rotation += turn_direction * current_turn_speed * delta

	velocity = transform.x * current_speed
	move_and_slide()
				
