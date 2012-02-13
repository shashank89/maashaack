package com.ggshily.game.magiccube;

import com.ggshily.game.util.ArrayUtil;


public class CubeResolver
{
	private static final Vertex[] EDGE_BLOCK_POSITION = {
		// front
		new Vertex(1, 0, 0),
		new Vertex(0, 0, 1),
		new Vertex(1, 0, 2),
		new Vertex(2, 0, 1),
		
		// middle y
		new Vertex(0, 1, 0),
		new Vertex(0, 1, 2),
		new Vertex(2, 1, 2),
		new Vertex(2, 1, 0),
		
		// back
		new Vertex(1, 2, 0),
		new Vertex(0, 2, 1),
		new Vertex(1, 2, 2),
		new Vertex(2, 2, 1),
	};
	
	private static final String[] FRONT_TOP_EDGE_METHOD = {
		"",
		"L'U'",
		"D2B2U2",
		"RU",
		
		"U'",
		"L2U'L2",
		"R2UR2",
		"U",
		
		"U2",
		"B'U2",
		"B2U2",
		"BU2"
	};
	
	private static final String FRONT_TOP_EDGE_COLOR_EXCHANGE = "UL'B'LU2";
	
	private static final Vertex[] CORNER_BLOCK_POSITION = {
		new Vertex(0, 0, 0),
		new Vertex(0, 0, 2),
		new Vertex(2, 0, 2),
		new Vertex(2, 0, 0),
		
		new Vertex(0, 2, 0),
		new Vertex(0, 2, 2),
		new Vertex(2, 2, 2),
		new Vertex(2, 2, 0),
	};
	
	private static final String[] FRONT_TOP_LEFT_CORNER_METHOD = {
		"",
		"LBL'B'UBU'",
		"R'BRB2UBU",
		"U'BUBUBU",
		
		"UBU'",
		"B'UBU'",
		"B2UBU'",
		"BUBU'"
	};
	
	private static final String FRONT_TOP_LEFT_CORNER_COLOR_EXCHANGE1 = "UBU'B'UBU";
	private static final String FRONT_TOP_LEFT_CORNER_COLOR_EXCHANGE2 = "UB'U'BUB'U";
	
	private static final String[] MIDDLE_TOP_LEFT_EDGE_METHOD = {
		"",
		"",
		"",
		"",
		
		"",
		"L'B'L'B'L'BLBLBU'B'U'B'U'BUBU",
		"RBRBRB'R'B'R'B'U'B'U'B'U'BUBU",
		"R'B'R'B'R'BRBRB'U'B'U'B'U'BUBU",
		
		"U'B'U'B'U'BUBU",
		"B'U'B'U'B'U'BUBU",
		"B2U'B'U'B'U'BUBU",
		"BU'B'U'B'U'BUBU",
	};
	private static final String MIDDLE_TOP_LEFT_EDGE_COLOR_EXCHANGE = "U'B'U'B'U'BUBUB'LBLBLB'L'B'L'";
	
	private static final String BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE = "FRUR'U'F'";
	
