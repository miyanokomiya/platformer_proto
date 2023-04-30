extends PanelContainer

@export var max_value: int = 10
@export var value: int = 10

@onready var middle_texture = %MiddleTexture
@onready var bit_texture = %BitTexture

var BIT_SIZE = 2


func _ready():
	update_view()


func update_view():
	middle_texture.custom_minimum_size.y = max_value * BIT_SIZE - 1
	bit_texture.custom_minimum_size.y = value * BIT_SIZE
	bit_texture.visible = value > 0


func update_value(v: int):
	value = v
	update_view()


func update_max_value(v: int):
	max_value = v
	update_view()
