extends CharacterBody2D

@export var texture: Texture2D = preload("res://art/fruits/Apple.png")
@export var slash_force: float = 300.0
@export var gravity: float = 250.0

var speed: float = 100.0
var move_direction: Vector2 = Vector2.RIGHT

@onready var sprite: Sprite2D = %Sprite2D

func _ready() -> void:
	sprite.texture = texture

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	%H1Sprite.global_rotation = 0.0
	%H2Sprite.global_rotation = 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

func slash_fruit(slash_direction: Vector2) -> void:
	sprite.visible = false
	set_physics_process(false)
	%CollisionShape2D.set_deferred("disabled", true)

	%SlashedCase.rotation = slash_direction.angle()

	%Half1.velocity = slash_direction * slash_force
	%Half2.velocity = -slash_direction * slash_force
	%Half1.gravity = gravity
	%Half2.gravity = gravity

func add_sprites_to_slashed_case() -> void:
	var half_sprite_1 = sprite.duplicate()
	half_sprite_1.visible = true
	half_sprite_1.position = Vector2(%ClipRect1.pivot_offset)
	%ClipRect1.add_child(half_sprite_1)

	var half_sprite_2 = half_sprite_1.duplicate()
	half_sprite_2.rotation = deg_to_rad(180)
	%ClipRect2.add_child(half_sprite_2)

func destroy() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	destroy()
