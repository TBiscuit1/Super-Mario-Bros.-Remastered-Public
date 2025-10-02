extends Block


func dispense_item() -> void:
	if can_hit == false:
		return
	can_hit = false
	await get_tree().create_timer(0.1, false).timeout
	DiscoLevel.combo_meter += item_amount * combo_meter_amount
	var item_to_dispense = player_mushroom_check(get_tree().get_first_node_in_group("Players"))
	while (item_amount > 0):
		var node = item_to_dispense.instantiate()
		if node is PowerUpItem or node.has_meta("is_item"):
			for i in get_tree().get_nodes_in_group("Players"):
				node.position = position + Vector2(0, -1)
				node.hide()
				add_sibling(node)
				if node is PowerUpItem:
					if Global.connected_players > 1:
						AudioManager.play_sfx("item_appear", global_position)
						node.player_multiplayer_launch_spawn(i)
					else:
						node.block_dispense_tween()
		else:
			if item.resource_path == "res://Scenes/Prefabs/Entities/Items/SpinningRedCoin.tscn":
				if has_meta("r_coin_id"):
					node.id = get_meta("r_coin_id", 0)
			var parent = get_parent()
			node.global_position = global_position + Vector2(0, -8) + node.get_meta("block_spawn_offset", Vector2.ZERO)
			if get_parent().get_parent() is TrackRider:
				parent = get_parent().get_parent().get_parent()
			parent.add_child(node)
			parent.move_child(node, get_index() - 1)
			print("FUCK: " + str(item.resource_path))
			if NO_SFX_ITEMS.has(item.resource_path) == false:
				AudioManager.play_sfx("item_appear", global_position)
				if (item.resource_path != "res://Scenes/Prefabs/Particles/Firework.tscn"):
					var random = randi_range(-250, -150)
					var random2 = randi_range(-100, 100)
					print(random)
					print(random2)
					node.set("velocity", Vector2(random2, node.get_meta("block_launch_velocity", random)))
					if ("direction" in node):
						node.direction = -1 if random2 == 0 else sign(random2)
				else:
					node.fly_tile = randi_range(3, 5)
		can_hit = true
		item_amount -= 1
		if item_amount == 1:
			if has_meta("red_coin") == true:
				item = load("res://Scenes/Prefabs/Entities/Items/SpinningRedCoin.tscn")
		if item_amount <= 0:
			spawn_empty_block()
