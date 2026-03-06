extends Node2D

signal fish_caught
signal fish_missed

@export var speed = 200.0
@export var move_pos_duration: float = 0.5

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
	timer.wait_time = move_pos_duration

	timer.timeout.connect(func():
		var random_y = randf_range(-bounds, bounds)
		var tween = create_tween()
		tween.tween_property(_fish, "position:y", random_y, 0.5).set_trans(Tween.TRANS_SINE)
	)
	add_child(timer)
	
	sensor.area_entered.connect(func(_area: Area2D):
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
				print("caught")
			else:
				fish_missed.emit()
				queue_free.call_deferred()
				print("missed")
