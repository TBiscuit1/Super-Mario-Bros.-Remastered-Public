extends Block


func _process(delta: float) -> void:
	$Sprite.visible = (Global.level_editor != null and !Global.level_editor.playing_level)
