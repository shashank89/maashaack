package com.ggshily.game.magiccube;

public class CubeUtil
{
	/**
	 * check if <code>cube1</code> and <code>cube2</code>'s color is match or not, ignore value -1
	 * 
	 * @param cube1
	 * @param cube2
	 * @return
	 */
	public static boolean isMatch(Cube cube1, Cube cube2)
	{
		for(int i = 0; i < cube1.getFrontBlocks().length; ++i)
		{
			if(cube1.getFrontBlocks()[i].getFrontColor() != cube2.getFrontBlocks()[i].getFrontColor() &&
					cube1.getFrontBlocks()[i].getFrontColor() != -1 &&
					cube2.getFrontBlocks()[i].getFrontColor() != -1)
			{
				return false;
			}
		}
		for(int i = 0; i < cube1.getBackBlocks().length; ++i)
		{
			if(cube1.getBackBlocks()[i].getBackColor() != cube2.getBackBlocks()[i].getBackColor() &&
					cube1.getBackBlocks()[i].getBackColor() != -1 &&
					cube2.getBackBlocks()[i].getBackColor() != -1)
			{
				return false;
			}
		}
		for(int i = 0; i < cube1.getLeftBlocks().length; ++i)
		{
			if(cube1.getLeftBlocks()[i].getLeftColor() != cube2.getLeftBlocks()[i].getLeftColor() &&
					cube1.getLeftBlocks()[i].getLeftColor() != -1 &&
					cube2.getLeftBlocks()[i].getLeftColor() != -1)
			{
				return false;
			}
		}
		for(int i = 0; i < cube1.getRightBlocks().length; ++i)
		{
			if(cube1.getRightBlocks()[i].getRightColor() != cube2.getRightBlocks()[i].getRightColor() &&
					cube1.getRightBlocks()[i].getRightColor() != -1 &&
					cube2.getRightBlocks()[i].getRightColor() != -1)
			{
				return false;
			}
		}
		for(int i = 0; i < cube1.getUpperBlocks().length; ++i)
		{
			if(cube1.getUpperBlocks()[i].getUpperColor() != cube2.getUpperBlocks()[i].getUpperColor() &&
					cube1.getUpperBlocks()[i].getUpperColor() != -1 &&
					cube2.getUpperBlocks()[i].getUpperColor() != -1)
			{
				return false;
			}
		}
		for(int i = 0; i < cube1.getDownBlocks().length; ++i)
		{
			if(cube1.getDownBlocks()[i].getDownColor() != cube2.getDownBlocks()[i].getDownColor() &&
					cube1.getDownBlocks()[i].getDownColor() != -1 &&
					cube2.getDownBlocks()[i].getDownColor() != -1)
			{
				return false;
			}
		}
		return true;
	}
	
	/**
	 * 
	 * check if two cube is match after rotate Y
	 * 
	 * @param cube1
	 * @param cube2
	 * @return -1, not match<br>
	 * 0 or 1 or 2 or 3, match after rotate Y 0/1/2/3 times
	 */
	public static int isMathAfterRotateY(Cube cube1, Cube cube2)
	{
		if(isMatch(cube1, cube2))
		{
			return 0;
		}
		cube1.rotateY90();
		if(isMatch(cube1, cube2))
		{
			return 1;
		}
		cube1.rotateY90();
		if(isMatch(cube1, cube2))
		{
			return 2;
		}
		cube1.rotateY90();
		if(isMatch(cube1, cube2))
		{
			return 3;
		}
		
		return -1;
	}
	
