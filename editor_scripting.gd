@tool
extends EditorScript

func _run():
	pass
	
func create_white_1x1() -> void:
	var img := Image.create(1, 1, false, Image.FORMAT_RGBA8)
	img.fill(Color.WHITE)
	const PATH = "res://art/block_breaker/white_1x1.png"
	img.save_png(PATH)
	print("Saved white_1x1.png")
