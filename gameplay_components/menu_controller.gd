extends Control

signal start_game

@warning_ignore("unused_signal")
signal game_over

const SELECTION_SCENE_PATH = "res://main.tscn"

func _on_start_button_pressed() -> void:
	$StartMenu.visible = false
	start_game.emit()

func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file(SELECTION_SCENE_PATH)

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file(SELECTION_SCENE_PATH)

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file(SELECTION_SCENE_PATH)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_TAB:
		$PauseMenu.visible = not $PauseMenu.visible
		get_tree().paused = $PauseMenu.visible

func _on_game_over() -> void:
	$EndMenu.visible = true

