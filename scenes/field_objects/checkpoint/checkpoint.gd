extends Node2D
class_name Checkpoint

signal activated(checkpoint: LevelCheckpointResource)

enum DIRECTION{RIGHT, LEFT}

@export var id: String
@export var progress: int = 0
@export var direction: DIRECTION = DIRECTION.RIGHT


func _on_area_2d_body_entered(_body):
	var checkpoint = LevelCheckpointResource.new()
	checkpoint.id = id
	checkpoint.progress = progress
	activated.emit(checkpoint)
