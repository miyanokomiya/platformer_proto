extends Node
class_name CharacterStateFuctory

@export var ground_state_scene: PackedScene
@export var ground_dash_state_scene: PackedScene
@export var ground_stagger_state_scene: PackedScene
@export var air_state_scene: PackedScene
@export var air_stagger_state_scene: PackedScene
@export var wall_state_scene: PackedScene
@export var wall_kicked_scene: PackedScene
@export var jumped_scene: PackedScene
@export var ladder_state_scene: PackedScene
@export var ladder_down_state_scene: PackedScene
@export var ladder_up_state_scene: PackedScene
@export var died_scene: PackedScene
@export var cutscene_scene: PackedScene
@export var ragdoll_scene: PackedScene


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
		"jumped":
			return jumped_scene.instantiate()
		"ladder":
			return ladder_state_scene.instantiate()
		"ladder_down":
			return ladder_down_state_scene.instantiate()
		"ladder_up":
			return ladder_up_state_scene.instantiate()
		"died":
			return died_scene.instantiate()
		"cutscene":
			return cutscene_scene.instantiate()
		"ragdoll":
			return ragdoll_scene.instantiate()
		_:
			return
