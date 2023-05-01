extends CharacterState


func on_enter(ctx: CharacterStateContext):
	ctx.set_after_effect_playing(false)
	ctx.action_main_attack_release(true)
