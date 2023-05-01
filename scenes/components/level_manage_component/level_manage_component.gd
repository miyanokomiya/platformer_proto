extends Node

@export var player: Player


func _ready():
	player.died.connect(on_player_died)


func victory():
	player.switch_state("cutscene")
	player.animation_player.play("victory")
	await player.animation_player.animation_finished
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()


func on_player_died():
	get_tree().reload_current_scene()
