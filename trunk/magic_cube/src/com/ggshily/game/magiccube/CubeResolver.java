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
	
	private static final String[] FRONT_LEFT_EDGE_METHOD = {
		"UL",
		"",
		"D'L'",
		"R2B2L2",
		
		"L",
		"L'",
		"D2L'D2",
		"U2LU2",
		
		"BL",
		"L2",
		"B'L2",
		"B2L2"
	};
	
	private static final String[] FRONT_BOTTOM_EDGE_METHOD = {
		"",
		"R'U'",
		"D2B2U2",
		"LU",
		
		"U'",
		"L2U'L2",
		"R2UR2",
		"U",
		
		"U2",
		"B'U2",
		"B2U2",
		"BU2"
	};
	
	private static final String[] FRONT_RIGHT_EDGE_METHOD = {
		"",
		"R'U'",
		"D2B2U2",
		"LU",
		
		"U'",
		"L2U'L2",
		"R2UR2",
		"U",
		
		"U2",
		"B'U2",
		"B2U2",
		"BU2"
	};
	
	private static final String[] LEFT_TOP_EDGE_METHOD = {
		"",
		"R'U'",
		"D2B2U2",
		"LU",
		
		"U'",
		"L2U'L2",
		"R2UR2",
		"U",
		
		"U2",
		"B'U2",
		"B2U2",
		"BU2"
	};
	
	private static final String[] LEFT_BOTTOM_EDGE_METHOD = {
		"",
		"R'U'",
		"D2B2U2",
		"LU",
		
		"U'",
		"L2U'L2",
		"R2UR2",
		"U",
		
		"U2",
		"B'U2",
		"B2U2",
		"BU2"
	};
	
	private static final String[] RIGHT_TOP_EDGE_METHOD = {
		"",
		"R'U'",
		"D2B2U2",
		"LU",
		
		"U'",
		"L2U'L2",
		"R2UR2",
		"U",
		
		"U2",
		"B'U2",
		"B2U2",
		"BU2"
	};
	
	private static final String[] RIGHT_BOTTOM_EDGE_METHOD = {
		"",
		"R'U'",
		"D2B2U2",
		"LU",
		
		"U'",
		"L2U'L2",
		"R2UR2",
		"U",
		
		"U2",
		"B'U2",
		"B2U2",
		"BU2"
	};
	
	private static final String[] BACK_TOP_EDGE_METHOD = {
		"",
		"R'U'",
		"D2B2U2",
		"LU",
		
		"U'",
		"L2U'L2",
		"R2UR2",
		"U",
		
		"U2",
		"B'U2",
		"B2U2",
		"BU2"
	};
	
	private static final String[] BACK_LEFT_EDGE_METHOD = {
		"",
		"R'U'",
		"D2B2U2",
		"LU",
		
		"U'",
		"L2U'L2",
		"R2UR2",
		"U",
		
		"U2",
		"B'U2",
		"B2U2",
		"BU2"
	};
	
	private static final String[] BACK_BOTTOM_EDGE_METHOD = {
		"",
		"R'U'",
		"D2B2U2",
		"LU",
		
		"U'",
		"L2U'L2",
		"R2UR2",
		"U",
		
		"U2",
		"B'U2",
		"B2U2",
		"BU2"
	};
	
	private static final String[] BACK_RIGHT_EDGE_METHOD = {
		"",
		"R'U'",
		"D2B2U2",
		"LU",
		
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
	private static final String FRONT_LEFT_EDGE_COLOR_EXCHANGE = "";
	private static final String FRONT_BOTTOM_EDGE_COLOR_EXCHANGE = "";
	private static final String FRONT_RIGHT_EDGE_COLOR_EXCHANGE = "";
	private static final String LEFT_TOP_EDGE_COLOR_EXCHANGE = "";
	private static final String LEFT_BOTTOM_EDGE_COLOR_EXCHANGE = "";
	private static final String RIGHT_TOP_EDGE_COLOR_EXCHANGE = "";
	private static final String RIGHT_BOTTOM_EDGE_COLOR_EXCHANGE = "";
	private static final String BACK_TOP_EDGE_COLOR_EXCHANGE = "";
	private static final String BACK_RIGHT_EDGE_COLOR_EXCHANGE = "";
	private static final String BACK_BOTTOM_EDGE_COLOR_EXCHANGE = "";
	private static final String BACK_LEFT_EDGE_COLOR_EXCHANGE = "";
	
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
	
	public static String resolve(Cube cube)
	{
		String result = "";
		
		// first step: correct front four edge blocks
		
		result += correctFrontTopEdgeBlock(cube);
		
		return result;
	}

	public static String correctFrontTopEdgeBlock(Cube cube)
	{
		String result = "";
		
		Block frontCenter = cube.getFrontBlocks()[4];
		Block upperCenter = cube.getUpperBlocks()[4];
		Block leftCenter = cube.getLeftBlocks()[4];
		Block rightCenter = cube.getRightBlocks()[4];
		Block downCenter = cube.getDownBlocks()[4];
		
		int frontColor = frontCenter.getFrontSurface().get_colorIndex();
		int upperColor = upperCenter.getUpperSurface().get_colorIndex();
		int leftColor = leftCenter.getLeftSurface().get_colorIndex();
		int rightColor = rightCenter.getRightSurface().get_colorIndex();
		int downColor = downCenter.getDownSurface().get_colorIndex();
		
		Block frontTopCenterBlock = cube.getEdgeBlock(frontColor, upperColor);
		Block frontLeftCenterBlock = cube.getEdgeBlock(frontColor, leftColor);
		Block frontDownCenterBlock = cube.getEdgeBlock(frontColor, downColor);
		Block frontRightCenterBlock = cube.getEdgeBlock(frontColor, rightColor);
		
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
		String result = "";
		
		Block frontCenter = cube.getFrontBlocks()[4];
		Block upperCenter = cube.getUpperBlocks()[4];
		Block leftCenter = cube.getLeftBlocks()[4];
		Block rightCenter = cube.getRightBlocks()[4];
		Block downCenter = cube.getDownBlocks()[4];
		
		int frontColor = frontCenter.getFrontSurface().get_colorIndex();
		int upperColor = upperCenter.getUpperSurface().get_colorIndex();
		int leftColor = leftCenter.getLeftSurface().get_colorIndex();
		int rightColor = rightCenter.getRightSurface().get_colorIndex();
		int downColor = downCenter.getDownSurface().get_colorIndex();
		
		Block frontTopCenterBlock = cube.getEdgeBlock(frontColor, upperColor);
		Block frontLeftCenterBlock = cube.getEdgeBlock(frontColor, leftColor);
		Block frontDownCenterBlock = cube.getEdgeBlock(frontColor, downColor);
		Block frontRightCenterBlock = cube.getEdgeBlock(frontColor, rightColor);
		
		Vertex base = new Vertex(0, 0, 0);
		frontLeftCenterBlock.getBasePoint(base);
		for(int i = 0; i < EDGE_BLOCK_POSITION.length; i++)
		{
			if(base.equals(EDGE_BLOCK_POSITION[i]))
			{
				result += FRONT_LEFT_EDGE_METHOD[i];
				
				execute(cube, FRONT_LEFT_EDGE_METHOD[i]);
			}
		}
		if(cube.getFrontBlocks()[2].getFrontSurface().get_colorIndex() != frontColor)
		{
			result += FRONT_LEFT_EDGE_COLOR_EXCHANGE;
			
			execute(cube, FRONT_LEFT_EDGE_COLOR_EXCHANGE);
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
}
