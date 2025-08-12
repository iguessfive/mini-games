extends Container

@export var title: StringName
@export var index: int

var start_screen: StringName

@onready var title_label := %TitleLabel
@onready var index_label := %IndexLabel

func _ready() -> void:
	title_label.text = title
	index_label.text = "#%d" % index

func _on_play_button_pressed() -> void:
	match index:
		1:
			get_tree().change_scene_to_file(FilePath.GAME01)
		2:
			get_tree().change_scene_to_file(FilePath.GAME02)
		_:
			print("Game Unavailable")
