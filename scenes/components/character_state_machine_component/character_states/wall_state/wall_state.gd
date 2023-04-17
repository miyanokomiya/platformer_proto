extends CharacterState


func on_enter(ctx: CharacterStateContext):
	ctx.animation_player.play("wall_stick")
	ctx.flip_character()


func state_process(ctx: CharacterStateContext, delta: float):
	var character = ctx.character
	
	if character.is_on_floor():
		next_state_name = "ground"
		return
	
	character.velocity.y = ctx.gravity * 3 * delta
	
	if Input.is_action_just_pressed("action_jump"):
		ctx.character.velocity.y = ctx.JUMP_VELOCITY
		next_state_name = "wall_kicked"
		return
	
	var direction = free_move(ctx)
	ctx.character.move_and_slide()
	
	if direction * ctx.current_direction >= 0:
		next_state_name = "air"


func free_move(ctx: CharacterStateContext) -> int:
	var direction = sign(Input.get_axis("move_left", "move_right"))
	if direction:
		ctx.character.velocity.x = direction * ctx.SPEED
	else:
		ctx.character.velocity.x = move_toward(ctx.character.velocity.x, 0, ctx.SPEED)
	
	return direction


func is_close_to_floor() -> bool:
	return true
