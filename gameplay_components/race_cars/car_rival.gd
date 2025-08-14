extends CharacterBody2D

@export var max_speed: float = 190.0
@export var rotation_smoothness: float = 5.0
@export var slow_down_effect_duration: float = 1.0

var lap: int = 0
var has_touched_mud: bool = false
var time_tracker: float = 0.0

@onready var route_options: Array = get_tree().get_nodes_in_group("route")
@onready var path: RemoteTransform2D = route_options.pick_random()
@onready var path_follow: PathFollow2D = path.get_parent()

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:

	var multiplier := 0.5 if has_touched_mud else 1.0

	if has_touched_mud:
		time_tracker += delta
		if time_tracker >= slow_down_effect_duration:
			has_touched_mud = false
			time_tracker = 0.0

	var current_speed = max_speed * multiplier
	path_follow.progress += current_speed * delta

	
