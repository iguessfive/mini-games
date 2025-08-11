extends Container

@export var title: StringName
@export var index: int

var start_screen := FilePath.GAME01

@onready var title_label := %TitleLabel
@onready var index_label := %IndexLabel

func _ready() -> void:
	title_label.text = title
	index_label.text = "#%d" % index

func _on_play_button_pressed() -> void:
	if start_screen != "":
		get_tree().change_scene_to_file(start_screen)