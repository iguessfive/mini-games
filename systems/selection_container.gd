@tool
extends Container

@export var title: StringName
@export var index: int
@export_file("*.tscn") var uuid: String

@onready var title_label := %TitleLabel
@onready var index_label := %IndexLabel

func _ready() -> void:
	title_label.text = title
	index_label.text = "#%d" % index

func _on_play_button_pressed() -> void:
	if uuid:
		get_tree().change_scene_to_file(uuid)
	else:
		push_warning("game scene not set, asign")
