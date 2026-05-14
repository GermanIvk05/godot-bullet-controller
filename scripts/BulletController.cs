using System;
using Godot;

[GlobalClass]
public partial class BulletController : Node2D
{
    private BulletModel _model;
    private Rid _space;

    [Export] public BulletView View;
    [Export]
    public BulletModel Model
    {
        get => _model;
        set
        {
            _model?.Clear();
            _model = value;
            _model.Initialize(_space);
            _model.UpdateBehaviour = OnUpdateBullet;
            _model.ShouldDespawn = OnShouldDespawn;
        }
    }

    public override void _Ready()
    {
        _space = GetWorld2D().Space;
    }

    public override void _PhysicsProcess(double delta)
    {
        _model?.Update((float)delta);
        View.Update(_model?.GetPositions() ?? Array.Empty<Vector2>());
    }

    public void SpawnBullet(Vector2 position, Vector2 velocity)
    {
        _model?.SpawnBullet(position, velocity);
    }

    public override void _ExitTree()
    {
        _model?.Clear();
    }

    protected virtual void OnUpdateBullet(Bullet bullet, float delta)
    {
        bullet.Velocity += bullet.Acceleration * delta;
        bullet.Position += bullet.Velocity * delta;
    }
    protected virtual bool OnShouldDespawn(Bullet bullet, float delta) => !GetViewportRect().HasPoint(bullet.Position);
}