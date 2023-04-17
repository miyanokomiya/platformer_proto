extends CharacterBody2D

@onready var character_state_context = $character_state_context
@onready var animation_player = $AnimationPlayer
@onready var close_floor_ray_cast = $CloseFloorRayCast


func _ready():
	character_state_context.character = self
	character_state_context.animation_player = animation_player
	character_state_context.is_close_to_floor = is_close_to_floor


func is_close_to_floor() -> bool:
	return close_floor_ray_cast.is_colliding()
