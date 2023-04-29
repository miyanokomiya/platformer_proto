extends Node2D

@export var fallen_block_scene: PackedScene

@onready var hand_l_player = %HandLPlayer
@onready var hand_r_player = %HandRPlayer
@onready var hand_l = %HandL
@onready var punch_ray_cast = %PunchRayCast
@onready var hand_r = %HandR
@onready var target_block = %TargetBlock
@onready var block_drop_marker = %BlockDropMarker
@onready var right_hand_default_marker = %RightHandDefaultMarker
@onready var action_timer = %ActionTimer


enum STATE{IDLE, LEFT_PUNCH_READY, LEFT_PUNCH, LEFT_PUNCH_BACK, RIGHT_GRAB_READY, RIGHT_BLOCK_SEEK, RIGHT_BLOCK_DROP}
var current_state = STATE.IDLE

var MAX_PUNCH_RANGE = 260
var current_punch_range = 0
var fallen_block: Node2D


func _ready():
	pass


func _physics_process(delta):
	match current_state:
		STATE.IDLE:
			hand_l_player.play("idle")
			hand_r_player.play("idle")
			if action_timer.is_stopped():
				action_timer.start()
		STATE.LEFT_PUNCH_READY:
			pass
		STATE.LEFT_PUNCH:
			if current_punch_range < MAX_PUNCH_RANGE:
				current_punch_range += 800 * delta
				hand_l.global_position.x -= 800 * delta
			else:
				stop_left_punch()
				return

			if punch_ray_cast.is_colliding():
				stop_left_punch()
				return
		STATE.LEFT_PUNCH_BACK:
			pass
		STATE.RIGHT_GRAB_READY:
			pass
		STATE.RIGHT_BLOCK_SEEK:
			seek_drop_position(delta)
			keep_fallen_block()
		STATE.RIGHT_BLOCK_DROP:
			pass


func left_punch():
	current_state = STATE.LEFT_PUNCH_READY
	current_punch_range = 0
	hand_l_player.play("punch")
	await hand_l_player.animation_finished
	current_state = STATE.LEFT_PUNCH


func left_punch_back():
	current_state = STATE.LEFT_PUNCH_BACK
	var tween = create_tween()
	tween.tween_property(hand_l, "position", Vector2(23, -15), 1.0).set_ease(Tween.EASE_IN).set_delay(1.0)
	await tween.finished
	current_state = STATE.IDLE


func stop_left_punch():
	left_punch_back()


func right_grab_block():
	current_state = STATE.RIGHT_GRAB_READY
	var tween = create_tween()
	tween.tween_property(hand_r, "global_position", target_block.global_position - Vector2(0, 24), 1.0).set_ease(Tween.EASE_IN)
	await tween.finished
	hand_r_player.play("grab_block")
	await hand_r_player.animation_finished
	
	fallen_block = fallen_block_scene.instantiate()
	var layer = get_tree().get_first_node_in_group("background_layer")
	if layer:
		layer.add_child(fallen_block)
	else:
		add_child(fallen_block)
	
	fallen_block.grab()
	right_block_seek()


func keep_fallen_block():
	if !fallen_block:
		return
	
	fallen_block.global_position = hand_r.global_position + Vector2(5, 24)


func right_block_seek():
	current_state = STATE.RIGHT_BLOCK_SEEK
	await get_tree().create_timer(3.0).timeout
	right_block_drop()


func seek_drop_position(delta: float):
	hand_r.global_position.y = lerp(hand_r.global_position.y, block_drop_marker.global_position.y, delta)
	var player = get_tree().get_first_node_in_group("Player") as Node2D
	if !player:
		return
	
	hand_r.global_position.x = lerp(hand_r.global_position.x, player.global_position.x, 2 * delta)


func right_block_drop():
	current_state = STATE.RIGHT_BLOCK_DROP
	hand_r_player.play("release_block")
	await hand_r_player.animation_finished
	fallen_block.drop()
	fallen_block = null
	var tween = create_tween()
	tween.tween_property(hand_r, "global_position", right_hand_default_marker.global_position, 1.0).set_ease(Tween.EASE_IN)
	await tween.finished
	current_state = STATE.IDLE


func _on_punch_hitbox_hit():
	stop_left_punch()


func _on_action_timer_timeout():
	if randf() < 0.5:
		right_grab_block()
	else:
		left_punch()
