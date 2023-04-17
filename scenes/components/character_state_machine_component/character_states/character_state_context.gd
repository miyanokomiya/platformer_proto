extends Node
class_name CharacterStateContext

const SPEED = 110.0
const JUMP_VELOCITY = -320.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var character: CharacterBody2D
var animation_player: AnimationPlayer
var is_close_to_floor: Callable

var current_direction = 1


func flip_character():
	character.scale.x *= -1
	current_direction *= -1
