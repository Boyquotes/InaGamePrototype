tool
extends StaticBody

enum GOING_TO {
	START_POS = 0,
	END_POS = 1,
}

export var activator_path: NodePath
export var start_position:= Vector3.ZERO setget set_start_position
export var end_position:= Vector3.ZERO setget set_end_position
export (float, 0.1, 100.0, 0.1) var time = 3.0
export var continuous = false
export var return_to_start = true

onready var start_pos3d = $StartPos
onready var end_pos3d = $EndPos
onready var tween = $Tween
onready var sfx = $SFX
onready var past_coord = global_transform.origin
onready var total_distance = start_position.distance_to(end_position)

var _activator_node
# If the moving platform is currently activated by a switch
var _activated = false
var _going_to = GOING_TO.END_POS

var global_start_position: Vector3
var global_end_position:Vector3

var past_time = 0.0
var time_started: float = 0.0

func _ready() -> void:
	if not Engine.editor_hint:
		_activator_node = get_node(activator_path)
		_activator_node.connect("state_changed", self, "_on_activator_state_changed")
		
		global_start_position = to_global(start_position)
		global_end_position = to_global(end_position)
		
		set_physics_process(false)


func _get_configuration_warning() -> String:
	return "Missing activator" if not activator_path else ""


func _physics_process(delta: float) -> void:
	if Engine.editor_hint:
		return
		
	var current_cord = global_transform.origin
	var diff = current_cord - past_coord
	constant_linear_velocity = diff / delta
	
	past_coord = current_cord


func set_start_position(new_val: Vector3) -> void:
	start_position = new_val
	if start_pos3d:
		start_pos3d.transform.origin = new_val


func set_end_position(new_val: Vector3) -> void:
	end_position = new_val
	if end_pos3d:
		end_pos3d.transform.origin = new_val


func _on_activator_state_changed(new_state: bool) -> void:
	_activated = new_state
	var goal_position = global_end_position if new_state else global_start_position
	if goal_position == self.global_transform.origin:
		return
	
	var time_aux = time
	if tween.is_active():
		time_aux = (self.global_transform.origin.distance_to(goal_position) * time) / total_distance
		tween.remove_all()
	
	tween.interpolate_property(
		self, "global_transform:origin",
		self.global_transform.origin,
		goal_position,
		time_aux)

	tween.start()
	sfx.play()
	set_physics_process(true)


func _on_Tween_tween_all_completed() -> void:
	if _activated and continuous:
		_going_to = GOING_TO.END_POS if _going_to == GOING_TO.START_POS else GOING_TO.START_POS
		var goal_position = global_end_position if _going_to == GOING_TO.END_POS else global_start_position
		
		tween.interpolate_property(
			self, "global_transform:origin",
			self.global_transform.origin,
			goal_position,
			time)
		tween.start()
	else:
		sfx.stop()
		constant_linear_velocity = Vector3.ZERO
		set_physics_process(false)
