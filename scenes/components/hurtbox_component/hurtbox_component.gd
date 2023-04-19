extends Area2D
class_name HurtboxComponent

signal hit(hitbox_component: HitboxComponent)

@export var health_component: HealthComponent
@export var invincible_time: float = 0.0

@onready var timer = $Timer

var invincible = false


func _ready():
	area_entered.connect(on_area_entered)
	timer.timeout.connect(on_timer_timeout)


func on_area_entered(other_area: Area2D):
	if health_component == null:
		return
	
	if !(other_area is HitboxComponent):
		return
	
	var hitbox_component = other_area as HitboxComponent

	if invincible:
		hitbox_component.hit.emit()
		return
	
	var damage = hitbox_component.get_damage()
	health_component.damage(damage)
	hitbox_component.hit.emit()
	hit.emit(hitbox_component)
	
	if invincible_time > 0:
		invincible = true
		timer.wait_time = invincible_time
		timer.start()


func on_timer_timeout():
	invincible = false
