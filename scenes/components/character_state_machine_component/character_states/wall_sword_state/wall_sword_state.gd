extends CharacterWallState


func on_enter(ctx: CharacterStateContext):
	ctx.animation_player.play("wall_sword")


func state_process(ctx: CharacterStateContext, delta: float):
	super.state_process(ctx, delta)
	
	if next_state_name == "" && !ctx.animation_player.is_playing():
		next_state_name = "wall"


func process_attack(ctx: CharacterStateContext):
	if Input.is_action_pressed("action_main_attack"):
		ctx.action_charge()
	else:
		ctx.action_main_attack_release(true)
