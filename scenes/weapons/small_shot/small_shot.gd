extends StaticBody2D

@onready var animation_player = $AnimationPlayer
@onready var terrain_ray_cast = $TerrainRayCast
@onready var gpu_particles_2d = $GPUParticles2D
@onready var hit_se = $HitSE
@onready var blocked_se = $BlockedSE
@onready var shoot_se = %ShootSE
@onready var projectile_component: ProjectimeComponent = $ProjectileComponent
@onready var denied_se = $DeniedSE

enum SHOT_STATE{DEFAULT, HIT, BLOCKED}
var current_state = SHOT_STATE.DEFAULT


func _physics_process(delta):
	if current_state == SHOT_STATE.HIT:
		return
	
	if terrain_ray_cast.is_colliding():
		on_hit()

	projectile_component.move(self, delta)


func shoot(from: Vector2, direction: Vector2):
	global_position = from
	projectile_component.angled_shoot(self, direction.angle())
	shoot_se.play()
	animation_player.play("flying")
	gpu_particles_2d.emitting = true


func on_hit():
	if current_state != SHOT_STATE.DEFAULT:
		return
	
	animation_player.play("hit")
	current_state = SHOT_STATE.HIT


func _on_area_2d_body_entered(_body):
	on_hit()


func _on_hitbox_component_hit():
	hit_se.play()
	on_hit()


func _on_hitbox_component_blocked():
	if current_state != SHOT_STATE.DEFAULT:
		return
	
	blocked_se.play()
	animation_player.play("stay")
	current_state = SHOT_STATE.BLOCKED
	projectile_component.y_angled_shoot(self, -PI * 0.75)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_hitbox_component_denied():
	if current_state != SHOT_STATE.DEFAULT:
		return
	
	denied_se.play()
	on_hit()
