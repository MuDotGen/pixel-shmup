extends Node
class_name CooldownComponent
## A Component to handle a cooldown timer.
##
## Add this Component to a base Node to limit the use of a weapon or ability with a cooldown timer.

## Signal emitted when the cooldown has completed.
signal cooldown_completed

## The Timer to control the cooldown time.
@export var cooldown_timer : Timer

## The cooldown time in seconds between weapon uses. Set to 0 to disable cooldown.
var cooldown_time : float = 0.5:
	get:
		return cooldown_time
	set(value):
		cooldown_time = value
		if cooldown_timer != null:
			cooldown_timer.wait_time = value
## Read-only property to check if the weapon can be used.
var cooldown_complete : bool = true:
	get:
		return _cooldown_complete

var _cooldown_complete : bool = true:
	set(value):
		_cooldown_complete = value
		if value:
			cooldown_completed.emit()


func _ready() -> void:
	_setup_cooldown_timer()


## If the cooldown is complete, calls the provided callback function
func conditional_completed(callback : Callable) -> void:
	if cooldown_time > 0:
		if _cooldown_complete:
			_cooldown_complete = false
			cooldown_timer.start()

			callback.call()


# Cooldown Timer
func _setup_cooldown_timer() -> void:
	if not cooldown_timer:
		cooldown_timer = Timer.new()
		cooldown_timer.wait_time = cooldown_time
		cooldown_timer.one_shot = true
		add_child(cooldown_timer)
	
	cooldown_timer.timeout.connect(_on_cooldown_timeout)

func _on_cooldown_timeout() -> void:
	_cooldown_complete = true
	pass