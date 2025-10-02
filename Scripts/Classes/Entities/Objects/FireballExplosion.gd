extends BetterAnimatedSprite2D

var has_exploaded = false
var score = 500

func _process(_delta: float) -> void:
	if (!has_exploaded):
		speed_scale = 1.0
		Global.score += score
		AudioManager.play_sfx("firework", self.global_position)
		$Timer.start()
		has_exploaded = true
