extends Switch

export (float, 0.0, 100.0, 1.0) var time_to_deactivate = 5

onready var deactivate_timer = $DeactivateTimer
onready var tick_sfx = $TickSFX

func _ready() -> void:
	._ready()
	deactivate_timer.wait_time = time_to_deactivate


func _on_Interactive_body_entered(body: Node) -> void:
	if body is Player and switched == initial_state:
		icon.visible = true
	_active = true


func _on_Switch_player_interacted() -> void:
	if switched == initial_state:
		._on_Switch_player_interacted()
		deactivate_timer.start()
		tick_sfx.play()
		icon.visible = false


func _on_DeactivateTimer_timeout() -> void:
	._on_Switch_player_interacted()
	tick_sfx.stop()
	
	for body in get_overlapping_bodies():
		if body is Player:
			icon.visible = true
	
