extends Area2D

signal picked(player: Player)


func _ready():
	body_entered.connect(on_body_entered)


func on_body_entered(body):
	if not body is Player:
		return
		
	picked.emit(body)
