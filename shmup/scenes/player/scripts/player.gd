extends CharacterBody2D
class_name Player

@export var SPEED : float = 300.0

func _physics_process(_delta: float) -> void:
	var movement : Vector2 = Vector2.ZERO

	movement = Input.get_vector("player_move_left", "player_move_right", "player_move_up", "player_move_down")

	print(movement.length())
	if movement.length() > 0:
		movement = movement.normalized()

	velocity = movement * SPEED

	move_and_slide()
