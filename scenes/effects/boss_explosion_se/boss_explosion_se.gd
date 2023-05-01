extends Node

@onready var explode_se_1 = $ExplodeSE1
@onready var explode_se_2 = $ExplodeSE2
@onready var explode_se_3 = $ExplodeSE3
@onready var explode_se_4 = $ExplodeSE4
@onready var timer = $Timer

var time = 0


func _ready():
	# play()
	pass


func play():
	time = 0
	timer.start()


func step():
	if time < 20:
		if time % 5 == 0:
			explode_se_1.play()
	elif time < 30:
		if time % 3 == 0:
			explode_se_1.play()
	elif time < 35:
		if time % 3 == 0:
			explode_se_1.play()
		if time % 2 == 0:
			explode_se_2.play()
		if time % 2 == 0:
			explode_se_3.play()
	elif time < 45:
		if time % 2 == 0:
			explode_se_1.play()
		if time % 2 == 0:
			explode_se_2.play()
		if time % 1 == 0:
			explode_se_3.play()
	elif time < 60:
		if time % 2 == 0:
			explode_se_1.play()
		if time % 2 == 0:
			explode_se_2.play()
		if time % 1 == 0:
			explode_se_3.play()
		if time % 1 == 0:
			explode_se_4.play()
	else:
		timer.stop()
	
	time += 1


func _on_timer_timeout():
	step()
