extends CharacterState


func on_enter(ctx: CharacterStateContext):
	ctx.set_after_effect_playing(false)
	ctx.has_dash_momentum = false
	ctx.animation_player.play("ground_in_trap")
	ctx.character.velocity = Vector2.ZERO


func state_process(ctx: CharacterStateContext, _delta: float):
	if Input.is_action_pressed("action_main_attack"):
		ctx.action_charge()
	else:
		ctx.action_main_attack_release(true)
	
	if Input.is_action_just_pressed("action_jump"):
		next_state_name = "ground_out_trap"
