extends CharacterBody2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var hit_collision = %HitCollision


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var held = false


func _physics_process(delta):
	if held:
		return
	
	velocity.y += gravity * delta
	move_and_slide()
	if is_on_floor():
		Callable(deactivate_hitbox).call_deferred()
	else:
		Callable(activate_hitbox).call_deferred()


func grab():
	held = true
	collision_shape_2d.disabled = true
	hit_collision.disabled = true


func drop():
	held = false
	collision_shape_2d.disabled = false
	hit_collision.disabled = false
	velocity.y = 50


func shove(v: Vector2):
	velocity = v


func make_broken():
	held = true
	collision_shape_2d.disabled = true
	hit_collision.disabled = true


func activate_hitbox():
	hit_collision.disabled = false


func deactivate_hitbox():
	hit_collision.disabled = true


func _on_hitbox_component_hit():
	animation_player.play("hit")
	Callable(make_broken).call_deferred()
