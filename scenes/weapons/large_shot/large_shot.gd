extends StaticBody2D

@onready var animation_player = $AnimationPlayer
@onready var terrain_ray_cast = $TerrainRayCast
@onready var hit_se = $HitSE
@onready var blocked_se = $BlockedSE
@onready var shoot_se = %ShootSE
@onready var projectile_component = $ProjectileComponent
@onready var denied_se = $DeniedSE

enum SHOT_STATE{DEFAULT, HIT, BLOCKED}
var current_state = SHOT_STATE.DEFAULT


func _physics_process(delta):
	if current_state == SHOT_STATE.BLOCKED:
		return
	
	if terrain_ray_cast.is_colliding():
		break_shot()

	projectile_component.move(self, delta)


func shoot(from: Vector2, direction: Vector2):
	global_position = from
	projectile_component.angled_shoot(self, direction.angle())
	shoot_se.play()
	animation_player.play("flying")


func break_shot():
	current_state = SHOT_STATE.BLOCKED
	animation_player.play("break")


func _on_hitbox_component_hit():
	hit_se.play()


func _on_hitbox_component_blocked():
	blocked_se.play()
	break_shot()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_hitbox_component_denied():
	if current_state != SHOT_STATE.DEFAULT:
		return
	
	denied_se.play()
	animation_player.play("break")


func _on_hitbox_component_broken():
	break_shot()
