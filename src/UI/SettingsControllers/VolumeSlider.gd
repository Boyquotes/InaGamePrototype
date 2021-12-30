extends HSlider

export var audio_bus_name := "Master"
onready var _bus := AudioServer.get_bus_index(audio_bus_name)
onready var sound_test = $SoundTest

var _ready_volume = false


func _ready() -> void:
	print(db2linear(-5.3))
	ConfigManager.connect("restored_settings", self, "load_value")
	load_value()


func load_value() -> void:
	value = ConfigManager.get_setting("sound", audio_bus_name)
	_ready_volume = false


func save_setting() -> void:
	ConfigManager.set_setting("sound", audio_bus_name, value)
	AudioServer.set_bus_volume_db(_bus, value)


func _on_VolumeSlider_value_changed(value: float) -> void:
	if _ready_volume:
		var bus_index = AudioServer.get_bus_index(sound_test.bus)
		AudioServer.set_bus_volume_db(bus_index, linear2db(value))
		sound_test.play()
	_ready_volume = true
