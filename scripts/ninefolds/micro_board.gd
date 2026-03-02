extends TileMapLayer

@export var is_playable: bool = false

@onready var valid_playable_pos: Array = get_used_cells()

func _unhandled_input(event: InputEvent) -> void:
	if not is_playable:
		return

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		add_cross_sprite()

func add_cross_sprite() -> void:
	var mouse_pos = get_local_mouse_position()
	var cell_pos = local_to_map(mouse_pos) # update the model with this data
	if not valid_playable_pos.has(cell_pos):
		return

	var sprite = Sprite2D.new()
	sprite.texture = preload("res://art/ninefolds/cross_small.png")
	sprite.global_position = map_to_local(cell_pos) # center the sprite in the cell
	add_child(sprite)
