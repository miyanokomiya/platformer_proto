extends CharacterGroundState

@onready var timer = $Timer

var dash_pressed = false
var jump_pressed = false
var initial_x_velocity = 0.0


func on_enter(ctx: CharacterStateContext):
	ctx.animation_player.play("ground_sword_1")
	ctx.has_dash_momentum = false
	ctx.set_after_effect_playing(false)
	timer.start()
	dash_pressed = false
	jump_pressed = false
	initial_x_velocity = abs(ctx.character.velocity.x)


func state_process(ctx: CharacterStateContext, delta: float):
	if Input.is_action_pressed("action_main_attack"):
		ctx.action_charge()
	
	if Input.is_action_just_released("action_main_attack"):
		ctx.action_main_attack_release()
	
	if !ctx.character.is_on_floor():
		next_state_name = "air"
	
	ctx.character.velocity.y += ctx.gravity * delta
	ctx.character.velocity.x = move_toward(ctx.character.velocity.x, 0, initial_x_velocity * 0.2)
	ctx.character.move_and_slide()
	
	if Input.is_action_just_pressed("action_dash"):
		dash_pressed = true
	
	if Input.is_action_just_pressed("action_jump"):
		jump_pressed = true
	
	if !timer.is_stopped():
		return
	
	if !ctx.animation_player.is_playing():
		next_state_name = "ground"
	
	if dash_pressed:
		next_state_name = "ground_dash"
	
	if jump_pressed:
		if Input.is_action_pressed("move_down"):
			ctx.character.set_collision_mask_value(8, false)
		else:
			ctx.character.velocity.y = ctx.JUMP_VELOCITY
			ctx.play_jump_se()
			next_state_name = "jumped"
