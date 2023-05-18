extends CharacterState
class_name CharacterAirState

@export var can_stick_wall: bool = true

# Keep minimum duration to pass the very floor
var passing_floor_delay = 0.05


func on_enter(ctx: CharacterStateContext):
	ctx.set_after_effect_playing(ctx.has_dash_momentum)
	passing_floor_delay = 0.1


func on_damage(_ctx: CharacterStateContext):
	next_state_name = "air_stagger"


func state_process(ctx: CharacterStateContext, delta: float):
	var character = ctx.character
	
	if !Input.is_action_pressed("move_down") || !Input.is_action_pressed("action_jump"):
		if passing_floor_delay <= 0:
			ctx.character.set_collision_mask_value(8, true)
		else:
			passing_floor_delay -= delta
	
	if character.is_on_floor():
		next_state_name = "ground"
		ctx.play_land_se()
		return
	
	if Input.is_action_pressed("move_up") && ctx.ladder_detect_component.is_close_to_ladder() && ctx.character.velocity.y > ctx.JUMP_VELOCITY / 2:
		next_state_name = "ladder"
		return
	
	character.velocity.y += ctx.gravity * delta
	
	if character.velocity.y < ctx.JUMP_VELOCITY / 8:
		ctx.animation_player.play("jump_up")
	elif character.velocity.y < 200:
		ctx.animation_player.play("jump_high")
	else:
		ctx.animation_player.play("jump_fall")
	
	var is_jump_pressed = GlobalInputBuffer.is_action_pressed("action_jump", false)
	if is_jump_pressed && ctx.is_close_to_front_wall.call():
		GlobalInputBuffer.consume_action("action_jump")
		ctx.character.velocity.y = ctx.JUMP_VELOCITY
		ctx.flip_character()
		next_state_name = "wall_kicked"
		return
	elif is_jump_pressed && ctx.is_close_to_back_wall.call():
		GlobalInputBuffer.consume_action("action_jump")
		ctx.character.velocity.y = ctx.JUMP_VELOCITY
		next_state_name = "wall_kicked"
		return
	
	if GlobalInputBuffer.is_action_pressed("action_main_attack"):
		ctx.action_main_attack()
	elif GlobalInputBuffer.is_action_pressed("action_weapon"):
		next_state_name = "air_sword"
	
	if Input.is_action_pressed("action_main_attack"):
		ctx.action_charge()
	
	if Input.is_action_just_released("action_main_attack"):
		ctx.action_main_attack_release()
	
	var direction = free_move(ctx)
	ctx.character.move_and_slide()
	
	if can_stick_wall && !ctx.is_close_to_floor.call() && direction * ctx.current_direction > 0:
		if ctx.front_stickable_wall_raycast.is_colliding():
			next_state_name = "wall"


func free_move(ctx: CharacterStateContext) -> int:
	var direction = sign(Input.get_axis("move_left", "move_right"))
	if direction:
		ctx.character.velocity.x = direction * ctx.get_move_speed()
		
		if ctx.current_direction * direction < 0:
			ctx.flip_character()
	else:
		ctx.character.velocity.x = move_toward(ctx.character.velocity.x, 0, ctx.get_move_speed())
	
	return direction
