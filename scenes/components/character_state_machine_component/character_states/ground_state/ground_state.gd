extends CharacterState
class_name CharacterGroundState


func on_enter(ctx: CharacterStateContext):
	ctx.set_after_effect_playing(false)


func on_damage(_ctx: CharacterStateContext):
	next_state_name = "ground_stagger"


func state_process(ctx: CharacterStateContext, delta: float):
	if !ctx.character.is_on_floor() && !ctx.almost_floor_raycast.is_colliding():
		next_state_name = "air"
	
	if Input.is_action_pressed("move_up") && ctx.ladder_detect_component.is_close_to_ladder():
		next_state_name = "ladder"
		return
	
	ctx.character.velocity.y += ctx.gravity * delta
	if free_move(ctx):
		ctx.animation_player.play("run")
	else:
		ctx.animation_player.play("idle")
	
	ctx.has_dash_momentum = Input.is_action_pressed("action_dash")
	
	if Input.is_action_just_pressed("action_dash"):
		next_state_name = "ground_dash"
	
	if Input.is_action_just_pressed("action_jump"):
		if Input.is_action_pressed("move_down"):
			ctx.character.set_collision_mask_value(8, false)
		else:
			ctx.character.velocity.y = ctx.JUMP_VELOCITY
			ctx.play_jump_se()
			next_state_name = "jumped"
	
	if Input.is_action_just_pressed("action_main_attack"):
		ctx.action_main_attack()
	
	if Input.is_action_just_released("action_main_attack"):
		ctx.action_main_attack_release()
	
	ctx.character.move_and_slide()


func free_move(ctx: CharacterStateContext) -> bool:
	var direction = sign(Input.get_axis("move_left", "move_right"))
	if direction:
		ctx.character.velocity.x = direction * ctx.SPEED
		
		if ctx.current_direction * direction < 0:
			ctx.flip_character()
	else:
		ctx.character.velocity.x = move_toward(ctx.character.velocity.x, 0, ctx.SPEED)
	
	return !!direction
