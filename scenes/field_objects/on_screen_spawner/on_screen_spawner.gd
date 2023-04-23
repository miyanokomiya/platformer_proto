extends VisibleOnScreenNotifier2D

enum DIRECTION{DEFAULT, FLIP, AUTO}

@export var pawn_scene: PackedScene
@export var direction_x: DIRECTION = DIRECTION.DEFAULT
@export var direction_y: DIRECTION = DIRECTION.DEFAULT


func _ready():
	remove_children()


func remove_children():
	for c in get_children():
		remove_child(c)
		c.queue_free()


func spawn_children():
	if get_child_count() > 0:
		return
	
	var pawn = pawn_scene.instantiate()
	if pawn is EnemyBase:
		var enemy = pawn as EnemyBase
		if direction_x == DIRECTION.FLIP:
			enemy.turn_h()
		if direction_y == DIRECTION.FLIP:
			enemy.turn_v()
	
	add_child(pawn)


func _on_screen_entered():
	spawn_children()
