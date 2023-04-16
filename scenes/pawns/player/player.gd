extends CharacterBody2D

@onready var animation_player = $AnimationPlayer

const SPEED = 120.0
const JUMP_VELOCITY = -300.0

enum PLAYER_STATE{GROUND, AIR}
var current_state = PLAYER_STATE.GROUND

var current_direction = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	match current_state:
		PLAYER_STATE.GROUND:
			state_process_ground(delta)
		PLAYER_STATE.AIR:
			state_process_air(delta)
	
	move_and_slide()


func free_move() -> bool:
	var direction = sign(Input.get_axis("move_left", "move_right"))
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			animation_player.play("run")
		
		if current_direction * direction < 0:
			scale.x *= -1
			
		current_direction = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	return !!direction


func state_process_ground(delta):
	if !is_on_floor():
		current_state = PLAYER_STATE.AIR
		return
	
	if Input.is_action_just_pressed("action_jump"):
		velocity.y = JUMP_VELOCITY
		state_process_air(delta)
		return
		
	if free_move():
		animation_player.play("run")
	else:
		animation_player.play("idle")


func state_process_air(delta):
	if is_on_floor():
		current_state = PLAYER_STATE.GROUND
		return
	
	velocity.y += gravity * delta
	
	if velocity.y < JUMP_VELOCITY / 8:
		animation_player.play("jump_up")
	elif velocity.y < 200:
		animation_player.play("jump_high")
	else:
		animation_player.play("jump_fall")
	
	free_move()
