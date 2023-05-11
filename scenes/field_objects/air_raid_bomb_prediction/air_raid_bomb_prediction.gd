extends Node2D

enum DIRECTION{DOWN = 0, LEFT = 1, RIGHT = 2}

@export var direction: DIRECTION = DIRECTION.DOWN

@onready var sprite_2d = $Sprite2D
@onready var terrain_ray_cast = %TerrainRayCast
@onready var animation_player = $AnimationPlayer


func _ready():
	match direction:
		DIRECTION.LEFT:
			animation_player.play("left")
			terrain_ray_cast.rotate(PI / 4)
		DIRECTION.RIGHT:
			animation_player.play("right")
			terrain_ray_cast.rotate(-PI / 4)
		_:
			animation_player.play("down")


func _physics_process(_delta):
	update_position()


func update_position():
	if !terrain_ray_cast.is_colliding():
		return
	
	var point = terrain_ray_cast.get_collision_point()
	sprite_2d.global_position = point


func _on_timer_timeout():
	queue_free()
