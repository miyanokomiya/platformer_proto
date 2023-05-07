extends CharacterBody2D

@export var speed: float = 100
@export var lifetime: float = 20.0

@onready var life_timer = $LifeTimer
@onready var sink_animation_player = $SinkAnimationPlayer
@onready var land_marker = $LandMarker

var land_candidate: CharacterBody2D


func _ready():
	life_timer.wait_time = lifetime
	life_timer.start()


func _physics_process(delta):
	velocity.y = lerp(velocity.y, speed, delta)
	move_and_slide()
	
	if land_candidate && land_candidate.is_on_floor() && land_candidate.global_position.y <= land_marker.global_position.y:
		landed()


func landed():
	sink_animation_player.play("sink")
	land_candidate = null


func _on_life_timer_timeout():
	queue_free()


func _on_land_area_body_entered(body):
	if body is CharacterBody2D:
		land_candidate = body


func _on_land_area_body_exited(body):
	if land_candidate == body:
		land_candidate = null
