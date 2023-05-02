extends Node

# Screen Shake Ref: https://shaggydev.com/2022/02/23/screen-shake-godot/

# How quickly to move through the noise
var NOISE_SHAKE_SPEED: float = 30.0
# Noise returns values in the range (-1, 1)
# So this is how much to multiply the returned value by
var NOISE_SHAKE_STRENGTH: float = 10.0
# Multiplier for lerping the shake strength to zero
var SHAKE_DECAY_RATE: float = 8.0

@onready var rand = RandomNumberGenerator.new()
@onready var noise = FastNoiseLite.new()

var shake_disabled = false
var camera: Camera2D

# Used to keep track of where we are in the noise
# so that we can smoothly move through it
var noise_i: float = 0.0

var shake_strength: float = 0.0


func _ready() -> void:
	rand.randomize()
	noise.seed = rand.randi()
	noise.frequency = 2.0


func apply_noise_shake(power = 1.0) -> void:
	camera = get_viewport().get_camera_2d()
	shake_strength = NOISE_SHAKE_STRENGTH * power


func _process(delta: float) -> void:
	if shake_disabled || !camera || shake_strength < 0.1:
		shake_strength = 0.0
		camera = null
		return
	
	# Fade out the intensity over time
	shake_strength = lerp(shake_strength, 0.0, SHAKE_DECAY_RATE * delta)

	# Shake by adjusting camera.offset so we can move the camera around the level via it's position
	camera.offset = get_noise_offset(delta)


func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * NOISE_SHAKE_SPEED
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength
	)
