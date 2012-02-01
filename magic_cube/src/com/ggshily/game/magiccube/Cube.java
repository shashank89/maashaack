package com.ggshily.game.magiccube;

public class Cube
{
	public static final int BLOCK_NUMBER = 27;
	
	private Block[] blocks;
	
	private Block[] leftBlocks;
	private Block[] rightBlocks;
	private Block[] frontBlocks;
	private Block[] backBlocks;
	private Block[] upperBlocks;
	private Block[] downBlocks;
	
	private float leftX;
	private float rightX;
	private float upZ;
	private float downZ;
	private float frontY;
	private float backY;
	
	private M4 transform = new M4();
	
	public Cube(Block[] blocks)
	{
		assert(blocks.length == BLOCK_NUMBER);
		
		this.blocks = blocks;
		init();
	}
	

	private void init()
	{
		Vertex base = new Vertex(0, 0, 0);
		blocks[0].getBasePoint(base);
		leftX = base.get_x();
		rightX = base.get_x();
		upZ = base.get_z();
		downZ = base.get_z();
		frontY = base.get_y();
		backY = base.get_y();
		
		for(int i = 1; i < BLOCK_NUMBER; ++i)
		{
			blocks[i].getBasePoint(base);
			
			leftX = Math.min(leftX, base.get_x());
			rightX = Math.max(rightX, base.get_x());
			upZ = Math.min(upZ, base.get_z());
			downZ = Math.max(downZ, base.get_z());
			frontY = Math.min(frontY, base.get_y());
			backY = Math.max(backY, base.get_y());
		}
	}


	/**
	 * @return the blocks
	 */
	public Block[] getBlocks()
	{
		return blocks;
	}

	/**
	 * @param blocks the blocks to set
	 */
	public void setBlocks(Block[] blocks)
	{
		this.blocks = blocks;
	}


	/**
	 * @return the leftBlocks
	 */
	public Block[] getLeftBlocks()
	{
		if(leftBlocks == null)
		{
			leftBlocks = new Block[9];
			Vertex base = new Vertex(0.0f, 0.0f, 0.0f);
			for(int i = 0; i < BLOCK_NUMBER; ++i)
			{
				blocks[i].getBasePoint(base);
				if(base.get_x() == leftX)
				{
					base.minus(new Vertex(leftX, frontY, upZ));
					leftBlocks[(int) ((2 - base.get_y()) + base.get_z() * 3)] = blocks[i];
				}
			}
		}
		return leftBlocks;
	}


	/**
	 * @return the rightBlocks
	 */
	public Block[] getRightBlocks()
	{
		if(rightBlocks == null)
		{
			rightBlocks = new Block[9];
			Vertex base = new Vertex(0.0f, 0.0f, 0.0f);
			for(int i = 0; i < BLOCK_NUMBER; ++i)
			{
				blocks[i].getBasePoint(base);
				if(base.get_x() == rightX)
				{
					base.minus(new Vertex(leftX, frontY, upZ));
					rightBlocks[(int) (base.get_y() + base.get_z() * 3)] = blocks[i];
				}
			}
		}
		return rightBlocks;
	}


	/**
	 * @return the frontBlocks
	 */
	public Block[] getFrontBlocks()
	{
		if(frontBlocks == null)
		{
			frontBlocks = new Block[9];
			Vertex base = new Vertex(0.0f, 0.0f, 0.0f);
			for(int i = 0; i < BLOCK_NUMBER; ++i)
			{
				blocks[i].getBasePoint(base);
				if(base.get_y() == frontY)
				{
					base.minus(new Vertex(leftX, frontY, upZ));
					frontBlocks[(int) (base.get_x() + base.get_z() * 3)] = blocks[i];
				}
			}
		}
		return frontBlocks;
	}


	/**
	 * @return the backBlocks
	 */
	public Block[] getBackBlocks()
	{
		if(backBlocks == null)
		{
			backBlocks = new Block[9];
			Vertex base = new Vertex(0.0f, 0.0f, 0.0f);
			for(int i = 0; i < BLOCK_NUMBER; ++i)
			{
				blocks[i].getBasePoint(base);
				if(base.get_y() == backY)
				{
					base.minus(new Vertex(leftX, frontY, upZ));
					backBlocks[(int) ((2 - base.get_x()) + base.get_z() * 3)] = blocks[i];
				}
			}
		}
		return backBlocks;
	}


