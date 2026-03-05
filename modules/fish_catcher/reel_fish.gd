extends Node2D

signal fish_caught

@export var speed = 200.0

var direction = 1

@onready var _fish = $Fish
@onready var _hook = $Hook
@onready var sensor = $Sensor

# the bound where the fish can spawn and the net moves within
@onready var bounds = $BG.scale.y/2.0 - 20

func _ready() -> void:
	_fish.position.y = randf_range(-bounds, bounds)
	var timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 1.0

	timer.timeout.connect(func():
		var random_y = randf_range(-bounds, bounds)
		var tween = create_tween()
		tween.tween_property(_fish, "position:y", random_y, 0.5).set_trans(Tween.TRANS_SINE)
	)
	add_child(timer)
	
	sensor.area_entered.connect(func(area: Area2D):
		direction *= -1
	)

func _process(delta: float) -> void:
	_hook.position.y += direction * speed * delta

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_SPACE and event.is_pressed():
			if _hook.overlaps_area(_fish):
				fish_caught.emit()
				queue_free.call_deferred()
			else:
				queue_free.call_deferred()
				print("missed")
