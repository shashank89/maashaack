package com.ggshily.game.magiccube;

public class CubeFactory
{
	/**
	 * 
	 * <p>&nbsp; &nbsp;111<br>
		&nbsp; &nbsp;111<br>
		&nbsp; &nbsp;111<br>
		222000333444<br>
		222000333444<br>
		222000333444<br>
		&nbsp; &nbsp;555<br>
		&nbsp; &nbsp;555<br>
		&nbsp; &nbsp;555</p>
	 * 
	 * @param data
	 * @return
	 */
	public static Cube createCube(String data)
	{
		return createCube(CubeUtil.string2Array(data));
	}

	/**
	 * 
	 * <p>&nbsp; &nbsp;111<br>
		&nbsp; &nbsp;111<br>
		&nbsp; &nbsp;111<br>
		222000333444<br>
		222000333444<br>
		222000333444<br>
		&nbsp; &nbsp;555<br>
		&nbsp; &nbsp;555<br>
		&nbsp; &nbsp;555</p>
	 * 
	 * @param data [0, 0, 0, 0, 0, 0, 0, 0, 0,
	 *              1, 1, 1, 1, 1, 1, 1, 1, 1,
	 *              2, 2, 2, 2, 2, 2, 2, 2, 2,
	 *              3, 3, 3, 3, 3, 3, 3, 3, 3,
	 *              4, 4, 4, 4, 4, 4, 4, 4, 4,
	 *              5, 5, 5, 5, 5, 5, 5, 5, 5]
	 * @return
	 */
	public static Cube createCube(int[] data)
	{

		Block[] blocks = new Block[3 * 3 * 3];
		for(int x = 0; x < 3; ++x)
		{
			for(int y = 0; y < 3; ++y)
			{
				for(int z = 0; z < 3; ++z)
				{
					int index = x * 3 * 3 + y * 3 + z;
					blocks[index] = new Block(BlockSurfaceFactory.createSurfaces(x - 1.5f, y - 1.5f, z - 1.5f));
					blocks[index].setId(index);
				}
			}
		}
		
		Cube cube = new Cube(blocks);
		
		Block[] surfaceBlocks = cube.getFrontBlocks();
		for(int i = 0; i < surfaceBlocks.length; ++i)
		{
			surfaceBlocks[i].getFrontSurface().set_colorIndex(Integer.valueOf(data[0 + i]));
		}
		
		surfaceBlocks = cube.getUpperBlocks();
		for(int i = 0; i < surfaceBlocks.length; ++i)
		{
			surfaceBlocks[i].getUpperSurface().set_colorIndex(Integer.valueOf(data[9 + i]));
		}
		
		surfaceBlocks = cube.getLeftBlocks();
		for(int i = 0; i < surfaceBlocks.length; ++i)
		{
			surfaceBlocks[i].getLeftSurface().set_colorIndex(Integer.valueOf(data[18 + i]));
		}
		
		surfaceBlocks = cube.getRightBlocks();
		for(int i = 0; i < surfaceBlocks.length; ++i)
		{
			surfaceBlocks[i].getRightSurface().set_colorIndex(Integer.valueOf(data[27 + i]));
		}
		
		surfaceBlocks = cube.getBackBlocks();
		for(int i = 0; i < surfaceBlocks.length; ++i)
		{
			surfaceBlocks[i].getBackSurface().set_colorIndex(Integer.valueOf(data[36 + i]));
		}
		
		surfaceBlocks = cube.getDownBlocks();
		for(int i = 0; i < surfaceBlocks.length; ++i)
		{
			surfaceBlocks[i].getDownSurface().set_colorIndex(Integer.valueOf(data[45 + i]));
		}
		
		return cube;
	}
}
