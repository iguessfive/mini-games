extends Node2D

@onready var waves: Sprite2D = $Waves

func _ready() -> void:
	waves.material.set_shader_parameter("Start", true)
