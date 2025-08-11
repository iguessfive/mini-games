extends Area2D

var can_register_position := false
var impact_point := Vector2()

var is_slasher_active := false
var click_point := Vector2()

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()

	if Input.is_action_pressed("left_click") and not is_slasher_active:
		is_slasher_active = true
		click_point = get_global_mouse_position()

	if Input.is_action_just_released("left_click") and is_slasher_active:
		is_slasher_active = false

	if Input.is_action_pressed("left_click") and can_register_position:
		impact_point = get_global_mouse_position()
		can_register_position = false

func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("fruits"):
		can_register_position = true
		if is_slasher_active:
			body.slash_fruit(get_slash_normal_direction())

func get_slash_normal_direction() -> Vector2:
	return (impact_point - click_point).normalized().orthogonal()
