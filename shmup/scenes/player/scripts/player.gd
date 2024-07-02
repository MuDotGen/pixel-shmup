extends CharacterBody2D
class_name Player

@export var movement_speed : float = 300.0
@export var projectile_cooldown_time : float:
	get:
		return projectile_cooldown_time
	set(value):
		projectile_cooldown_time = value
		if projectile_cooldown != null:
			projectile_cooldown.wait_time = value

@export var projectile_offset : Vector2 = Vector2(0, -4)
@export var projectile_scene : PackedScene

@onready var projectile_audio : AudioStreamPlayer2D = $ProjectileAudioStream
@onready var projectile_cooldown : Timer = $ProjectileCooldown

var _can_fire_projectile : bool = false

func _ready() -> void:
	if projectile_scene != null:
		_can_fire_projectile = true

	if projectile_cooldown != null:
		projectile_cooldown.wait_time = projectile_cooldown_time
		projectile_cooldown.timeout.connect(_on_projectile_cooldown_timeout)

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
	if _can_fire_projectile and Input.is_action_pressed("player_weapon_primary"):
		_fire_projectile()
		

		# ;) Cheat

		# "Spreader"
		# _fire_projectile(- PI / 8)
		# _fire_projectile(-PI / 16)
		# _fire_projectile(PI / 16)
		# _fire_projectile(PI / 8)

		# "Wave"
		# _fire_projectile(0, Vector2(-8, 0))
		# _fire_projectile(0, Vector2(-16, 0))
		# _fire_projectile(0, Vector2(-24, 0))
		# _fire_projectile(0, Vector2(-32, 0))
		# _fire_projectile(0, Vector2(-40, 0))
		# _fire_projectile(0, Vector2(8, 0))
		# _fire_projectile(0, Vector2(16, 0))
		# _fire_projectile(0, Vector2(24, 0))
		# _fire_projectile(0, Vector2(32, 0))
		# _fire_projectile(0, Vector2(40, 0))
		

func _fire_projectile(angle_offset: float = 0.0, fine_offset: Vector2 = Vector2.ZERO) -> void:
	var projectile_angle : float = rotation + angle_offset
	var projectile : Projectile = projectile_scene.instantiate() as Projectile
	get_tree().root.add_child(projectile) # Set the projectile as a child of the root node so it is not affected by theh player rotation
	projectile.global_position = global_position + projectile_offset.rotated(projectile_angle) + fine_offset # Set where the projectile will spawn
	projectile.global_rotation = projectile_angle # Set the visual rotation of the projectile
	projectile.direction = projectile.direction.rotated(projectile_angle).normalized() # Set the direction to move

	projectile_audio.play()

	# Reset the firing cooldown
	_can_fire_projectile = false
	projectile_cooldown.start()

	pass

func _on_projectile_cooldown_timeout() -> void:
	_can_fire_projectile = true
	pass