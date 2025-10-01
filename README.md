# Godot Bullet Controller

A tiny, fast bullet system for **Godot 5** that renders large numbers of projectiles with a `MultiMeshInstance2D` while updating motion through the low‑level `PhysicsServer2D` API.

> Works great for shmups, radial barrages, and any effect that needs many simple moving sprites/particles with per‑instance transforms.

## Features

- **High‑throughput rendering** with `MultiMeshInstance2D` (one draw call; thousands of instances possible).
- **Lightweight physics** using `PhysicsServer2D` bodies (kinematic), so you can opt into collisions later.
- **Composable bullets**: a base `BulletController.Bullet` class you can extend for custom behaviors.
- **Simple API** to add/remove bullets from a central controller.
- **Deterministic updates** via a single `update(delta)` per bullet.

## Requirements

- Godot **5.x** (tested with 5.x API names used in these scripts).
- A 2D project.

## Quick Start

1. **Copy files** into your project (e.g. `res://scripts/`):
   - `bullet_controller.gd`
   - `bullet.gd`
   - `main.gd` (sample spawner)

2. **Scene setup**
   - Create a `Node2D` root and attach `main.gd` to it (optional: use it as a demo).
   - Add a child **`MultiMeshInstance2D`** node and set its script to **`bullet_controller.gd`**. Name it **`BulletController`** so `$BulletController` works.
   - Assign a **texture/material** to the `MultiMeshInstance2D`:
	 - Create a `CanvasItemMaterial` if you need blending, and a quad mesh via `QuadMesh` or `PlaneMesh` (for 2D, QuadMesh is typical).
	 - Set the `multimesh` mesh to your quad and size it to your bullet sprite dimensions.
   - Optionally, add a UI Button and connect its `pressed()` signal to `_on_spawn_circle_button_pressed` in `main.gd` to try the demo.

3. **Run the scene** and press the button to spawn a ring of bullets.

## How it works

### `BulletController` (`bullet_controller.gd`)

A controller node that owns:

- A `MultiMesh` for rendering bullets in a single draw call.
- An array of **`Bullet`** instances (lightweight logic holders).
- Add/remove helpers that keep the `MultiMesh` instance transforms and count in sync.

Key pieces (simplified):

```gdscript
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
```

There are helpers (not shown fully here) such as:

- `add_bullet(bullet: Bullet) -> void` — appends a new bullet and writes its transform into the next MultiMesh instance, increasing `visible_instance_count`.
- `remove_bullet(id: int) -> void` — removes and frees a bullet by index, decreasing `visible_instance_count`.
- `_process(delta)` or `_physics_process(delta)` (depending on how you wire it) — iterates bullets, calls `update(delta)`, and writes each transform to the `MultiMesh`.

> Note: The controller is implemented as a `MultiMeshInstance2D`, so you **must** assign a mesh/material for visible rendering.

### `RegularBullet` (`bullet.gd`)

A concrete bullet that extends the nested base class:

```gdscript
class_name RegularBullet
extends BulletController.Bullet

var velocity: Vector2 = Vector2.ZERO
var acceleration: Vector2 = Vector2.ZERO

func _init(position: Vector2, shape: Shape2D, space: RID) -> void:
	super(position)
	PhysicsServer2D.body_set_mode(body, PhysicsServer2D.BODY_MODE_KINEMATIC)
	PhysicsServer2D.body_add_shape(body, shape)
	PhysicsServer2D.body_set_collision_mask(body, 0) # no collisions by default
	PhysicsServer2D.body_set_space(body, space)

func set_velocity(value: Vector2) -> RegularBullet:
	velocity = value
	return self

func set_acceleration(value: Vector2) -> RegularBullet:
	acceleration = value
	return self

func update(delta: float) -> void:
	velocity += acceleration * delta
	transform.origin += velocity * delta + 0.5 * acceleration * pow(delta, 2)
	PhysicsServer2D.body_set_state(body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform)
```

## Usage patterns

- **Linear motion:** set `velocity` only.
- **Accelerated motion:** also set `acceleration` (e.g. gravity‐like pull or easing in/out).
- **Spiral/radial patterns:** vary `dir` and/or update `velocity` in `update(delta)` for custom bullets.
- **Lifetime & culling:** implement lifespan or off‑screen checks inside your `update(delta)` and call `remove_bullet(index)` from the controller when needed.

---

## Extending

Create your own bullet types by extending `BulletController.Bullet`:

```gdscript
class_name HomingBullet
extends BulletController.Bullet

@export var turn_rate: float = 5.0
var target: Node2D

func update(delta: float) -> void:
	if target:
		var to_target := (target.global_position - transform.origin).normalized()
		var current := Vector2.RIGHT.rotated(transform.get_rotation())
		var new_dir := current.slerp(to_target, clamp(turn_rate * delta, 0.0, 1.0))
		# Move forward in the new direction
		transform = Transform2D(new_dir.angle(), transform.origin + new_dir * 200.0 * delta)
	PhysicsServer2D.body_set_state(body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform)
```

Register it with the controller the same way you add `RegularBullet`.

## Tips & gotchas

- The controller depends on its **`MultiMesh`** being set up. If bullets are invisible, verify you created and assigned a mesh and material.
- `collision_mask` is set to `0` in `RegularBullet`, so by default bullets **won’t collide**. Change masks/layers and add query/callbacks if you need hits.
- Consider using `_physics_process(delta)` in the controller if you need fixed‑timestep updates.
- For extremely large counts, pre‑allocate the `MultiMesh` instance count and reuse bullet slots to avoid reallocation.
- Clean up: call `remove_bullet()` or ensure bullets `destroy()` their RIDs when done (e.g., on scene change).

---

## Minimal code to spawn one bullet

```gdscript
var b := RegularBullet.new(global_position, preload("res://circle_shape.tres"), get_world_2d().get_space())
b.set_velocity(Vector2.RIGHT * 600.0)
$BulletController.add_bullet(b)
```
