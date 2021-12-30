extends HSlider

export var audio_bus_name := "Master"
onready var _bus := AudioServer.get_bus_index(audio_bus_name)
onready var sound_test = $SoundTest

var _ready_volume = false


func _ready() -> void:
	sound_test.bus = audio_bus_name
	update_value()


func update_value() -> void:
	value = db2linear(AudioServer.get_bus_volume_db(_bus))


func save_setting() -> void:
	ConfigManager.set_setting("sound", audio_bus_name, value)


func _on_VolumeSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus, linear2db(value))
	if _ready_volume:
		sound_test.play()
	_ready_volume = true
