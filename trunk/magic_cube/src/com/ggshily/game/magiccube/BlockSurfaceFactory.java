package com.ggshily.game.magiccube;

public class BlockSurfaceFactory
{
	public static BlockSurface createSurfaceVerticalX(int x, int y, int z)
	{
		Vertex[] vertexs = new Vertex[4];
		
		vertexs[0] = new Vertex(x, y, z);
		vertexs[1] = new Vertex(x, y, z + 1);
		vertexs[2] = new Vertex(x, y + 1, z);
		vertexs[3] = new Vertex(x, y + 1, z + 1);
		
		BlockSurface surface = new BlockSurface(vertexs);
		return surface;
	}
	public static BlockSurface createSurfaceVerticalY(int x, int y, int z)
	{
		Vertex[] vertexs = new Vertex[4];
		
		vertexs[0] = new Vertex(x, y, z);
		vertexs[1] = new Vertex(x + 1, y, z);
		vertexs[2] = new Vertex(x, y, z + 1);
		vertexs[3] = new Vertex(x + 1, y, z + 1);
		
		BlockSurface surface = new BlockSurface(vertexs);
		return surface;
	}
	public static BlockSurface createSurfaceVerticalZ(int x, int y, int z)
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
