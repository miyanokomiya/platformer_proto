extends Node
class_name CharacterStateContext

const SPEED = 110.0
const DASH_SPEED = 220.0
const DASH_MOMENTUM = 180.0
const JUMP_VELOCITY = -320.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var jump_se: AudioStreamPlayer
@export var land_se: AudioStreamPlayer

var character: CharacterBody2D
var animation_player: AnimationPlayer
var is_close_to_floor: Callable
var is_close_to_front_wall: Callable
var is_close_to_back_wall: Callable
var after_effect_component: AfterEffectComponent

var current_direction = 1
var has_dash_momentum = false


func flip_character():
	character.scale.x *= -1
	current_direction *= -1
	after_effect_component.flip_h = !after_effect_component.flip_h


func get_move_speed() -> float:
	if has_dash_momentum:
		return DASH_MOMENTUM
	else:
		return SPEED


func wall_kicked_spped() -> float:
	if has_dash_momentum:
		return JUMP_VELOCITY * 0.75
	else:
		return JUMP_VELOCITY * 0.5


func set_after_effect_playing(value: bool):
	if !after_effect_component:
		return
	
	if value:
		after_effect_component.play()
	else:
		after_effect_component.stop()


func play_jump_se():
	if jump_se:
		jump_se.play()


func play_land_se():
	if land_se:
		land_se.play()
