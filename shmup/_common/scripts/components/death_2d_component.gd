# death_component.gd
extends Node2D

class_name Death2DComponent

signal death_animation_finished

## AudioStreamPlayer2D SFX to play when the entity dies
@export var _death_sfx: AudioStreamPlayer2D
## AnimatedSprite2D to play the death animation (separate from the entity's sprite)
@export var _death_animation: AnimatedSprite2D
## Frame of the death animation to hide the entity's sprite
@export var _hide_frame: int = 3
## Node2D to hide when the death animation reaches the specified frame
@export var _sprite_to_hide: Node2D

var is_dead : bool = false

func _ready() -> void:
	if _death_animation:
		_death_animation.animation_finished.connect(_on_death_animation_finished)

func die() -> void:
	if not is_dead:
		# Hide the specified sprite at the given frame
		if _sprite_to_hide and _death_animation:
			_death_animation.frame_changed.connect(_on_frame_changed)
		
		# Ensure the AnimatedSprite2D is visible
		if _death_animation:
			_death_animation.show()
			_death_animation.play("explosion")

		# Play the explosion sfx
		if _death_sfx:
			_death_sfx.pitch_scale = randf_range(-0.5, 0.5) + 1
			_death_sfx.play()

func _on_frame_changed() -> void:
	if _death_animation.frame == _hide_frame:
		_sprite_to_hide.hide()
		_death_animation.frame_changed.disconnect(_on_frame_changed)

func _on_death_animation_finished() -> void:
	is_dead = true
	death_animation_finished.emit()