	private static final int[] BACK_CORNER_BLOCKS_COLOR_TEMPLATE_DONE = 
		{-1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		  4,  4,  4,  4,  4,  4,  4,  4,  4,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		};
	private static final int[] BACK_CORNER_BLOCKS_COLOR_TEMPLATE_1 = 
		{-1, -1, -1, -1, -1, -1, -1, -1, -1,
		  4, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		  4, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1,  4, -1,  4,  4,  4, -1,  4,  4,
		  4, -1, -1, -1, -1, -1, -1, -1, -1,
		};
	private static final int[] BACK_CORNER_BLOCKS_COLOR_TEMPLATE_2 = 
		{-1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1,  4, -1, -1, -1, -1, -1, -1,
		 -1, -1,  4, -1, -1, -1, -1, -1, -1,
		 -1, -1,  4, -1, -1, -1, -1, -1, -1,
		  4,  4,  4,  4,  4,  4,  4,  4,  4,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		};
	private static final String BACK_CORNER_BLOCKS_COLOR_EXCHANGE1 = "R'U'RU'R'U'2R";
	private static final String BACK_CORNER_BLOCKS_COLOR_EXCHANGE2 = "FUF'UFU2F'";
	private static final int[] BACK_CORNER_BLOCKS_COLOR_TEMPLATE_3 = 
		{-1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		  4,  4,  4,  4,  4,  4,  4,  4,  4,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		};
	private static final int[] BACK_CORNER_BLOCKS_COLOR_TEMPLATE_4 = 
		{-1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		  4,  4,  4,  4,  4,  4,  4,  4,  4,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		};
	private static final int[] BACK_CORNER_BLOCKS_COLOR_TEMPLATE_5 = 
		{-1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		  4,  4,  4,  4,  4,  4,  4,  4,  4,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		};
	private static final int[] BACK_CORNER_BLOCKS_COLOR_TEMPLATE_6 = 
		{-1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		  4,  4,  4,  4,  4,  4,  4,  4,  4,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		};
	private static final int[] BACK_CORNER_BLOCKS_COLOR_TEMPLATE_7 = 
		{-1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		  4,  4,  4,  4,  4,  4,  4,  4,  4,
		 -1, -1, -1, -1, -1, -1, -1, -1, -1,
		};
	
	public static String resolve(Cube cube)
	{
		String result = "";
		
		// 1st step: correct front four edge blocks
		result += correctFrontTopEdgeBlock(cube) + "\n";
		result += correctFrontLeftEdgeBlock(cube) + "\n";
		result += correctFrontDownEdgeBlock(cube) + "\n";
		result += correctFrontRightEdgeBlock(cube) + "\n";
		
		// 2nd step: correct front four corner blocks
		result += correctFrontTopLeftBlock(cube) + "\n";
		result += correctFrontLeftDownBlock(cube) + "\n";
		result += correctFrontRightDownBlock(cube) + "\n";
		result += correctFrontRightTopBlock(cube) + "\n";
		
		// 3th step: correct middle four edge blocks
		result += correctMiddleTopLeftBlock(cube) + "\n";
		result += correctMiddleLeftDownBlock(cube) + "\n";
		result += correctMiddleRightDownBlock(cube) + "\n";
		result += correctMiddleRightTopBlock(cube) + "\n";
		
		// 4th step: correct back four edge blocks' back color
		result += correctBackEdgeBlocksBackColor(cube) + "\n";
		
		// 5th step: correct back corner blocks' back color
		result += correctBackCornerBlocksBackColor(cube) + "\n";
		
		// 6th step: correct back corner blocks' position
		
		// 7th step: correct back edge blocks' position
		
		return result;
	}

	public static String correctFrontTopEdgeBlock(Cube cube)
	{
		String result = "";
		
		Block frontCenter = cube.getFrontBlocks()[4];
		Block upperCenter = cube.getUpperBlocks()[4];
		
		int frontColor = frontCenter.getFrontSurface().get_colorIndex();
		int upperColor = upperCenter.getUpperSurface().get_colorIndex();
		
		Block frontTopCenterBlock = cube.getEdgeBlock(frontColor, upperColor);
		
		Vertex base = new Vertex(0, 0, 0);
		frontTopCenterBlock.getBasePoint(base);
		cube.transformBasePoint(base);
		for(int i = 0; i < EDGE_BLOCK_POSITION.length; i++)
		{
			if(base.equals(EDGE_BLOCK_POSITION[i]))
			{
				result += FRONT_TOP_EDGE_METHOD[i];
				
				executeCommands(cube, FRONT_TOP_EDGE_METHOD[i]);
			}
		}
		if(cube.getFrontBlocks()[2].getFrontSurface().get_colorIndex() != frontColor)
		{
			result += FRONT_TOP_EDGE_COLOR_EXCHANGE;
			
			executeCommands(cube, FRONT_TOP_EDGE_COLOR_EXCHANGE);
		}
		return result;
	}

	public static String correctFrontLeftEdgeBlock(Cube cube)
	{
		cube.rotateYNegative90();
		String result = rotateCommandY90(correctFrontTopEdgeBlock(cube));
		cube.rotateY90();
		return result;
	}

