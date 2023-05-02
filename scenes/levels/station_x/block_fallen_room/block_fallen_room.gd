extends Node2D

@export var block_scene: PackedScene
@export var play_demo: bool = false
@export var max_land_height: Node2D

@onready var fall_timer = $FallTimer
@onready var shadow_raycasts = %ShadowRaycasts
@onready var shadow_base = %ShadowBase

var finished = false


func _ready():
	shadow_base.visible = false


func activate():
	if !finished:
		fall_timer.start()


func deactivate():
	fall_timer.stop()
	finished = true


func spawn_block():
	var layer = get_tree().get_first_node_in_group("background_layer")
	layer = layer if layer else self
	var shadow_layer = get_tree().get_first_node_in_group("foreground_layer")
	shadow_layer = shadow_layer if shadow_layer else self
	
	var raycasts =  shadow_raycasts.get_children()
	if raycasts.size() == 0:
		deactivate()
		return
	
	var index = RngManager.enemy_rng.randi_range(0, raycasts.size() - 1)
	if play_demo:
		index = 3
	
	var shadow_raycast = raycasts[index] as RayCast2D
	var point = shadow_raycast.get_collision_point()
	
	if max_land_height && point.y <= max_land_height.global_position.y:
		shadow_raycasts.remove_child(shadow_raycast)
		shadow_raycast.queue_free()
		spawn_block()
		return
	
	var max_distance = shadow_raycast.target_position.y
	
	var block = block_scene.instantiate() as CharacterBody2D
	block.global_position = point + Vector2.UP * max_distance
	layer.add_child(block)
	block.velocity.y += 50
	
	var shadow = shadow_base.duplicate() as Sprite2D
	shadow.global_position = point
	shadow_layer.add_child(shadow)
	shadow.scale.x = 10.0
	shadow.visible = true
	var tween = create_tween()
	tween.tween_property(shadow, "scale:x", 48.0, 0.7)
	await tween.finished
	shadow.queue_free()


func _on_fall_timer_timeout():
	spawn_block()


func _on_room_area_body_entered(body):
	if play_demo:
		var player = body as Player
		player.switch_state("ragdoll")
		await get_tree().create_timer(2.0).timeout
		spawn_block()
		await get_tree().create_timer(2.0).timeout
		player.switch_state("ground")
		play_demo = false
		activate()
	else:
		activate()


func _on_room_area_body_exited(_body):
	deactivate()
