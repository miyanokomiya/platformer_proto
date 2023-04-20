extends Area2D
class_name HurtboxComponent

signal hit(hitbox_component: HitboxComponent)

@export var health_component: HealthComponent
@export var invincible_time: float = 0.0

@onready var timer = $Timer

var colliding_hitboxes: Array[HitboxComponent] = []
var invincible = false


func _ready():
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)
	timer.timeout.connect(on_timer_timeout)


func _physics_process(_delta):
	for c in colliding_hitboxes:
		accept_hitbox(c)


func accept_hitbox(hitbox_component: HitboxComponent):
	if health_component == null:
		return
	
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


func on_area_entered(other_area: Area2D):
	if !(other_area is HitboxComponent):
		return
	
	var hitbox_component = other_area as HitboxComponent
	if hitbox_component.oneshot:
		accept_hitbox(hitbox_component)
	else:
		colliding_hitboxes.append(other_area as HitboxComponent)
		colliding_hitboxes.sort_custom(func(a, b): return a.get_damage() >= b.get_damage())


func on_area_exited(other_area: Area2D):
	if !(other_area is HitboxComponent):
		return
	
	colliding_hitboxes = colliding_hitboxes.filter(func(c): return c != other_area)


func on_timer_timeout():
	invincible = false
