extends Control

onready var focus_first: Control = $Panel/Settings/SensitivityMouse


func _ready() -> void:
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.get_action_strength("pause"):
		get_tree().paused = true
		visible = true
		focus_first.grab_focus()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func close_menu() -> void:
	get_tree().paused = false
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_AcceptBtn_pressed() -> void:
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, "SettingController", "save_setting")
	ConfigManager.save_settings_file()
	close_menu()


func _on_CancelBtn_pressed():
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, "SettingController", "load_value")
	close_menu()


func _on_ResetBtn_pressed():
	ConfigManager.restore_settings()
