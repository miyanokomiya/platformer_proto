extends CharacterState

@export var ground_state_scene: PackedScene

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func state_process(ctx: CharacterStateContext, delta: float):
	var character = ctx.character
	
	if character.is_on_floor():
		next_state_name = "ground"
		return
	
	character.velocity.y += gravity * delta
	
	if character.velocity.y < ctx.JUMP_VELOCITY / 8:
		ctx.animation_player.play("jump_up")
	elif character.velocity.y < 200:
		ctx.animation_player.play("jump_high")
	else:
		ctx.animation_player.play("jump_fall")
	
	free_move(ctx)
	ctx.character.move_and_slide()


func free_move(ctx: CharacterStateContext):
	var direction = sign(Input.get_axis("move_left", "move_right"))
	if direction:
		ctx.character.velocity.x = direction * ctx.SPEED
		
		if ctx.current_direction * direction < 0:
			ctx.flip_character()
	else:
		ctx.character.velocity.x = move_toward(ctx.character.velocity.x, 0, ctx.SPEED)
