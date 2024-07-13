extends Node
class_name SFXPositional2DComponent
## A Component to play a SFX positionally in 2D space.
##
## Add this Component to a base Node2D to play a SFX positionally in 2D space.

## Signal emitted when the SFX is played.
signal sfx_played

## AudioStreamPlayer2D to play the SFX
@export var sfx_player : AudioStreamPlayer2D


func _ready() -> void:
	_setup_audio()


## Play the SFX
func play() -> void:
	sfx_player.play()
	sfx_played.emit()

## Stop the SFX
func stop() -> void:
	sfx_player.stop()

## Change the pitch scale of the SFX
func change_pitch_scale(scale: float) -> void:
	sfx_player.pitch_scale = scale

# Setup Audio
func _setup_audio() -> void:
	if not sfx_player:
		print("No AudioStreamPlayer2D set at " + str(get_path()))
		sfx_player = AudioStreamPlayer2D.new()
		add_child(sfx_player)

func _on_sfx_player_finished() -> void:
	sfx_played.emit()

func _on_sfx_player_started() -> void:
	pass

func _on_sfx_player_stopped() -> void:
	pass

func _on_sfx_player_paused() -> void:
	pass
