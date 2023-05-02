extends Node

@export var player: Player

@onready var scene_transition_effect = $SceneTransitionEffect


func _ready():
	if !player:
		return
	
	scene_transition_effect.fade_out(true)
	await get_tree().create_timer(0.4).timeout
	scene_transition_effect.fade_in()
	player.died.connect(on_player_died)
	player.visible = false
	await get_tree().create_timer(0.4).timeout
	player.teleport_in()
	await get_tree().create_timer(0.05).timeout
	player.visible = true


func victory():
	player.switch_state("cutscene")
	player.animation_player.play("victory")
	await player.animation_player.animation_finished
	scene_transition_effect.fade_out()
	await scene_transition_effect.transition_finished
	get_tree().reload_current_scene()


func on_player_died():
	scene_transition_effect.fade_out()
	await scene_transition_effect.transition_finished
	get_tree().reload_current_scene()
