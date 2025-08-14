@tool
extends EditorScript

func _run() -> void:
	pass
	
func create_white_1x1() -> void:
	var img := Image.create(1, 1, false, Image.FORMAT_RGBA8)
	img.fill(Color.WHITE)
	const PATH = "res://art/white_1x1.png"
	img.save_png(PATH)
	print("Saved white_1x1.png")

func scale_image(path: String, new_width: int, new_height: int) -> Image:
	var img := Image.new()
	img.load(path) 
	img.resize(new_width, new_height, Image.INTERPOLATE_NEAREST)
	return img
