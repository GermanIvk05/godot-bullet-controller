using Godot;

public struct SpawnData
{
    public Vector2 Position;
    public Vector2 Direction;
}

[GlobalClass]
public abstract partial class BulletPattern : Resource
{
    public abstract SpawnData[] GetSpawnData();
}