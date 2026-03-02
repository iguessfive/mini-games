extends StaticBody2D

@export var color_01: Color
@export var color_02: Color
@export var color_03: Color

var health := 3

func _ready() -> void:
	modulate = color_01

func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.is_in_group("ball"):
		health -= 1
		match health:
			2: modulate = color_02
			1: modulate = color_03
			0:
				get_tree().current_scene.score += 1
				queue_free()
