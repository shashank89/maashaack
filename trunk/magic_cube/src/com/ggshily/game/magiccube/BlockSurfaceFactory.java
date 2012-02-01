package com.ggshily.game.magiccube;

public class BlockSurfaceFactory
{
	public static BlockSurface[] createSurfaces(float x, float y, float z)
	{
		BlockSurface[] surfaces = new BlockSurface[Block.SURFACE_NUMBER];
		surfaces[0] = BlockSurfaceFactory.createSurfaceVerticalX(x, y, z);
		surfaces[1] = BlockSurfaceFactory.createSurfaceVerticalX(x + 1, y, z);
		surfaces[2] = BlockSurfaceFactory.createSurfaceVerticalY(x, y, z);
		surfaces[3] = BlockSurfaceFactory.createSurfaceVerticalY(x, y + 1, z);
		surfaces[4] = BlockSurfaceFactory.createSurfaceVerticalZ(x, y, z);
		surfaces[5] = BlockSurfaceFactory.createSurfaceVerticalZ(x, y, z + 1);
		
		return surfaces;
	}
	
	public static BlockSurface createSurfaceVerticalX(float x, float y, float z)
	{
		Vertex[] vertexs = new Vertex[4];
		
		vertexs[0] = new Vertex(x, y, z);
		vertexs[1] = new Vertex(x, y, z + 1);
		vertexs[2] = new Vertex(x, y + 1, z);
		vertexs[3] = new Vertex(x, y + 1, z + 1);
		
		BlockSurface surface = new BlockSurface(vertexs);
		return surface;
	}
	public static BlockSurface createSurfaceVerticalY(float x, float y, float z)
	{
		Vertex[] vertexs = new Vertex[4];
		
		vertexs[0] = new Vertex(x, y, z);
		vertexs[1] = new Vertex(x + 1, y, z);
		vertexs[2] = new Vertex(x, y, z + 1);
		vertexs[3] = new Vertex(x + 1, y, z + 1);
		
		BlockSurface surface = new BlockSurface(vertexs);
		return surface;
	}
	public static BlockSurface createSurfaceVerticalZ(float x, float y, float z)
	{
		Vertex[] vertexs = new Vertex[4];
		
		vertexs[0] = new Vertex(x, y, z);
		vertexs[1] = new Vertex(x + 1, y, z);
		vertexs[2] = new Vertex(x, y + 1, z);
		vertexs[3] = new Vertex(x + 1, y + 1, z);
		
		BlockSurface surface = new BlockSurface(vertexs);
		return surface;
	}
}
