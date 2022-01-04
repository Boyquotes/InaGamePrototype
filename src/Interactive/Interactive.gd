extends Area
class_name Interactive

signal player_interacted()

onready var icon: Sprite3D = $Icon

var _active := false

func _unhandled_input(event: InputEvent) -> void:
	if _active and event.is_action_pressed("interact"):
		emit_signal("player_interacted")


func _on_Interactive_body_entered(body: Node) -> void:
	if body is Player:
		icon.visible = true
		_active = true


func _on_Interactive_body_exited(body: Node) -> void:
	if body is Player:
		icon.visible = false
		_active = false
