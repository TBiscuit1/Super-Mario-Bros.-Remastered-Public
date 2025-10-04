extends PowerUpState

var hammer_amount := 0
const PLAYER_HAMMER = preload("res://Scenes/Prefabs/Entities/Items/PlayerHammer.tscn")
func update(_delta: float) -> void:
	if Global.player_action_just_pressed("action", player.player_id) and hammer_amount < 4 and player.state_machine.state.name == "Normal":
		throw_hammer()

func throw_hammer() -> void:
	var node = PLAYER_HAMMER.instantiate()
	node.character = player.character
	node.global_position = player.global_position - Vector2(-4 * player.direction, 16 * player.gravity_vector.y)
	node.direction = player.direction
	if Global.player_action_pressed("move_up", player.player_id):
		node.velocity.y = -300
		node.velocity.x = player.direction * 25
	else:
		node.velocity.y = -150
		node.velocity.x = player.direction * max(abs(player.velocity.x + player.direction * 120), 35)
	
	player.call_deferred("add_sibling", node)
	hammer_amount += 1
	node.tree_exited.connect(func(): hammer_amount -= 1)
	AudioManager.play_sfx("hammer_throw", player.global_position)
	player.attacking = true
	await get_tree().create_timer(0.1, false).timeout
	player.attacking = false