	public static String correctFrontDownEdgeBlock(Cube cube)
	{
		cube.rotateY90();
		cube.rotateY90();
		String result = rotateCommandY90(rotateCommandY90(correctFrontTopEdgeBlock(cube)));
		cube.rotateY90();
		cube.rotateY90();
		return result;
	}

	public static String correctFrontRightEdgeBlock(Cube cube)
	{
		cube.rotateY90();
		String result = rotateCommandY90(rotateCommandY90(rotateCommandY90(correctFrontTopEdgeBlock(cube))));
		cube.rotateYNegative90();
		return result;
	}
	
	public static String correctFrontTopLeftBlock(Cube cube)
	{
		String result = "";
		
		Block frontCenter = cube.getFrontBlocks()[4];
		Block leftCenter = cube.getLeftBlocks()[4];
		Block upperCenter = cube.getUpperBlocks()[4];
		
		int frontColor = frontCenter.getFrontSurface().get_colorIndex();
		int leftColor = leftCenter.getLeftSurface().get_colorIndex();
		int upperColor = upperCenter.getUpperSurface().get_colorIndex();
		
		Block frontTopLeftBlock = cube.getCornerBlock(frontColor, leftColor, upperColor);
		
		Vertex base = new Vertex(0, 0, 0);
		frontTopLeftBlock.getBasePoint(base);
		cube.transformBasePoint(base);
		for(int i = 0; i < CORNER_BLOCK_POSITION.length; i++)
		{
			if(base.equals(CORNER_BLOCK_POSITION[i]))
			{
				result += FRONT_TOP_LEFT_CORNER_METHOD[i];
				executeCommands(cube, FRONT_TOP_LEFT_CORNER_METHOD[i]);
			}
		}
		
		if(frontTopLeftBlock.getFrontSurface().get_colorIndex() == leftColor &&
				frontTopLeftBlock.getLeftSurface().get_colorIndex() == upperColor)
		{
			result += FRONT_TOP_LEFT_CORNER_COLOR_EXCHANGE1;
			executeCommands(cube, FRONT_TOP_LEFT_CORNER_COLOR_EXCHANGE1);
		}
		else if(frontTopLeftBlock.getFrontSurface().get_colorIndex() == upperColor &&
				frontTopLeftBlock.getLeftSurface().get_colorIndex() == frontColor)
		{
			result += FRONT_TOP_LEFT_CORNER_COLOR_EXCHANGE2;
			executeCommands(cube, FRONT_TOP_LEFT_CORNER_COLOR_EXCHANGE2);
		}
		else
		{
			assert(false);
		}
		
		return result;
	}
	
	public static String correctFrontLeftDownBlock(Cube cube)
	{
		String result = "";
		
		cube.rotateYNegative90();
		result = rotateCommandY90(correctFrontTopLeftBlock(cube));
		cube.rotateY90();
		
		return result;
	}
	
	public static String correctFrontRightDownBlock(Cube cube)
	{
		String result = "";
		
		cube.rotateY90();
		cube.rotateY90();
		result = rotateCommandY90(rotateCommandY90(correctFrontTopLeftBlock(cube)));
		cube.rotateY90();
		cube.rotateY90();
		
		return result;
	}
	
	public static String correctFrontRightTopBlock(Cube cube)
	{
		String result = "";
		
		cube.rotateY90();
		result = rotateCommandY90(rotateCommandY90(rotateCommandY90(correctFrontTopLeftBlock(cube))));
		cube.rotateYNegative90();
		
		return result;
	}
	
