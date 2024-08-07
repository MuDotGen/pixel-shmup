extends Area2D
class_name Projectile

@export var speed: float = 300
@export var direction: Vector2 = Vector2.UP

@export var _visible_on_screen_enabler_2d: VisibleOnScreenEnabler2D


func _ready() -> void:
	_visible_on_screen_enabler_2d.screen_exited.connect(_on_exit_screen)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_exit_screen() -> void:
	# TO-DO: Make use of the visible on screen enabler to pool projectiles. Return to pool instead of queue_free()
	queue_free()
