extends Node2D
class_name Weapon2D

signal weapon_used

@export var cooldown_time : float = 0.5:
	get:
		return cooldown_time
	set(value):
		cooldown_time = value
		if _cooldown_timer != null:
			_cooldown_timer.wait_time = value

@onready var use_audio : AudioStreamPlayer2D = $ProjectileAudioStream
@onready var _cooldown_timer : Timer = $ProjectileCooldown

var _can_use : bool = true

## Setup
func _ready() -> void:
	_setup_cooldown_timer()
	_setup_use_audio()

# Cooldown Timer
func _setup_cooldown_timer() -> void:
	if not _cooldown_timer:
		_cooldown_timer = Timer.new()
		_cooldown_timer.wait_time = cooldown_time
		add_child(_cooldown_timer)
	
	_cooldown_timer.timeout.connect(_on_cooldown_timeout)

# Use Audio
func _setup_use_audio() -> void:
	if not use_audio:
		use_audio = AudioStreamPlayer2D.new()
		add_child(use_audio)

func _on_cooldown_timeout() -> void:
	_can_use = true
	pass


## Abstract Implementations in Child Classes
func _implement_use() -> void:
	pass


## Public Methods
# Use Weapon
func use() -> void:
	if _can_use:
		if cooldown_time > 0:
			_can_use = false
			_cooldown_timer.start()

		weapon_used.emit()
		_implement_use()