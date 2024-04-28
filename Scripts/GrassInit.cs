using Godot;
using System;

[Tool]
public partial class GrassInit : MultiMeshInstance3D
{
	[Export] public CompressComponent Compressor;
	
	public override void _Ready()
	{
	}

	public override void _Process(double delta)
	{
		if(Compressor != null)
		{
			Node3D c = (Node3D)Compressor.GetParent();
			((ShaderMaterial)((MeshInstance3D)GetChild(0)).Mesh.SurfaceGetMaterial(0)).SetShaderParameter("compressor",new Vector4(c.GlobalPosition[0],c.GlobalPosition[1],c.GlobalPosition[2],Compressor.Amplitude));
		//	SetInstanceShaderParameter("compressor",new Vector4(c.GlobalPosition[0],c.GlobalPosition[1],c.GlobalPosition[2],Compressor.Amplitude));
		}
	}
}
