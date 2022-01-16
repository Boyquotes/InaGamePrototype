extends Area

export(String, FILE) var new_scene


func _on_ChangeLevelTrigger_body_entered(body: Node) -> void:
	if body is Player:
		get_tree().change_scene(new_scene)
