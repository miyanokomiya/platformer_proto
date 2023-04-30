extends StaticBody2D
class_name AreaGate

signal unlocked
signal locked

@onready var animation_player = $AnimationPlayer


func unlock():
	animation_player.play("open")
	await animation_player.animation_finished
	unlocked.emit()


func lock():
	animation_player.play("close")
	await animation_player.animation_finished
	locked.emit()
