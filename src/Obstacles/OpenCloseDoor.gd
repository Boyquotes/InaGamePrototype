tool
extends Spatial

onready var open_pos_3d: Position3D = $OpenPosition
onready var close_pos_3d: Position3D = $ClosePosition
onready var tween: Tween = $Tween
onready var door: StaticBody = $Door
onready var sfx = $SFX
onready var total_distance = opened_position.distance_to(closed_position)

export var activator_path: NodePath
export var closed_position:= Vector3.ZERO setget set_closed_position
export var opened_position:= Vector3(0, -3.9, 0) setget set_opened_position
export (float, 0.1, 100.0, 0.1) var time = 3.0

var _activator_node

func _ready() -> void:
	if not Engine.editor_hint:
		_activator_node = get_node(activator_path)
		_activator_node.connect("state_changed", self, "_on_activator_state_changed")


func _get_configuration_warning() -> String:
	return "Missing activator" if not activator_path else ""


func set_closed_position(new_pos: Vector3) -> void:
	closed_position = new_pos
	if close_pos_3d:
		close_pos_3d.transform.origin = new_pos


func set_opened_position(new_pos: Vector3) -> void:
	opened_position = new_pos
	if open_pos_3d:
		open_pos_3d.transform.origin = new_pos


func _on_activator_state_changed(new_state: bool) -> void:
	var goal_position = opened_position if new_state else closed_position
	
	var time_aux = time
	if tween.is_active():
		time_aux = (door.translation.distance_to(goal_position) * time) / total_distance
		tween.remove_all()
	
	tween.interpolate_property(door, "translation", door.translation, goal_position, time_aux)
	
	sfx.play()
	tween.start()


func _on_Tween_tween_all_completed() -> void:
	sfx.stop()
