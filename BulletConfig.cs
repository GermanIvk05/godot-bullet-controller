using Godot;

[GlobalClass]
public partial class BulletConfig : Resource
{
    [ExportGroup("Combat")]
    [Export] public int Damage { get; set; } = 400;

    [ExportGroup("Movement")]
    [Export] public float Speed { get; set; } = 400f;
    [Export] public float Acceleration { get; set; } = 0f;
    [Export] public float AngularVelocity { get; set; } = 0f;

    [Export] public float MaxSpeed { get; set; } = 800f;
    [Export] public float MaxAcceleration { get; set; } = 0f;
    
    [ExportGroup("Collision")]
    [Export(PropertyHint.Layers2DPhysics)] public uint CollisionLayer { get; set; } = 0;
    [Export(PropertyHint.Layers2DPhysics)] public uint CollisionMask { get; set; } = 0;

    [ExportGroup("Lifecycle")]
    [Export] public float Livespan { get; set; } = 5f;
}