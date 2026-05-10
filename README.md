# Bullet System (Godot 4)

A lightweight, MVVM-style bullet system for **Godot 4** that separates game logic (Model), scene orchestration (ViewModel), and rendering (View) using a performant `MultiMeshInstance2D`.

> Files included
>
> - `bullet.gd` — Base **Bullet** class (kinematic Body via `PhysicsServer2D`)  
> - `bullet_model.gd` — **BulletModel**: owns bullet data, spawning, physics, lifecycle, and ticks physics  
> - `bullet_view.gd` — **BulletView**: fast batched rendering with `MultiMeshInstance2D`

## Features

- **MVVM separation**: clean boundaries between logic, update loop, and rendering
- **Batched rendering**: `MultiMeshInstance2D` for thousands of bullets
- **PhysicsServer2D**-backed bullets (kinematic bodies) for control and performance
- **Pluggable**: provide any `Shape2D`, acceleration, and max velocity via exports

## Getting Started

### Requirements

- **Godot 4.x** (uses `PhysicsServer2D` & `MultiMeshInstance2D`)
- A `Shape2D` (e.g., `CircleShape2D`) to define the bullet collision/size

### 1) Add Nodes to Your Scene

1. Add a **Node2D** and attach `bullet_model.gd` (or create a custom node that instantiates it).
2. Add a **MultiMeshInstance2D** as a sibling or child and attach `bullet_view.gd`.
3. In the **BulletView** inspector, set **`model`** to your BulletModel node.
   - `shape` → your `Shape2D` (e.g., `CircleShape2D`)
   - `max_velocity` → cap speed (e.g., `400`)
   - `acceleration` → per-axis acceleration (e.g., `Vector2(0, 0)`)

> The `BulletModel` automatically sets `model.space = get_world_2d().get_space()` in `_ready()`.

### 2) Spawning Bullets

Call `spawn_bullet()` on the **BulletModel** with a velocity in pixels/second. The bullet uses the model's `global_position` as the origin.

```gdscript
# Example: Fire a bullet to the right at 800 px/s
@onready var bullets: BulletModel = $BulletModel

func _input(event):
    if event.is_action_pressed("fire"):
        bullets.spawn_bullet(Vector2(800, 0))
```

The **BulletView** syncs its `MultiMesh` transforms to **BulletModel**. It also sets a `custom_aabb` based on the current viewport for efficient culling.

### 3) Physics Updates
`BulletModel._physics_process(delta)` updates all bullet positions and velocities, then emits `bullets_updated(...)` with a `PackedVector2Array` for fast, contiguous memory copies into the MultiMesh.

## Extending

- **Collisions**: turn on collision masks and query shapes with `PhysicsServer2D` or use an `Area2D` field test per bullet when needed.
- **Trails / Effects**: render particles or trail meshes indexed to bullet positions.
- **Pooling**: transform `bullets` into a pool to avoid allocations under heavy fire.
