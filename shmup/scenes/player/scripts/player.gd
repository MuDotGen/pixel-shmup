extends CharacterBody2D
class_name Player

@export var movement_speed : float = 300.0
@export var projectile_scene : PackedScene

var _can_fire_projectile : bool = false

func _ready() -> void:
	if projectile_scene != null:
		_can_fire_projectile = true

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
	if _can_fire_projectile and Input.is_action_just_pressed("player_weapon_primary"):
		_fire_projectile()

func _fire_projectile() -> void:
	var projectile : Projectile = projectile_scene.instantiate() as Projectile

	get_tree().root.add_child(projectile) # Add the projectile to the root of the scene tree so it doesn't get affected by the player's movement

	projectile.global_position = self.global_position 

	pass