	/**
	 * @return the topBlocks
	 */
	public Block[] getUpperBlocks()
	{
		if(upperBlocks == null)
		{
			upperBlocks = new Block[9];
			Vertex base = new Vertex(0.0f, 0.0f, 0.0f);
			for(int i = 0; i < BLOCK_NUMBER; ++i)
			{
				blocks[i].getBasePoint(base);
				if(base.get_z() == upZ)
				{
					base.minus(new Vertex(leftX, frontY, upZ));
					upperBlocks[(int) (base.get_x() + (2 - base.get_y()) * 3)] = blocks[i];
				}
			}
		}
		return upperBlocks;
	}


	/**
	 * @return the bottomBlocks
	 */
	public Block[] getDownBlocks()
	{
		if(downBlocks == null)
		{
			downBlocks = new Block[9];
			Vertex base = new Vertex(0.0f, 0.0f, 0.0f);
			for(int i = 0; i < BLOCK_NUMBER; ++i)
			{
				blocks[i].getBasePoint(base);
				if(base.get_z() == downZ)
				{
					base.minus(new Vertex(leftX, frontY, upZ));
					downBlocks[(int) (base.get_x() + base.get_y() * 3)] = blocks[i];
				}
			}
		}
		return downBlocks;
	}
	
	public void R()
	{
		float[][] m = transform.m;

		float sin = (float)Math.sin(Math.PI / 2);
		float cos = (float)Math.cos(Math.PI / 2);

		m[1][1] = cos;
		m[1][2] = sin;
		m[2][1] = -sin;
		m[2][2] = cos;
		m[0][0] = 1f;
		m[0][1] = m[0][2] = m[1][0] = m[2][0] = 0f;
		
		for(int i = 0; i < getRightBlocks().length; ++i)
		{
			getRightBlocks()[i].transform(transform);
		}
		
		rightBlocks = null;
		upperBlocks = null;
		downBlocks = null;
		frontBlocks = null;
		backBlocks = null;
	}
	
	/**
	 * R'
	 * 
	 */
	public void R_CC()
	{
		float[][] m = transform.m;

		float sin = (float)Math.sin(-Math.PI / 2);
		float cos = (float)Math.cos(-Math.PI / 2);

		m[1][1] = cos;
		m[1][2] = sin;
		m[2][1] = -sin;
		m[2][2] = cos;
		m[0][0] = 1f;
		m[0][1] = m[0][2] = m[1][0] = m[2][0] = 0f;
		
		for(int i = 0; i < getRightBlocks().length; ++i)
		{
			getRightBlocks()[i].transform(transform);
		}
		
		rightBlocks = null;
		upperBlocks = null;
		downBlocks = null;
		frontBlocks = null;
		backBlocks = null;
		
	}
	
	public void L()
	{
		float[][] m = transform.m;

		float sin = (float)Math.sin(Math.PI / 2);
		float cos = (float)Math.cos(Math.PI / 2);

		m[1][1] = cos;
		m[1][2] = sin;
		m[2][1] = -sin;
		m[2][2] = cos;
		m[0][0] = 1f;
		m[0][1] = m[0][2] = m[1][0] = m[2][0] = 0f;
		
		for(int i = 0; i < getLeftBlocks().length; ++i)
		{
			getLeftBlocks()[i].transform(transform);
		}
		
		leftBlocks = null;
		upperBlocks = null;
		downBlocks = null;
		frontBlocks = null;
		backBlocks = null;
	}
	
	/**
	 * L'
	 * 
	 */
	public void L_CC()
	{
		float[][] m = transform.m;

		float sin = (float)Math.sin(-Math.PI / 2);
		float cos = (float)Math.cos(-Math.PI / 2);

		m[1][1] = cos;
		m[1][2] = sin;
		m[2][1] = -sin;
		m[2][2] = cos;
		m[0][0] = 1f;
		m[0][1] = m[0][2] = m[1][0] = m[2][0] = 0f;
		
		for(int i = 0; i < getLeftBlocks().length; ++i)
		{
			getLeftBlocks()[i].transform(transform);
		}
		
		leftBlocks = null;
		upperBlocks = null;
		downBlocks = null;
		frontBlocks = null;
		backBlocks = null;
		
	}
	
