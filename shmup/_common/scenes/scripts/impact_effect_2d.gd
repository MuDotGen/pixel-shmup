extends Node2D
class_name ImpactEffect2D

signal shake_finished
signal slow_motion_finished

@export_group("Shake")
@export var shaking_range : float = 3
@export var shaking_duration : float = 0.1
@export var node_to_shake : Node2D = null

@onready var _shake_timer : Timer = $ShakeTimer

var _is_shaking : bool = false:
	get:
		return _is_shaking
	set(value):
		_is_shaking = value
		if (!_is_shaking and node_to_shake):
			node_to_shake.position = Vector2(0, 0) # If the shaking is disabled, reset the sprite position


@export_group("Slow Motion")
@export var slow_motion_scale : float = 0.5
@export var slow_motion_duration : float = 1.0

@onready var _slow_motion_timer : Timer = $SlowMotionTimer

func _ready() -> void:
	_shake_timer.timeout.connect(_on_ShakeTimer_timeout)
	_slow_motion_timer.timeout.connect(_on_SlowMotionTimer_timeout)
	pass

func shake() -> void:
	if not node_to_shake:
		print("ImpactEffect2D: Sprite Animation is not set.")
		pass
	_is_shaking = true
	_shake_timer.start(shaking_duration)

func slow_motion() -> void:
	Engine.time_scale = slow_motion_scale
	_slow_motion_timer.start(slow_motion_duration * slow_motion_scale)

func _process(_delta: float) -> void:
	_process_shaking()
	pass

func _process_shaking() -> void:
	if _is_shaking and node_to_shake:
		var shake_position : Vector2 = Vector2(randf_range(-shaking_range, shaking_range), randf_range(-shaking_range, shaking_range))
		node_to_shake.position = shake_position

func _on_ShakeTimer_timeout() -> void:
	_is_shaking = false
	shake_finished.emit()

func _on_SlowMotionTimer_timeout() -> void:
	Engine.time_scale = 1.0
	slow_motion_finished.emit()


# Screen Flash: Briefly flash the screen or part of the screen with a bright color (usually white or red) to indicate a hit or impact.

# Hit Sparks: Display sparks or small explosion effects at the point of impact.

# Screen Shake: Already mentioned, but consider varying the intensity and duration based on the severity of the impact.

# Damage Numbers: Show floating damage numbers that appear and then fade or move upward when an enemy is hit.

# Particle Effects: Use particles to simulate debris, dust, or blood splatter at the point of impact.

# Slow Motion: Temporarily slow down time to emphasize the impact, then gradually return to normal speed.

# Blur Effect: Apply a motion blur effect to the impacted area or the whole screen to simulate the force of the hit.

# Color Shift: Change the color of the impacted character or object briefly to indicate damage (e.g., a red tint).

# Shake with Distortion: Combine a shake with a distortion effect, such as a wave or ripple, to emphasize the impact.

# Screen Crack: Show a crack effect on the screen for very powerful impacts, as if the screen itself is cracking.

# Sound Effects: Accompany visual effects with impactful sound effects for added emphasis.

# Camera Zoom: Briefly zoom the camera in or out to emphasize the impact.

# Hit Pause: Add a very brief pause (a few frames) at the moment of impact to make the hit feel more powerful.

# Directional Impact Indicators: Show visual indicators (arrows, lines) around the screen's edge to indicate the direction of the impact.
