extends CharacterBody2D

@export var target: Node2D

@onready var body_animation = $BodyAnimation
@onready var direction_anchor = $DirectionAnchor
@onready var action_timer = %ActionTimer
@onready var ready_stinger_timer = %ReadyStingerTimer
@onready var stinger_ray_cast = %StingerRayCast
@onready var front_wall_ray_cast = %FrontWallRayCast
@onready var ceil_ray_cast = %CeilRayCast

enum STATE{\
	IDLE, DIED,\
	LEAP_FORWARD,
	WALL_STICK, CEIL_STICK,\
	STINGER, STINGER_READY, STINGER_STUCK,\
	CROSS}
var current_state = STATE.IDLE


func _physics_process(delta):
	match current_state:
		STATE.IDLE:
			body_animation.play("idle")
			if action_timer.is_stopped():
				action_timer.start()
		STATE.DIED:
			velocity = Vector2.ZERO
		STATE.LEAP_FORWARD:
			body_animation.play("air")
			move_leap_forward(delta)
		STATE.WALL_STICK:
			body_animation.play("wall_stick")
			move_wall_stick(delta)
		STATE.CEIL_STICK:
			body_animation.play("ceil_stick")
			move_ceil_stick(delta)
		STATE.STINGER:
			body_animation.play("stinger")
			move_stinger(delta)
		STATE.STINGER_READY:
			ready_stinger()
		STATE.STINGER_STUCK:
			velocity = Vector2.ZERO
	
	move_and_slide()


func turn_h():
	scale.x *= -1


func face_to_target():
	var v = global_position.direction_to(target.global_position)
	var current = direction_anchor.get_global_direction()
	if v.x * current.x < 0:
		turn_h()


func choose_action():
	if current_state == STATE.DIED:
		return
	
	current_state = STATE.LEAP_FORWARD


func move_leap_forward(_delta: float):
	if front_wall_ray_cast.is_colliding():
		turn_h()
		current_state = STATE.WALL_STICK
	elif ceil_ray_cast.is_colliding():
		face_to_target()
		current_state = STATE.CEIL_STICK
	else:
		var v = direction_anchor.get_global_direction() * 500
		v.y = -260
		velocity = v


func move_wall_stick(_delta: float):
	velocity = -direction_anchor.get_global_direction() * 100


func move_ceil_stick(_delta: float):
	velocity = Vector2.UP * 100


func move_stinger(delta: float):
	if stinger_ray_cast.is_colliding():
		velocity = Vector2.ZERO
		current_state = STATE.STINGER_STUCK
		await get_tree().create_timer(1.0).timeout
		if current_state == STATE.DIED:
			return
		
		current_state = STATE.IDLE
	else:
		velocity = velocity.lerp(direction_anchor.get_global_direction() * 1200, 4.0 * delta)


func ready_stinger():
	velocity = Vector2.ZERO
	face_to_target()
	if ready_stinger_timer.is_stopped():
		ready_stinger_timer.start()


func _on_action_timer_timeout():
	choose_action()


func _on_ready_stinger_timer_timeout():
	if current_state == STATE.DIED:
		return
	
	current_state = STATE.STINGER
