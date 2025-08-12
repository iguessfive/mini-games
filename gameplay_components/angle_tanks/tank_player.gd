extends CharacterBody2D

@export var movement_speed := 70.0
@export var bullet_speed := 120.0
@export var barrel_rotation_speed := 20.0
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
	
	if event.is_action_pressed("left_click"):
		shoot_bullet()

func shoot_bullet() -> void:
	var bullet := preload("res://scenes/angle_tanks/bulllet.tscn").instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = %BulletSpawnPoint.global_position
	bullet.velocity = -$Pivot.global_transform.y * bullet_speed

func handle_barrel_aim() -> void:
	var pivot = $Pivot
	var mouse_pos = get_global_mouse_position()
	var direction_aim = (mouse_pos - pivot.global_position).normalized()
	var target_angle = direction_aim.angle()

	pivot.rotation = lerp_angle(pivot.rotation, target_angle, barrel_rotation_speed * get_process_delta_time())