extends Node2D

enum SIZE{LARGE, MIDDLE}

@export var auto_start: bool = true
@export var size: SIZE = SIZE.MIDDLE

@onready var animation_player = $AnimationPlayer


func _ready():
	if auto_start:
		play()
	else:
		stop()


func play():
	if size:
		animation_player.play("flash_middle")
	else:
		animation_player.play("flash")


func stop():
	animation_player.play("stop")
