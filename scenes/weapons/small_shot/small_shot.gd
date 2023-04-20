extends StaticBody2D

@export var speed = 300
@export var lifetime: float = 1.0
@export var flip_h: bool = false

@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer
@onready var terrain_ray_cast = $TerrainRayCast
@onready var gpu_particles_2d = $GPUParticles2D
@onready var hit_se = $HitSE

var direction = Vector2.RIGHT
var hit = false

func _ready():
	timer.timeout.connect(queue_free)


func shoot(from: Vector2, _direction: Vector2, _rotation: bool):
	timer.wait_time = lifetime
	timer.start()
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