	public static String correctMiddleTopLeftBlock(Cube cube)
	{
		String result = "";

		Block leftCenter = cube.getLeftBlocks()[4];
		Block upperCenter = cube.getUpperBlocks()[4];
		
		int leftColor = leftCenter.getLeftSurface().get_colorIndex();
		int upperColor = upperCenter.getUpperSurface().get_colorIndex();
		
		Block middleTopLeftBlock = cube.getEdgeBlock(leftColor, upperColor);
		
		Vertex base = new Vertex(0, 0, 0);
		middleTopLeftBlock.getBasePoint(base);
		cube.transformBasePoint(base);
		for(int i = 0; i < EDGE_BLOCK_POSITION.length; i++)
		{
			if(base.equals(EDGE_BLOCK_POSITION[i]))
			{
				result += MIDDLE_TOP_LEFT_EDGE_METHOD[i];
				
				executeCommands(cube, MIDDLE_TOP_LEFT_EDGE_METHOD[i]);
			}
		}
		if(middleTopLeftBlock.getUpperSurface().get_colorIndex() != upperColor)
		{
			result += MIDDLE_TOP_LEFT_EDGE_COLOR_EXCHANGE;
			
			executeCommands(cube, MIDDLE_TOP_LEFT_EDGE_COLOR_EXCHANGE);
		}

		return result;
	}
	
	public static String correctMiddleLeftDownBlock(Cube cube)
	{
		String result = "";
		
		cube.rotateYNegative90();
		result = rotateCommandY90(correctMiddleTopLeftBlock(cube));
		cube.rotateY90();
		
		return result;
	}
	
	public static String correctMiddleRightDownBlock(Cube cube)
	{
		String result = "";
		
		cube.rotateY90();
		cube.rotateY90();
		result = rotateCommandY90(rotateCommandY90(correctMiddleTopLeftBlock(cube)));
		cube.rotateY90();
		cube.rotateY90();
		
		return result;
	}
	
	public static String correctMiddleRightTopBlock(Cube cube)
	{
		String result = "";
		
		cube.rotateY90();
		result = rotateCommandY90(rotateCommandY90(rotateCommandY90(correctMiddleTopLeftBlock(cube))));
		cube.rotateYNegative90();
		
		return result;
	}

	public static String correctBackEdgeBlocksBackColor(Cube cube)
	{
		String result = "";
		
		Block[] backBlocks = cube.getBackBlocks();
		int backColor = backBlocks[4].getBackSurface().get_colorIndex();
		
		if(backBlocks[1].getBackColor() == backColor &&
				backBlocks[3].getBackColor() == backColor &&
				backBlocks[5].getBackColor() == backColor &&
				backBlocks[7].getBackColor() == backColor)
		{
			// done
		}
		else if(backBlocks[1].getBackColor() == backColor &&
				backBlocks[3].getBackColor() != backColor &&
				backBlocks[5].getBackColor() != backColor &&
				backBlocks[7].getBackColor() == backColor)
		{
			cube.rotateY90();
			cube.rotateXNegative90();
			executeCommands(cube, BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE);
			result = rotateCommandY90(rotateCommandY90(rotateCommandY90(rotateCommandX90(BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE))));
			cube.rotateX90();
			cube.rotateYNegative90();
		}
		else if(backBlocks[1].getBackColor() != backColor &&
				backBlocks[3].getBackColor() == backColor &&
				backBlocks[5].getBackColor() == backColor &&
				backBlocks[7].getBackColor() != backColor)
		{
			cube.rotateXNegative90();
			executeCommands(cube, BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE);
			result = rotateCommandX90(BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE);
			cube.rotateX90();
		}
		else if(backBlocks[1].getBackColor() != backColor &&
				backBlocks[3].getBackColor() != backColor &&
				backBlocks[5].getBackColor() != backColor &&
				backBlocks[7].getBackColor() != backColor)
		{
			cube.rotateXNegative90();
			executeCommands(cube, BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE);
			result = rotateCommandX90(BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE);

			cube.rotateY90();
			cube.rotateY90();
			
			executeCommands(cube, BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE);
			executeCommands(cube, BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE);
			result = rotateCommandY90(rotateCommandY90(rotateCommandX90(BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE)));
			result += rotateCommandY90(rotateCommandY90(rotateCommandX90(BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE)));

			cube.rotateY90();
			cube.rotateY90();
			
			cube.rotateX90();
		}
		else if(backBlocks[1].getBackColor() == backColor &&
				backBlocks[3].getBackColor() == backColor &&
				backBlocks[5].getBackColor() != backColor &&
				backBlocks[7].getBackColor() != backColor)
		{
			cube.rotateY90();
			cube.rotateY90();
			
			cube.rotateXNegative90();
			executeCommands(cube, BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE);
			executeCommands(cube, BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE);
			result = rotateCommandY90(rotateCommandY90(rotateCommandX90(BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE)));
			result += rotateCommandY90(rotateCommandY90(rotateCommandX90(BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE)));
			cube.rotateX90();

			cube.rotateY90();
			cube.rotateY90();
		}
		else if(backBlocks[1].getBackColor() == backColor &&
				backBlocks[3].getBackColor() != backColor &&
				backBlocks[5].getBackColor() == backColor &&
				backBlocks[7].getBackColor() != backColor)
		{
			cube.rotateY90();

			cube.rotateXNegative90();
			executeCommands(cube, BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE);
			executeCommands(cube, BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE);
			result = rotateCommandY90(rotateCommandY90(rotateCommandY90(rotateCommandX90(BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE))));
			result += rotateCommandY90(rotateCommandY90(rotateCommandY90(rotateCommandX90(BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE))));
			cube.rotateX90();
			
			cube.rotateYNegative90();
		}
		else if(backBlocks[1].getBackColor() != backColor &&
				backBlocks[3].getBackColor() == backColor &&
				backBlocks[5].getBackColor() != backColor &&
				backBlocks[7].getBackColor() == backColor)
		{
			cube.rotateYNegative90();

			cube.rotateXNegative90();
			executeCommands(cube, BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE);
			executeCommands(cube, BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE);
			result = rotateCommandY90(rotateCommandX90(BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE));
			result += rotateCommandY90(rotateCommandX90(BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE));
			cube.rotateX90();

			cube.rotateY90();
		}
		else if(backBlocks[1].getBackColor() != backColor &&
				backBlocks[3].getBackColor() != backColor &&
				backBlocks[5].getBackColor() == backColor &&
				backBlocks[7].getBackColor() == backColor)
		{
			cube.rotateXNegative90();
			executeCommands(cube, BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE);
			executeCommands(cube, BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE);
			result = rotateCommandX90(BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE);
			result += rotateCommandX90(BACK_EDGE_BLOCKS_BACK_COLOR_EXCHANGE);
			cube.rotateX90();
		}
		else
		{
			assert(false);
		}
		
		return result;
	}

