extends Node2D

@export var scroll_speed_multiplier : float = 1:
	get():
		return scroll_speed_multiplier
	set(value):
		scroll_speed_multiplier = value
		_multiply_scroll_speeds()

@export var _parallax_layers : Array[Parallax2D] = []

var _base_scroll_velocities : Array[Vector2] = []

func _ready() -> void:
	# Get all children of the node of type Parallax2D if they are not set
	if _parallax_layers.size() == 0:
		var children : Array = get_children()
		for child : Parallax2D in children:
			if child is Parallax2D:
				_parallax_layers.append(child)

	# Get the base auto scroll velocities of all parallax layers
	for layer : Parallax2D in _parallax_layers:
		_base_scroll_velocities.append(layer.autoscroll)

	# Multiply the scroll speeds
	_multiply_scroll_speeds()


func _multiply_scroll_speeds() -> void:
	if _parallax_layers.size() == 0:
		return
	
	if _base_scroll_velocities.size() == 0:
		return

	for i in range(_parallax_layers.size()):
		_parallax_layers[i].autoscroll = _base_scroll_velocities[i] * scroll_speed_multiplier
