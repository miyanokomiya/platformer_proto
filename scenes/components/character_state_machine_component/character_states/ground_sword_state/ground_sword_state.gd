extends CharacterGroundState

@onready var timer = $Timer
@onready var combo_1_timer = $Combo1Timer

var dash_pressed = false
var jump_pressed = false
var sword_pressed_count = 0
var sword_count = 0
var initial_x_velocity = 0.0


func on_enter(ctx: CharacterStateContext):
	sword_count += 1
	ctx.animation_player.play("ground_sword_1")
	ctx.has_dash_momentum = false
	ctx.set_after_effect_playing(false)
	dash_pressed = false
	jump_pressed = false
	sword_pressed_count = 0
	initial_x_velocity = abs(ctx.character.velocity.x)
	combo_1_timer.start()
	init()


func init():
	timer.start()


func state_process(ctx: CharacterStateContext, delta: float):
	if Input.is_action_pressed("action_main_attack"):
		ctx.action_charge()
	else:
		ctx.action_main_attack_release(true)
	
	if !ctx.character.is_on_floor():
		next_state_name = "air"
	
	ctx.character.velocity.y += ctx.gravity * delta
	ctx.character.velocity.x = move_toward(ctx.character.velocity.x, 0, initial_x_velocity * 0.2)
	ctx.character.move_and_slide()
	
	if GlobalInputBuffer.is_action_pressed("action_dash"):
		dash_pressed = true
	
	if GlobalInputBuffer.is_action_pressed("action_jump"):
		jump_pressed = true
	
	if GlobalInputBuffer.is_action_pressed("action_weapon", false) && sword_count == 1:
		GlobalInputBuffer.consume_action("action_weapon")
		sword_pressed_count += 1
		# Override other action buffers
		dash_pressed = false
		jump_pressed = false
	
	if !timer.is_stopped():
		return
	
	if sword_pressed_count > 0 && combo_1_timer.is_stopped():
		if sword_count == 1:
			sword_count += 1
			sword_pressed_count -= 1
			ctx.animation_player.play("ground_sword_2")
			init()
			return
	
	if !ctx.animation_player.is_playing():
		next_state_name = "ground"
	
	if dash_pressed:
		next_state_name = "ground_dash"
	
	if jump_pressed:
		if Input.is_action_pressed("move_down"):
			ctx.character.set_collision_mask_value(8, false)
		else:
			ctx.character.velocity.y = ctx.JUMP_VELOCITY
			ctx.play_jump_se()
			next_state_name = "jumped"
