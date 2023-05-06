extends CharacterBody2D

@export var target: Node2D

@onready var animation = $Animation
@onready var direction_anchor = $DirectionAnchor
@onready var action_timer = %ActionTimer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum STATE{DIED, IDLE, SETUP, GROUND_THROW}
var current_state = STATE.IDLE

var normal_action_table = SemiRandomTable.new()


func _ready():
	normal_action_table.max_duplicated_count = 100
	normal_action_table.add_item(STATE.SETUP, 1.0)


func _physics_process(delta):
	match current_state:
		STATE.DIED:
			return
		STATE.IDLE:
			animation.play("idle")
			try_start_action()
			velocity.y += gravity * delta
		STATE.SETUP:
			animation.play("setup")
			velocity.y += gravity * delta
		STATE.GROUND_THROW:
			animation.play("ground_throw")
			velocity.y += gravity * delta
	
	move_and_slide()


func turn_h():
	scale.x *= -1


func face_to_target():
	var v = global_position.direction_to(target.global_position)
	var current = direction_anchor.get_global_direction()
	if v.x * current.x < 0:
		turn_h()


func try_start_action():
	if action_timer.is_stopped():
		action_timer.start()


func choose_action():
	if !target || current_state == STATE.DIED:
		return
	
	if current_state == STATE.SETUP:
		current_state = STATE.GROUND_THROW
		return
	
	var action = normal_action_table.pick(RngManager.enemy_rng.randf())
	if !action:
		return
	
	match action:
		STATE.SETUP:
			face_to_target()
	
	current_state = action


func on_ground_setup():
	choose_action()


func on_ground_throw():
	current_state = STATE.IDLE


func _on_action_timer_timeout():
	choose_action()
