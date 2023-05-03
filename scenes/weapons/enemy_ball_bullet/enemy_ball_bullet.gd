extends CharacterBody2D

@export var speed: float = 400.0
@export var gravity_rate: float = 1.0

@onready var animation_player = $AnimationPlayer
@onready var hit_se = $HitSE
@onready var blocked_se = $BlockedSE
@onready var shoot_se = %ShootSE
@onready var projectile_component: ProjectimeComponent = $ProjectileComponent

enum SHOT_STATE{DEFAULT, HIT}
var current_state = SHOT_STATE.DEFAULT


func _physics_process(delta):
	if current_state == SHOT_STATE.HIT:
		return

	projectile_component.move_and_slide(self, delta)


func shoot(from: Vector2, direction: Vector2):
	global_position = from
	projectile_component.speed = speed
	projectile_component.gravity_rate = gravity_rate
	projectile_component.angled_shoot(self, direction.angle())
	shoot_se.play()
	animation_player.play("flying")


func on_hit():
	if current_state != SHOT_STATE.DEFAULT:
		return
	
	hit_se.play()
	animation_player.play("hit")
	current_state = SHOT_STATE.HIT


func _on_hitbox_component_hit():
	on_hit()


func _on_hitbox_component_blocked():
	blocked_se.play()
	on_hit()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_land_area_body_entered(_body):
	on_hit()


func _on_health_component_died():
	on_hit()
