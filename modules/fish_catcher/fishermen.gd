extends CharacterBody2D

signal hooked(state: bool)

## Reeling fish mini-game scene
@export_file("*tscn") var scene
@export var reel_point: Marker2D 

@export var reel_right := 130.0
@export var reel_left := -130

var was_moving: bool
var on_hook: bool
var bite_duration: float = 3.0
var bite_timer: Timer = Timer.new()
var cooldown_timer: Timer = Timer.new()

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	sprite.play("idle")
	
	var space = InputEventKey.new()
	space.keycode = KEY_SPACE
	InputMap.add_action("throw")
	InputMap.action_add_event("throw", space)
	
	add_child(bite_timer)
	bite_timer.one_shot = true
	bite_timer.timeout.connect(func():
		fish_bite()
	)
	sprite.animation_finished.connect(bite_timer.start)
	
	add_child(cooldown_timer)
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = 1.0

func _physics_process(_delta: float) -> void:
	var input_dir = Input.get_axis("direction_left", "direction_right")
	velocity.x = input_dir * 200.0
	
	if abs(input_dir) > 0:
		sprite.play("row")
	elif was_moving:
		sprite.play("idle")
	
	move_and_slide()
	
	if Input.is_action_just_pressed("throw"):
		throw()
	
	was_moving = abs(input_dir) > 0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_SPACE and on_hook:
			hook()

# throw and wait for bite
func throw():
	if not cooldown_timer.is_stopped():
		return
	sprite.play("throw")
	set_physics_process(false)

func fish_bite():
	on_hook = true
	animation.play("fish_bite")
	animation.animation_finished.connect(func(anim_name: String):
		if anim_name == "fish_bite":
			on_hook = false
			set_physics_process.call_deferred(true)
	)

func hook():
	# on bit hook and add reel event
	hooked.emit(true)
	reel_point.position = Vector2(reel_left, 0) if global_position.x > get_viewport_rect().size.x / 2 else Vector2(reel_right, 0)
	sprite.play("reel")
	var reel_scene = (load(scene) as PackedScene).instantiate()
	reel_point.add_child(reel_scene)
	set_physics_process.call_deferred(false)
	
	reel_scene.fish_caught.connect(func():
		cooldown_timer.start()
		set_physics_process.call_deferred(true)
		hooked.emit(false)
	)
	reel_scene.fish_missed.connect(func():
		cooldown_timer.start()
		set_physics_process.call_deferred(true)
		hooked.emit(false)
	)
