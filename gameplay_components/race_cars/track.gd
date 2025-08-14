extends Node2D

const mud = preload("res://scenes/race_cars/mud.tscn")
const full_asphalt = Vector2i(4,10)

@export var mud_spot_max: int = 3

var mud_spot_count: int = 0

func _ready() -> void:
	$MudTimer.start()

@warning_ignore("unused_parameter")
# func _process(delta: float) -> void:
# 	if mud_spot_count >= mud_spot_max:
# 		$MudTimer.stop()
# 	else:
# 		$MudTimer.start()

func _on_lap_marker_body_entered(body:Node2D) -> void:
	if body.is_in_group("car"):
		body.lap += 1
		print(body.name, body.lap)

func _on_mud_timer_timeout() -> void:
	if mud_spot_count < mud_spot_max:
		mud_spot_count += 1
		var full_asphalt_cell_position = $TrackLayer.get_used_cells_by_id(-1, full_asphalt).pick_random()
		var mud_position = $TrackLayer.map_to_local(full_asphalt_cell_position)
		var mud_instance = mud.instantiate()
		mud_instance.global_position = mud_position
		add_child(mud_instance)
		mud_instance.body_entered.connect(_on_mud_body_entered.bind(mud_instance))

func _on_mud_body_entered(body:Node2D, source: Area2D) -> void:
	if body.is_in_group("car"):
		body.has_touched_mud = true
		mud_spot_count -= 1
		source.queue_free()