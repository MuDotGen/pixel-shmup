extends Node2D
class_name SlowMotionEffect2DComponent

signal slow_motion_finished

@export var slow_motion_scale : float = 0.5
@export var slow_motion_duration : float = 1.0
@export var _slow_motion_timer : Timer = null

# Setup
func _ready() -> void:
	if _slow_motion_timer:
		_slow_motion_timer.timeout.connect(_on_slow_motion_timer_timeout)
	pass


# Public Methods
func slow_motion() -> void:
	Engine.time_scale = slow_motion_scale
	_slow_motion_timer.start(slow_motion_duration * slow_motion_scale)


# Signal Handlers
func _on_slow_motion_timer_timeout() -> void:
	Engine.time_scale = 1.0
	slow_motion_finished.emit()