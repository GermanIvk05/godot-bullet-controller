using System;
using System.Collections.Generic;
using Godot;

public class Bullet
{
    private Transform2D _transform = Transform2D.Identity;
    private Rid _body;

    public Vector2 Velocity { get; set; } = Vector2.Zero;
    public Vector2 Acceleration { get; set; } = Vector2.Zero;

    public Vector2 Position 
    { 
        get => _transform.Origin;
        set
        {
            _transform.Origin = value;
            PhysicsServer2D.BodySetState(_body, PhysicsServer2D.BodyState.Transform, _transform);
        }
    }
    
    public uint CollisionLayer
    {
        get => PhysicsServer2D.BodyGetCollisionLayer(_body);
        set => PhysicsServer2D.BodySetCollisionLayer(_body, value);
    }
    
    public uint CollisionMask
    {
        get => PhysicsServer2D.BodyGetCollisionMask(_body);
        set => PhysicsServer2D.BodySetCollisionMask(_body, value);
    }

    public Bullet(Shape2D shape, Rid space)
    {
        _body = PhysicsServer2D.BodyCreate();

        PhysicsServer2D.BodySetMode(_body, PhysicsServer2D.BodyMode.Kinematic);
        PhysicsServer2D.BodyAddShape(_body, shape.GetRid());
        PhysicsServer2D.BodySetSpace(_body, space);
    }

    public void Destroy()
    {
        PhysicsServer2D.FreeRid(_body);
    }
}

[GlobalClass]
public partial class BulletModel : Resource
{
    private List<Bullet> _bullets = new();
    private Rid _space;

    [Export] public Shape2D Shape;
    [Export] public uint CollisionLayer = 0;
    [Export] public uint CollisionMask = 0;

    public Action<Bullet, float> UpdateBehaviour { get; set; }
    public Func<Bullet, float, bool> ShouldDespawn { get; set; }

    public void Initialize(Rid space)
    {
        _space = space;
    }

    public void Update(float delta)
    {
        int i = 0;
        while (i < _bullets.Count)
        {
            var bullet = _bullets[i];
            UpdateBehaviour?.Invoke(bullet, delta);
    
            if (ShouldDespawn?.Invoke(bullet, delta) ?? false)
            {
                DespawnBullet(bullet);
            } else
            {
                i++;
            }
        }
    }

    public Vector2[] GetPositions()
    {
        var positions = new Vector2[_bullets.Count];
        for (int i = 0; i < _bullets.Count; i++)
        {
            positions[i] = _bullets[i].Position;
        }
        return positions;
    }

    public void SpawnBullet(Vector2 position, Vector2 velocity)
    {
        var bullet = new Bullet(Shape, _space)
        {
            Position = position,
            Velocity = velocity,
            CollisionLayer = CollisionLayer,
            CollisionMask = CollisionMask
        };
        _bullets.Add(bullet);
    }

    public void Clear()
    {
        foreach (var bullet in _bullets)
        {
            bullet.Destroy();
        }
        _bullets.Clear();
    }

    public void DespawnBullet(Bullet bullet)
    {
        bullet.Destroy();
        int idx = _bullets.IndexOf(bullet);
        _bullets[idx] = _bullets[^1];
        _bullets.RemoveAt(_bullets.Count - 1);
    }
}