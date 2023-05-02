extends CharacterAirState

# Turn off "can_stick_wall" in the inspector to prevent sticking wall right after jumping

@onready var timer = $Timer

var released = false


func on_enter(ctx: CharacterStateContext):
	super.on_enter(ctx)
	timer.start()
	released = false


func state_process(ctx: CharacterStateContext, delta: float):
	if !Input.is_action_pressed("action_jump"):
		released = true
	
	if timer.is_stopped():
		if released:
			# Short jump should be consistent height
			ctx.character.velocity.y = max(ctx.JUMP_VELOCITY * 0.2, ctx.character.velocity.y)
		
		next_state_name = "air"

	super.state_process(ctx, delta)
