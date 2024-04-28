using Godot;
using System;

public partial class Tile3D : StaticBody3D
{
	private MeshInstance3D _spriteMesh;
	[Export] public int TileId {get; set;} = 0;
	
	public Tile3D Setup(int t)
	{
		TileId = t;
		return this;
	}
	
	public Tile3D Setup(float x, float y, float z, int t)
	{
		SetCoords(x,y,z);
		return Setup(t);
	}
	
	public override void _Ready()
	{
		_spriteMesh = GetNode<MeshInstance3D>("TileSymbol");
		SetSprite();
	}
	
	public void SetCoords(float x, float y, float z)
	{
		Position = new Vector3(x,y,z);
	}
	
	private void SetSprite()
	{
		ShaderMaterial sprite = _spriteMesh.GetActiveMaterial(0) as ShaderMaterial;//_spriteMesh.Mesh.SurfaceGetMaterial(0) as ShaderMaterial;
		if(sprite != null)
			sprite.SetShaderParameter("uv1_offset",new Vector3((TileId%10)*0.1f,(TileId/10)*0.25f,0));
	}
}
