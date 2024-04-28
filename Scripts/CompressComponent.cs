using Godot;
using System;

[Tool]
[GlobalClass]
public partial class CompressComponent : Node
{
	[Export] public float Amplitude = 0;
	
	public override void _Ready(){}

	public override void _Process(double delta){}
}
