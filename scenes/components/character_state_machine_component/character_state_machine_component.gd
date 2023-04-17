extends Node
class_name CharacterStateMachine

@export var state_context: CharacterStateContext
@export var state_fuctory: CharacterStateFuctory
@export var default_state_scene: PackedScene

var current_state: CharacterState


func _ready():
	if !state_context || !state_fuctory || !default_state_scene:
		push_error("Invalid initialization")
		return
	
	switch_state(default_state_scene.instantiate())


func _physics_process(delta):
	current_state.state_process(state_context, delta)
	state_transition()


func _input(event):
	current_state.state_input(state_context, event)
	state_transition()


func state_transition():
	if current_state.next_state_name:
		var next_state = state_fuctory.get_state(current_state.next_state_name)
		if next_state:
			switch_state(next_state)
		else:
			print_debug("Unknown state: " + current_state.next_state_name)


func switch_state(next_state: CharacterState):
	if current_state:
		current_state.on_exit(state_context)
		current_state.queue_free()
	current_state = next_state
	add_child(current_state)
	current_state.on_enter(state_context)
	
