extends CharacterBody2D

@onready var ground_detector = %GroundDetector
@onready var wall_detector = %WallDetector
@onready var animation_player = $AnimationPlayer
@onready var activate_timer = $"../../ActivateTimer"
@onready var health_component = $HealthComponent

@export var h_flip: bool = false

var speed = 30.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1
var activated = false
var died = false


func _ready():
	health_component.died.connect(on_died)
	activate_timer.timeout.connect(on_activate_timer_timeout)
	activate_timer.start()
	if h_flip:
		scale.x *= -1
		direction *= -1


func _physics_process(delta):
	if died:
		return
	
	velocity.y += gravity
	
	if activated:
		if ground_detector.is_colliding() && !wall_detector.is_colliding():
			animation_player.play("walk")
			velocity.x = direction * lerp(abs(velocity.x), speed, delta * speed)
		else:
			velocity.x = 0
			stop_and_turn()
	
	move_and_slide()


func stop_and_turn():
	activated = false
	animation_player.play("idle")
	await get_tree().create_timer(2).timeout
	scale.x *= -1
	direction *= -1
	activated = true


func on_activate_timer_timeout():
	activated = true


func on_died():
	died = true
	animation_player.play("die")
