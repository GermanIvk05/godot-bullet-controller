using Godot;
using System;

[GlobalClass]
public partial class ArcPattern : BulletPattern
{
    [Export] public int BulletCount { get; set; } = 5;
    [Export] public float Radius { get; set; } = 50f;
    [Export] public float StartAngle { get; set; } = -45f;
    [Export] public float EndAngle { get; set; } = 45f;

    public override SpawnData[] GetSpawnData()
    {
        if (BulletCount <= 0)
        {
            return Array.Empty<SpawnData>();
        }

        float startRad = Mathf.DegToRad(StartAngle);
        float endRad = Mathf.DegToRad(EndAngle);

        if (BulletCount == 1) {
            Vector2 direction = Vector2.FromAngle((startRad + endRad) / 2f);
            return [
                new SpawnData
                {
                    Position = direction * Radius,
                    Direction = direction
                }
            ];
        }

        SpawnData[] spawns = new SpawnData[BulletCount];
        float angleStep = (endRad - startRad) / (BulletCount - 1);

        for (int i = 0; i < BulletCount; i++)
        {
            float angle = StartAngle + i * angleStep;
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