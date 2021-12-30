extends Sprite3D

const DOT_APPROX = 0.025


func _ready() -> void:
	set_as_toplevel(true)


func update(ray: RayCast) -> void:
	ray.force_raycast_update()
	var is_colliding: = ray.is_colliding()
	visible = is_colliding
	
	if is_colliding:
		
		var dot = ray.get_collision_normal().dot(Vector3.UP)
		
		if 1.0 - DOT_APPROX < dot and dot < 1.0 + DOT_APPROX:
			(material_override as SpatialMaterial).albedo_color = Color(510, 510, 510)
		else:
			(material_override as SpatialMaterial).albedo_color = Color(510, 0, 0)
		
		if ray.get_collider().is_in_group("AntiTentacle"):
			(material_override as SpatialMaterial).albedo_color = Color(510, 0, 0)
		
		var collision_point: = ray.get_collision_point()
		var collision_normal: = ray.get_collision_normal()
		
		global_transform.origin = collision_point + collision_normal * 0.01
		var point = collision_point - collision_normal
		if(point != global_transform.basis.y.normalized()):
			look_at(point, global_transform.basis.y.normalized())
		
