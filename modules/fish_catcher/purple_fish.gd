extends AnimatedSprite2D

@export var speed = 100.0

var time_passed: float
var direction = 1.0

@onready var viewport_width = get_viewport_rect().size.x

func _ready() -> void:
	position.x = randf_range(64, viewport_width - 64)
	play("swim")
	flip_h = true

func _process(delta: float) -> void:
	position.x += speed * direction * delta
	
	if position.x > viewport_width - 64:
		direction = -1.0
		flip_h = false
	elif position.x < 64:
		direction = 1.0
		flip_h = true

	time_passed += delta
	position.y += sin(time_passed) / 8.0
