extends Node


func _ready() -> void:
	InputHelper.connect("device_changed", self, "_on_input_device_changed")
	change_buttons(InputHelper.guess_device_name())


func _on_input_device_changed(device: String, _device_index: int) -> void:
	print(device)
	change_buttons(device)

func change_buttons(device: String) -> void:
	match device:
		InputHelper.DEVICE_KEYBOARD:
			Dialogic.set_variable("aim_btn", "right click")
			Dialogic.set_variable("fire_btn", "left click")
			Dialogic.set_variable("interact_btn", "E")
			Dialogic.set_variable("reset_camera_btn", "Middle mouse button")
		
		InputHelper.DEVICE_XBOX_CONTROLLER:
			Dialogic.set_variable("aim_btn", "LT")
			Dialogic.set_variable("fire_btn", "RT")
			Dialogic.set_variable("interact_btn", "A button")
			Dialogic.set_variable("reset_camera_btn", "Right stick button")
		
		InputHelper.DEVICE_PLAYSTATION_CONTROLLER:
			Dialogic.set_variable("aim_btn", "L1")
			Dialogic.set_variable("fire_btn", "R1")
			Dialogic.set_variable("interact_btn", "Cross button")
			Dialogic.set_variable("reset_camera_btn", "Right stick button")
		
		InputHelper.DEVICE_SWITCH_CONTROLLER:
			Dialogic.set_variable("aim_btn", "ZL")
			Dialogic.set_variable("fire_btn", "ZR")
			Dialogic.set_variable("interact_btn", "B button")
			Dialogic.set_variable("reset_camera_btn", "Right stick button")
		
