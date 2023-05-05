class_name SemiRandomTable

# When 0, no action is supposed to be chosen twice in a row
@export var max_duplicated_count = 0

var table = []
var last_item = null
var duplicated_count = 0


func add_item(item, weight: float):
	table.append({
		"item": item,
		"weight": weight,
	})


func pick(r: float):
	return _pick(table, r)


func _pick(target_table: Array, r: float):
	
	var total_weight = 0.0
	for item_info in target_table:
		total_weight += item_info["weight"]
	
	var target_r = r * total_weight
	var v = 0.0
	var chosen_item
	for item_info in target_table:
		v += item_info["weight"]
		if target_r <= v:
			chosen_item = item_info["item"]
			break
	
	if !chosen_item:
		return null
	
	if last_item && last_item == chosen_item:
		duplicated_count += 1
	else:
		last_item = chosen_item
		duplicated_count = 0
	
	if duplicated_count > max_duplicated_count:
		var next_table = target_table.filter(func(info): return info["item"] != chosen_item)
		return _pick(next_table, r)
	else:
		return chosen_item
