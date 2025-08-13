extends CharacterBody2D

@export var speed: float = 400.0
@export var bounce_strength: float = 1.0

var rng = RandomNumberGenerator.new()
var current_velocity: Vector2

func _ready():
	rng.randomize()
	set_random_initial_velocity()

	set_physics_process(false)
	get_tree().create_timer(1.0).timeout.connect(set_physics_process.bind(true))

func _physics_process(delta):		
	velocity = current_velocity
	
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var normal = collision.get_normal()
		current_velocity = current_velocity.bounce(normal) * bounce_strength
		global_position += normal * 2
	
	if current_velocity.length_squared() > 0.01:
		current_velocity = current_velocity.normalized() * speed
		
func set_random_initial_velocity() -> void:
	var angle_degrees = rng.randf_range(45, 135)
	if rng.randi() % 2 == 0: # a coin flip
		angle_degrees += 180
	var intital_direction = Vector2.RIGHT.rotated(deg_to_rad(angle_degrees))
	current_velocity = intital_direction * speed
