class_name BooBuddy
extends Node2D

var dead = false
var tangible = true

const SMOKE_PARTICLE = preload("uid://d08nv4qtfouv1")

func _process(_delta: float) -> void:
	if (!tangible or dead):
		hide()
	else:
		show()

func die(score: int) -> void:
	if (!tangible or dead): return
	dead = true
	$ScoreNoteSpawner.spawn_note(score)

func hammer_die(_hammer: PlayerHammer) -> void:
	if (!tangible or dead): return
	$GibSpawner.summon_gib().position = position
	die(500)

func summon_smoke_particle() -> void:
	var particle = SMOKE_PARTICLE.instantiate()
	particle.global_position = position
	add_sibling(particle)

func on_area_entered(area: Area2D) -> void:
	if (!tangible or dead): return
	if area.owner is Player:
		if area.owner.is_invincible:
			summon_smoke_particle()
			die(1000)
		else:
			area.owner.damage()

# Blame Mad
func penis() -> void:
	print("My penis is so hard")
