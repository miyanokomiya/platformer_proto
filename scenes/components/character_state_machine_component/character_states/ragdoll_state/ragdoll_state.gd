extends CharacterState


func on_enter(ctx: CharacterStateContext):
	ctx.set_after_effect_playing(false)
	ctx.character.velocity.x = 0
	ctx.character.velocity.y = max(0, ctx.character.velocity.y)
	ctx.action_main_attack_release(true)


func state_process(ctx: CharacterStateContext, delta: float):
	if ctx.character.is_on_floor():
		ctx.animation_player.play("idle")
	else:
		ctx.animation_player.play("jump_fall")
	
	ctx.character.velocity.y += ctx.gravity * delta
	ctx.character.move_and_slide()