	public static String correctBackCornerBlocksBackColor(Cube cube)
	{
		String result = "";
		
		Block[] backBlocks = cube.getBackBlocks();
		int backColor = backBlocks[4].getBackColor();
		
		int[] data = BACK_CORNER_BLOCKS_COLOR_TEMPLATE_DONE.clone();
		ArrayUtil.replace(data, 4, backColor);

		if(CubeUtil.isMatch(CubeFactory.createCube(data), cube))
		{
			// done
		}
		else
		{
			int count = 0;
			if(backBlocks[0].getBackColor() == backColor)
				count++;
			if(backBlocks[2].getBackColor() == backColor)
				count++;
			if(backBlocks[6].getBackColor() == backColor)
				count++;
			if(backBlocks[8].getBackColor() == backColor)
				count++;
			
			if(count == 1)
			{
				data = BACK_CORNER_BLOCKS_COLOR_TEMPLATE_1;
				ArrayUtil.replace(data, 4, backColor);
				int rotateCount1 = CubeUtil.isMathAfterRotateY(CubeFactory.createCube(data), cube);

				data = BACK_CORNER_BLOCKS_COLOR_TEMPLATE_2;
				ArrayUtil.replace(data, 4, backColor);
				int rotateCount2 = CubeUtil.isMathAfterRotateY(CubeFactory.createCube(data), cube);
				if(rotateCount1 != -1)
				{
					for(int i = 0; i < rotateCount1; ++i)
					{
						cube.rotateY90();
					}
					
					cube.rotateXNegative90();
					executeCommands(cube, BACK_CORNER_BLOCKS_COLOR_EXCHANGE1);
					result = rotateCommandX90(BACK_CORNER_BLOCKS_COLOR_EXCHANGE1);
					
					for(int i = rotateCount1; i < 4; ++i)
					{
						cube.rotateY90();
						result = rotateCommandYNegative90(result);
					}
				}
				else if(rotateCount2 != -1)
				{
					for(int i = 0; i < rotateCount2; ++i)
					{
						cube.rotateY90();
					}
					
					cube.rotateXNegative90();
					executeCommands(cube, BACK_CORNER_BLOCKS_COLOR_EXCHANGE2);
					result = rotateCommandX90(BACK_CORNER_BLOCKS_COLOR_EXCHANGE2);
					
					for(int i = rotateCount2; i < 4; ++i)
					{
						cube.rotateY90();
						result = rotateCommandYNegative90(result);
					}
				}
				else
				{
					assert(false);
				}
			}
		}
		
		return result;
	}
	
