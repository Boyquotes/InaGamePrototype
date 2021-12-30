extends FollowerState

export var offset = Vector3.ZERO
export var look_offset = Vector3.ZERO
export var max_distance = 10.0

export (float, 0, 100, 5) var linear_speed_max := 10.0
export (float, 0, 100, 0.1) var linear_acceleration_max := 1.0
export (float, 0, 50, 0.1) var arrival_tolerance := 0.5
export (float, 0, 50, 0.1) var deceleration_radius := 5.0
export (int, 0, 1080, 10) var angular_speed_max := 270
export (int, 0, 2048, 10) var angular_accel_max := 45
export (int, 0, 178, 2) var align_tolerance := 5
export (int, 0, 180, 2) var angular_deceleration_radius := 45

onready var agent: GSAIKinematicBody3DAgent
onready var target: GSAIAgentLocation
onready var look_target: GSAIAgentLocation
onready var accel: GSAITargetAcceleration
onready var blend: GSAIBlend
onready var face: GSAIFace
onready var arrive: GSAIArrive

var target_node: Spatial

func physics_process(delta: float) -> void:
	
	var new_offset = (target_node.transform.basis.z * offset.z +
	target_node.transform.basis.x * offset.x)
	var new_look_offset = (target_node.transform.basis.z * look_offset.z +
	target_node.transform.basis.x * look_offset.x)
	
	new_offset.y = offset.y
	new_look_offset.y = look_offset.y
	
	follower.test.global_transform.origin = target_node.global_transform.origin + new_look_offset
	
	if follower.global_transform.origin.distance_to(target_node.global_transform.origin) > max_distance:
		follower.global_transform.origin = target_node.transform.origin + new_offset
	
	target.position = target_node.transform.origin + new_offset
	look_target.position = target_node.transform.origin + new_look_offset
	blend.calculate_steering(accel)
	agent._apply_steering(accel, delta)


func enter(msg: = {}) -> void:
	agent = GSAIKinematicBody3DAgent.new(follower)
	target = GSAIAgentLocation.new()
	look_target = GSAIAgentLocation.new()
	accel = GSAITargetAcceleration.new()
	blend = GSAIBlend.new(agent)
	face = GSAIFace.new(agent, look_target, true)
	arrive = GSAIArrive.new(agent, target)
	
	agent.linear_speed_max = linear_speed_max
	agent.linear_acceleration_max = linear_acceleration_max
	agent.linear_drag_percentage = 0.05
	agent.angular_acceleration_max = deg2rad(angular_accel_max)
	agent.angular_speed_max = deg2rad(angular_speed_max)
	agent.angular_drag_percentage = 0.1

	arrive.arrival_tolerance = arrival_tolerance
	arrive.deceleration_radius = deceleration_radius

	face.alignment_tolerance = deg2rad(align_tolerance)
	face.deceleration_radius = deg2rad(angular_deceleration_radius)

	target_node = follower.target_node
	target.position = target_node.transform.origin
	look_target.position = target_node.transform.origin
	blend.add(arrive, 1)
	blend.add(face, 1)
