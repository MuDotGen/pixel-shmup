extends CharacterBody2D
class_name Player

@export var movement_speed : float = 300.0
@onready var primary_weapon : Weapon2D = $DefaultBlaster2D

func _physics_process(_delta: float) -> void:
	_process_movement()

	_process_weapon()

func _process_movement() -> void:
	var movement : Vector2 = Vector2.ZERO

	movement = Input.get_vector("player_move_left", "player_move_right", "player_move_up", "player_move_down")

	if movement.length() > 0:
		movement = movement.normalized()

	velocity = movement * movement_speed

	move_and_slide()

func _process_weapon() -> void:
		if Input.is_action_pressed("player_weapon_primary"):
			primary_weapon.use()
