extends Node

signal finished

@export var duration: float = 1.0
@export var sprite: Sprite2D
@export var teleport_material: ShaderMaterial

@onready var audio_stream_player = $AudioStreamPlayer

var tween_obj: Tween


func play():
	sprite.material = teleport_material
	if tween_obj != null && tween_obj.is_valid():
		tween_obj.kill()
	
	play_se()
	teleport_material.set_shader_parameter("progress", 1.0)
	tween_obj = create_tween()
	tween_obj.tween_property(teleport_material, "shader_parameter/progress", 0.0, duration)
	await tween_obj.finished
	finished.emit()


func play_backwards():
	sprite.material = teleport_material
	if tween_obj != null && tween_obj.is_valid():
		tween_obj.kill()
	
	play_se()
	teleport_material.set_shader_parameter("progress", 0.0)
	tween_obj = create_tween()
	tween_obj.tween_property(teleport_material, "shader_parameter/progress", 1.0, duration)
	await tween_obj.finished
	finished.emit()


func play_se():
	await get_tree().create_timer(0.2).timeout
	audio_stream_player.play()
