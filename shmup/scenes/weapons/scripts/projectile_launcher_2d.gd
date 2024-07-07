extends Weapon2D
class_name ProjectileLauncher2D

@export var projectile_scene : PackedScene

func _ready() -> void:
	super()
	if projectile_scene != null:
		_can_use = true
	else:
		_can_use = false