extends Node2D

var score: int = 0

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if get_tree().current_scene.has_node("Ball"):
		if $Ball.global_position.y >= get_viewport().size.y:
			%Menus.game_over.emit()
			$Ball.queue_free.call_deferred()
