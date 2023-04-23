extends EnemyBase

@onready var flying_timer = $FlyingTimer
@onready var player_detect_area = $PlayerDetectArea
@onready var health_component = $HealthComponent
@onready var animation_player = $AnimationPlayer

@export var h_flip: bool = false

var direction = -1
var flying_direction = 1.0
var target: Node2D
var died = false


func _ready():
	super._ready()
	flying_timer.timeout.connect(on_flying_timer_timeout)
	player_detect_area.body_entered.connect(on_player_detect_area_body_entered)
	player_detect_area.body_exited.connect(on_player_detect_area_body_exited)
	health_component.died.connect(on_died)


func turn_h():
	super.turn_h()
	direction *= -1


func _physics_process(delta):
	
	if target:
		var v = (target.global_position - global_position).normalized()
		velocity = lerp(velocity, v * 60, delta)
		if direction * v.x < 0:
			turn_h()
	
	velocity.y = lerp(velocity.y, flying_direction * 30.0, delta)
	move_and_slide()


func on_flying_timer_timeout():
	flying_direction *= -1


func on_player_detect_area_body_entered(body):
	target = body


func on_player_detect_area_body_exited(_body):
	target = null


func on_died():
	died = true
	animation_player.play("die")
