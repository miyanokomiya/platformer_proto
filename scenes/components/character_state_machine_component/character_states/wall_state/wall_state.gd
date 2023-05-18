extends CharacterState
class_name CharacterWallState

# WHen target wall is thin (not bigger than 16px?), "back_stickable_wall_raycast" misdetects at the second frame for some reason
# Make extra frame threshold to avoid this misdetection
var uncolliding_frame = 0


func on_enter(ctx: CharacterStateContext):
	ctx.animation_player.play("wall_stick")
	if ctx.front_stickable_wall_raycast.is_colliding():
		ctx.flip_character()
	ctx.set_after_effect_playing(false)
	uncolliding_frame = 0


func on_damage(_ctx: CharacterStateContext):
	next_state_name = "air_stagger"


func state_process(ctx: CharacterStateContext, delta: float):
	var character = ctx.character
	
	if character.is_on_floor():
		next_state_name = "ground"
		return
	
	character.velocity.y = ctx.gravity * 3 * delta
	
	ctx.has_dash_momentum = Input.is_action_pressed("action_dash")
	
	if GlobalInputBuffer.is_action_pressed("action_jump"):
		ctx.character.velocity.y = ctx.JUMP_VELOCITY
		next_state_name = "wall_kicked"
	
	process_attack(ctx)
	
	var direction = free_move(ctx)
	ctx.character.move_and_slide()
	
	if ctx.back_stickable_wall_raycast.is_colliding():
		uncolliding_frame = 0
	else:
		uncolliding_frame += 1
	
	if uncolliding_frame >= 2 || direction * ctx.current_direction >= 0:
		character.velocity.y = 0
		next_state_name = "air"


func free_move(ctx: CharacterStateContext) -> int:
	var direction = sign(Input.get_axis("move_left", "move_right"))
	if direction:
		ctx.character.velocity.x = direction * ctx.SPEED
	else:
		ctx.character.velocity.x = move_toward(ctx.character.velocity.x, 0, ctx.SPEED)
	
	return direction


func is_close_to_floor() -> bool:
	return true

func process_attack(ctx: CharacterStateContext):
	if GlobalInputBuffer.is_action_pressed("action_main_attack"):
		ctx.action_main_attack()
	elif GlobalInputBuffer.is_action_pressed("action_weapon"):
		next_state_name = "wall_sword"
	
	if Input.is_action_pressed("action_main_attack"):
		ctx.action_charge()
	
	if Input.is_action_just_released("action_main_attack"):
		ctx.action_main_attack_release()
