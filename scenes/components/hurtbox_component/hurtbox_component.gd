extends Area2D
class_name HurtboxComponent

signal hit(hitbox_component: HitboxComponent)
signal blocked(hitbox_component: HitboxComponent)
signal denied(hitbox_component: HitboxComponent)

@export var health_component: HealthComponent
@export var invincible_time: float = 0.0
@export var invincible = false
@export var block = false
## The higher, the more difficult this hurtbox is passed through
@export var density: int = 0

@onready var timer = $Timer

var colliding_hitboxes: Array[Dictionary] = []
var minimum_cooltime = 0.0


func _ready():
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)
	timer.timeout.connect(on_timer_timeout)


func _physics_process(delta):
	minimum_cooltime -= delta
	if minimum_cooltime > 0.0:
		return
	
	for c in colliding_hitboxes:
		if c["count"] < c["hitbox"].max_hit_count:
			accept_hitbox(c["hitbox"])
			c["count"] += 1
			minimum_cooltime = 0.025


func accept_hitbox(hitbox_component: HitboxComponent):
	if block:
		hitbox_component.blocked.emit()
		blocked.emit(hitbox_component)
		check_break(hitbox_component)
		return
	
	if invincible:
		hitbox_component.denied.emit()
		denied.emit(hitbox_component)
		check_break(hitbox_component)
		return
	
	if health_component == null:
		return
	
	var damage = hitbox_component.get_damage()
	health_component.damage(damage)
	hitbox_component.hit.emit()
	check_break(hitbox_component)
	hit.emit(hitbox_component)
	
	if invincible_time > 0:
		invincible = true
		timer.wait_time = invincible_time
		timer.start()


func check_break(hitbox_component: HitboxComponent):
	if hitbox_component.density <= density:
		hitbox_component.broken.emit()


func on_area_entered(other_area: Area2D):
	if !(other_area is HitboxComponent):
		return
	
	var hitbox_component = other_area as HitboxComponent
	if hitbox_component.oneshot:
		accept_hitbox(hitbox_component)
	else:
		colliding_hitboxes.append({
			"hitbox": other_area,
			"count": 0,
		})
		colliding_hitboxes.sort_custom(func(a, b): return a["hitbox"].get_damage() >= b["hitbox"].get_damage())


func on_area_exited(other_area: Area2D):
	if !(other_area is HitboxComponent):
		return
	
	colliding_hitboxes = colliding_hitboxes.filter(func(c): return c["hitbox"] != other_area)


func on_timer_timeout():
	invincible = false
