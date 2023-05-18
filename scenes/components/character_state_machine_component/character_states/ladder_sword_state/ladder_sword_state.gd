extends CharacterState


func on_enter(ctx: CharacterStateContext):
	ctx.set_after_effect_playing(false)
	ctx.character.velocity = Vector2.ZERO
	ctx.animation_player.play("ladder_sword")


func on_damage(_ctx: CharacterStateContext):
	next_state_name = "air_stagger"


func state_process(ctx: CharacterStateContext, _delta: float):
	if GlobalInputBuffer.is_action_pressed("action_jump"):
		if !Input.is_action_pressed("move_down"):
			ctx.character.velocity.y = ctx.JUMP_VELOCITY
			ctx.play_jump_se()
		next_state_name = "air"
	
	if Input.is_action_pressed("action_main_attack"):
		ctx.action_charge()
	else:
		ctx.action_main_attack_release(true)
	
	ctx.character.move_and_slide()
	
	if next_state_name == "" && !ctx.animation_player.is_playing():
		next_state_name = "ladder"
