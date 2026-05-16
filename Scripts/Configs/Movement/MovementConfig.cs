using Godot;

[GlobalClass]
public abstract partial class MovementConfig : Resource
{
    public abstract IMovementStrategy CreateStrategy();
}

public interface IMovementStrategy
{
    public Vector2 Calculate(Vector2 position, float angle, float lifetime, float delta);
}
