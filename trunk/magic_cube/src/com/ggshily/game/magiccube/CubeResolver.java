package com.ggshily.game.magiccube;


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
		"",
		"",
		"",
		
		"",
		"",
		"",
		""
	};
	
	public static String resolve(Cube cube)
	{
		String result = "";
		
		// first step: correct front four edge blocks
		result += correctFrontTopEdgeBlock(cube) + "\n";
		result += correctFrontLeftEdgeBlock(cube) + "\n";
		result += correctFrontDownEdgeBlock(cube) + "\n";
		result += correctFrontRightEdgeBlock(cube) + "\n";
		
		// second step: correct front four corner blocks
		
		
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
				
				execute(cube, FRONT_TOP_EDGE_METHOD[i]);
			}
		}
		if(cube.getFrontBlocks()[2].getFrontSurface().get_colorIndex() != frontColor)
		{
			result += FRONT_TOP_EDGE_COLOR_EXCHANGE;
			
			execute(cube, FRONT_TOP_EDGE_COLOR_EXCHANGE);
		}
		return result;
	}

	public static String correctFrontLeftEdgeBlock(Cube cube)
	{
		cube.rotateY90();
		cube.rotateY90();
		cube.rotateY90();
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
		cube.rotateY90();
		cube.rotateY90();
		cube.rotateY90();
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
				execute(cube, FRONT_TOP_LEFT_CORNER_METHOD[i]);
			}
		}
		
		if(frontTopLeftBlock.getFrontSurface().get_colorIndex() == frontColor)
		{
			if(frontTopLeftBlock.getLeftSurface().get_colorIndex() != leftColor)
			{
				// TO-DO
			}
		}
		else if(frontTopLeftBlock.getFrontSurface().get_colorIndex() == leftColor)
		{
			if(frontTopLeftBlock.getLeftSurface().get_colorIndex() == upperColor)
			{
				// TO-DO
			}
			else
			{
				// TO-DO
			}
		}
		else
		{
			if(frontTopLeftBlock.getLeftSurface().get_colorIndex() == leftColor)
			{
				// TO-DO
			}
			else
			{
				// TO-DO
			}
		}
		
		return result;
	}
	
	public static void execute(Cube cube, String commands)
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
}
