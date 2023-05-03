class_name UniqueQueue

var queue = []


func append(item):
	remove(item)
	queue.append(item)


func remove(item):
	queue = queue.filter(func(a): return a != item)
