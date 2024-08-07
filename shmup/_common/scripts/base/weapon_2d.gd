extends Node2D
class_name Weapon2D
## A base class for 2D weapons.
##
## Add this script to a base Node2D to create a 2D weapon.

## Signal emitted when the weapon is used.
signal weapon_used

## Add a SFXPositional2DComponent for the SFX to play when using the weapon
@export var use_sfx : SFXPositional2DComponent
## Add a CooldownComponent to limit the use frequency of the weapon with a cooldown timer.
@export var cooldown : CooldownComponent
## If the weapon can be used.
@export var can_use : bool = true


## Use Weapon
func use() -> void:
	if not can_use:
		return

	var on_cooldown_complete : Callable = func() -> void:
		weapon_used.emit()
		_implement_use()

	cooldown.conditional_completed(on_cooldown_complete)


## Virtual Method Implemented in Child Classes
func _implement_use() -> void:
	pass