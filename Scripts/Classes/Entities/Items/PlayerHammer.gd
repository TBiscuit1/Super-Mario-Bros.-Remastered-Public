class_name PlayerHammer
extends Node2D

const CHARACTERS := ["Mario", "Luigi", "Toad", "Toadette"]

var velocity := Vector2(0, -200)
var character := "Mario"

var direction := -1

func _ready() -> void:
	$Sprite.flip_h = direction == 1
	$Animations.speed_scale = -direction
	if Settings.file.audio.extra_sfx == 1:
		AudioManager.play_sfx("hammer_throw", global_position)

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	velocity.y += (Global.entity_gravity / delta) * delta
	velocity.y = clamp(velocity.y, -INF, Global.entity_max_fall_speed)

func hit(play_sfx := true) -> void:
	if play_sfx:
		AudioManager.play_sfx("bump", global_position)
