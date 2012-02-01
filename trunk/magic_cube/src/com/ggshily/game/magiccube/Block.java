package com.ggshily.game.magiccube;

public class Block
{
	public static final int SURFACE_NUMBER = 6;
	
	private BlockSurface[] surfaces;

	public Block(int x, int y, int z)
	{
		
		surfaces = new BlockSurface[SURFACE_NUMBER];
		surfaces[0] = BlockSurfaceFactory.createSurfaceVerticalX(x, y, z);
		surfaces[1] = BlockSurfaceFactory.createSurfaceVerticalX(x + 1, y, z);
		surfaces[2] = BlockSurfaceFactory.createSurfaceVerticalY(x, y, z);
		surfaces[3] = BlockSurfaceFactory.createSurfaceVerticalY(x, y + 1, z);
		surfaces[4] = BlockSurfaceFactory.createSurfaceVerticalZ(x, y, z);
		surfaces[5] = BlockSurfaceFactory.createSurfaceVerticalZ(x, y, z + 1);
	}

	/**
	 * @return the surfaces
	 */
	public BlockSurface[] getSurfaces()
	{
		return surfaces;
	}

	/**
	 * @param surfaces the surfaces to set
	 */
	public void setSurfaces(BlockSurface[] surfaces)
	{
		this.surfaces = surfaces;
	}
	
	public void getBasePoint(Vertex base)
	{
		float x = 3.0f;
		float y = 3.0f;
		float z = 3.0f;
		
		for(int i = 0; i < SURFACE_NUMBER; ++i)
		{
			Vertex surfaceBase = surfaces[i].getBase();
			x = Math.min(x, surfaceBase.get_x());
			y = Math.min(y, surfaceBase.get_y());
			z = Math.min(z, surfaceBase.get_z());
		}
		
		base.set_x(x);
		base.set_y(y);
		base.set_z(z);
	}
	
	public BlockSurface getRightSurface()
	{
		Vertex base = new Vertex(0, 0, 0);
		getBasePoint(base);
		
		for(int i = 0; i < SURFACE_NUMBER; ++i)
		{
			if(surfaces[i].hasSameX() && surfaces[i].getBase().get_x() != base.get_x())
			{
				return surfaces[i];
			}
		}
		
		assert(false);
		return null;
	}
	
	public BlockSurface getLeftSurface()
	{
		Vertex base = new Vertex(0, 0, 0);
		getBasePoint(base);
		
		for(int i = 0; i < SURFACE_NUMBER; ++i)
		{
			if(surfaces[i].hasSameX() && surfaces[i].getBase().get_x() == base.get_x())
			{
				return surfaces[i];
			}
		}
		
		assert(false);
		return null;
	}
	
	public BlockSurface getFrontSurface()
	{
		Vertex base = new Vertex(0, 0, 0);
		getBasePoint(base);
		
		for(int i = 0; i < SURFACE_NUMBER; ++i)
		{
			if(surfaces[i].hasSameY() && surfaces[i].getBase().get_y() == base.get_y())
			{
				return surfaces[i];
			}
		}
		
		assert(false);
		return null;
	}
	
	public BlockSurface getBackSurface()
	{
		Vertex base = new Vertex(0, 0, 0);
		getBasePoint(base);
		
		for(int i = 0; i < SURFACE_NUMBER; ++i)
		{
			if(surfaces[i].hasSameY() && surfaces[i].getBase().get_y() != base.get_y())
			{
				return surfaces[i];
			}
		}
		
		assert(false);
		return null;
	}
	
	public BlockSurface getUpperSurface()
	{
		Vertex base = new Vertex(0, 0, 0);
		getBasePoint(base);
		
		for(int i = 0; i < SURFACE_NUMBER; ++i)
		{
			if(surfaces[i].hasSameZ() && surfaces[i].getBase().get_z() == base.get_z())
			{
				return surfaces[i];
			}
		}
		
		assert(false);
		return null;
	}
	
	public BlockSurface getDownSurface()
	{
		Vertex base = new Vertex(0, 0, 0);
		getBasePoint(base);
		
		for(int i = 0; i < SURFACE_NUMBER; ++i)
		{
			if(surfaces[i].hasSameZ() && surfaces[i].getBase().get_z() != base.get_z())
			{
				return surfaces[i];
			}
		}
		
		assert(false);
		return null;
	}

	public void transform(M4 transform)
	{
		for(int i = 0; i < surfaces.length; ++i)
		{
			surfaces[i].transform(transform);
		}
		
	}
}
