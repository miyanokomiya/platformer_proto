extends Area2D


func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(area: Area2D):
	pass
