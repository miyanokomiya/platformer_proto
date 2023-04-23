extends Area2D
class_name LadderDetectComponent

var ladder: Area2D

func _ready():
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)


func is_close_to_ladder() -> bool:
	return !!ladder


func get_ladder() -> Node2D:
	return ladder


func on_area_entered(area: Area2D):
	ladder = area


func on_area_exited(area: Area2D):
	if ladder == area:
		ladder = null