	public void U()
	{
		float[][] m = transform.m;

		float sin = (float)Math.sin(Math.PI / 2);
		float cos = (float)Math.cos(Math.PI / 2);

		m[0][0] = cos;
		m[0][1] = sin;
		m[1][0] = -sin;
		m[1][1] = cos;
		m[2][2] = 1f;
		m[2][0] = m[2][1] = m[0][2] = m[1][2] = 0f;
		
		for(int i = 0; i < getUpperBlocks().length; ++i)
		{
			getUpperBlocks()[i].transform(transform);
		}
		
		rightBlocks = null;
		upperBlocks = null;
		leftBlocks = null;
		frontBlocks = null;
		backBlocks = null;
	}
	
	/**
	 * U'
	 * 
	 */
	public void U_CC()
	{
		float[][] m = transform.m;

		float sin = (float)Math.sin(-Math.PI / 2);
		float cos = (float)Math.cos(-Math.PI / 2);

		m[0][0] = cos;
		m[0][1] = sin;
		m[1][0] = -sin;
		m[1][1] = cos;
		m[2][2] = 1f;
		m[2][0] = m[2][1] = m[0][2] = m[1][2] = 0f;
		
		for(int i = 0; i < getUpperBlocks().length; ++i)
		{
			getUpperBlocks()[i].transform(transform);
		}
		
		rightBlocks = null;
		upperBlocks = null;
		leftBlocks = null;
		frontBlocks = null;
		backBlocks = null;
		
	}
	
	public void D()
	{
		float[][] m = transform.m;

		float sin = (float)Math.sin(Math.PI / 2);
		float cos = (float)Math.cos(Math.PI / 2);

		m[0][0] = cos;
		m[0][1] = sin;
		m[1][0] = -sin;
		m[1][1] = cos;
		m[2][2] = 1f;
		m[2][0] = m[2][1] = m[0][2] = m[1][2] = 0f;
		
		for(int i = 0; i < getDownBlocks().length; ++i)
		{
			getDownBlocks()[i].transform(transform);
		}
		
		rightBlocks = null;
		upperBlocks = null;
		leftBlocks = null;
		frontBlocks = null;
		backBlocks = null;
	}
	
	/**
	 * D'
	 * 
	 */
	public void D_CC()
	{
		float[][] m = transform.m;

		float sin = (float)Math.sin(-Math.PI / 2);
		float cos = (float)Math.cos(-Math.PI / 2);

		m[0][0] = cos;
		m[0][1] = sin;
		m[1][0] = -sin;
		m[1][1] = cos;
		m[2][2] = 1f;
		m[2][0] = m[2][1] = m[0][2] = m[1][2] = 0f;
		
		for(int i = 0; i < getDownBlocks().length; ++i)
		{
			getDownBlocks()[i].transform(transform);
		}
		
		rightBlocks = null;
		upperBlocks = null;
		leftBlocks = null;
		frontBlocks = null;
		backBlocks = null;
		
	}
	
	public void F()
	{
		float[][] m = transform.m;

		float sin = (float)Math.sin(Math.PI / 2);
		float cos = (float)Math.cos(Math.PI / 2);

		m[0][0] = cos;
		m[0][2] = sin;
		m[2][0] = -sin;
		m[2][2] = cos;
		m[1][1] = 1f;
		m[0][1] = m[1][0] = m[1][2] = m[2][1] = 0f;
		
		for(int i = 0; i < getFrontBlocks().length; ++i)
		{
			getFrontBlocks()[i].transform(transform);
		}
		
		rightBlocks = null;
		upperBlocks = null;
		downBlocks = null;
		frontBlocks = null;
		leftBlocks = null;
	}
	
