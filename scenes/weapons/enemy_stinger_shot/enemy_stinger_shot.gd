extends StaticBody2D

@onready var animation_player = $AnimationPlayer
@onready var terrain_ray_cast = %TerrainRayCast
@onready var hit_se = $HitSE
@onready var blocked_se = $BlockedSE
@onready var shoot_se = %ShootSE
@onready var projectile_component: ProjectimeComponent = $ProjectileComponent
@onready var sprite_2d = $Sprite2D

enum SHOT{IDLE, FLYING, HIT, BLOCKED, STUCK, STUCK_EXPLODED}
var current_state = SHOT.IDLE


func _physics_process(delta):
	match current_state:
		SHOT.IDLE:
			return
		SHOT.FLYING:
			projectile_component.move(self, delta)
			if terrain_ray_cast.is_colliding():
				current_state = SHOT.STUCK
			return
		SHOT.HIT:
			return
		SHOT.BLOCKED:
			return
		SHOT.STUCK:
			animation_player.play("stuck")
			return
		SHOT.STUCK_EXPLODED:
			animation_player.play("stuck_explode")
			return


func spawn(from: Vector2, direction: Vector2):
	global_position = from
	projectile_component.angled_shoot(self, direction.angle())
	update_sprite_frame(direction)
	shoot_se.play()


func shoot():
	animation_player.play("flying")
	current_state = SHOT.FLYING


func update_sprite_frame(direction: Vector2):
	var v = Vector2(abs(direction.x), direction.y)
	var rounded = snapped(rad_to_deg(v.angle()) * 10, 225)
	sprite_2d.frame = (rounded + 900) / 225
	terrain_ray_cast.rotation = deg_to_rad(rounded / 10.0)


func on_hit():
	if current_state != SHOT.FLYING:
		return
	
	current_state = SHOT.HIT
	queue_free()


func _on_hitbox_component_hit():
	hit_se.play()
	on_hit()


func _on_hitbox_component_blocked():
	if current_state != SHOT.FLYING:
		return
	
	blocked_se.play()
	current_state = SHOT.BLOCKED
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_stuck_switch_area_body_entered(_body):
	current_state = SHOT.STUCK_EXPLODED


func _on_time_disappear_component_timeout():
	queue_free()
