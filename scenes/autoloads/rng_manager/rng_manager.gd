extends Node

var drop_rng_seed: RngSeedResource = RngSeedResource.new()
var drop_rng: RandomNumberGenerator = RandomNumberGenerator.new()

var enemy_rng_seed: RngSeedResource = RngSeedResource.new()
var enemy_rng: RandomNumberGenerator = RandomNumberGenerator.new()


func restore():
	drop_rng.seed = drop_rng_seed.rng_seed
	drop_rng.state = drop_rng_seed.rng_state
	
	enemy_rng.seed = enemy_rng_seed.rng_seed
	enemy_rng.state = enemy_rng_seed.rng_state


func save():
	drop_rng_seed.rng_seed = drop_rng.seed
	drop_rng_seed.rng_state = drop_rng.state
	
	enemy_rng_seed.rng_seed = enemy_rng.seed
	enemy_rng_seed.rng_state = enemy_rng.state
