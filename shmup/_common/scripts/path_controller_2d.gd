extends Path2D
class_name PathController2D

## The set speed the children follow on the path
@export var _speed: float = 100
## If there are multiple children, then each one will start to follow the path one after another with this delay
@export var _children_move_delay: float = 0.5 # In seconds
## Child nodes that will follow the path
@export var _path_children : Array[PathFollow2D] = []
## Duration of the tween for each child to follow the path
@export var _duration : float = 5.0

# TO-DO: Make this more robust, maybe based on pixel distance and progress instead of ratio
var _space_between : float = 0

# Ready
func _ready() -> void:
	# Get all children of the node of type Node2D if they are not set
	if _path_children.size() == 0:
		var children : Array = get_children()
		for child : Node2D in children:
			if child is PathFollow2D:
				_path_children.append(child)
				# When the child is destroyed, remove its reference from the list as well
	
	for child in _path_children:
		child.tree_exiting.connect(_on_child_tree_exiting.bind(child))
	
	# Start moving the children along the path
	_start_move_children_along_path()

func _start_move_children_along_path() -> void:
	if _path_children.size() == 0:
		return
	
	
	for path_child : PathFollow2D in _path_children:
		await get_tree().create_timer(_children_move_delay).timeout
		_move_child_along_path(path_child)
		_space_between += 0.1

func _move_child_along_path(path_child : PathFollow2D) -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(path_child, "progress_ratio", 1 - _space_between, _duration).set_trans(Tween.TRANS_QUAD)


func _on_child_tree_exiting(child : Node2D) -> void:
	_path_children.erase(child)
