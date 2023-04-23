extends Node2D

@onready var top_out_area = %TopOutArea

var found_player: Player


func _ready():
	top_out_area.body_entered.connect(on_top_out_area_body_entered)
	top_out_area.body_exited.connect(on_top_out_area_body_exited)


func _physics_process(_delta):
	if !found_player:
		return
	
	if found_player.get_current_state().state_name == "ground":
		if Input.is_action_pressed("move_down"):
			found_player.global_position.x = global_position.x
			found_player.switch_state("ladder_down")
	elif found_player.get_current_state().state_name == "ladder":
		if Input.is_action_pressed("move_up") && found_player.global_position.y > global_position.y:
			found_player.switch_state("ladder_up")


func on_top_out_area_body_entered(body: Node2D):
	if !(body is Player):
		return
	
	found_player = body as Player


func on_top_out_area_body_exited(body: Node2D):
	if !(body is Player) || body != found_player:
		return
	
	found_player = null
