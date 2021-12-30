extends Control

func _ready() -> void:
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.get_action_strength("pause"):
		get_tree().paused = true
		visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_CloseBtn_pressed() -> void:
	get_tree().paused = false
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _on_AcceptBtn_pressed() -> void:
	get_tree().call_group("SettingController", "save_setting")
