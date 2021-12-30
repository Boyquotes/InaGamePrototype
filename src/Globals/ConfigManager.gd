# Global class that manages the settings for the game
extends Node

signal loaded_settings
signal restored_settings
signal changed_setting(category, key, new_value)

const SAVE_PATH = "res://config.cfg"
const ConfigConsoleColor = Color.teal

var _config_file: ConfigFile = ConfigFile.new()

# TODO: add version checking in case the settings file isn't the same
# This are the default settings
var _settings: Dictionary = {
	"version":
	{
		"game_version": ProjectSettings.get_setting("application/config/version"),
	},
	"display":
	{
		"fullscreen": false,
		"show_fps": true,
	},
	"controls":
	{
		"inverted": false,
		"hold_for_aim": true,
		"mouse_sensitivity": 1.8,
		"controller_sensitivity": 2.0,
	},
	"sound":
	{
		"Master": 1.0,
		"Music": 1.0,
		"SFX": 1.0,
	},
}

var _default_settings = _settings.duplicate(true)

func _ready() -> void:
	load_settings_file()
	apply_settings()

	emit_signal("loaded_settings")


func save_settings_file() -> void:
	for section in _settings.keys():
		for key in _settings[section]:
			_config_file.set_value(section, key, _settings[section][key])
	_config_file.save(SAVE_PATH)


func load_settings_file() -> void:
	var file = File.new()
	if file.file_exists(SAVE_PATH):
		var error = _config_file.load(SAVE_PATH)
		if error != OK:
			print("Error loading config file, error code #", error)
			return

		for section in _settings.keys():
			for key in _settings[section]:
				_settings[section][key] = _config_file.get_value(section, key)
	else:
		save_settings_file()


func apply_settings() -> void:
	OS.window_fullscreen = get_setting("display", "fullscreen")

	for channel in _settings["sound"]:
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index(channel), linear2db(get_setting("sound", channel))
		)


func restore_settings() -> void:
	_settings = _default_settings.duplicate(true)
	emit_signal("restored_settings")


# These two functions are the best way to read and set settings
func get_setting(category: String, key: String):
	return _settings[category][key]


func set_setting(category: String, key: String, value) -> bool:
	if typeof(value) == typeof(_settings[category][key]):
		_settings[category][key] = value
		emit_signal("changed_setting", category, key, value)
		return true
	else:
		return false


# Returns the category if it finds it, else it returns an empty string
func has_setting(name: String) -> String:
	for category in _settings:
		if _settings[category].has(name):
			return category
	return ""
