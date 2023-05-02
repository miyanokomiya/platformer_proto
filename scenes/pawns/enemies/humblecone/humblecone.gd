extends EnemyBase

@export var shot_scene: PackedScene

@onready var player_detect_area = $PlayerDetectArea
@onready var animation_player = $AnimationPlayer
@onready var health_component = $HealthComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var block_timer = $BlockTimer
@onready var item_drop_component = $ItemDropComponent
@onready var direction_anchor = $DirectionAnchor

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_detected = false
var blocked = false
var died = false


func _ready():
	super._ready()
	health_component.died.connect(on_died)
	block_timer.timeout.connect(on_block_timer_timeout)


func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()


func start_block():
	if !player_detected || blocked:
		return
	
	start_invicible()
	animation_player.play("block")
	block_timer.start()


func start_invicible():
	hurtbox_component.block = true
	blocked = true


func end_invicible():
	hurtbox_component.block = false
	blocked = false


func shoot():
	var layer = get_tree().get_first_node_in_group("foreground_layer")
	if !layer:
		return
	
	var shot1 = shot_scene.instantiate()
	var shot2 = shot_scene.instantiate()
	layer.add_child(shot1)
	layer.add_child(shot2)
	
	var direction = direction_anchor.get_global_direction()
	shot1.shoot(direction_anchor.global_position, direction)
	shot2.shoot(direction_anchor.global_position, direction + Vector2.UP / 2.0)


func _on_player_detect_area_body_entered(_body):
	player_detected = true
	start_block()


func _on_player_detect_area_body_exited(_body):
	player_detected = false


func on_died():
	item_drop_component.try_drop()
	died = true
	animation_player.play("die")


func _on_hurtbox_component_blocked(_hitbox_component):
	block_timer.start()


func on_block_timer_timeout():
	end_invicible()
	animation_player.play("unblock")
	await animation_player.animation_finished
	start_block()
