using Godot;

[GlobalClass]
public partial class LinearMovementConfig : MovementConfig
{
    [Export] public float Speed { get; set; } = 100f;

    public override IMovementStrategy CreateStrategy() => new LinearMovementStrategy(Speed);
}

public class LinearMovementStrategy : IMovementStrategy
{
    private float _speed;

    public LinearMovementStrategy(float speed)
    {
        _speed = speed;
    }

    public Vector2 Calculate(Vector2 position, float angle, float lifetime, float delta)
    {
        return Vector2.FromAngle(angle) * _speed * delta;
    }
}