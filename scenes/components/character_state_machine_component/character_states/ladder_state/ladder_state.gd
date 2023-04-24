extends CharacterState

@onready var begin_timer = $BeginTimer
@onready var attack_wait_timer = $AttackWaitTimer


func on_enter(ctx: CharacterStateContext):
	ctx.set_after_effect_playing(false)
	ctx.animation_player.play("ladder")
	var ladder = ctx.ladder_detect_component.get_ladder()
	if ladder:
		ctx.character.global_position.x = ladder.global_position.x
		begin_timer.start()
	else:
		next_state_name = "air"


func on_damage(_ctx: CharacterStateContext):
	next_state_name = "air_stagger"


func state_process(ctx: CharacterStateContext, _delta: float):
	if begin_timer.is_stopped() && ctx.character.is_on_floor():
		next_state_name = "ground"
		return
	
	if !ctx.ladder_detect_component.is_close_to_ladder():
		next_state_name = "air"
		return
	
	if attack_wait_timer.is_stopped():
		var direction = free_move(ctx)
		if direction < 0:
			ctx.animation_player.play("ladder")
		elif direction > 0:
			ctx.animation_player.play_backwards("ladder")
		else:
			ctx.animation_player.pause()
	else:
		ctx.character.velocity.x = 0
		ctx.character.velocity.y = 0
	
	ctx.character.move_and_slide()


func state_input(ctx: CharacterStateContext, _event: InputEvent):
	ctx.has_dash_momentum = Input.is_action_pressed("action_dash")
	
	if Input.is_action_just_pressed("action_jump"):
		if !Input.is_action_pressed("move_down"):
			ctx.character.velocity.y = ctx.JUMP_VELOCITY
			ctx.play_jump_se()
		next_state_name = "air"
	
	if Input.is_action_just_pressed("action_main_attack"):
		if ctx.current_direction * sign(Input.get_axis("move_left", "move_right")) < 0:
			ctx.flip_character()
		
		if ctx.action_main_attack():
			ctx.animation_player.play("ladder_buster")
			attack_wait_timer.start()
	
	if Input.is_action_just_released("action_main_attack"):
		if ctx.current_direction * sign(Input.get_axis("move_left", "move_right")) < 0:
			ctx.flip_character()
			
		if ctx.action_main_attack_release():
			ctx.animation_player.play("ladder_buster")
			attack_wait_timer.start()


func free_move(ctx: CharacterStateContext) -> int:
	ctx.character.velocity.x = 0
	var direction = sign(Input.get_axis("move_up", "move_down"))
	var speed = ctx.get_ladder_speed()
	if direction:
		ctx.character.velocity.y = direction * speed
	else:
		ctx.character.velocity.y = move_toward(ctx.character.velocity.y, 0, speed)
	
	return direction
