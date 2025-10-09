# Bullet System (Godot 4)

A lightweight, MVVM-style bullet system for **Godot 4** that separates game logic (Model), scene orchestration (ViewModel), and rendering (View) using a performant `MultiMeshInstance2D`.

> Files included
>
> - `bullet.gd` — Base **Bullet** class (kinematic Body via `PhysicsServer2D`)  
> - `bullet_model.gd` — **BulletModel**: owns bullet data, spawning, physics, and lifecycle  
> - `bullet_viewmodel.gd` — **BulletViewModel**: bridges Model ↔ View, emits signals, ticks physics  
> - `bullet_view.gd` — **BulletView**: fast batched rendering with `MultiMeshInstance2D`

## Features

- **MVVM separation**: clean boundaries between logic, update loop, and rendering
- **Batched rendering**: `MultiMeshInstance2D` for thousands of bullets
- **Signals-first API**: `bullet_created`, `bullets_updated`, `bullet_destroyed`
- **PhysicsServer2D**-backed bullets (kinematic bodies) for control and performance
- **Pluggable**: provide any `Shape2D`, acceleration, and max velocity via exports

## Getting Started

### Requirements

- **Godot 4.x** (uses `PhysicsServer2D` & `MultiMeshInstance2D`)
- A `Shape2D` (e.g., `CircleShape2D`) to define the bullet collision/size

### 1) Add Nodes to Your Scene

1. Add a **Node2D** and attach `bullet_viewmodel.gd` (or create a custom node that instantiates it).
2. Add a **MultiMeshInstance2D** as a sibling or child and attach `bullet_view.gd`.
3. In the **BulletView** inspector, set **`view_model`** to your BulletViewModel node.
4. Create a **BulletModel** resource and assign it to **`view_model.model`**. Configure:
   - `shape` → your `Shape2D` (e.g., `CircleShape2D`)
   - `max_velocity` → cap speed (e.g., `Vector2(1200, 1200)`)
   - `acceleration` → per-axis acceleration (e.g., `Vector2(0, 0)`)

> The `BulletViewModel` automatically sets `model.space = get_world_2d().get_space()` in `_ready()`.

### 2) Spawning Bullets

Call `spawn_bullet()` on the **BulletViewModel** with a velocity in pixels/second. The bullet uses the view model's `global_position` as the origin.

```gdscript
# Example: Fire a bullet to the right at 800 px/s
@onready var bullets: BulletViewModel = $BulletViewModel

func _input(event):
    if event.is_action_pressed("fire"):
        bullets.spawn_bullet(Vector2(800, 0))
```

When a bullet is spawned/updated/destroyed, the view model emits:
- `bullet_created(total_count, location)`
- `bullets_updated(positions)` (every physics tick)
- `bullet_destroyed`

The **BulletView** listens and updates its `MultiMesh` transforms accordingly. It also sets a `custom_aabb` based on the current viewport for efficient culling.

### 3) Physics Updates
`BulletViewModel._physics_process(delta)` forwards the tick to `BulletModel.physics_update(delta)`, which updates all bullet positions and velocities, then emits `bullets_updated(...)` with a `PackedVector2Array` for fast, contiguous memory copies into the MultiMesh.

## Extending

- **Lifetimes / Despawn**: add TTL or out‑of‑bounds checks in `BulletModel.physics_update` and emit `bullet_destroyed` when removing instances.
- **Collisions**: turn on collision masks and query shapes with `PhysicsServer2D` or use an `Area2D` field test per bullet when needed.
- **Trails / Effects**: render particles or trail meshes indexed to bullet positions.
- **Pooling**: transform `bullets` into a pool to avoid allocations under heavy fire.
