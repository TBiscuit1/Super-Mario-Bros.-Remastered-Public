class_name HammerDetection
extends Node

@export var hitbox: Area2D = null
@export var play_sfx_on_hit := false
signal hammer_hit(hammer: PlayerHammer)

func _ready() -> void:
	if hitbox != null:
		hitbox.area_entered.connect(area_entered)

func area_entered(area: Area2D) -> void:
	if area.owner is PlayerHammer:
		hammer_hit.emit(area.owner)
		area.owner.hit(play_sfx_on_hit)
