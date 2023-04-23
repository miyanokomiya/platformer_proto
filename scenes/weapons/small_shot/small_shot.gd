extends StaticBody2D

@export var speed = 300
@export var flip_h: bool = false

@onready var animation_player = $AnimationPlayer
@onready var terrain_ray_cast = $TerrainRayCast
@onready var gpu_particles_2d = $GPUParticles2D
@onready var hit_se = $HitSE
@onready var blocked_se = $BlockedSE

var direction = Vector2.RIGHT
var hit = false
var blocked = false


func shoot(from: Vector2, _direction: Vector2, _rotation: bool):
	global_position = from
	rotation = _rotation
	direction = _direction
	
	if flip_h:
		scale.x *= -1
	
	animation_player.play("flying")
	gpu_particles_2d.emitting = true


func _physics_process(delta):
	if hit:
		return
	
	if terrain_ray_cast.is_colliding():
		on_hit()

	global_position += direction * speed * delta


func on_hit():
	animation_player.play("hit")
	hit = true


func _on_area_2d_body_entered(_body):
	on_hit()


func _on_hitbox_component_hit():
	hit_se.play()
	on_hit()


func _on_hitbox_component_blocked():
	blocked_se.play()
	animation_player.play("stay")
	blocked = true
	if direction.x >= 0:
		direction = direction.rotated(PI * 1.25)
	else:
		direction = direction.rotated(PI * 0.75)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
