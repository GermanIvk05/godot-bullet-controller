using Godot;

[GlobalClass]
public partial class LifetimeDespawnCondition : DespawnCondition
{
    [Export] public float MaxLifetime { get; set; }

    public override bool ShouldDespawn(Bullet bullet) => bullet.Lifetime >= MaxLifetime;
}