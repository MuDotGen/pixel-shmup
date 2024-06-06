extends Area2D

@export var shaking_range : float = 10

@onready var _impact_effect : ImpactEffect2D = $ImpactEffect2d

func _ready() -> void:
	area_entered.connect(_on_Area2D_area_entered)
	pass

func _process(_delta: float) -> void:
	pass

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("Projectiles"):
			area.queue_free()
			_impact_effect.shake() # Simply add whatever effect is available in ImpactEffect2D