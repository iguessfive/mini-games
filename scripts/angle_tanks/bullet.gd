extends CharacterBody2D

const MAX_COLLISION_ITERATION = 5

@export var max_bounces := 4
@export var lifetime := 6.0

var bounce_count := 0

@onready var lifetime_timer: Timer = $LifetimeTimer

func _ready():
	lifetime_timer.wait_time = lifetime
	lifetime_timer.one_shot = true
	lifetime_timer.start()

func _physics_process(delta: float) -> void:
	if velocity.length() > 0:
		rotation = velocity.angle()

	var motion := velocity * delta
	var iteration := 0

	while iteration < MAX_COLLISION_ITERATION: # Resolve cases with multiple collisions
		var collision := move_and_collide(motion)
		if collision:
			var collider = collision.get_collider()
			if (collider is TileMapLayer):
				if bounce_count < max_bounces:
					# NOTE: Core idea behind the game mechanic
					velocity = velocity.bounce(collision.get_normal())
					var ratio = collision.get_remainder().length() / velocity.length()
					motion = velocity * ratio
					bounce_count += 1
				else:
					destroy()
					return
		iteration += 1

func _on_lifetime_timer_timeout() -> void:
	destroy()

func destroy() -> void:
	call_deferred("queue_free")

func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.is_in_group("tanks"):
		destroy()
	elif body.is_in_group("bullets"):
		destroy()
