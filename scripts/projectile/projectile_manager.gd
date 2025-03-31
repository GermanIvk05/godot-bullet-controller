class_name ProjectileManager
extends MultiMeshInstance2D

@export var projectile: Projectile
var projectiles: Array[Projectile] = []

func _physics_process(delta: float) -> void:
	var view_rect := get_viewport_rect()
	var transform2d := Transform2D()
	
	view_rect.position -= global_position
	# view_rect.size += 2 * texture.get_size()
	
	for i in range(projectiles.size() - 1, -1, -1):
		var projectile: Projectile = projectiles.get(i)
		projectile.update(delta)
		
		# Destroy projectiles that are outside the viewport.
		if not view_rect.has_point(projectile.position):
			_destroy_projectile(i)
			continue
		
		transform2d.origin = projectile.position
		multimesh.set_instance_transform_2d(i, transform2d)
		PhysicsServer2D.body_set_state(projectile.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)

func _exit_tree() -> void:
	for projectile: Projectile in projectiles:
		PhysicsServer2D.free_rid(projectile.body)
	projectiles.clear()

func spawn_projectile(location: Vector2, velocity: Vector2, acceleration: Vector2) -> void:
	var p = projectile.duplicate() as Projectile
	var transform2d := Transform2D()
	
	# Initialize the projectile.
	p.position = location
	p.linear_velocity = velocity
	p.linear_acceleration = acceleration
	p.body = PhysicsServer2D.body_create()
	
	# Place the projectile at the specified position.
	transform2d.origin = location
	
	PhysicsServer2D.body_set_space(p.body, get_world_2d().get_space())
	PhysicsServer2D.body_add_shape(p.body, p.shape)
	
	# Don't make projectiles check collision with other projectiles to improve performance.
	PhysicsServer2D.body_set_collision_mask(p.body, 0)

	PhysicsServer2D.body_set_state(p.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)
	
	multimesh.set_instance_transform_2d(projectiles.size(), transform2d)
	multimesh.set_instance_color(projectiles.size(), Color(1, 1, 1, 1))
	multimesh.visible_instance_count += 1
	projectiles.push_back(p)

func _destroy_projectile(index: int) -> void:
	var projectile: Projectile = projectiles.get(index)

	PhysicsServer2D.free_rid(projectile.body)

	multimesh.set_instance_transform_2d(index, Transform2D())
	multimesh.set_instance_color(index, Color.TRANSPARENT)
	multimesh.visible_instance_count -= 1