	public static void executeCommands(Cube cube, String commands)
	{
		int i = 0;
		while(i < commands.length())
		{
			char command = commands.charAt(i);
			if(i + 1 < commands.length() && commands.charAt(i + 1) == '\'')
			{
				command += 1;
				i++;
			}
			boolean twice = false;
			if(i + 1 < commands.length() && commands.charAt(i + 1) == '2')
			{
				twice = true;
				i++;
			}
			executeSingleCommand(cube, command);
			if(twice)
				executeSingleCommand(cube, command);
			
			i++;
		}
	}

	public static void executeSingleCommand(Cube cube, char command)
	{
		switch(command)
		{
		case 'F':
			cube.F();
			break;
		case 'B':
			cube.B();
			break;
		case 'L':
			cube.L();
			break;
		case 'R':
			cube.R();
			break;
		case 'U':
			cube.U();
			break;
		case 'D':
			cube.D();
			break;
		case 'F' + 1:
			cube.F_CC();
			break;
		case 'B' + 1:
			cube.B_CC();
			break;
		case 'L' + 1:
			cube.L_CC();
			break;
		case 'R' + 1:
			cube.R_CC();
			break;
		case 'U' + 1:
			cube.U_CC();
			break;
		case 'D' + 1:
			cube.D_CC();
			break;
		default:
			throw new Error("unknow command:" + command);
		}
	}
	
	public static String rotateCommandX90(String commands)
	{
		char[] commandChars = commands.toCharArray();
		
		for(int i = 0; i < commandChars.length; i++)
		{
			switch(commandChars[i])
			{
			case 'F':
				commandChars[i] = 'U';
				break;
			case 'U':
				commandChars[i] = 'B';
				break;
			case 'B':
				commandChars[i] = 'D';
				break;
			case 'D':
				commandChars[i] = 'F';
				break;
			}
		}
		return String.valueOf(commandChars);
	}
	
	public static String rotateCommandY90(String commands)
	{
		char[] commandChars = commands.toCharArray();
		
		for(int i = 0; i < commandChars.length; i++)
		{
			switch(commandChars[i])
			{
			case 'R':
				commandChars[i] = 'U';
				break;
			case 'U':
				commandChars[i] = 'L';
				break;
			case 'L':
				commandChars[i] = 'D';
				break;
			case 'D':
				commandChars[i] = 'R';
				break;
			}
		}
		return String.valueOf(commandChars);
	}
	
	public static String rotateCommandZ90(String commands)
	{
		char[] commandChars = commands.toCharArray();
		
		for(int i = 0; i < commandChars.length; i++)
		{
			switch(commandChars[i])
			{
			case 'F':
				commandChars[i] = 'L';
				break;
			case 'L':
				commandChars[i] = 'B';
				break;
			case 'B':
				commandChars[i] = 'R';
				break;
			case 'R':
				commandChars[i] = 'F';
				break;
			}
		}
		return String.valueOf(commandChars);
	}
	
	public static String rotateCommandYNegative90(String commands)
	{
		char[] commandChars = commands.toCharArray();
		
		for(int i = 0; i < commandChars.length; i++)
		{
			switch(commandChars[i])
			{
			case 'R':
				commandChars[i] = 'D';
				break;
			case 'U':
				commandChars[i] = 'R';
				break;
			case 'L':
				commandChars[i] = 'U';
				break;
			case 'D':
				commandChars[i] = 'L';
				break;
			}
		}
		return String.valueOf(commandChars);
	}
}
