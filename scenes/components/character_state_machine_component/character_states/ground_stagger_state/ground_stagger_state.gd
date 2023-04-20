extends CharacterState

@onready var timer = $Timer


func _ready():
	timer.timeout.connect(on_timer_timeout)


func on_enter(ctx: CharacterStateContext):
	ctx.set_after_effect_playing(false)
	ctx.has_dash_momentum = false
	ctx.animation_player.play("stagger")
	timer.start()


func state_process(ctx: CharacterStateContext, _delta: float):
	ctx.character.velocity.x = -ctx.current_direction * ctx.get_stagger_speed()
	ctx.character.velocity.y = 0
	ctx.character.move_and_slide()


func on_timer_timeout():
	# The character may be in the air though, state transition should work well
	next_state_name = "ground"
