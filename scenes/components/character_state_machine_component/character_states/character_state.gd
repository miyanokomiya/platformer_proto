extends Node
class_name CharacterState

@export var state_name = ""

var next_state_name: String


func on_enter(_ctx: CharacterStateContext):
	pass


func on_exit(_ctx: CharacterStateContext):
	pass


func state_process(_ctx: CharacterStateContext, _delta: float):
	pass


func on_damage(_ctx: CharacterStateContext):
	pass
