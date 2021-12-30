tool
extends HSlider

export var setting_category := "controls"
export var setting_name := "mouse_sensitivity"

var _after_ready = false


func _ready() -> void:
	if not Engine.editor_hint:
		load_value()


func _get_configuration_warning() -> String:
	return "Missing category and/or name" if not setting_category or not setting_name else ""


func load_value() -> void:
	value = ConfigManager.get_setting(setting_category, setting_name)


func save_setting() -> void:
	ConfigManager.set_setting(setting_category, setting_name, value)