	/**
	 * F'
	 * 
	 */
	public void F_CC()
	{
		float[][] m = transform.m;

		float sin = (float)Math.sin(-Math.PI / 2);
		float cos = (float)Math.cos(-Math.PI / 2);

		m[0][0] = cos;
		m[0][2] = sin;
		m[2][0] = -sin;
		m[2][2] = cos;
		m[1][1] = 1f;
		m[0][1] = m[1][0] = m[1][2] = m[2][1] = 0f;
		
		for(int i = 0; i < getFrontBlocks().length; ++i)
		{
			getFrontBlocks()[i].transform(transform);
		}
		
		rightBlocks = null;
		upperBlocks = null;
		downBlocks = null;
		frontBlocks = null;
		leftBlocks = null;
		
	}
	
	public void B()
	{
		float[][] m = transform.m;

		float sin = (float)Math.sin(Math.PI / 2);
		float cos = (float)Math.cos(Math.PI / 2);

		m[0][0] = cos;
		m[0][2] = sin;
		m[2][0] = -sin;
		m[2][2] = cos;
		m[1][1] = 1f;
		m[0][1] = m[1][0] = m[1][2] = m[2][1] = 0f;
		
		for(int i = 0; i < getBackBlocks().length; ++i)
		{
			getBackBlocks()[i].transform(transform);
		}
		
		rightBlocks = null;
		upperBlocks = null;
		downBlocks = null;
		leftBlocks = null;
		backBlocks = null;
	}
	
	/**
	 * B'
	 * 
	 */
	public void B_CC()
	{
		float[][] m = transform.m;

		float sin = (float)Math.sin(-Math.PI / 2);
		float cos = (float)Math.cos(-Math.PI / 2);

		m[0][0] = cos;
		m[0][2] = sin;
		m[2][0] = -sin;
		m[2][2] = cos;
		m[1][1] = 1f;
		m[0][1] = m[1][0] = m[1][2] = m[2][1] = 0f;
		
		for(int i = 0; i < getBackBlocks().length; ++i)
		{
			getBackBlocks()[i].transform(transform);
		}
		
		rightBlocks = null;
		upperBlocks = null;
		downBlocks = null;
		leftBlocks = null;
		backBlocks = null;
		
	}
	
	public String toString()
	{
		String result = "   ";
		
		Block[] surfaceBlocks = getUpperBlocks();
		for(int i = 0; i < surfaceBlocks.length; ++i)
		{
			if(i > 0 && i % 3 == 0)
			{
				result += "\n";
				if(i < surfaceBlocks.length - 1)
				{
					result += "   ";
				}
			}
			result += surfaceBlocks[i].getUpperSurface().get_colorIndex();
		}
		result += "\n";
		
		for(int i = 0; i < 3; ++i)
		{
			result += getLeftBlocks()[0 + i * 3].getLeftSurface().get_colorIndex();
			result += getLeftBlocks()[1 + i * 3].getLeftSurface().get_colorIndex();
			result += getLeftBlocks()[2 + i * 3].getLeftSurface().get_colorIndex();
			
			result += getFrontBlocks()[0 + i * 3].getFrontSurface().get_colorIndex();
			result += getFrontBlocks()[1 + i * 3].getFrontSurface().get_colorIndex();
			result += getFrontBlocks()[2 + i * 3].getFrontSurface().get_colorIndex();
			
			result += getRightBlocks()[0 + i * 3].getRightSurface().get_colorIndex();
			result += getRightBlocks()[1 + i * 3].getRightSurface().get_colorIndex();
			result += getRightBlocks()[2 + i * 3].getRightSurface().get_colorIndex();
			
			result += getBackBlocks()[0 + i * 3].getBackSurface().get_colorIndex();
			result += getBackBlocks()[1 + i * 3].getBackSurface().get_colorIndex();
			result += getBackBlocks()[2 + i * 3].getBackSurface().get_colorIndex();
			result += "\n";
		}
		
		result += "   ";
		for(int i = 0; i < getDownBlocks().length; ++i)
		{
			if(i > 0 && i % 3 == 0)
			{
				result += "\n";
				if(i < getDownBlocks().length - 1)
				{
					result += "   ";
				}
			}
			result += getDownBlocks()[i].getDownSurface().get_colorIndex();
		}
		
		return result;
	}
}
