extends Area2D
class_name Projectile

@export var speed: float = 300
@export var direction: Vector2 = Vector2.UP

@onready var timeout: Timer = $TimeoutTimer

func _ready() -> void:
	timeout.timeout.connect(self._on_timer_timeout)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_timer_timeout() -> void:
	queue_free()
