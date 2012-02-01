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
	
	private M4 transform = new M4();
	
	public Cube(Block[] blocks)
	{
		assert(blocks.length == BLOCK_NUMBER);
		
		this.blocks = blocks;
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
				if(base.get_x() == 0.0f)
				{
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
				if(base.get_x() == 2.0f)
				{
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
				if(base.get_z() == 0.0f)
				{
					frontBlocks[(int) (base.get_x() + base.get_y() * 3)] = blocks[i];
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
				if(base.get_z() == 2.0f)
				{
					backBlocks[(int) (base.get_x() + (2 - base.get_y()) * 3)] = blocks[i];
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
				if(base.get_y() == 0.0f)
				{
					upperBlocks[(int) (base.get_x() + (2 - base.get_z()) * 3)] = blocks[i];
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
				if(base.get_y() == 2.0f)
				{
					downBlocks[(int) (base.get_x() + base.get_z() * 3)] = blocks[i];
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
