class_name BulletManager
extends MultiMeshInstance2D

@export var shape: Shape2D
# @export var strategy: Resource

class Bullet:
	var position: Vector2 = Vector2.ZERO
	var body: RID = RID()

var bullets: Array[Bullet] = []
var free_instances: Array[int] = []


func _ready() -> void:
	for i in range(multimesh.instance_count):
		var bullet := Bullet.new()
		bullet.body = PhysicsServer2D.body_create()

		# 	
		PhysicsServer2D.body_set_space(bullet.body, get_world_2d().get_space())

		# Create a new shape for the bullet and disable it. 
		PhysicsServer2D.body_add_shape(bullet.body, shape)
		PhysicsServer2D.body_set_shape_disabled(bullet.body, 0, true)

		# Don't make bullets check collision with other bullets to improve performance.
		PhysicsServer2D.body_set_collision_mask(bullet.body, 0)

		# Set the bullet's initial position to the origin.
		PhysicsServer2D.body_set_state(bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, Transform2D())
		
		bullets.push_back(bullet)
		free_instances.push_back(i)


func _process(_delta: float) -> void:
	print("FPS: %d" % Engine.get_frames_per_second())

	var transform2d := Transform2D()
	
	for i in range(multimesh.visible_instance_count):
		var bullet = bullets.get(i) as Bullet
		transform2d.origin = bullet.position

		# TODO: Add iterpolation to the bullet position.
		multimesh.set_instance_transform_2d(i, transform2d)


func _physics_process(_delta: float) -> void:
	var transform2d := Transform2D()

	for i in range(multimesh.visible_instance_count):
		var bullet = bullets.get(i) as Bullet 
		transform2d.origin = bullet.position

		# TODO: Implement the bullet movement logic here.

		PhysicsServer2D.body_set_state(bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)


func _exit_tree() -> void:
	for bullet: Bullet in bullets:
		PhysicsServer2D.free_rid(bullet.body)
	bullets.clear()


func add_bullet(location: Vector2) -> void:
	var instance_id := multimesh.visible_instance_count
	
	if instance_id >= bullets.size():
		return  # No free bullet available.	
	
	var bullet = bullets.get(instance_id) as Bullet
	var transform2d := Transform2D()

	bullet.position = location 
	transform2d.origin = location 

	# Enable the bullet's collision shape.
	PhysicsServer2D.body_set_state(bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)
	PhysicsServer2D.body_set_shape_disabled(bullet.body, 0, false)

	multimesh.set_instance_transform_2d(instance_id, transform2d)
	multimesh.set_instance_color(instance_id, Color(1, 1, 1, 1))
	multimesh.visible_instance_count += 1
	
	Global.projectile_count += 1


func remove_bullet(instance_id: int) -> void:
	var last_index = multimesh.visible_instance_count - 1
	if instance_id < 0 or instance_id > last_index:
		return

	var bullet = bullets.get(instance_id) as Bullet

	# Disable the bullet's collision shape.
	PhysicsServer2D.body_set_shape_disabled(bullet.body, 0, true)

	# Make bullet invisible.
	multimesh.set_instance_color(instance_id, Color.TRANSPARENT)
	multimesh.visible_instance_count -= 1
	
	free_instances.push_back(instance_id)
	
	Global.projectile_count -= 1
