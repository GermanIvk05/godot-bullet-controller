using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using Godot;

public struct Bullet
{
    public Vector2 Position;
    public float Angle;
    public float Lifetime;
}

public class BulletBatch
{
    private List<Bullet> _bullets = new();
    private List<Rid> _bodies = new();
    private Rid _space;
    private Shape2D _shape;
    private uint _collisionLayer;
    private uint _collisionMask;
    
    public int Count => _bullets.Count;
    public IMovementStrategy MovementStrategy { get; set; }
    public DespawnCondition[] DespawnConditions { get; set; }
    

    public BulletBatch(Rid space, Shape2D shape, uint collisionLayer, uint collisionMask, IMovementStrategy strategy, DespawnCondition[] despawnConditions)
    {
        _space = space;
        _shape = shape;
        _collisionLayer = collisionLayer;
        _collisionMask = collisionMask;
        MovementStrategy = strategy;
        DespawnConditions = despawnConditions;
    }

    public void Spawn(Vector2 position, float angle)
    {
        _bullets.Add(new Bullet { Position = position, Angle = angle });

        var body = PhysicsServer2D.BodyCreate();
        PhysicsServer2D.BodySetMode(body, PhysicsServer2D.BodyMode.Kinematic);
        PhysicsServer2D.BodyAddShape(body, _shape.GetRid());
        PhysicsServer2D.BodySetSpace(body, _space);
        PhysicsServer2D.BodySetCollisionLayer(body, _collisionLayer);
        PhysicsServer2D.BodySetCollisionMask(body, _collisionMask);

        var t = new Transform2D(0f, position);
        PhysicsServer2D.BodySetState(body, PhysicsServer2D.BodyState.Transform, t);
    
        _bodies.Add(body);
    }

    public void SpawnBullets(ReadOnlySpan<(Vector2 Position, float Angle)> bullets)
    {
        _bullets.Capacity = _bodies.Capacity = _bullets.Count + bullets.Length;
        foreach (var (position, angle) in bullets)
        {
            Spawn(position, angle);
        }
    }

    public void Update(float delta)
    {
        var span = CollectionsMarshal.AsSpan(_bullets);
        for (int i = span.Length - 1; i >= 0; i--)
        {
            ref var bullet = ref span[i];
            bullet.Lifetime += delta;
            bullet.Position += MovementStrategy.Calculate(bullet.Position, bullet.Angle, bullet.Lifetime, delta);
            
            var t = new Transform2D(0f, bullet.Position);
            PhysicsServer2D.BodySetState(_bodies[i], PhysicsServer2D.BodyState.Transform, t);

            bool shouldDespawn = false;
            foreach (var condition in DespawnConditions)
            {
                if (condition.ShouldDespawn(bullet.Position, bullet.Angle, bullet.Lifetime))
                {
                    shouldDespawn = true;
                    break;
                }
            }
            
            if (shouldDespawn)
            {
                Despawn(i);
            }
        }
    }

    public void Despawn(int index)
    {
        PhysicsServer2D.FreeRid(_bodies[index]);
        _bullets[index] = _bullets[^1];
        _bodies[index] = _bodies[^1];
        _bullets.RemoveAt(_bullets.Count - 1);
        _bodies.RemoveAt(_bodies.Count - 1);
    }

    public void Clear()
    {
        foreach (var body in _bodies)
        {
            PhysicsServer2D.FreeRid(body);
        }
        _bullets.Clear();
        _bodies.Clear();
    }

    public void CopyPositionsTo(Vector2[] array, int offset)
    {
        var span = CollectionsMarshal.AsSpan(_bullets);
        for (int i = 0; i < span.Length; i++)
        {
            array[offset + i] = span[i].Position;
        }
    }
}
