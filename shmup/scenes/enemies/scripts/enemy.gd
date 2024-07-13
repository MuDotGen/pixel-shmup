extends Area2D

## Signal called when the enemy's hp hits zero
signal enemy_hp_reduced_to_zero
## Signal called when the enemy dies and is gone (just before being destroyed)
signal enemy_died

@export var _collision_shape: CollisionShape2D

## Add a ShakeEffect2DComponent for when the enemy takes damage
@export var _shake_effect_2d_component: ShakeEffect2DComponent

## Add a HealthComponent for the enemy
@export var _health_component: HealthComponent

## Add a Label to display the enemy's hp
@export var _hp_label: Label

## Add a Death2DComponent for the enemy to handle death animations and sfx
@export var _death_2d_component : Death2DComponent


@onready var _damage_sfx_player: AudioStreamPlayer2D = $DamageSFXPlayer
# @onready var _explosion_sfx_player: AudioStreamPlayer2D = $ExplosionSFXPlayer
@onready var _enemy_sprite: AnimatedSprite2D = $EnemySprite
# @onready var _death_animation: AnimatedSprite2D = $DeathAnimation

func _ready() -> void:
	area_entered.connect(_on_Area2D_area_entered)
	_death_2d_component.death_animation_finished.connect(_on_death_animation_finished)
	
	_setup_health_component()


func _setup_health_component() -> void:
	if _health_component and _hp_label:
		_health_component.hp_reduced.connect(func(_damage: int) -> void:
			_hp_label.text = str(_health_component.current_hp)
		)

		_health_component.hp_restored.connect(func(_heal: int) -> void:
			_hp_label.text = str(_health_component.current_hp)
			_hp_label.add_theme_color_override("max_color", Color(0, 1, 0)) # Sets the color of the label to green when the hp is max
		)

		_health_component.hp_changed.connect(func(new_hp: int, _old_hp: int) -> void:
			if new_hp <= 0:
				if _collision_shape:
					_collision_shape.queue_free()
				enemy_hp_reduced_to_zero.emit()
				print("HP REDUCED TO ZERO")
				print(_death_2d_component)
				if _death_2d_component:
					print("CALLING DEATH")
					_death_2d_component.die()
				
			if new_hp == 0:
				_hp_label.set("theme_override_colors/font_color", Color(1, 0, 0)) # Sets the color of the label to red when the hp is 0
			elif new_hp == _health_component.max_hp:
				_hp_label.set("theme_override_colors/font_color", Color(0, 1, 0)) # Sets the color of the label to green when the hp is max
			else:
				_hp_label.set("theme_override_colors/font_color", Color(1, 1, 1)) # Sets the color of the label to white when the hp is between 0 and max
		)

	# Set a timer to loop and attack
	var attack_timer: Timer = Timer.new()
	add_child(attack_timer)
	attack_timer.set_wait_time(5)
	attack_timer.set_one_shot(false)
	attack_timer.timeout.connect(_attack)
	attack_timer.start()

func _process(_delta: float) -> void:
	pass

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("Projectiles"):
			area.queue_free()
			_take_damage(10)

func _attack() -> void:
	_enemy_sprite.play("attack1")
	_enemy_sprite.animation_finished.connect(func() -> void:
		_enemy_sprite.play("idle")
	)
	pass

func _take_damage(damage_amount: int) -> void:
	_health_component.take_damage(damage_amount)
	_damage_sfx_player.pitch_scale = randf_range( - 0.3, 0.3) + 0.3 + (1 - float(_health_component.current_hp) / float(_health_component.max_hp))
	_damage_sfx_player.play()

	if _shake_effect_2d_component:
		_shake_effect_2d_component.shake() # Simply add whatever effect is available in ImpactEffect2D

# func _play_death_animation() -> void:
# 	# Hide the enemy sprite mid explosion animation
# 	_death_animation.frame_changed.connect(func() -> void:
# 		if _death_animation.frame == 3:
# 			_enemy_sprite.hide()
# 	)
	
# 	# Ensure the AnimatedSprite2D is visible
# 	_death_animation.show()
	
# 	# Play the animation
# 	_death_animation.play("explosion")

# 	# Play the explosion sfx
# 	_explosion_sfx_player.pitch_scale = randf_range( - 0.5, 0.5) + 1
# 	_explosion_sfx_player.play()

func _on_death_animation_finished() -> void:
	enemy_died.emit()
	queue_free()