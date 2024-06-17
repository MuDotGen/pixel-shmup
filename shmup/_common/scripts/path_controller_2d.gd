extends PathFollow2D
class_name PathController2D

# TO-DO: Probably better to extend Path2D instead of PathFollow2D so that each
# child can have its own PathFollow2D node to progress along the same path.

## The set speed the children follow on the path
@export var _speed: float = 100
## If there are multiple children, then each one will start to follow the path one after another with this delay
@export var _children_move_delay: float = 0.5 # In seconds
## Child nodes that will follow the path
@export var _path_children : Array = []

# Ready
func _ready() -> void:
	# Get all children of the node of type Node2D if they are not set
	if _path_children.size() == 0:
		var children : Array = get_children()
		for child : Node2D in children:
			if child is Node2D:
				_path_children.append(child)
				child.tree_exiting.connect(_on_child_tree_exiting.bind(child))
	

# Process
func _process(delta: float) -> void:
	_process_path_follow_auto_move(delta)
	pass

func _process_path_follow_auto_move(delta: float) -> void:
	if _path_children.size() == 0:
		return
	
	progress += delta * _speed

func _on_child_tree_exiting(child : Node2D) -> void:
	_path_children.erase(child)