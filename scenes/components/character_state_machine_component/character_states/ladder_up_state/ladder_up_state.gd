extends CharacterState

var target_ladder


func on_enter(ctx: CharacterStateContext):
	ctx.set_after_effect_playing(false)
	target_ladder = ctx.ladder_detect_component.ladder
	if !target_ladder:
		next_state_name = "air"


func on_damage(_ctx: CharacterStateContext):
	next_state_name = "air_stagger"


func state_process(ctx: CharacterStateContext, _delta: float):
	if target_ladder != ctx.ladder_detect_component.ladder:
		next_state_name = "ground"
		ctx.character.velocity.y = 0
	
	ctx.character.velocity.x = 0
	ctx.character.velocity.y = -ctx.get_ladder_speed()
	ctx.animation_player.play("ladder")
	
	if Input.is_action_just_pressed("action_jump"):
		if !Input.is_action_pressed("move_down"):
			ctx.character.velocity.y = ctx.JUMP_VELOCITY
			ctx.play_jump_se()
		next_state_name = "air"
	
	ctx.character.move_and_slide()
