extends CharacterGroundState

@onready var timer = $Timer


func on_enter(ctx: CharacterStateContext):
	ctx.animation_player.play("ground_sword_1")
	ctx.has_dash_momentum = false
	ctx.set_after_effect_playing(false)
	timer.start()


func state_process(ctx: CharacterStateContext, delta: float):
	if !ctx.character.is_on_floor():
		next_state_name = "air"
	
	ctx.character.velocity.y += ctx.gravity * delta
	
	if !timer.is_stopped():
		return
	
	if !ctx.animation_player.is_playing():
		next_state_name = "ground"
	
	if Input.is_action_pressed("action_dash"):
		next_state_name = "ground_dash"
	
	if Input.is_action_just_pressed("action_jump"):
		ctx.character.velocity.y = ctx.JUMP_VELOCITY
		ctx.play_jump_se()
		next_state_name = "jumped"
	
	if Input.is_action_pressed("action_main_attack"):
		ctx.action_charge()
	
	if Input.is_action_just_released("action_main_attack"):
		ctx.action_main_attack_release()
	
	ctx.character.velocity.x = move_toward(ctx.character.velocity.x, 0, ctx.SPEED)
	ctx.character.move_and_slide()
