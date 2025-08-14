extends Node2D

var has_car_won := false

@onready var countdown_label: Label = $UI/CountdownLabel
@onready var cars_in_scene := get_tree().get_nodes_in_group("car")
@onready var countdown_timer: Timer = countdown_label.get_child(0)

func _ready() -> void:
	countdown_label.text = str(countdown_timer.wait_time as int)
	get_tree().paused = true
	
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not countdown_timer.is_stopped():
		countdown_label.text = str(countdown_timer.time_left as int)

	for car in cars_in_scene:
		if car.lap >= 1: 
			game_over(car)

func game_over(car: Node2D) -> void:
	if not has_car_won: 
		has_car_won = true
		if car.name.contains("Player"):
			$UI/Menus/EndMenu/GameOverLabel.text = "You won!"
		else:
			$UI/Menus/EndMenu/GameOverLabel.text = "You lost!"
		$UI/Menus.game_over.emit()
		get_tree().paused = true

func _on_menus_start_game() -> void:
	get_tree().paused = false
	countdown_label.visible = true
	get_tree().create_timer(0.5).timeout.connect(countdown_timer.start)
	countdown_timer.timeout.connect(func() -> void:
		countdown_label.visible = false
		for car in cars_in_scene:
			$Track.set_process(true)
			car.set_physics_process(true)
	)
