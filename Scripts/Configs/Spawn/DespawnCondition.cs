using Godot;

[GlobalClass]
public abstract partial class DespawnCondition : Resource
{
    public abstract bool ShouldDespawn(Bullet bullet);
}