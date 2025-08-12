extends CharacterBody2D

enum AI {
	IDLE,
	MOVE,
	SHOOT,
	AIM
}

# Bit flags for actions
const ACTION_MOVE  = 1 << 0
const ACTION_SHOOT = 1 << 1
const ACTION_AIM   = 1 << 2

@export var travel_points: Node2D

@export_category("Stats")
@export var movement_speed := 70.0
@export var bullet_speed := 100.0
@export var rotation_speed_move := 10.0
@export var rotation_speed_aim := 20.0
@export var cooldown_time_aim := 0.2

var state_machine := CallableStateMachine.new()
var action_flags := 0
var time_tracker := 0.0
var direction_aim := Vector2.ZERO

@onready var _last_travel_point: Marker2D
@onready var _next_travel_point: Marker2D

func _ready() -> void:
	add_states_to_machine()
	state_machine.set_initial_state(AI.IDLE)

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	state_machine.update()

func _on_idle_enter() -> void:
	if travel_points != null:
		state_machine.change_state(AI.MOVE)

func _on_idle_update() -> void:
	# use if you need to pause for a while
	pass

func _on_move_enter() -> void:
	_last_travel_point = travel_points.get_children().pick_random()
	_next_travel_point = _last_travel_point

func _on_move_update() -> void:
	var distance_to_target = global_position.distance_to(_next_travel_point.global_position)
	
	if distance_to_target < 30.0 or _next_travel_point == null:
		_last_travel_point = _next_travel_point
		while _last_travel_point == _next_travel_point:
			_next_travel_point = travel_points.get_children().pick_random()
	
	if velocity.length() > 0:
		time_tracker += get_physics_process_delta_time()

	velocity = (_next_travel_point.global_position - global_position).normalized() * movement_speed
	rotation = lerp_angle(rotation, velocity.angle() + PI / 2, rotation_speed_move * get_physics_process_delta_time())

	move_and_slide()

	if time_tracker >= 2.5:
		state_machine.change_state(AI.AIM)

func _on_shoot_enter() -> void:
	if action_flags & ACTION_SHOOT:
		shoot_bullet()
		set_action_flag(ACTION_SHOOT, false)
		set_action_flag(ACTION_AIM, true)
		state_machine.change_state(AI.MOVE)

func _on_aim_update() -> void:
	handle_barrel_aim()

func add_states_to_machine() -> void:
	state_machine.add_state(AI.IDLE, _on_idle_enter, _on_idle_update, Callable())
	state_machine.add_state(AI.MOVE, _on_move_enter, _on_move_update, Callable())
	state_machine.add_state(AI.SHOOT, _on_shoot_enter, Callable(), Callable())
	state_machine.add_state(AI.AIM, Callable(), _on_aim_update, Callable())

func shoot_bullet() -> void:
	var bullet := preload("res://scenes/angle_tanks/bulllet.tscn").instantiate()
	bullet.get_node("Sprite2D").texture = preload("res://art/top_down_tanks/bulletRed1_outline.png")
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = %BulletSpawnPoint.global_position
	bullet.velocity = -$Pivot.global_transform.y * bullet_speed

func handle_barrel_aim() -> void:
	var pivot = $Pivot
	var player: CharacterBody2D

	if get_tree().current_scene.has_node("PlayerTank"):
		player = get_tree().current_scene.get_node("PlayerTank")
	else:
		return

	time_tracker += get_process_delta_time()

	# Randomize the aim direction within a 120-degree (±60°) cone towards the player
	if time_tracker >= cooldown_time_aim:
		time_tracker = 0.0
		var max_angle_offset = deg_to_rad(60)
		var random_offset = randf_range(-max_angle_offset, max_angle_offset)
		var direction_to_player = (player.global_position - pivot.global_position).normalized()
		direction_aim = direction_to_player.rotated(random_offset)
		$ShootTimer.start()

	pivot.rotation = lerp_angle(pivot.rotation, direction_aim.angle(), rotation_speed_aim * get_process_delta_time())

func set_action_flag(flag: int, enabled: bool) -> void:
	if enabled:
		action_flags |= flag
	else:
		action_flags &= ~flag

func _on_shoot_timer_timeout() -> void:
	state_machine.change_state(AI.SHOOT)
	set_action_flag(ACTION_AIM, false)
	set_action_flag(ACTION_SHOOT, true)
