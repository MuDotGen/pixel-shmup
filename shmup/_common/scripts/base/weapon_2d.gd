extends Node2D
class_name Weapon2D

signal _weapon_used

@export var _cooldown : float = 0.5
@export var _cooldown_timer : Timer

var _can_use : bool = true


## Setup
func _ready() -> void:
	_setup_cooldown_timer()
	
# Cooldown Timer
func _setup_cooldown_timer() -> void:
	if not _cooldown_timer:
		_cooldown_timer = Timer.new()
		_cooldown_timer.wait_time = _cooldown
		_cooldown_timer.timeout.connect(_on_cooldown_timeout)
		add_child(_cooldown_timer)

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
		if _cooldown > 0:
			_can_use = false
			_cooldown_timer.start()

		_weapon_used.emit()
		_implement_use()