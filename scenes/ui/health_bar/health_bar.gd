extends PanelContainer

@export var max_value: int = 6
@export var value: int = 6
@export var logo: Texture2D

@onready var middle_texture = %MiddleTexture
@onready var animation_player = $AnimationPlayer
@onready var logo_texture = %LogoTexture
@onready var damaged_bit_texture_1 = %DamagedBitTexture1
@onready var damaged_bit_texture_2 = %DamagedBitTexture2
@onready var bit_texture_1 = %BitTexture1
@onready var bit_texture_2 = %BitTexture2

var BIT_SIZE = 2
var UNIT_AMOUNT = 25


func _ready():
	if logo_texture:
		logo_texture.texture = logo
	
	update_view()


func update_view():
	middle_texture.custom_minimum_size.y = min(UNIT_AMOUNT, max_value) * BIT_SIZE - 1
	
	var v1 = min(UNIT_AMOUNT, value)
	bit_texture_1.custom_minimum_size.y = v1 * BIT_SIZE
	bit_texture_1.visible = v1 > 0
	
	var v2 = max(0, min(UNIT_AMOUNT * 2, value) - UNIT_AMOUNT)
	bit_texture_2.custom_minimum_size.y = v2 * BIT_SIZE
	bit_texture_2.visible = v2 > 0


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
	damaged_bit_texture_1.custom_minimum_size.y = min(UNIT_AMOUNT, value) * BIT_SIZE
	if damaged_bit_texture_1.custom_minimum_size.y > 0:
		damaged_bit_texture_1.visible = true
	
	damaged_bit_texture_2.custom_minimum_size.y = max(0, (min(UNIT_AMOUNT * 2, value) - UNIT_AMOUNT)) * BIT_SIZE
	if damaged_bit_texture_2.custom_minimum_size.y > 0:
		damaged_bit_texture_2.visible = true
	
	value = clamp(value - damage, 0, max_value)
	update_view()
	animation_player.stop()
	animation_player.play("damaged")
	await animation_player.animation_finished
	# Make these invisible to hide unavoidable minimum texture
	damaged_bit_texture_1.visible = false
	damaged_bit_texture_2.visible = false
