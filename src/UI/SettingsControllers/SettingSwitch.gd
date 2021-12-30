extends CheckButton

export var setting_category := "controls"
export var setting_name := "inverted"

var _after_ready = false


func _ready() -> void:
	ConfigManager.connect("restored_settings", self, "load_value")
	load_value()


func _get_configuration_warning() -> String:
	return "Missing category and/or name" if not setting_category or not setting_name else ""


func load_value() -> void:
	pressed = ConfigManager.get_setting(setting_category, setting_name)


func save_setting() -> void:
	ConfigManager.set_setting(setting_category, setting_name, pressed)
