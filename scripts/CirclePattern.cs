using Godot;

[GlobalClass]
public partial class CirclePattern : BulletPattern
{
    [Export] public int BulletCount { get; set; } = 10;
    [Export] public float Radius { get; set; } = 50f;

    public override SpawnData[] GetSpawnData()
    {
        SpawnData[] spawns = new SpawnData[BulletCount];
        float angleStep = Mathf.Tau / BulletCount;

        for (int i = 0; i < BulletCount; i++)
        {
            float angle = i * angleStep;
            Vector2 direction = Vector2.FromAngle(angle);

            spawns[i] = new SpawnData
            {
                Position = direction * Radius,
                Direction = direction
            };
        }
        return spawns;
    }
}