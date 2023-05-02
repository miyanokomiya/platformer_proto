extends CharacterBody2D

@export var max_speed: float = 600

@onready var animation_player = $AnimationPlayer
@onready var hit_collision = %HitCollision
@onready var body_collision = $BodyCollision
@onready var land_se = $LandSE

enum STATE{IDLE, AIR, HELD, EXPLODED, BROKEN}
var current_state = STATE.IDLE


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	match current_state:
		STATE.IDLE:
			move_and_slide()
			if is_on_floor():
				Callable(deactivate_hitbox).call_deferred()
			else:
				current_state = STATE.AIR
		STATE.AIR:
			velocity.x = 0
			velocity.y = min(max_speed, velocity.y + gravity * delta)
			move_and_slide()
			if is_on_floor():
				land_se.play()
				CameraManager.apply_noise_shake()
				current_state = STATE.IDLE
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
	body_collision.disabled = true
	hit_collision.disabled = true


func drop():
	current_state = STATE.AIR
	body_collision.disabled = false
	hit_collision.disabled = false
	velocity.y = 50


func shove(v: Vector2):
	velocity = v
	current_state = STATE.EXPLODED
	CameraManager.apply_noise_shake()


func activate_hitbox():
	hit_collision.disabled = false


func deactivate_hitbox():
	hit_collision.disabled = true


func _on_hitbox_component_hit():
	current_state = STATE.BROKEN


func _on_hitbox_component_blocked():
	current_state = STATE.BROKEN
