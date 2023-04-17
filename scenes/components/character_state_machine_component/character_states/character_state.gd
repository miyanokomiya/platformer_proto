extends Node
class_name CharacterState

var next_state_name: String


func on_enter(_ctx: CharacterStateContext):
	pass


func on_exit(_ctx: CharacterStateContext):
	pass


func state_input(_ctx: CharacterStateContext, _event: InputEvent):
	pass


func state_process(_ctx: CharacterStateContext, _delta: float):
	pass
