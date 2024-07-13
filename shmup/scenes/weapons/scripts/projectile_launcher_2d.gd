extends Weapon2D
class_name ProjectileLauncher2D

@export var projectile_scene : PackedScene

func _ready() -> void:
	# If the weapon has no projectile scene, it cannot be used
	if projectile_scene != null:
		_can_use = true
	else:
		_can_use = false