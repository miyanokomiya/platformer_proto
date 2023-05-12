extends CharacterState


func on_enter(ctx: CharacterStateContext):
	ctx.animation_player.play("ground_out_trap")


func state_process(ctx: CharacterStateContext, _delta: float):
	if Input.is_action_pressed("action_main_attack"):
		ctx.action_charge()
	else:
		ctx.action_main_attack_release(true)
	
	if !ctx.animation_player.is_playing():
		next_state_name = "ground"
