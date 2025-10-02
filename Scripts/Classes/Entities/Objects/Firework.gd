extends BetterAnimatedSprite2D

var initialised = false
@export_range(100, 10000, 100) var score = 500
@export_range(1, 8) var fly_tile := 4
var target_y := 0.0
const FIREBALL_EXPLOSION = "res://Scenes/Prefabs/Particles/FireworkeExplosion.tscn"

func _process(_delta: float) -> void:
	if (!initialised):
		target_y = position.y - fly_tile * 16
		initialised = true
	position.y = lerpf(position.y, target_y, 0.05)
	if (abs(position.y - target_y) <= 0.5):
		explode()

func explode() -> void:
	var fireball = load(FIREBALL_EXPLOSION).instantiate()
	fireball.score = score
	fireball.position = position
	add_sibling(fireball)
	queue_free()
