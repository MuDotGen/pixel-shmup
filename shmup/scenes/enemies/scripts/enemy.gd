extends Area2D

@export var shaking_range : float = 10

@onready var _collision_shape : CollisionShape2D = $CollisionShape2D
@onready var _impact_effect : ImpactEffect2D = $ImpactEffect2D
@onready var _damageable : Damageable = $Damageable
@onready var _hp_label : Label = $HPLabel
@onready var _damage_sfx_player : AudioStreamPlayer2D = $DamageSFXPlayer

func _ready() -> void:
	area_entered.connect(_on_Area2D_area_entered)

	# DEBUG: This is a test code to see if the heal effect works
	# var repeat : Timer = Timer.new()
	# add_child(repeat)
	# repeat.set_wait_time(2)
	# repeat.set_one_shot(false)
	# repeat.timeout.connect(func() -> void:
	# 	_impact_effect.shake()
	# 	_damageable.heal(5)
	# )
	# repeat.start()

	_damageable.hp_reduced.connect(func(_damage: int) -> void:
		_hp_label.text = str(_damageable.current_hp)
	)

	_damageable.hp_restored.connect(func(_heal: int) -> void:
		_hp_label.text = str(_damageable.current_hp)
		_hp_label.add_theme_color_override("max_color", Color(0, 1, 0)) # Sets the color of the label to green when the hp is max
	)

	_damageable.hp_changed.connect(func(new_hp: int, _old_hp: int) -> void:
		if new_hp <= 0:
			_collision_shape.queue_free()
			var death_timer : Timer = Timer.new()
			add_child(death_timer)
			death_timer.set_wait_time(1)
			death_timer.set_one_shot(true)
			death_timer.timeout.connect(func() -> void:
				queue_free()
			)
			death_timer.start()

			
		if new_hp == 0:
			_hp_label.set("theme_override_colors/font_color", Color(1, 0, 0)) # Sets the color of the label to red when the hp is 0
		elif new_hp == _damageable.max_hp:
			_hp_label.set("theme_override_colors/font_color", Color(0, 1, 0)) # Sets the color of the label to green when the hp is max
		else:
			_hp_label.set("theme_override_colors/font_color", Color(1, 1, 1)) # Sets the color of the label to white when the hp is between 0 and max
	)

func _process(_delta: float) -> void:
	pass

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("Projectiles"):
			area.queue_free()
			_take_damage(10)

func _take_damage(damage_amount : int) -> void:
	_damageable.take_damage(damage_amount)
	_damage_sfx_player.pitch_scale = randf_range(-0.3, 0.3) + 0.3 + (1 - float(_damageable.current_hp) / float(_damageable.max_hp))
	_damage_sfx_player.play()
	_impact_effect.shake() # Simply add whatever effect is available in ImpactEffect2D