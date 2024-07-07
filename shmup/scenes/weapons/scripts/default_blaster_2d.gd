extends ProjectileLauncher2D
class_name DefaultBlaster2D

func _implement_use() -> void:
		_fire_projectile()

		# ;) Cheats

		# Right Shoulder Spread
		# _fire_projectile(- PI / 8)
		# _fire_projectile(PI / 4, Vector2(8, 0))
		# _fire_projectile(PI / 4, Vector2(-8, 0))

		# "Spreader"
		_fire_projectile(- PI / 8)
		_fire_projectile(-PI / 16)
		_fire_projectile(-PI / 4)
		_fire_projectile(-PI / 2)
		_fire_projectile(PI / 2)
		_fire_projectile(PI / 4)
		_fire_projectile(PI / 16)
		_fire_projectile(PI / 8)

		# "Wave"
		# _fire_projectile(0, Vector2(-8, 0))
		# _fire_projectile(0, Vector2(-16, 0))
		# _fire_projectile(0, Vector2(-24, 0))
		# _fire_projectile(0, Vector2(-32, 0))
		# _fire_projectile(0, Vector2(-40, 0))
		# _fire_projectile(0, Vector2(-48, 0))
		# _fire_projectile(0, Vector2(-56, 0))
		# _fire_projectile(0, Vector2(-64, 0))
		# _fire_projectile(0, Vector2(-72, 0))
		# _fire_projectile(0, Vector2(-80, 0))
		# _fire_projectile(0, Vector2(-88, 0))
		# _fire_projectile(0, Vector2(-96, 0))
		# _fire_projectile(0, Vector2(-104, 0))
		# _fire_projectile(0, Vector2(8, 0))
		# _fire_projectile(0, Vector2(16, 0))
		# _fire_projectile(0, Vector2(24, 0))
		# _fire_projectile(0, Vector2(32, 0))
		# _fire_projectile(0, Vector2(40, 0))
		# _fire_projectile(0, Vector2(48, 0))
		# _fire_projectile(0, Vector2(56, 0))
		# _fire_projectile(0, Vector2(64, 0))
		# _fire_projectile(0, Vector2(72, 0))
		# _fire_projectile(0, Vector2(80, 0))
		# _fire_projectile(0, Vector2(88, 0))
		# _fire_projectile(0, Vector2(96, 0))
		# _fire_projectile(0, Vector2(104, 0))

func _fire_projectile(angle_offset: float = 0.0, position_offset: Vector2 = Vector2.ZERO) -> void:
	var projectile_angle : float = global_rotation + angle_offset
	var projectile : Projectile = projectile_scene.instantiate() as Projectile
	get_tree().root.add_child(projectile) # Set the projectile as a child of the root node so it is not affected by theh player rotation
	projectile.global_position = global_position + position.rotated(projectile_angle) + position_offset.rotated(projectile_angle) # Set where the projectile will spawn
	projectile.global_rotation = projectile_angle # Set the visual rotation of the projectile
	projectile.direction = projectile.direction.rotated(projectile_angle).normalized() # Set the direction to move

	use_audio.play()

	# Reset the firing cooldown
	_can_use = false
	_cooldown_timer.start()