class_name CharacterStateContext

const SPEED = 110.0
const JUMP_VELOCITY = -320.0

var character: CharacterBody2D
var animation_player: AnimationPlayer

var current_direction = 1

func _init(_character: CharacterBody2D, _animation_player: AnimationPlayer):
	character = _character
	animation_player = _animation_player


func flip_character():
	character.scale.x *= -1
	current_direction *= -1
