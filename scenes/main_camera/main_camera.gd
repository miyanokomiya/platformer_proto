extends Camera2D

@export var target: Node2D

var target_position = Vector2.ZERO


func _ready():
	make_current()


func _process(delta):
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 5))


func acquire_target():
	if target:
		target_position = target.global_position
