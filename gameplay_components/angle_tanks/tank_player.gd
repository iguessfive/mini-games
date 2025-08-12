extends CharacterBody2D

@export var speed := 70.0
@export var bullet_speed := 120.0

func _physics_process(delta: float) -> void:
	var direction_move = Input.get_axis("direction_up", "direction_down")
	var direction_rotate = Input.get_axis("direction_left", "direction_right")

	if abs(direction_rotate) > 0:
		rotation += direction_rotate * delta  # Adjust 2.0 for desired rotation speed
	
	velocity = transform.y * direction_move * speed

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		shoot_bullet()

func shoot_bullet() -> void:
	var bullet := preload("res://scenes/angle_tanks/bulllet.tscn").instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = %BulletSpawnPoint.global_position
	bullet.velocity = -transform.y * bullet_speed
