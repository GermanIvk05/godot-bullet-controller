using Godot;

public partial class Main : Node2D
{
	[Export] BulletController Controller;
	[Export] BulletPattern Pattern;

	public void OnButtonPressed()
	{
		Controller.SpawnPattern(Pattern, Controller.GlobalPosition, Controller.GlobalRotation);
	}
}
