extends VisibleOnScreenNotifier2D

enum DIRECTION{DEFAULT, FLIP}

@export var pawn_scene: PackedScene
@export var facing: bool = true
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
		var d = get_direction()
		if d.x < 0:
			enemy.turn_h()
		if d.y < 0:
			enemy.turn_v()
	
	add_child(pawn)


func get_direction() -> Vector2:
	var v = Vector2(1, 1)
	if facing:
		var player = get_tree().get_first_node_in_group("Player") as Node2D
		if player:
			# Enemies are supposed to face toward left hand side
			v.x = player.global_position.direction_to(global_position).x
	
	match direction_x:
		DIRECTION.FLIP:
			v.x *= -1
	
	match direction_y:
		DIRECTION.FLIP:
			v.y *= -1
	
	return v


func _on_screen_entered():
	spawn_children()