	/**
	 * 
	 * &nbsp;&nbsp;&nbsp;111<br>
	 * &nbsp;&nbsp;&nbsp;111<br>
	 * &nbsp;&nbsp;&nbsp;111<br>
	 * 222000333444<br>
		222000333444<br>
		222000333444<br>
		&nbsp; &nbsp;555<br>
		&nbsp; &nbsp;555<br>
		&nbsp; &nbsp;555<br>
		to<br>
		[0, 0, 0, 0, 0, 0, 0, 0, 0,<br>
	 *  &nbsp;1, 1, 1, 1, 1, 1, 1, 1, 1,<br>
	 *  &nbsp;2, 2, 2, 2, 2, 2, 2, 2, 2,<br>
	 *  &nbsp;3, 3, 3, 3, 3, 3, 3, 3, 3,<br>
	 *  &nbsp;4, 4, 4, 4, 4, 4, 4, 4, 4,<br>
	 *  &nbsp;5, 5, 5, 5, 5, 5, 5, 5, 5]
	 */
	public static int[] string2Array(String value)
	{
		int[] data = new int[54];
		
		data[0 * 9 + 0] = Integer.valueOf(String.valueOf(value.charAt(21 + 3)));
		data[0 * 9 + 1] = Integer.valueOf(String.valueOf(value.charAt(21 + 4)));
		data[0 * 9 + 2] = Integer.valueOf(String.valueOf(value.charAt(21 + 5)));
		data[0 * 9 + 3] = Integer.valueOf(String.valueOf(value.charAt(34 + 3)));
		data[0 * 9 + 4] = Integer.valueOf(String.valueOf(value.charAt(34 + 4)));
		data[0 * 9 + 5] = Integer.valueOf(String.valueOf(value.charAt(34 + 5)));
		data[0 * 9 + 6] = Integer.valueOf(String.valueOf(value.charAt(47 + 3)));
		data[0 * 9 + 7] = Integer.valueOf(String.valueOf(value.charAt(47 + 4)));
		data[0 * 9 + 8] = Integer.valueOf(String.valueOf(value.charAt(47 + 5)));

		data[1 * 9 + 0] = Integer.valueOf(String.valueOf(value.charAt(0 + 3)));
		data[1 * 9 + 1] = Integer.valueOf(String.valueOf(value.charAt(0 + 4)));
		data[1 * 9 + 2] = Integer.valueOf(String.valueOf(value.charAt(0 + 5)));
		data[1 * 9 + 3] = Integer.valueOf(String.valueOf(value.charAt(7 + 3)));
		data[1 * 9 + 4] = Integer.valueOf(String.valueOf(value.charAt(7 + 4)));
		data[1 * 9 + 5] = Integer.valueOf(String.valueOf(value.charAt(7 + 5)));
		data[1 * 9 + 6] = Integer.valueOf(String.valueOf(value.charAt(14 + 3)));
		data[1 * 9 + 7] = Integer.valueOf(String.valueOf(value.charAt(14 + 4)));
		data[1 * 9 + 8] = Integer.valueOf(String.valueOf(value.charAt(14 + 5)));

		data[2 * 9 + 0] = Integer.valueOf(String.valueOf(value.charAt(21 + 0)));
		data[2 * 9 + 1] = Integer.valueOf(String.valueOf(value.charAt(21 + 1)));
		data[2 * 9 + 2] = Integer.valueOf(String.valueOf(value.charAt(21 + 2)));
		data[2 * 9 + 3] = Integer.valueOf(String.valueOf(value.charAt(34 + 0)));
		data[2 * 9 + 4] = Integer.valueOf(String.valueOf(value.charAt(34 + 1)));
		data[2 * 9 + 5] = Integer.valueOf(String.valueOf(value.charAt(34 + 2)));
		data[2 * 9 + 6] = Integer.valueOf(String.valueOf(value.charAt(47 + 0)));
		data[2 * 9 + 7] = Integer.valueOf(String.valueOf(value.charAt(47 + 1)));
		data[2 * 9 + 8] = Integer.valueOf(String.valueOf(value.charAt(47 + 2)));

		data[3 * 9 + 0] = Integer.valueOf(String.valueOf(value.charAt(21 + 6)));
		data[3 * 9 + 1] = Integer.valueOf(String.valueOf(value.charAt(21 + 7)));
		data[3 * 9 + 2] = Integer.valueOf(String.valueOf(value.charAt(21 + 8)));
		data[3 * 9 + 3] = Integer.valueOf(String.valueOf(value.charAt(34 + 6)));
		data[3 * 9 + 4] = Integer.valueOf(String.valueOf(value.charAt(34 + 7)));
		data[3 * 9 + 5] = Integer.valueOf(String.valueOf(value.charAt(34 + 8)));
		data[3 * 9 + 6] = Integer.valueOf(String.valueOf(value.charAt(47 + 6)));
		data[3 * 9 + 7] = Integer.valueOf(String.valueOf(value.charAt(47 + 7)));
		data[3 * 9 + 8] = Integer.valueOf(String.valueOf(value.charAt(47 + 8)));

		data[4 * 9 + 0] = Integer.valueOf(String.valueOf(value.charAt(21 + 9)));
		data[4 * 9 + 1] = Integer.valueOf(String.valueOf(value.charAt(21 + 10)));
		data[4 * 9 + 2] = Integer.valueOf(String.valueOf(value.charAt(21 + 11)));
		data[4 * 9 + 3] = Integer.valueOf(String.valueOf(value.charAt(34 + 9)));
		data[4 * 9 + 4] = Integer.valueOf(String.valueOf(value.charAt(34 + 10)));
		data[4 * 9 + 5] = Integer.valueOf(String.valueOf(value.charAt(34 + 11)));
		data[4 * 9 + 6] = Integer.valueOf(String.valueOf(value.charAt(47 + 9)));
		data[4 * 9 + 7] = Integer.valueOf(String.valueOf(value.charAt(47 + 10)));
		data[4 * 9 + 8] = Integer.valueOf(String.valueOf(value.charAt(47 + 11)));

		data[5 * 9 + 0] = Integer.valueOf(String.valueOf(value.charAt(60 + 3)));
		data[5 * 9 + 1] = Integer.valueOf(String.valueOf(value.charAt(60 + 4)));
		data[5 * 9 + 2] = Integer.valueOf(String.valueOf(value.charAt(60 + 5)));
		data[5 * 9 + 3] = Integer.valueOf(String.valueOf(value.charAt(67 + 3)));
		data[5 * 9 + 4] = Integer.valueOf(String.valueOf(value.charAt(67 + 4)));
		data[5 * 9 + 5] = Integer.valueOf(String.valueOf(value.charAt(67 + 5)));
		data[5 * 9 + 6] = Integer.valueOf(String.valueOf(value.charAt(74 + 3)));
		data[5 * 9 + 7] = Integer.valueOf(String.valueOf(value.charAt(74 + 4)));
		data[5 * 9 + 8] = Integer.valueOf(String.valueOf(value.charAt(74 + 5)));
		return data;
	}

