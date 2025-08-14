extends CharacterBody2D

@export var max_speed: float = 190.0
@export var rotation_smoothness: float = 5.0

var lap: int = 0
var has_touched_mud: bool = false

@onready var route_options: Array = get_tree().get_nodes_in_group("route")
@onready var path: RemoteTransform2D = route_options.pick_random()
@onready var path_follow: PathFollow2D = path.get_parent()

func _physics_process(delta: float) -> void:

	var current_speed = max_speed
	path_follow.progress += current_speed * delta

	
