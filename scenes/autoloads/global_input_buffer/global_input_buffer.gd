extends Node

var THRESHOLD = 0.1
var input_buffers = {}


func _physics_process(delta: float):
	_update_inputs(delta)
	_detect_inputs()


func _update_inputs(delta: float):
	for key in input_buffers:
		input_buffers[key] += delta
		if input_buffers[key] > THRESHOLD:
			input_buffers.erase(key)



func _detect_inputs():
	_detect_input("action_dash")
	_detect_input("action_jump")
	_detect_input("action_main_attack")
	_detect_input("action_weapon")



func _detect_input(key: String):
	if Input.is_action_just_pressed(key):
		input_buffers[key] = 0.0


func is_action_pressed(key: String, consume = true) -> bool:
	if input_buffers.has(key):
		if consume:
			input_buffers.erase(key)
		
		return true
	else:
		return false


func consume_action(key: String):
	if input_buffers.has(key):
		input_buffers.erase(key)
