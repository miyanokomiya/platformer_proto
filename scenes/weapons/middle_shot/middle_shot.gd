extends StaticBody2D

@export var speed = 380
@export var flip_h: bool = false

@onready var animation_player = $AnimationPlayer
@onready var terrain_ray_cast = $TerrainRayCast
@onready var gpu_particles_2d = $GPUParticles2D
@onready var hit_se = $HitSE
@onready var blocked_se = $BlockedSE
@onready var shoot_se = %ShootSE

var direction = Vector2.RIGHT
var broken = false


func shoot(from: Vector2, _direction: Vector2, _rotation: bool):
	global_position = from
	rotation = _rotation
	direction = _direction
	
	if flip_h:
		scale.x *= -1
	
	shoot_se.play()
	animation_player.play("flying")
	gpu_particles_2d.emitting = true


func _physics_process(delta):
	if broken:
		return
	
	if terrain_ray_cast.is_colliding():
		break_shot()

	global_position += direction * speed * delta


func break_shot():
	broken = true
	animation_player.play("break")


func _on_hitbox_component_hit():
	hit_se.play()


func _on_hitbox_component_blocked():
	blocked_se.play()
	break_shot()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