	/**
	 * 
	 * [0, 0, 0, 0, 0, 0, 0, 0, 0,<br>
	 *  &nbsp;1, 1, 1, 1, 1, 1, 1, 1, 1,<br>
	 *  &nbsp;2, 2, 2, 2, 2, 2, 2, 2, 2,<br>
	 *  &nbsp;3, 3, 3, 3, 3, 3, 3, 3, 3,<br>
	 *  &nbsp;4, 4, 4, 4, 4, 4, 4, 4, 4,<br>
	 *  &nbsp;5, 5, 5, 5, 5, 5, 5, 5, 5]<br>
	 * to<br>
	 * &nbsp;&nbsp;&nbsp;111<br>
	 * &nbsp;&nbsp;&nbsp;111<br>
	 * &nbsp;&nbsp;&nbsp;111<br>
	 * 222000333444<br>
		222000333444<br>
		222000333444<br>
		&nbsp; &nbsp;555<br>
		&nbsp; &nbsp;555<br>
		&nbsp; &nbsp;555
	 */
	public static String array2String(int[] value)
	{
		String data = "   ";

		for(int i = 0; i < 9; ++i)
		{
			if(i > 0 && i % 3 == 0)
			{
				data += "\n";
				if(i < 9 - 1)
				{
					data += "   ";
				}
			}
			data += value[1 * 9 + i];
		}
		data += "\n";
		
		for(int i = 0; i < 3; ++i)
		{
			data += value[2 * 9 + 0 + i * 3];
			data += value[2 * 9 + 1 + i * 3];
			data += value[2 * 9 + 2 + i * 3];
			
			data += value[0 * 9 + 0 + i * 3];
			data += value[0 * 9 + 1 + i * 3];
			data += value[0 * 9 + 2 + i * 3];
			
			data += value[3 * 9 + 0 + i * 3];
			data += value[3 * 9 + 1 + i * 3];
			data += value[3 * 9 + 2 + i * 3];
			
			data += value[4 * 9 + 0 + i * 3];
			data += value[4 * 9 + 1 + i * 3];
			data += value[4 * 9 + 2 + i * 3];
			data += "\n";
		}
		
		data += "   ";
		for(int i = 0; i < 9; ++i)
		{
			if(i > 0 && i % 3 == 0)
			{
				data += "\n";
				if(i < 9 - 1)
				{
					data += "   ";
				}
			}
			data += value[5 * 9 + i];
		}
		return data;
	}
}
