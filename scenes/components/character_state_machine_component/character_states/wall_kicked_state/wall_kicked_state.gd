extends CharacterAirState

@onready var timer = $Timer
@onready var audio_stream_player = $AudioStreamPlayer


func on_enter(ctx: CharacterStateContext):
	super.on_enter(ctx)
	audio_stream_player.play()
	timer.start()


func state_process(ctx: CharacterStateContext, delta: float):
	if timer.is_stopped():
		next_state_name = "air"
	
	if ctx.character.velocity.y >= 0:
		next_state_name = "air"

	super.state_process(ctx, delta)


func free_move(ctx: CharacterStateContext) -> int:
	ctx.character.velocity.x = ctx.wall_kicked_spped() * ctx.current_direction * -1
	return sign(Input.get_axis("move_left", "move_right"))
