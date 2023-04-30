extends Resource
class_name LevelCheckpointResource

## Unique ID for each checkpoint
@export var id: String
## Smaller progress doesn't overwrite bigger one
@export var progress: int = 0
