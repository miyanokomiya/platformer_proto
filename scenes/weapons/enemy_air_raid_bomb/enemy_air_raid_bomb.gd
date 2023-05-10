extends StaticBody2D

@onready var animation_player = $AnimationPlayer
@onready var terrain_ray_cast = %TerrainRayCast
@onready var projectile_component: ProjectimeComponent = $ProjectileComponent
@onready var sprite_2d = $Sprite2D

enum SHOT{IDLE, FLYING, HIT}
var current_state = SHOT.IDLE


func _physics_process(delta):
	match current_state:
		SHOT.IDLE:
			return
		SHOT.FLYING:
			projectile_component.move(self, delta)
			animation_player.play("flying")
			if terrain_ray_cast.is_colliding():
				current_state = SHOT.HIT
			return
		SHOT.HIT:
			animation_player.play("hit")
			return


func shoot(from: Vector2, direction: Vector2):
	global_position = from
	projectile_component.angled_shoot(self, direction.angle())
	update_sprite_frame(direction)
	current_state = SHOT.FLYING


func update_sprite_frame(direction: Vector2):
	if direction.x != 0:
		sprite_2d.frame = 1
		terrain_ray_cast.rotation = -PI / 4
	else:
		sprite_2d.frame = 2
		terrain_ray_cast.rotation = 0


func on_hit():
	if current_state != SHOT.FLYING:
		return
	
	current_state = SHOT.HIT


func _on_hitbox_component_hit():
	on_hit()


func _on_hitbox_component_blocked():
	on_hit()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
