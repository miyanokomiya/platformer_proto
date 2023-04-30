extends Node2D
class_name ItemDropComponenet

@export var items: Array[ItemDropResource]


func try_drop():
	var item = roll()
	if !item:
		return
	
	var obj = item.item_scene.instantiate()
	var layer = get_tree().get_first_node_in_group("foreground_layer")
	if layer:
		obj.global_position = global_position
		obj.velocity = Vector2.UP * 150
		Callable(layer.add_child).call_deferred(obj)


func roll() -> ItemDropResource:
	var total_weight = 0.0
	for item in items:
		total_weight += item.weight
	
	var v = RngManager.drop_rng.randf_range(0.0, total_weight)
	var target: ItemDropResource
	for item in items:
		if v < item.weight:
			if item.item_scene:
				target = item
			break
		else:
			v -= item.weight
	
	return target
