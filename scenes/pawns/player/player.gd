extends CharacterBody2D

@onready var character_state_context = $character_state_context
@onready var animation_player = $AnimationPlayer
@onready var close_floor_ray_cast = $CloseFloorRayCast
@onready var back_wall_ray_cast = $BackWallRayCast
@onready var front_wall_ray_cast = $FrontWallRayCast

@export var h_flipped = false

func _ready():
	character_state_context.character = self
	character_state_context.animation_player = animation_player
	character_state_context.is_close_to_floor = is_close_to_floor
	character_state_context.is_close_to_front_wall = is_close_to_front_wall
	character_state_context.is_close_to_back_wall = is_close_to_back_wall
	
	if h_flipped:
		character_state_context.flip_character()


func is_close_to_floor() -> bool:
	return close_floor_ray_cast.is_colliding()


func is_close_to_front_wall() -> bool:
	return front_wall_ray_cast.is_colliding()


func is_close_to_back_wall() -> bool:
	return back_wall_ray_cast.is_colliding()
