extends MultiMeshInstance2D
class_name BulletView

@export var model: BulletModel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	model.bullets_updated.connect(_on_bullets_updated)
	_update_aabb()
	get_viewport().size_changed.connect(_update_aabb)

func _update_aabb() -> void:
	var rect := get_viewport_rect()
	multimesh.custom_aabb = AABB(
		Vector3(rect.position.x, rect.position.y, 0),
		Vector3(rect.size.x, rect.size.y, 0)
	)

func _on_bullets_updated(positions: PackedVector2Array) -> void:
	_update_capacity(positions.size())
	multimesh.visible_instance_count = positions.size()
	var t := Transform2D()
	for i in multimesh.visible_instance_count:
		t.origin = positions[i]
		multimesh.set_instance_transform_2d(i, t)

func _update_capacity(count: int) -> void:
	var capacity := multimesh.instance_count
	if count > capacity:
		multimesh.instance_count = max(count, capacity * 2)
	if count < capacity / 4.:
		multimesh.instance_count = max(count, capacity / 2.)
