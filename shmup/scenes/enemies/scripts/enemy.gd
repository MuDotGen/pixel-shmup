extends Area2D

@export var shaking_range : float = 10

@export var _is_shaking : bool = false:
	get:
		return _is_shaking
	set(value):
		_is_shaking = value
		if (!_is_shaking):
			_sprite_animation.position = Vector2(0, 0) # If the shaking is disabled, reset the sprite position

@onready var _sprite_animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var _shake_timer : Timer = $ShakeTimer

func _ready() -> void:
	area_entered.connect(_on_Area2D_area_entered)
	_shake_timer.timeout.connect(_on_ShakeTimer_timeout)
	pass

func shake() -> void:
	_is_shaking = true
	_shake_timer.start()


func _process(_delta: float) -> void:
	_process_shaking()
	pass

func _process_shaking() -> void:
	if _is_shaking:
		var sprite_position : Vector2 = Vector2(randf_range(-shaking_range, shaking_range), randf_range(-shaking_range, shaking_range))
		_sprite_animation.position = sprite_position

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("Projectiles"):
			area.queue_free()
			shake()

func _on_ShakeTimer_timeout() -> void:
	_is_shaking = false