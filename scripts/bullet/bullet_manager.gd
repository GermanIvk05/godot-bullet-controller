class_name BulletManager
extends MultiMeshInstance2D

class Bullet:
	var transform: Transform2D
	var body: RID

	func _init(position: Vector2 = Vector2.ZERO) -> void:
		transform = Transform2D().translated(position)
		body = PhysicsServer2D.body_create()

	func update(_delta: float) -> void:
		return

	func debug(_vectors: PackedVector2Array, _colors: PackedColorArray) -> void:
		return

	func destroy() -> void:
		PhysicsServer2D.free_rid(body)

var bullets: Array[Bullet] = []

func _physics_process(delta: float) -> void:
	if bullets.is_empty():
		return
		
	for i in range(multimesh.visible_instance_count):
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
