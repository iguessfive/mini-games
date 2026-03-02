extends Node2D

var score: int = 0

func _ready() -> void:
	$CanvasLayer/Menus/StartMenu.visible = true
	get_tree().paused = true

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if get_tree().current_scene.has_node("Ball"):
		if $Ball.global_position.y >= get_viewport().size.y:
			%Menus.game_over.emit()
			$Ball.queue_free.call_deferred()

func _on_menus_game_over() -> void:
	%ScoreLabel.text = "Score: %d" % score


func _on_menus_start_game() -> void:
	get_tree().paused = false
