extends Node
class_name CharacterStateFuctory

@export var ground_state_scene: PackedScene
@export var air_state_scene: PackedScene
@export var wall_state_scene: PackedScene
@export var wall_kicked_scene: PackedScene


func get_state(state_name: String) -> CharacterState:
	match (state_name):
		"ground":
			return ground_state_scene.instantiate()
		"air":
			return air_state_scene.instantiate()
		"wall":
			return wall_state_scene.instantiate()
		"wall_kicked":
			return wall_kicked_scene.instantiate()
		_:
			return
