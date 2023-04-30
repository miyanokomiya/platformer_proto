extends CanvasLayer

@onready var health_bar = %HealthBar


func _ready():
	GlobalState.player_current_health_changed.connect(on_player_current_health_changed)
	GlobalState.player_max_health_changed.connect(on_player_max_health_changed)
	health_bar.update_max_value(GlobalState.player_health.max_value)
	health_bar.update_value(GlobalState.player_health.value)


func on_player_current_health_changed(health: HealthResource):
	health_bar.update_value(health.value)


func on_player_max_health_changed(health: HealthResource):
	health_bar.update_max_value(health.max_value)
