extends CharacterGroundState

@onready var timer = $Timer


func on_enter(ctx: CharacterStateContext):
	timer.start()
	ctx.animation_player.play("dash")
	ctx.has_dash_momentum = true
	ctx.set_after_effect_playing(true)


func state_process(ctx: CharacterStateContext, delta: float):
	if timer.is_stopped():
		next_state_name = "ground"
		super.state_process(ctx, delta)
		return
	
	if !ctx.character.is_on_floor():
		next_state_name = "air"
	
	ctx.character.velocity.y += ctx.gravity * delta
	var direction = sign(Input.get_axis("move_left", "move_right"))
	if ctx.current_direction * direction < 0:
		next_state_name = "ground"
	
	ctx.character.velocity.x = ctx.current_direction * ctx.DASH_SPEED
	ctx.character.move_and_slide()


func state_input(ctx: CharacterStateContext, _event: InputEvent):
	if !Input.is_action_pressed("action_dash"):
		next_state_name = "ground"
		ctx.has_dash_momentum = false
	
	if Input.is_action_just_pressed("action_jump"):
		ctx.character.velocity.y = ctx.JUMP_VELOCITY
		ctx.play_jump_se()
	
	if Input.is_action_just_pressed("action_main_attack"):
		ctx.action_main_attack()
