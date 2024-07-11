extends Node2D
class_name ShakeEffect2DComponent

signal shake_finished

@export var shaking_range : float = 3
@export var shaking_duration : float = 0.1
@export var node_to_shake : Node2D = null
@export var _shake_timer : Timer = null

var _is_shaking : bool = false:
	get:
		return _is_shaking
	set(value):
		_is_shaking = value
		if (!_is_shaking and node_to_shake):
			node_to_shake.position = Vector2(0, 0) # If the shaking is disabled, reset the sprite position

# Setup
func _ready() -> void:
	if _shake_timer:
		_shake_timer.timeout.connect(_on_shake_timer_timeout)


# Public Methods
func shake() -> void:
	if not node_to_shake:
		print("ShakeEffect2D: Sprite Animation is not set.")
		pass
	_is_shaking = true
	_shake_timer.start(shaking_duration)


# Process Frame
func _process(_delta: float) -> void:
	_process_shaking()
	pass

func _process_shaking() -> void:
	if _is_shaking and node_to_shake:
		var shake_position : Vector2 = Vector2(randf_range(-shaking_range, shaking_range), randf_range(-shaking_range, shaking_range))
		node_to_shake.position = shake_position


# Signal Handlers
func _on_shake_timer_timeout() -> void:
	_is_shaking = false
	shake_finished.emit()