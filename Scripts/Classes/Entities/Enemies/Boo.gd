extends Node2D

var target_player: Player = null

var velocity := Vector2.ZERO

const MOVE_SPEED := 30
const SMOKE_PARTICLE = preload("uid://d08nv4qtfouv1")
var direction := -1

@export var on_screen_enabler: VisibleOnScreenNotifier2D = null
@export var score_note_adder: ScoreNoteSpawner = null

signal killed

func _physics_process(delta: float) -> void:
	target_player = get_tree().get_first_node_in_group("Players")
	if $TrackJoint.is_attached == false:
		handle_movement(delta)
	$Sprite.scale.x = direction

func handle_movement(delta: float) -> void:
	var target_direction = sign(target_player.global_position.x - global_position.x)
	if target_direction != 0:
		direction = target_direction
	if target_player.direction == direction:
		if $Sprite.animation != "Move":
			$Sprite.play("Move")
		velocity = lerp(velocity, 30 * global_position.direction_to(target_player.global_position), delta * 5)
	else:
		if $Sprite.animation != "Idle":
			$Sprite.play("Idle")
		velocity = lerp(velocity, Vector2.ZERO, delta * 5)
	global_position += velocity * delta


func on_area_entered(area: Area2D) -> void:
	if area.owner is Player:
		if area.owner.is_invincible:
			summon_smoke_particle()
			die(1000)
		else:
			area.owner.damage()

func die(score: int) -> void:
	queue_free()
	killed.emit()
	if score_note_adder != null:
		score_note_adder.spawn_note(score)

func flag_die() -> void:
	if on_screen_enabler != null:
		if on_screen_enabler.is_on_screen():
			queue_free()
			if score_note_adder != null:
				score_note_adder.spawn_note(500)

func summon_smoke_particle() -> void:
	var particle = SMOKE_PARTICLE.instantiate()
	particle.global_position = global_position
	add_sibling(particle)


func die_from_object(_hammer: PlayerHammer) -> void:
	$GibSpawner.summon_gib()
	die(500)
