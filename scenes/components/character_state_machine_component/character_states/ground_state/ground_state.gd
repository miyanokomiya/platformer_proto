extends CharacterState
class_name CharacterGroundState


func on_enter(ctx: CharacterStateContext):
	ctx.set_after_effect_playing(false)


func state_process(ctx: CharacterStateContext, _delta: float):
	if !ctx.character.is_on_floor():
		next_state_name = "air"
	
	if free_move(ctx):
		ctx.animation_player.play("run")
	else:
		ctx.animation_player.play("idle")
	
	ctx.character.move_and_slide()


func state_input(ctx: CharacterStateContext, _event: InputEvent):
	ctx.has_dash_momentum = Input.is_action_pressed("action_dash")
	
	if Input.is_action_just_pressed("action_dash"):
		next_state_name = "ground_dash"
	
	if Input.is_action_just_pressed("action_jump"):
		ctx.character.velocity.y = ctx.JUMP_VELOCITY
		ctx.play_jump_se()
	
	if Input.is_action_just_pressed("action_main_attack"):
		ctx.action_main_attack()


func free_move(ctx: CharacterStateContext) -> bool:
	var direction = sign(Input.get_axis("move_left", "move_right"))
	if direction:
		ctx.character.velocity.x = direction * ctx.SPEED
		
		if ctx.current_direction * direction < 0:
			ctx.flip_character()
	else:
		ctx.character.velocity.x = move_toward(ctx.character.velocity.x, 0, ctx.SPEED)
	
	return !!direction
