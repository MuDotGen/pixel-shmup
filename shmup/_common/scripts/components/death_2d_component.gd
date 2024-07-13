# death_component.gd
extends Node2D
class_name Death2DComponent
## A Component to handle death animations and sfx for 2D entities.
##
## Add this Component to a base Node2D to handle death animations and sfx for 2D entities.

## Signal emitted when the entity's death animation finishes.
signal death_animation_finished

## SFXPositional2DComponent SFX to play when the entity dies
@export var _death_sfx: SFXPositional2DComponent
## AnimatedSprite2D to play the death animation (separate from the entity's sprite)
@export var _death_animation: AnimatedSprite2D
## Frame of the death animation to hide the entity's sprite
@export var _hide_frame: int = 3
## Node2D to hide when the death animation reaches the specified frame
@export var _sprite_to_hide: Node2D

var _is_dead : bool = false


func _ready() -> void:
	if _death_animation:
		_death_animation.animation_finished.connect(_on_death_animation_finished)
	# Hide the specified sprite at the given frame
	if _sprite_to_hide and _death_animation:
		_death_animation.frame_changed.connect(_on_frame_changed)


## Play the death animation and sfx
func die() -> void:
	if not _is_dead:
		
		
		# Ensure the AnimatedSprite2D is visible
		if _death_animation:
			_death_animation.show()
			_death_animation.play("explosion")

		# Play the explosion sfx
		if _death_sfx:
			_death_sfx.change_pitch_scale(randf_range(-0.5, 0.5) + 1)
			_death_sfx.play()


func _on_frame_changed() -> void:
	if _death_animation.frame == _hide_frame:
		_sprite_to_hide.hide()
		_death_animation.frame_changed.disconnect(_on_frame_changed)

func _on_death_animation_finished() -> void:
	_is_dead = true
	death_animation_finished.emit()