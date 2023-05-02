extends Node2D

@export var target: Node2D
@export var damage: int = 3

@onready var laser_line = %LaserLine
@onready var laser_collision = %LaserCollision
@onready var laser_ray_cast = %LaserRayCast
@onready var laser_hitbox = %LaserHitbox
@onready var laser_se = %LaserSE
@onready var hit_effect = %HitEffect
@onready var hit_particles = %HitParticles

enum STATE{STOPPED, SHOOTING}
var current_state = STATE.STOPPED


func _physics_process(_delta):
	if current_state == STATE.STOPPED:
		return
	
	move_laser()


func shoot():
	current_state = STATE.SHOOTING
	laser_hitbox.damage = damage
	laser_se.play()
	reset_posiiton()
	Callable(activate).call_deferred()


func stop():
	current_state = STATE.STOPPED
	laser_se.stop()
	hit_particles.emitting = false
	Callable(deactivate).call_deferred()


func activate():
	laser_line.visible = true
	laser_collision.disabled = false


func deactivate():
	laser_line.visible = false
	laser_collision.disabled = true


func reset_posiiton():
	laser_ray_cast.target_position = target.global_position - laser_ray_cast.global_position
	laser_line.points[1] = Vector2.DOWN
	(laser_collision.shape as SegmentShape2D).b = Vector2.DOWN


func move_laser():
	var from = laser_ray_cast.global_position
	var v = laser_ray_cast.target_position
	if laser_ray_cast.is_colliding():
		var point = laser_ray_cast.get_collision_point()
		v = point - from
		hit_effect.global_position = point
		hit_particles.emitting = true
	else:
		hit_particles.emitting = false
	
	laser_line.points[1] = v
	(laser_collision.shape as SegmentShape2D).b = v
	
	# Updating RayCast doesn't affect current collision check
	laser_ray_cast.target_position = target.global_position - laser_ray_cast.global_position
