class_name BoardModel extends RefCounted

signal winner_found(board_type)
signal no_winner

enum {EMPTY, CIRCLE, CROSS}
enum {MACRO, MICRO}

var macro_board_status: Dictionary[Vector2i, Dictionary] = {} # map cell pos to board & won state
var micro_grid_current: Vector2i = Vector2i.ONE
var micro_grid_next: Vector2i

func _init() -> void:
	setup_board()

func setup_board() -> void:
	for col in range(3):
		for row in range(3):
			macro_board_status[Vector2i(col, row)] = {
				"board": create_micro_board(),
				"token": EMPTY
			}

func create_micro_board() -> Dictionary:
	var board: Dictionary[Vector2i, Dictionary] = {}
	for col in range(3): # moves along x-axis
		for row in range(3): # moves along y-axis
			var cell_pos = Vector2i(col, row)
			board[cell_pos] = {
				"token": EMPTY,
			}
	return board

func verify_winner(on_board: int) -> int:

	var board = (
		macro_board_status if on_board == MACRO
		else macro_board_status[micro_grid_current]["board"]
	)

	var horizontal_check = []
	var vertical_check = []
	var forward_slash_check = []
	var backward_slash_check = []

	for index in range(3):
		horizontal_check.append([Vector2i(index, 0), Vector2i(index, 1), Vector2i(index, 2)])
		vertical_check.append([Vector2i(0, index), Vector2i(1, index), Vector2i(2, index)])
	
	forward_slash_check.append([Vector2i(0, 2), Vector2i(1, 1), Vector2i(2, 0)])
	backward_slash_check.append([Vector2i(0, 0), Vector2i(1, 1), Vector2i(2, 2)])

	var all_checks = []

	var check_count = 0
	for check in [horizontal_check, vertical_check, forward_slash_check, backward_slash_check]:
		for line in check: # each line has three points
			all_checks.append(line)
			if check_line(
				board[line[0]]["token"], board[line[1]]["token"], board[line[2]]["token"]
			):
				winner_found.emit(on_board)
				return board[line[0]]["token"]
			else:
				check_count += 1

	if check_count == all_checks.size():
		no_winner.emit()
		return EMPTY

	return EMPTY

func check_line(point_1, point_2, point_3) -> bool:
	if (
		point_1 != EMPTY
		and point_1 == point_2
		and point_2 == point_3
	):
		return true
	return false

func has_added_move(token: int, point: Vector2i) -> bool:
	var micro_board = macro_board_status[micro_grid_current]["board"]

	if micro_board[point]["token"] != EMPTY:
		return false

	micro_board[point]["token"] = token
	macro_board_status[micro_grid_current]["token"] = verify_winner(MICRO)

	return micro_board[point]["token"] != EMPTY
