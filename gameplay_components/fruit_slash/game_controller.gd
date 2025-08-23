extends Node

func _ready() -> void:
	get_tree().paused = true
	
func _on_menus_start_game() -> void:
	get_tree().paused = false
