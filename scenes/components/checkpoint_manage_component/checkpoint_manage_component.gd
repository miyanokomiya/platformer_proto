extends Node

## This component should be initialized before the player
@export var player: Node2D


func _ready():
	var saved_checkpoint = GlobalState.level_checkpoint
	var target_checkpoint: Checkpoint
	
	for c in get_children():
		if c is Checkpoint:
			var checkpoint = c as Checkpoint
			checkpoint.activated.connect(on_checkpoint_activated)
			if saved_checkpoint && checkpoint.id == saved_checkpoint.id:
				target_checkpoint = checkpoint
	
	if target_checkpoint && player:
		player.global_position = target_checkpoint.global_position
		player.flip_h = target_checkpoint.direction == target_checkpoint.DIRECTION.LEFT


func on_checkpoint_activated(checkpoint: LevelCheckpointResource):
	var saved_checkpoint = GlobalState.level_checkpoint
	if checkpoint.progress < saved_checkpoint.progress:
		return
	
	GlobalState.update_level_checkpoint(checkpoint)
