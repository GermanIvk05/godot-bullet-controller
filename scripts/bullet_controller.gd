class_name BulletController
extends MultiMeshInstance2D

@abstract class Bullet:
	var transform: Transform2D
	var body: RID

	func _init(position: Vector2 = Vector2.ZERO) -> void:
		transform = Transform2D().translated(position)
		body = PhysicsServer2D.body_create()
	
	func destroy() -> void:
		PhysicsServer2D.free_rid(body)

	@abstract func update(delta: float)


var bullets: Array[Bullet] = []

func _ready() -> void:
	var viewport_rect = get_viewport_rect()
	var aabb_position = Vector3(viewport_rect.position.x, viewport_rect.position.y, 0)
	var aabb_size = Vector3(viewport_rect.size.x, viewport_rect.size.y, 0)
	multimesh.custom_aabb = AABB(aabb_position, aabb_size)
	# TODO: Make the custom AABB update when screen is resized


func _physics_process(delta: float) -> void:
	if bullets.is_empty():
		return
		
	for i in multimesh.visible_instance_count:
		bullets[i].update(delta)
		multimesh.set_instance_transform_2d(i, bullets[i].transform)


func _exit_tree() -> void:
	for bullet: Bullet in bullets: 
		bullet.destroy()
	bullets.clear()


func add_bullet(bullet: Bullet) -> void:
	if multimesh.visible_instance_count >= multimesh.instance_count:
		return

	multimesh.set_instance_transform_2d(bullets.size(), bullet.transform)
	bullets.push_back(bullet)
	multimesh.visible_instance_count = bullets.size()


func remove_bullet(id: int) -> void:
	if id < 0 or id > multimesh.visible_instance_count:
		return

	var bullet = bullets.pop_at(id) as Bullet

	bullet.destroy()
	multimesh.visible_instance_count -= 1
