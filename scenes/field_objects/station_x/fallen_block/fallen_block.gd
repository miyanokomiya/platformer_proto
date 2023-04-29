extends CharacterBody2D

@onready var collision_shape_2d = $CollisionShape2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var held = false


func _physics_process(delta):
	if held:
		return
	
	velocity.y += gravity * delta
	move_and_slide()


func grab():
	held = true
	collision_shape_2d.disabled = true


func drop():
	held = false
	collision_shape_2d.disabled = false
	velocity.y = 50
