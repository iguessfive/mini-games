extends CharacterBody2D

## Reeling fish mini-game scene
@export_file("*tscn") var scene = "uid://0bxtxj0lyc67"
@export var reel_point: Marker2D 

@export var reel_right := 130.0
@export var reel_left := -130

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.play("idle")
	
	var space = InputEventKey.new()
	space.keycode = KEY_SPACE
	InputMap.add_action("reel")
	InputMap.action_add_event("reel", space)

func _physics_process(_delta: float) -> void:
	var input_dir = Input.get_axis("direction_left", "direction_right")
	velocity.x = input_dir * 200.0
	
	if abs(input_dir) > 0:
		sprite.play("row")
	else:
		sprite.play("idle")
	
	move_and_slide()
	
	if Input.is_action_just_pressed("reel"):
		reel_fish()

func reel_fish():
	
	reel_point.position = Vector2(reel_left, 0) if global_position.x > get_viewport_rect().size.x / 2 else Vector2(reel_right, 0)
	
	# load reel_fish event
	print("reeling")
