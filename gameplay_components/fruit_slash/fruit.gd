extends CharacterBody2D

@export var texture: Texture2D = preload("res://art/fruits/Apple.png")

func _ready() -> void:
	for sprite in get_tree().get_nodes_in_group(("sprite")):
		sprite.texture = texture

	 
