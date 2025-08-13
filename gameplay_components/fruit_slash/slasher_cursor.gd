extends Area2D

var is_slasher_active := false
var click_point := Vector2()
var impact_point := Vector2()
var max_trail_points := 5

@onready var slash_line: Line2D = %Line2D

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()

	if Input.is_action_just_pressed("left_click"):
		is_slasher_active = true
		slash_line.visible = is_slasher_active
		click_point = global_position
		slash_line.add_point(click_point)

	if Input.is_action_just_released("left_click"):
		is_slasher_active = false
		slash_line.visible = is_slasher_active
		slash_line.clear_points()

	if Input.is_action_pressed("left_click") and is_slasher_active:
		slash_line.add_point(get_global_mouse_position()) # Updating slash line while dragging

		while slash_line.get_point_count() > max_trail_points:
			slash_line.remove_point(0)

func _on_body_entered(body:Node2D) -> void:
	impact_point = get_global_mouse_position()
	if body.is_in_group("fruits") and is_slasher_active:
		body.slash_fruit(get_slash_direction())

func get_slash_direction() -> Vector2:
	return (impact_point - click_point).normalized()
