extends Node2D

signal passed(player: Player)

@onready var area_gate = $AreaGate
@onready var exit_marker = $ExitMarker

@export var flip_h: bool = false
## If supplied, make it next camera bounds during the gate's transition
@export var next_camera_bounds: CameraBounds


func _ready():
	if flip_h:
		scale.x *= -1


func unlock():
	pass


func _on_area_2d_body_entered(body):
	if not body is Player:
		return
	
	var player = body as Player
	var camera = get_viewport().get_camera_2d()
	
	get_tree().paused = true
	area_gate.unlock()
	await area_gate.unlocked
	if next_camera_bounds:
		next_camera_bounds.set_bounds()
	
	camera.process_mode = Node.PROCESS_MODE_ALWAYS
	if player.get_current_state().state_name == "ground":
		player.animation_player.process_mode  = Node.PROCESS_MODE_ALWAYS
	var tween = create_tween()
	tween.tween_property(player, "global_position", Vector2(exit_marker.global_position.x, player.global_position.y), 0.7)
	await tween.finished
	
	camera.process_mode  = Node.PROCESS_MODE_INHERIT
	player.animation_player.process_mode  = Node.PROCESS_MODE_INHERIT
	area_gate.lock()
	await area_gate.locked
	get_tree().paused = false
	passed.emit(player)
