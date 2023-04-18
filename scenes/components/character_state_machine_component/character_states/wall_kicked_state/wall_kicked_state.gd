extends CharacterAirState

@onready var timer = $Timer


func on_enter(ctx: CharacterStateContext):
	timer.start()
	if ctx.has_dash_momentum:
		ctx.set_after_effect_playing(true)


func state_process(ctx: CharacterStateContext, delta: float):
	if timer.is_stopped():
		next_state_name = "air"

	super.state_process(ctx, delta)


func free_move(ctx: CharacterStateContext) -> int:
	ctx.character.velocity.x = ctx.wall_kicked_spped() * ctx.current_direction * -1
	return sign(Input.get_axis("move_left", "move_right"))
