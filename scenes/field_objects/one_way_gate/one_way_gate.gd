extends Node2D

@onready var area_gate = $AreaGate
@onready var exit_marker = $ExitMarker

@export var flip_h: bool = false


func _ready():
	if flip_h:
		scale.x *= -1


func unlock():
	pass


func _on_area_2d_body_entered(body):
	if not body is Player:
		return
	
	var player = body as Player
	
	get_tree().paused = true
	area_gate.unlock()
	await area_gate.unlocked
	
	if player.get_current_state().state_name == "ground":
		player.animation_player.process_mode  = Node.PROCESS_MODE_ALWAYS
	var tween = create_tween()
	tween.tween_property(player, "global_position", Vector2(exit_marker.global_position.x, player.global_position.y), 0.7)
	await tween.finished
	
	player.animation_player.process_mode  = Node.PROCESS_MODE_INHERIT
	area_gate.lock()
	await area_gate.locked
	get_tree().paused = false
