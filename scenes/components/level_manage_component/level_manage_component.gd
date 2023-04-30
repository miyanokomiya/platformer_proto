extends Node

@export var player: Player


func _ready():
	player.died.connect(on_player_died)


func on_player_died():
	get_tree().reload_current_scene()
