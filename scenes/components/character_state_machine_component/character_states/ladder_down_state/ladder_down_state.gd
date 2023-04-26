extends CharacterState

@onready var begin_timer = $BeginTimer


func on_enter(ctx: CharacterStateContext):
	ctx.set_after_effect_playing(false)
	begin_timer.start()
	# Climb down a bit to slip throught one-way floor
	ctx.character.global_position.y += 5


func on_damage(_ctx: CharacterStateContext):
	next_state_name = "air_stagger"


func state_process(ctx: CharacterStateContext, _delta: float):
	ctx.character.velocity.x = 0
	ctx.character.velocity.y = ctx.get_ladder_speed()
	ctx.animation_player.play_backwards("ladder")
	
	if Input.is_action_just_pressed("action_jump"):
		if Input.is_action_pressed("move_down"):
			ctx.character.velocity.y = 0
		else:
			ctx.character.velocity.y = ctx.JUMP_VELOCITY
			ctx.play_jump_se()
		next_state_name = "air"
	
	ctx.character.move_and_slide()


func _on_begin_timer_timeout():
	next_state_name = "ladder"
