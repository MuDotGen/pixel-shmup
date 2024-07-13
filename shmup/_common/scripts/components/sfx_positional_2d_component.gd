extends Node
class_name SFXPositional2DComponent
## A Component to play a SFX positionally in 2D space.
##
## Add this Component to a base Node2D to play a SFX positionally in 2D space.

signal sfx_played

@export var sfx_player : AudioStreamPlayer2D

## Setup
func _ready() -> void:
	_setup_audio()

# Setup Audio
func _setup_audio() -> void:
	if not sfx_player:
		print("No AudioStreamPlayer2D set at " + str(get_path()))
		sfx_player = AudioStreamPlayer2D.new()
		add_child(sfx_player)


## Public Methods
func play() -> void:
	sfx_player.play()
	sfx_played.emit()