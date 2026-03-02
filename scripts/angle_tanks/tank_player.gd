extends CharacterBody2D

@export var movement_speed := 70.0
@export var bullet_speed := 120.0
@export var rotation_speed_aim := 50.0
@export var rotation_speed := 2.0

func _physics_process(delta: float) -> void:
	var direction_move = Input.get_axis("direction_up", "direction_down")
	var direction_rotate = Input.get_axis("direction_left", "direction_right")

	if abs(direction_rotate) > 0:
		rotation += direction_rotate * delta * rotation_speed  # Adjust 2.0 for desired rotation speed
	
	velocity = transform.y * direction_move * movement_speed

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		handle_barrel_aim()

	var input_shoot = (
		event is InputEventMouseButton 
		and event.is_pressed() 
		and event.button_index == MOUSE_BUTTON_LEFT
	)

	if input_shoot:
		shoot_bullet()

func shoot_bullet() -> void:
	var bullet := preload("res://scenes/angle_tanks/bullet.tscn").instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = %BulletSpawnPoint.global_position
	bullet.velocity = -$Pivot.global_transform.y * bullet_speed

func handle_barrel_aim() -> void:
	var pivot = $Pivot
	var mouse_pos = get_global_mouse_position()
	var direction_aim = (mouse_pos - pivot.global_position).normalized()
	var target_angle = wrapf(direction_aim.angle(), 0, 2 * PI)
	pivot.rotation = lerp_angle(pivot.rotation, target_angle, rotation_speed_aim * get_process_delta_time())
