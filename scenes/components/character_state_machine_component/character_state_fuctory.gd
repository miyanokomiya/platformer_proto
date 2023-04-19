extends Node
class_name CharacterStateFuctory

@export var ground_state_scene: PackedScene
@export var ground_dash_state_scene: PackedScene
@export var ground_stagger_state_scene: PackedScene
@export var air_state_scene: PackedScene
@export var air_stagger_state_scene: PackedScene
@export var wall_state_scene: PackedScene
@export var wall_kicked_scene: PackedScene


func get_state(state_name: String) -> CharacterState:
	match (state_name):
		"ground":
			return ground_state_scene.instantiate()
		"ground_dash":
			return ground_dash_state_scene.instantiate()
		"ground_stagger":
			return ground_stagger_state_scene.instantiate()
		"air":
			return air_state_scene.instantiate()
		"air_stagger":
			return air_stagger_state_scene.instantiate()
		"wall":
			return wall_state_scene.instantiate()
		"wall_kicked":
			return wall_kicked_scene.instantiate()
		_:
			return
