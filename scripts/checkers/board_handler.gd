extends Node2D

enum {RED, BLUE}

const ATLAS_ID = 1
const TILE_SELECTED = Vector2i(1,0)
const TILE_VALID_MOVE =  Vector2i(0,0)

var turn: int = RED

@onready var board: TileMapLayer = $Board
@onready var game_state: TileMapLayer = $GameState

@onready var board_tiles: Array = board.get_used_cells()
@onready var pieces_pos: Array = game_state.get_used_cells()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var mouse_pos = board.get_local_mouse_position()
			var board_pos = board.local_to_map(mouse_pos)
			if not board_tiles.has(board_pos):
				return

			if pieces_pos.has(board_pos):
				if game_state.get_cell_alternative_tile(board_pos) == turn:
					pass
					board.set_cell(board_pos, ATLAS_ID, TILE_SELECTED)


func scan_diagonal_neighbors(from_pos: Vector2i) -> Array[Vector2i]:
	var diagonal_offsets = [
		Vector2i(1, 1),   # Bottom-right
		Vector2i(1, -1),  # Top-right  
		Vector2i(-1, 1),  # Bottom-left
		Vector2i(-1, -1)  # Top-left
	]
	
	var valid_neighbors: Array[Vector2i] = []
	
	for offset in diagonal_offsets:
		var target_pos = from_pos + offset
		# Check if the position is within the board bounds
		if board_tiles.has(target_pos):
			valid_neighbors.append(target_pos)
	
	return valid_neighbors
