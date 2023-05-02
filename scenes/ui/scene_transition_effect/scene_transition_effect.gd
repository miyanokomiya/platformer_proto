extends CanvasLayer

signal transition_finished

@onready var animation_player = $AnimationPlayer
@onready var color_rect = $ColorRect


func fade_in(instant = false):
	if instant:
		color_rect.modulate.a = 0.0
		transition_finished.emit()
		return
	
	animation_player.play("fade_in")
	await animation_player.animation_finished
	transition_finished.emit()


func fade_out(instant = false):
	if instant:
		color_rect.modulate.a = 1.0
		transition_finished.emit()
		return
	
	animation_player.play("fade_out")
	await animation_player.animation_finished
	transition_finished.emit()
