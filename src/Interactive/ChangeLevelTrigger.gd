extends Area

export(String, FILE, "*.tscn") var new_scene
onready var sfx_player = $SFX

func _ready() -> void:
	var sfx_length = sfx_player.stream.get_length()
	var rand_sec = rand_range(0.0, sfx_length)
	print(rand_sec)
	sfx_player.seek(rand_sec)
	

func _on_ChangeLevelTrigger_body_entered(body: Node) -> void:
	if body is Player:
		get_tree().change_scene(new_scene)
