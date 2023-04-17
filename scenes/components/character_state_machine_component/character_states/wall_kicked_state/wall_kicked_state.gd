extends CharacterAirState

@onready var timer = $Timer


func on_enter(_ctx: CharacterStateContext):
	timer.start()


func state_process(ctx: CharacterStateContext, delta: float):
	if next_state_name:
		return
	
	if timer.is_stopped():
		next_state_name = "air"

	super.state_process(ctx, delta)


func free_move(ctx: CharacterStateContext) -> int:
	ctx.character.velocity.x = ctx.JUMP_VELOCITY * ctx.current_direction * -0.5
	return sign(Input.get_axis("move_left", "move_right"))
