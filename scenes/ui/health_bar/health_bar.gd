extends PanelContainer

@export var max_value: int = 10
@export var value: int = 10

@onready var middle_texture = %MiddleTexture
@onready var bit_texture = %BitTexture
@onready var damaged_bit_texture = %DamagedBitTexture
@onready var animation_player = $AnimationPlayer

var BIT_SIZE = 2


func _ready():
	update_view()


func update_view():
	middle_texture.custom_minimum_size.y = max_value * BIT_SIZE - 1
	bit_texture.custom_minimum_size.y = value * BIT_SIZE
	bit_texture.visible = value > 0


func update_value(v: int):
	if v < value:
		apply_damage(value - v)
	else:
		value = clamp(v, 0, max_value)
		update_view()


func update_max_value(v: int):
	max_value = max(0, v)
	update_view()


func apply_damage(damage: int):
	damaged_bit_texture.custom_minimum_size.y = value * BIT_SIZE
	value = clamp(value - damage, 0, max_value)
	update_view()
	animation_player.stop()
	animation_player.play("damaged")
	await animation_player.animation_finished
	damaged_bit_texture.custom_minimum_size.y = value * BIT_SIZE
