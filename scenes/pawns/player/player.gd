extends CharacterBody2D

@onready var character_state_machine = $CharacterStateMachine
@onready var character_state_context = $CharacterStateContext
@onready var animation_player = $AnimationPlayer
@onready var close_floor_ray_cast = $CloseFloorRayCast
@onready var back_wall_ray_cast = $BackWallRayCast
@onready var front_wall_ray_cast = $FrontWallRayCast
@onready var after_effect_component = $AfterEffectComponent
@onready var sprite_2d = $Sprite2D
@onready var buster_texture_timer = $BusterTextureTimer
@onready var buster_direction = %BusterDirection
@onready var buster_small_se = %BusterSmallSE
@onready var footstep_se = %FootstepSE


var default_texture = preload("res://assets/sprites/aria/aria.png")
var buster_texture = preload("res://assets/sprites/aria/aria_buster.png")

@export var flip_h = false
@export var small_shot: PackedScene

func _ready():
	character_state_machine.state_changed.connect(on_state_changed)
	character_state_context.buster.connect(on_bustered)
	character_state_context.flipped.connect(on_flipped)
	buster_texture_timer.timeout.connect(on_buster_texture_timer_timeout)
	
	character_state_context.character = self
	character_state_context.animation_player = animation_player
	character_state_context.is_close_to_floor = is_close_to_floor
	character_state_context.is_close_to_front_wall = is_close_to_front_wall
	character_state_context.is_close_to_back_wall = is_close_to_back_wall
	character_state_context.after_effect_component = after_effect_component
	
	if flip_h:
		character_state_context.flip_character()


func is_close_to_floor() -> bool:
	return close_floor_ray_cast.is_colliding()


func is_close_to_front_wall() -> bool:
	return front_wall_ray_cast.is_colliding()


func is_close_to_back_wall() -> bool:
	return back_wall_ray_cast.is_colliding()


func play_footstep_se():
	footstep_se.play_random()


func on_state_changed():
	sprite_2d.texture = default_texture
	buster_texture_timer.stop()


func on_bustered():
	sprite_2d.texture = buster_texture
	buster_texture_timer.start()
	var shot = small_shot.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(shot)
	shot.flip_h = character_state_context.current_direction == -1
	shot.shoot(buster_direction.global_position, buster_direction.get_direction(), buster_direction.get_angle())
	buster_small_se.play_random()


func on_buster_texture_timer_timeout():
	sprite_2d.texture = default_texture


func on_flipped(h_flip: bool):
	buster_direction.h_flip = h_flip


func _on_hurtbox_component_hit(_hitbox_component):
	character_state_machine.on_damage()
