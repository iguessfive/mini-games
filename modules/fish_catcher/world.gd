extends Node2D

@export var fisherman: CharacterBody2D

@onready var waves: Sprite2D = $Waves

@onready var purple_fish: AnimatedSprite2D = $PurpleFish
@onready var purple_fish_2: AnimatedSprite2D = $PurpleFish2

func _ready() -> void:
	waves.material.set_shader_parameter("Start", true)
	
