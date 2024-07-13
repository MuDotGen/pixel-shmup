extends Node2D
class_name ShakeEffect2DComponent
## A Component to shake a Node2D positionally in 2D space.
##
## Add this Component to a base Node2D and define a Node2D to shake.

## Signal emitted when the shaking effect finishes.
signal shake_finished

## The range of the shaking effect, the maximum distance in pixels the Node2D will move.
@export var shaking_range : float = 3
## The duration of the shaking effect in seconds.
@export var shaking_duration : float = 0.1
## The Node2D to shake. This could be a sprite or camera or any other Node2D.
@export var node_to_shake : Node2D = null
## The Timer to control the shaking effect length.
@export var shake_timer : Timer = null

var _is_shaking : bool = false:
	get:
		return _is_shaking
	set(value):
		_is_shaking = value
		if (!_is_shaking and node_to_shake):
			node_to_shake.position = Vector2(0, 0) # If the shaking is disabled, reset the sprite position


func _ready() -> void:
	if shake_timer:
		shake_timer.timeout.connect(_on_shake_timer_timeout)

func _process(_delta: float) -> void:
	_process_shaking()
	pass


## Shake the Node2D
func shake() -> void:
	if not node_to_shake:
		print("ShakeEffect2D: Sprite Animation is not set.")
		pass
	_is_shaking = true
	shake_timer.start(shaking_duration)


func _process_shaking() -> void:
	if _is_shaking and node_to_shake:
		var shake_position : Vector2 = Vector2(randf_range(-shaking_range, shaking_range), randf_range(-shaking_range, shaking_range))
		node_to_shake.position = shake_position

func _on_shake_timer_timeout() -> void:
	_is_shaking = false
	shake_finished.emit()