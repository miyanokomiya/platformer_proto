extends Node
class_name ChargeComponent

signal charged(level: int)
signal released(level: int)

@export var charge_times: Array[float] = []

var current_timer_index = 0
var is_charging_flag = false


func _ready():
	for time in charge_times:
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = time
		timer.one_shot = true
		timer.timeout.connect(on_charged)


func get_charge_level() -> int:
	return current_timer_index


func get_max_charge_level() -> int:
	return charge_times.size()


func is_charging() -> bool:
	return is_charging_flag


func start_charge():
	if current_timer_index >= get_child_count():
		return
	
	is_charging_flag = true
	var timer = get_child(current_timer_index)
	timer.start()


func release_charge() -> int:
	var level = get_charge_level()
	current_timer_index = 0
	is_charging_flag = false
	for timer in get_children():
		(timer as Timer).stop()
	
	released.emit(level)
	return level


func on_charged():
	current_timer_index = min(current_timer_index + 1, charge_times.size())
	charged.emit(get_charge_level())
	start_charge()
