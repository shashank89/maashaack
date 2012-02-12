package com.ggshily.game.magiccube;

public class Block
{
	public static final int SURFACE_NUMBER = 6;
	
	private BlockSurface[] surfaces;
	private int id;

	public Block(BlockSurface[] surfaces)
	{
		this.surfaces = surfaces;
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
		Vertex surfaceBase = surfaces[0].getBase();
		float x = surfaceBase.get_x();
		float y = surfaceBase.get_y();
		float z = surfaceBase.get_z();
		
		for(int i = 1; i < SURFACE_NUMBER; ++i)
		{
			surfaceBase = surfaces[i].getBase();
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

	@Override
	public String toString()
	{
		Vertex base = new Vertex(0, 0, 0);
		getBasePoint(base);
		return "id(" + id + ") base(" + base.get_x() + ", " + base.get_y() + ", " + base.get_z() + ")" +
				" F" + getFrontSurface().get_colorIndex() + " L" + getLeftSurface().get_colorIndex() +
				" R" + getRightSurface().get_colorIndex() + " U" + getUpperSurface().get_colorIndex() + 
				" D" + getDownSurface().get_colorIndex() + " B" + getBackSurface().get_colorIndex();
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public int getOutSurfaceNumber()
	{
		int outSurfaceNumber = 0;
		for(int i = 0; i < surfaces.length; ++i)
		{
			if(surfaces[i].get_colorIndex() >= 0)
			{
				outSurfaceNumber++;
			}
		}
		return outSurfaceNumber;
	}

	public boolean hasColor(int color)
	{
		for(int i = 0; i < surfaces.length; ++i)
		{
			if(surfaces[i].get_colorIndex() == color)
			{
				return true;
			}
		}
		return false;
	}

	public int getBackColor()
	{
		return getBackSurface().get_colorIndex();
	}
}
