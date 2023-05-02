extends Node2D

@export var target: Node2D
@export var activated: bool = true


func _physics_process(_delta):
	if !activated:
		return
	
	adjust_children()


func adjust_children():
	var items = get_children()
	var size = items.size()
	var from = global_position
	var to = target.global_position
	
	for i in size:
		var p = from.lerp(to, float(i) / float(size))
		items[i].global_position = p
