extends Area2D

var player: Player


func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)


func _physics_process(_delta):
	if !player:
		return
	
	player.instant_death()
	player = null


func on_body_entered(body: Node2D):
	if not body is Player:
		return
	
	player = body


func on_body_exited(body: Node2D):
	if body != player:
		return
	
	player = null
