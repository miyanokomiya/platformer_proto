extends Area2D
class_name CameraBounds

@export var camera: MainCamera

@onready var bounds_area = %BoundsArea


func _ready():
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_existed)


func set_bounds():
	if !camera:
		return
	
	var bounds_center = bounds_area.global_position
	var bounds_size = (bounds_area.shape as RectangleShape2D).size
	camera.set_bounds(get_instance_id(), bounds_center, bounds_size)


func reset_bounds():
	if !camera:
		return
	
	camera.clear_limit(get_instance_id())


func on_body_entered(_body: Node2D):
	set_bounds()


func on_body_existed(_body: Node2D):
	reset_bounds()
