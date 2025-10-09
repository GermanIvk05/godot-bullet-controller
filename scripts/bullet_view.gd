extends MultiMeshInstance2D
class_name BulletView

@export var view_model: BulletViewModel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	view_model.connect("bullet_created", _on_bullet_created)
	view_model.connect("bullets_updated", _on_bullets_updated)
	view_model.connect("bullet_destroyed", _on_bullet_destoryed)

	var viewport_rect = get_viewport_rect()
	var aabb_position = Vector3(viewport_rect.position.x, viewport_rect.position.y, 0)
	var aabb_size = Vector3(viewport_rect.size.x, viewport_rect.size.y, 0)
	multimesh.custom_aabb = AABB(aabb_position, aabb_size)
	# TODO: Make the custom AABB update when screen is resized


func _on_bullet_created(total_count: int, location: Vector2) -> void:
	# TODO: increment instance_count if not enough
	if multimesh.visible_instance_count >= multimesh.instance_count:
		return

	var transform2d := Transform2D()
	transform2d.origin = location
	multimesh.set_instance_transform_2d(total_count, transform2d)
	multimesh.visible_instance_count += 1


func _on_bullets_updated(positions: PackedVector2Array) -> void:
	var transform2d := Transform2D()
	for i in multimesh.visible_instance_count:
		transform2d.origin = positions[i]
		multimesh.set_instance_transform_2d(i, transform2d)


func _on_bullet_destoryed() -> void:
	multimesh.visible_instance_count -= 1
