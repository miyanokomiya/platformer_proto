extends CharacterAirState


func on_enter(ctx: CharacterStateContext):
	ctx.animation_player.play("air_sword_1")


func state_process(ctx: CharacterStateContext, delta: float):
	if Input.is_action_pressed("action_main_attack"):
		ctx.action_charge()
	else:
		ctx.action_main_attack_release(true)
	
	if ctx.character.is_on_floor():
		next_state_name = "ground"
		ctx.play_land_se()
		return
	
	if Input.is_action_pressed("move_up") && ctx.ladder_detect_component.is_close_to_ladder() && ctx.character.velocity.y > ctx.JUMP_VELOCITY / 2:
		next_state_name = "ladder"
		return
	
	ctx.character.velocity.y += ctx.gravity * delta
	var direction = free_move(ctx)
	ctx.character.move_and_slide()
	
	if can_stick_wall && !ctx.is_close_to_floor.call() && direction * ctx.current_direction > 0:
		if ctx.front_stickable_wall_raycast.is_colliding():
			next_state_name = "wall"
	
	if !ctx.animation_player.is_playing():
		next_state_name = "air"
