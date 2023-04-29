extends CharacterBody2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var hit_collision = %HitCollision

enum STATE{IDLE, HELD, EXPLODED, BROKEN}
var current_state = STATE.IDLE


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	match current_state:
		STATE.IDLE:
			velocity.x = 0
			velocity.y += gravity * delta
			move_and_slide()
			if is_on_floor():
				Callable(deactivate_hitbox).call_deferred()
			else:
				Callable(activate_hitbox).call_deferred()
		STATE.HELD:
			return
		STATE.EXPLODED:
			animation_player.play("explode")
			move_and_slide()
			return
		STATE.BROKEN:
			animation_player.play("hit")
			return


func grab():
	current_state = STATE.HELD
	collision_shape_2d.disabled = true
	hit_collision.disabled = true


func drop():
	current_state = STATE.IDLE
	collision_shape_2d.disabled = false
	hit_collision.disabled = false
	velocity.y = 50


func shove(v: Vector2):
	velocity = v
	current_state = STATE.EXPLODED


func activate_hitbox():
	hit_collision.disabled = false


func deactivate_hitbox():
	hit_collision.disabled = true


func _on_hitbox_component_hit():
	current_state = STATE.BROKEN


func _on_hitbox_component_blocked():
	current_state = STATE.BROKEN
