extends CharacterState


func on_enter(ctx: CharacterStateContext):
	ctx.animation_player.play("wall_stick")
	ctx.flip_character()
	ctx.set_after_effect_playing(false)


func on_damage(_ctx: CharacterStateContext):
	next_state_name = "air_stagger"


func state_process(ctx: CharacterStateContext, delta: float):
	var character = ctx.character
	
	if character.is_on_floor():
		next_state_name = "ground"
		return
	
	character.velocity.y = ctx.gravity * 3 * delta
	var direction = free_move(ctx)
	ctx.character.move_and_slide()
	
	if !ctx.character.is_on_wall() || direction * ctx.current_direction >= 0:
		character.velocity.y = 0
		next_state_name = "air"


func state_input(ctx: CharacterStateContext, _event: InputEvent):
	ctx.has_dash_momentum = Input.is_action_pressed("action_dash")
	
	if Input.is_action_just_pressed("action_jump"):
		ctx.character.velocity.y = ctx.JUMP_VELOCITY
		next_state_name = "wall_kicked"
	
	if Input.is_action_just_pressed("action_main_attack"):
		ctx.action_main_attack()
	
	if Input.is_action_just_released("action_main_attack"):
		ctx.action_main_attack_release()


func free_move(ctx: CharacterStateContext) -> int:
	var direction = sign(Input.get_axis("move_left", "move_right"))
	if direction:
		ctx.character.velocity.x = direction * ctx.SPEED
	else:
		ctx.character.velocity.x = move_toward(ctx.character.velocity.x, 0, ctx.SPEED)
	
	return direction


func is_close_to_floor() -> bool:
	return true
