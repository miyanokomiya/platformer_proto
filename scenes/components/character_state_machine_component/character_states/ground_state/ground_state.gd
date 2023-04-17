extends CharacterState


func state_process(ctx: CharacterStateContext, _delta: float):
	if !ctx.character.is_on_floor():
		next_state_name = "air"
		return
		
	if free_move(ctx):
		ctx.animation_player.play("run")
	else:
		ctx.animation_player.play("idle")
	
	ctx.character.move_and_slide()


func state_input(ctx: CharacterStateContext, _event: InputEvent):
	if Input.is_action_just_pressed("action_jump"):
		ctx.character.velocity.y = ctx.JUMP_VELOCITY
		next_state_name = "air"


func free_move(ctx: CharacterStateContext) -> bool:
	var direction = sign(Input.get_axis("move_left", "move_right"))
	if direction:
		ctx.character.velocity.x = direction * ctx.SPEED
		
		if ctx.current_direction * direction < 0:
			ctx.flip_character()
	else:
		ctx.character.velocity.x = move_toward(ctx.character.velocity.x, 0, ctx.SPEED)
	
	return !!direction
