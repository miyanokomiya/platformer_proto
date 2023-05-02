extends Node

enum HEALTH_CHANGED_ACTION{NONE=0, DAMAGED=1, HEALED=2}

signal player_current_health_changed(health: HealthResource, action: HEALTH_CHANGED_ACTION)
signal player_max_health_changed(health: HealthResource)

@export var player_health: HealthResource
@export var level_checkpoint: LevelCheckpointResource = LevelCheckpointResource.new()


func update_level_checkpoint(checkpoint: LevelCheckpointResource):
	level_checkpoint = checkpoint


func reset_player_health():
	update_player_current_health(player_health.max_value, HEALTH_CHANGED_ACTION.NONE)


func update_player_current_health(value: float, action: HEALTH_CHANGED_ACTION):
	player_health.value = clamp(floor(value), 0, player_health.max_value)
	player_current_health_changed.emit(player_health, action)


func update_player_max_health(value: float):
	player_health.max_value = max(0, floor(value))
	player_current_health_changed.emit(player_health)


func bind_player_health_component(health_component: HealthComponent):
	health_component.damaged.connect(on_player_damaged)
	health_component.healed.connect(on_player_healed)
	health_component.max_health = player_health.max_value
	health_component.current_health = player_health.value


func on_player_damaged(damage_value: float):
	update_player_current_health(player_health.value - damage_value, HEALTH_CHANGED_ACTION.DAMAGED)


func on_player_healed(heal_value: float):
	update_player_current_health(player_health.value + heal_value, HEALTH_CHANGED_ACTION.HEALED)
