extends RefCounted

# Test state variables
var winner_emitted = false
var winner_token = null
var winner_board_type = null
var no_winner_emitted = false

func _on_winner_found(board_type):
	winner_emitted = true
	winner_board_type = board_type

func _on_no_winner():
	no_winner_emitted = true

func reset_test_state():
	winner_emitted = false
	winner_token = null
	winner_board_type = null
	no_winner_emitted = false

func test_winner_verification() -> bool:
	var board_model = BoardModel.new()
	
	# Connect signals to our test methods
	board_model.winner_found.connect(_on_winner_found)
	board_model.no_winner.connect(_on_no_winner)

	# Test micro board win (simulate a row win for CIRCLE)
	reset_test_state()
	board_model.micro_grid_current = Vector2i(0, 0)
	var micro_board = board_model.macro_board_status[Vector2i.ZERO]["board"]
	micro_board[Vector2i(0, 0)]["token"] = BoardModel.CIRCLE
	micro_board[Vector2i(1, 0)]["token"] = BoardModel.CIRCLE
	micro_board[Vector2i(2, 0)]["token"] = BoardModel.CIRCLE
	winner_token = board_model.verify_winner(BoardModel.MICRO)
	assert(winner_emitted, "winner_found signal should have been emitted for micro board row win")
	assert(winner_token == BoardModel.CIRCLE, "Winner token should be CIRCLE but got: " + str(winner_token))
	assert(winner_board_type == BoardModel.MICRO, "Winner board type should be MICRO but got: " + str(winner_board_type))

	# Test macro board win (simulate a column win for CROSS)
	reset_test_state()
	board_model.macro_board_status[Vector2i(0, 0)]["token"] = BoardModel.CROSS
	board_model.macro_board_status[Vector2i(0, 1)]["token"] = BoardModel.CROSS
	board_model.macro_board_status[Vector2i(0, 2)]["token"] = BoardModel.CROSS
	winner_token = board_model.verify_winner(BoardModel.MACRO)
	assert(winner_emitted, "winner_found signal should have been emitted for macro board column win")
	assert(winner_token == BoardModel.CROSS, "Winner token should be CROSS but got: " + str(winner_token))
	assert(winner_board_type == BoardModel.MACRO, "Winner board type should be MACRO but got: " + str(winner_board_type))

	# Test no winner
	reset_test_state()
	board_model.macro_board_status[Vector2i(0, 0)]["token"] = BoardModel.CIRCLE
	board_model.macro_board_status[Vector2i(0, 1)]["token"] = BoardModel.CROSS
	board_model.macro_board_status[Vector2i(0, 2)]["token"] = BoardModel.EMPTY
	winner_token = board_model.verify_winner(BoardModel.MACRO)
	assert(no_winner_emitted, "no_winner signal should have been emitted when there's no winner")
	assert(not winner_emitted, "winner_found signal should NOT have been emitted when there's no winner")
	assert(winner_token == BoardModel.EMPTY, "Winner token should be EMPTY when there's no winner but got: " + str(winner_token))

	print("Winner verification test passed")

	return true

func test_has_added_move() -> bool:
	var board_model = BoardModel.new()
	board_model.winner_found.connect(_on_winner_found)
	board_model.no_winner.connect(_on_no_winner)

	reset_test_state()
	var chosen_point = Vector2i(2, 2)
	var token = BoardModel.CROSS

	# The cell should be empty before the move
	assert(
		board_model.macro_board_status[Vector2i(1, 1)]["board"][chosen_point]["token"] == BoardModel.EMPTY,
		"Cell should be EMPTY before move"
	)

	var result = board_model.has_added_move(token, chosen_point)

	# The move should be added
	assert(result, "has_added_move should return true after adding a move")
	assert(
		board_model.macro_board_status[Vector2i(1, 1)]["board"][chosen_point]["token"] == token,
		"Token should be set at the move point"
	)

	print("Added move successfully")
	return true


# Function to run tests with error handling
func run_tests():
	print("Starting BoardModel tests...")
	
	# Run the test - any assertion failures will be caught by Godot's error system
	assert(test_winner_verification(), "Winner verification test failed")
	assert(test_has_added_move(), "Adding move test failed")

	print("✓ All BoardModel tests completed successfully!")
