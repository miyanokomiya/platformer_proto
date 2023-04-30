extends Node

signal player_current_health_changed(health: HealthResource)
signal player_max_health_changed(health: HealthResource)

@export var player_health: HealthResource


func reset_player_health():
	update_player_current_health(player_health.max_value)


func update_player_current_health(value: float):
	player_health.value = clamp(floor(value), 0, player_health.max_value)
	player_current_health_changed.emit(player_health)


func update_player_max_health(value: float):
	player_health.max_value = max(0, floor(value))
	player_current_health_changed.emit(player_health)


func bind_player_health_component(health_component: HealthComponent):
	health_component.damaged.connect(on_player_damaged)
	health_component.healed.connect(on_player_healed)
	health_component.max_health = player_health.max_value
	health_component.current_health = player_health.value


func on_player_damaged(damage_value: float):
	update_player_current_health(player_health.value - damage_value)


func on_player_healed(heal_value: float):
	update_player_current_health(player_health.value + heal_value)
