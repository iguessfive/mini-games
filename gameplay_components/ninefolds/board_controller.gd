extends Node2D

const BOARD_TEST_CASE = preload("res://tests/ninefold/test_board_model.gd")

var board_model = NineFoldsBoardModel.new()

@onready var macro_board = $MacroBoard
@onready var micro_boards = $MicroBoards

func _init() -> void:
	BOARD_TEST_CASE.new().run_tests()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		pass
		

func cross_large() -> void:
	var mouse_pos = macro_board.get_local_mouse_position()
	var cell_pos = macro_board.local_to_map(mouse_pos) # update the model with this data
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://art/ninefolds/cross_large.png")
	sprite.global_position = macro_board.map_to_local(cell_pos) # center the sprite in the cell
	macro_board.add_child(sprite)
