using Godot;

[GlobalClass]
public partial class OscillateMovementConfig : MovementConfig
{
    [Export] public float ForwardSpeed { get; set; } = 100f;
    [Export] public float OscillateSpeed { get; set; } = 2f;
    [Export]public float Amplitude { get; set; } = 50f;

    public override IMovementStrategy CreateStrategy() => new OscillateMovementStrategy(ForwardSpeed, OscillateSpeed, Amplitude);
}


public class OscillateMovementStrategy : IMovementStrategy
{
    private float _forwardSpeed, _oscillateSpeed, _amplitude;

    public OscillateMovementStrategy(float forwardSpeed, float oscillateSpeed, float amplitude)
    {
        _forwardSpeed = forwardSpeed;
        _oscillateSpeed = oscillateSpeed;
        _amplitude = amplitude;
    }

    public Vector2 Calculate(Vector2 position, float angle, float lifetime, float delta)
    {
        Vector2 forward = Vector2.FromAngle(angle);
        Vector2 perpendicular = forward.Orthogonal();

        float previousSin = Mathf.Sin((lifetime - delta) * _oscillateSpeed) * _amplitude;
        float currentSin = Mathf.Sin(lifetime * _oscillateSpeed) * _amplitude;
        return forward * _forwardSpeed * delta + perpendicular * (currentSin - previousSin);
    }
}
