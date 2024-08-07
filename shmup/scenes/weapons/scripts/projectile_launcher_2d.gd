extends Weapon2D
class_name ProjectileLauncher2D

@export var projectile_scene : PackedScene

func _ready() -> void:
	# If the weapon has no projectile scene, it cannot be used
	if projectile_scene != null:
		can_use = true
	else:
		can_use = false


## Set the weapon's projectile scene
func set_projectile_scene(scene : PackedScene) -> void:
	projectile_scene = scene