extends CharacterBody2D

@export var target: Node2D

@onready var body_animation = $BodyAnimation
@onready var direction_anchor = $DirectionAnchor
@onready var action_timer = %ActionTimer
@onready var ready_stinger_timer = %ReadyStingerTimer
@onready var stinger_ray_cast = %StingerRayCast
@onready var front_wall_ray_cast = %FrontWallRayCast
@onready var ceil_ray_cast = %CeilRayCast
@onready var after_effect = $AfterEffect

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum STATE{\
	IDLE, DIED,\
	LEAP_FORWARD,
	WALL_STICK, CEIL_STICK,\
	AIR_RAID,\
	STINGER, STINGER_READY, STINGER_STUCK,\
	CROSS}
var current_state = STATE.IDLE

var attck_direction = Vector2.RIGHT


func _physics_process(delta):
	match current_state:
		STATE.IDLE:
			after_effect.stop()
			body_animation.play("idle")
			try_start_action()
		STATE.DIED:
			velocity = Vector2.ZERO
		STATE.LEAP_FORWARD:
			after_effect.stop()
			body_animation.play("air")
			move_leap_forward(delta)
		STATE.WALL_STICK:
			after_effect.stop()
			body_animation.play("wall_stick")
			move_wall_stick(delta)
			try_start_action()
		STATE.CEIL_STICK:
			after_effect.stop()
			body_animation.play("ceil_stick")
			move_ceil_stick(delta)
			try_start_action()
		STATE.AIR_RAID:
			after_effect.play()
			body_animation.play("air_raid")
			move_air_raid(delta)
		STATE.STINGER:
			after_effect.play()
			body_animation.play("stinger")
			move_stinger(delta)
		STATE.STINGER_READY:
			after_effect.play()
			body_animation.play("air")
			ready_stinger()
		STATE.STINGER_STUCK:
			after_effect.stop()
			velocity = Vector2.ZERO
	
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
	if current_state == STATE.DIED:
		return
	
	if current_state == STATE.CEIL_STICK:
		air_raid()
		return
	
	if current_state == STATE.WALL_STICK:
		air_raid()
		return
	
	var v = RngManager.enemy_rng.randf() * 2.0
	if v < 1.0:
		current_state = STATE.STINGER_READY
	else:
		current_state = STATE.LEAP_FORWARD


func move_leap_forward(_delta: float):
	var v = direction_anchor.get_global_direction() * 500
	v.y = -300
	velocity = v
	try_stick_tarrein()


func try_stick_tarrein() -> bool:
	if front_wall_ray_cast.is_colliding():
		turn_h()
		velocity = Vector2.ZERO
		current_state = STATE.WALL_STICK
		return true
	elif velocity.y < 0 && ceil_ray_cast.is_colliding():
		face_to_target()
		velocity = Vector2.ZERO
		current_state = STATE.CEIL_STICK
		return true
	
	return false


func move_wall_stick(_delta: float):
	velocity = -direction_anchor.get_global_direction() * 100


func move_ceil_stick(_delta: float):
	velocity = Vector2.UP * 100


func move_air_raid(delta: float):
	velocity = velocity.lerp(attck_direction * 1000, 6.0 * delta)
	if is_on_floor():
		current_state = STATE.IDLE
		velocity.x = 0
	else:
		try_stick_tarrein()


func move_stinger(delta: float):
	if stinger_ray_cast.is_colliding():
		velocity = Vector2.ZERO
		current_state = STATE.STINGER_STUCK
		await get_tree().create_timer(0.5).timeout
		if current_state == STATE.DIED:
			return
		
		current_state = STATE.IDLE
	else:
		velocity = velocity.lerp(direction_anchor.get_global_direction() * 1200, 6.0 * delta)


func air_raid():
	attck_direction = global_position.direction_to(target.global_position)
	current_state = STATE.AIR_RAID


func ready_stinger():
	velocity = Vector2.DOWN * 100
	if ready_stinger_timer.is_stopped():
		face_to_target()
		ready_stinger_timer.start()


func _on_action_timer_timeout():
	choose_action()


func _on_ready_stinger_timer_timeout():
	if current_state == STATE.DIED:
		return
	
	current_state = STATE.STINGER
