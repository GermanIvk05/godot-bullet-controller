using Godot;

[GlobalClass]
public partial class BulletView : MultiMeshInstance2D
{
    public override void _Ready()
    {
        UpdateAabb();
        GetViewport().SizeChanged += UpdateAabb;
    }

    private void UpdateAabb()
    {
        var rect = GetViewportRect();
        Multimesh.CustomAabb = new Aabb(
            new Vector3(rect.Position.X, rect.Position.Y, 0),
            new Vector3(rect.Size.X, rect.Size.Y, 0)
        );
    }

    public void Update(Vector2[] positions)
    {
        UpdateCapacity(positions.Length);
        Multimesh.VisibleInstanceCount = positions.Length;
        var t = Transform2D.Identity;
        for (int i = 0; i < positions.Length; i++)
        {
            t.Origin = positions[i];
            Multimesh.SetInstanceTransform2D(i, t);
        }
    }

    private void UpdateCapacity(int count)
    {
        int capacity = Multimesh.InstanceCount;
        if (count > capacity)
        {
            Multimesh.InstanceCount = Mathf.Max(count, capacity * 2);
        } else if (count < capacity / 4)
        {
            Multimesh.InstanceCount = Mathf.Max(count, capacity / 2);
        }
    }
}