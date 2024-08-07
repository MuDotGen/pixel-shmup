extends Node
class_name HealthComponent
## A Component to handle health and damage.
##
## Add this Component to a base Node to handle health and damage.
## This Component emits signals when health has been restored, reduced, or changed.
## It also emits signals when health has been maxed out or reduced to zero.
## Can be paired with visual components to display health changes.

## Signal emitted when health has been restored to max
signal hp_maxed_out
## Signal emitted when health has been depleted
signal hp_reduced_to_zero
## Signal emitted when health has changed, new_hp is the new health, old_hp is the old health
signal hp_changed(new_hp: int, old_hp: int)
## Signal emitted when health has been restored, healed_amount is the amount of health restored
signal hp_restored(healed_amount: int)
## Signal emitted when health has been reduced, damage_amount is the amount of damage taken
signal hp_reduced(damage_amount: int)

# Properties
## The maximum health of the object
@export var max_hp: int = 100
## The current health of the object
@export var current_hp: int = max_hp:
	get:
			return current_hp
	set(value):
		var new_hp : int = clamp(value, 0, max_hp)
		var old_hp : int = current_hp
		current_hp = new_hp

		if new_hp <= 0:
				hp_reduced_to_zero.emit()
		elif new_hp >= max_hp:
				hp_maxed_out.emit()
		hp_changed.emit(new_hp, old_hp)
## The damage multiplier of the object. Higher means more damage taken
@export var damage_multiplier: float = 1.0

# Methods
## Restore health to max
func max_out_hp() -> void:
	current_hp = max_hp
	hp_maxed_out.emit()

## Set health to zero
func reduce_hp_to_zero() -> void:
	current_hp = 0
	hp_reduced_to_zero.emit()

## Take and calculate damage
func take_damage(damage: int) -> void:
	var final_damage : int = int(damage * damage_multiplier)
	current_hp -= final_damage
	hp_reduced.emit(final_damage)

## Restore health by healing
func heal(heal_amount: int) -> void:
	current_hp += heal_amount
	hp_restored.emit(heal_amount)