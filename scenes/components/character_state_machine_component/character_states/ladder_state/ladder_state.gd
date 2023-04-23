extends CharacterState

@onready var begin_timer = $BeginTimer

var can_land = false


func on_enter(ctx: CharacterStateContext):
	ctx.set_after_effect_playing(false)
	var ladder = ctx.ladder_detect_component.get_ladder()
	ctx.character.global_position.x = ladder.global_position.x
	can_land = false
	begin_timer.start()


func on_damage(_ctx: CharacterStateContext):
	next_state_name = "air_stagger"


func state_process(ctx: CharacterStateContext, _delta: float):
	if can_land && ctx.character.is_on_floor():
		next_state_name = "ground"
		return
	
	if !ctx.ladder_detect_component.is_close_to_ladder():
		next_state_name = "air"
		return
	
	if free_move(ctx):
		ctx.animation_player.play("ladder")
	else:
		ctx.animation_player.pause()
	
	ctx.character.move_and_slide()


func state_input(ctx: CharacterStateContext, _event: InputEvent):
	ctx.has_dash_momentum = Input.is_action_pressed("action_dash")
	
	if Input.is_action_just_pressed("action_jump"):
		if !Input.is_action_pressed("move_down"):
			ctx.character.velocity.y = ctx.JUMP_VELOCITY
			ctx.play_jump_se()
		next_state_name = "air"
	
	if Input.is_action_just_pressed("action_main_attack"):
		# ctx.action_main_attack()
		pass


func free_move(ctx: CharacterStateContext) -> bool:
	ctx.character.velocity.x = 0
	var direction = sign(Input.get_axis("move_up", "move_down"))
	var speed = ctx.SPEED * 0.7
	if direction:
		ctx.character.velocity.y = direction * speed
	else:
		ctx.character.velocity.y = move_toward(ctx.character.velocity.y, 0, speed)
	
	return !!direction


func _on_begin_timer_timeout():
	can_land = true
