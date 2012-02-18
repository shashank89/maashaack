package com.ggshily.game.magiccube;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

public class CubeResolverTest extends CubeResolver
{
	private Cube _cube;
	private int[] data = {0, 0, 0, 0, 0, 0, 0, 0, 0,
			  1, 1, 1, 1, 1, 1, 1, 1, 1,
			  2, 2, 2, 2, 2, 2, 2, 2, 2,
			  3, 3, 3, 3, 3, 3, 3, 3, 3,
			  4, 4, 4, 4, 4, 4, 4, 4, 4,
			  5, 5, 5, 5, 5, 5, 5, 5, 5,
			  };

	@BeforeClass
	public static void setUpBeforeClass() throws Exception
	{
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception
	{
	}

	@Before
	public void setUp() throws Exception
	{
		_cube = CubeFactory.createCube(data);
	}

	@After
	public void tearDown() throws Exception
	{
		_cube = null;
	}

	@Test
	public void testCorrectFrontTopEdgeBlock()
	{
		final String result =
				"   111\n" +
				"   111\n" +
				"   111\n" +
				"222000333444\n" +
				"222000333444\n" +
				"222000333444\n" +
				"   555\n" +
				"   555\n" +
				"   555";

		assertEquals("", CubeResolver.correctFrontTopEdgeBlock(_cube));
		assertEquals(result, _cube.toString());
		
		_cube.U();
		assertEquals("U'", CubeResolver.correctFrontTopEdgeBlock(_cube));
		assertEquals(result, _cube.toString());
		
		_cube.U();
		_cube.L();
		assertEquals("L'U'", CubeResolver.correctFrontTopEdgeBlock(_cube));
		assertEquals(result, _cube.toString());
	}

	@Test
	public void testCorrectFrontLeftEdgeBlock()
	{
		final String result =
			"   111\n" +
			"   111\n" +
			"   111\n" +
			"222000333444\n" +
			"222000333444\n" +
			"222000333444\n" +
			"   555\n" +
			"   555\n" +
			"   555";

		assertEquals("", CubeResolver.correctFrontLeftEdgeBlock(_cube));
		assertEquals(result, _cube.toString());
		
		_cube.L();
		assertEquals("L'", CubeResolver.correctFrontLeftEdgeBlock(_cube));
		assertEquals(result, _cube.toString());
	}

	@Test
	public void testCorrectFrontDownEdgeBlock()
	{
		final String result =
			"   111\n" +
			"   111\n" +
			"   111\n" +
			"222000333444\n" +
			"222000333444\n" +
			"222000333444\n" +
			"   555\n" +
			"   555\n" +
			"   555";

		assertEquals("", CubeResolver.correctFrontDownEdgeBlock(_cube));
		assertEquals(result, _cube.toString());
		
		_cube.D();
		assertEquals("D'", CubeResolver.correctFrontDownEdgeBlock(_cube));
		assertEquals(result, _cube.toString());
	}

	@Test
	public void testCorrectFrontRightEdgeBlock()
	{
		final String result =
			"   111\n" +
			"   111\n" +
			"   111\n" +
			"222000333444\n" +
			"222000333444\n" +
			"222000333444\n" +
			"   555\n" +
			"   555\n" +
			"   555";

		assertEquals("", CubeResolver.correctFrontRightEdgeBlock(_cube));
		assertEquals(result, _cube.toString());
		
		_cube.R();
		assertEquals("R'", CubeResolver.correctFrontRightEdgeBlock(_cube));
		assertEquals(result, _cube.toString());
	}
	
	@Test
	public void testCorrectBackEdgeBlocksBackColor()
	{
		final String result =
			"   111\n" +
			"   111\n" +
			"   111\n" +
			"222000333444\n" +
			"222000333444\n" +
			"222000333444\n" +
			"   555\n" +
			"   555\n" +
			"   555";
		CubeResolver.correctBackEdgeBlocksBackColor(_cube);
		assertEquals(result, _cube.toString());

		final String init =
			"   141\n" +
			"   111\n" +
			"   111\n" +
			"222000333494\n" +
			"422000334949\n" +
			"222000333494\n" +
			"   555\n" +
			"   555\n" +
			"   545";
		Cube cube = CubeFactory.createCube(init);
		CubeResolver.correctBackEdgeBlocksBackColor(cube);

		final String init2 =
			"   111\n" +
			"   111\n" +
			"   111\n" +
			"222000333444\n" +
			"422000333449\n" +
			"222000333494\n" +
			"   555\n" +
			"   555\n" +
			"   545";
		Cube cube2 = CubeFactory.createCube(init2);
		CubeResolver.correctBackEdgeBlocksBackColor(cube2);

		final String init3 =
			"   141\n" +
			"   111\n" +
			"   111\n" +
			"222000333494\n" +
			"922000333444\n" +
			"222000333494\n" +
			"   555\n" +
			"   555\n" +
			"   545";
		Cube cube3 = CubeFactory.createCube(init3);
		CubeResolver.correctBackEdgeBlocksBackColor(cube3);

		final String init4 =
			"   111\n" +
			"   111\n" +
			"   111\n" +
			"222000333444\n" +
			"422000334949\n" +
			"222000333444\n" +
			"   555\n" +
			"   555\n" +
			"   555";
		Cube cube4 = CubeFactory.createCube(init4);
		CubeResolver.correctBackEdgeBlocksBackColor(cube4);
	}
	
	@Test
	public void testCorrectBackCornerBlocksBackColor()
	{
		final String result =
			"   111\n" +
			"   111\n" +
			"   111\n" +
			"222000333444\n" +
			"222000333444\n" +
			"222000333444\n" +
			"   555\n" +
			"   555\n" +
			"   555";
		CubeResolver.correctBackCornerBlocksBackColor(_cube);
		assertEquals(result, _cube.toString());

		final String init = 
				"   413\n" +
				"   111\n" +
				"   111\n" +
				"122000335449\n" +
				"222000333444\n" +
				"422000335949\n" +
				"   555\n" +
				"   555\n" +
				"   254";
		
		Cube cube = CubeFactory.createCube(init);
		CubeResolver.correctBackCornerBlocksBackColor(cube);
		assertEquals(4, cube.getBackBlocks()[0].getBackColor());
		assertEquals(4, cube.getBackBlocks()[2].getBackColor());
		assertEquals(4, cube.getBackBlocks()[6].getBackColor());
		assertEquals(4, cube.getBackBlocks()[8].getBackColor());

		final String init1 = 
				"   111\n" +
				"   111\n" +
				"   111\n" +
				"424000333449\n" +
				"222000333444\n" +
				"222000334949\n" +
				"   555\n" +
				"   555\n" +
				"   455";
		Cube cube1 = CubeFactory.createCube(init1);
		CubeResolver.correctBackCornerBlocksBackColor(cube1);
		assertEquals(4, cube1.getBackBlocks()[0].getBackColor());
		assertEquals(4, cube1.getBackBlocks()[2].getBackColor());
		assertEquals(4, cube1.getBackBlocks()[6].getBackColor());
		assertEquals(4, cube1.getBackBlocks()[8].getBackColor());
		
		final String init2 =
				"   114\n" +
				"   111\n" +
				"   111\n" +
				"222000333944\n" +
				"222000333444\n" +
				"222000333944\n" +
				"   555\n" +
				"   555\n" +
				"   554";
		Cube cube2 = CubeFactory.createCube(init2);
		CubeResolver.correctBackCornerBlocksBackColor(cube2);
		assertEquals(4, cube2.getBackBlocks()[0].getBackColor());
		assertEquals(4, cube2.getBackBlocks()[2].getBackColor());
		assertEquals(4, cube2.getBackBlocks()[6].getBackColor());
		assertEquals(4, cube2.getBackBlocks()[8].getBackColor());

		final String init3 =
				"   414\n" +
				"   111\n" +
				"   111\n" +
				"222000333949\n" +
				"222000333444\n" +
				"222000333444\n" +
				"   555\n" +
				"   555\n" +
				"   555";
		Cube cube3 = CubeFactory.createCube(init3);
		CubeResolver.correctBackCornerBlocksBackColor(cube3);
		assertEquals(4, cube3.getBackBlocks()[0].getBackColor());
		assertEquals(4, cube3.getBackBlocks()[2].getBackColor());
		assertEquals(4, cube3.getBackBlocks()[6].getBackColor());
		assertEquals(4, cube3.getBackBlocks()[8].getBackColor());

		final String init4 =
				"   114\n" +
				"   111\n" +
				"   111\n" +
				"222000333944\n" +
				"222000333444\n" +
				"422000333449\n" +
				"   555\n" +
				"   555\n" +
				"   555";
		Cube cube4 = CubeFactory.createCube(init4);
		CubeResolver.correctBackCornerBlocksBackColor(cube4);
		assertEquals(4, cube4.getBackBlocks()[0].getBackColor());
		assertEquals(4, cube4.getBackBlocks()[2].getBackColor());
		assertEquals(4, cube4.getBackBlocks()[6].getBackColor());
		assertEquals(4, cube4.getBackBlocks()[8].getBackColor());

		final String init5 =
				"   411\n" +
				"   111\n" +
				"   111\n" +
				"222000334949\n" +
				"222000333444\n" +
				"222000334949\n" +
				"   555\n" +
				"   555\n" +
				"   455";
		Cube cube5 = CubeFactory.createCube(init5);
		CubeResolver.correctBackCornerBlocksBackColor(cube5);
		assertEquals(4, cube5.getBackBlocks()[0].getBackColor());
		assertEquals(4, cube5.getBackBlocks()[2].getBackColor());
		assertEquals(4, cube5.getBackBlocks()[6].getBackColor());
		assertEquals(4, cube5.getBackBlocks()[8].getBackColor());

		final String init6 =
				"   111\n" +
				"   111\n" +
				"   111\n" +
				"422000334949\n" +
				"222000333444\n" +
				"422000334949\n" +
				"   555\n" +
				"   555\n" +
				"   555";
		Cube cube6 = CubeFactory.createCube(init6);
		CubeResolver.correctBackCornerBlocksBackColor(cube6);
		assertEquals(4, cube6.getBackBlocks()[0].getBackColor());
		assertEquals(4, cube6.getBackBlocks()[2].getBackColor());
		assertEquals(4, cube6.getBackBlocks()[6].getBackColor());
		assertEquals(4, cube6.getBackBlocks()[8].getBackColor());
	}
	
	@Test
	public void testCorrectBackCornerBlocksPosition()
	{
		final String result =
			"   111\n" +
			"   111\n" +
			"   111\n" +
			"222000333444\n" +
			"222000333444\n" +
			"222000333444\n" +
			"   555\n" +
			"   555\n" +
			"   555";
		_cube.B();
		CubeResolver.correctBackCornerBlocksPosition(_cube);
		assertEquals(result, _cube.toString());
		
		
		final String init = 
				"   313\n" +
				"   111\n" +
				"   111\n" +
				"122000335444\n" +
				"222000333444\n" +
				"122000335444\n" +
				"   555\n" +
				"   555\n" +
				"   252";
		
		Cube cube = CubeFactory.createCube(init);
		CubeResolver.correctBackCornerBlocksPosition(cube);
		assertEquals(1, cube.getUpperBlocks()[0].getUpperColor());
		assertEquals(1, cube.getUpperBlocks()[2].getUpperColor());
		assertEquals(2, cube.getLeftBlocks()[0].getLeftColor());
		assertEquals(2, cube.getLeftBlocks()[6].getLeftColor());
		assertEquals(5, cube.getDownBlocks()[6].getDownColor());
		assertEquals(5, cube.getDownBlocks()[8].getDownColor());
		assertEquals(3, cube.getRightBlocks()[2].getRightColor());
		assertEquals(3, cube.getRightBlocks()[8].getRightColor());
		
		
		final String init1 = 
				"   123\n" +
				"   111\n" +
				"   111\n" +
				"222000335444\n" +
				"522000333444\n" +
				"322000335444\n" +
				"   555\n" +
				"   555\n" +
				"   112";
		
		Cube cube1 = CubeFactory.createCube(init1);
		CubeResolver.correctBackCornerBlocksPosition(cube1);
		assertEquals(1, cube1.getUpperBlocks()[0].getUpperColor());
		assertEquals(1, cube1.getUpperBlocks()[2].getUpperColor());
		assertEquals(2, cube1.getLeftBlocks()[0].getLeftColor());
		assertEquals(2, cube1.getLeftBlocks()[6].getLeftColor());
		assertEquals(5, cube1.getDownBlocks()[6].getDownColor());
		assertEquals(5, cube1.getDownBlocks()[8].getDownColor());
		assertEquals(3, cube1.getRightBlocks()[2].getRightColor());
		assertEquals(3, cube1.getRightBlocks()[8].getRightColor());
	}
	
	@Test
	public void testCorrectBackEdgeBlocksPosition()
	{
		final String result =
				"   111\n" +
				"   111\n" +
				"   111\n" +
				"222000333444\n" +
				"222000333444\n" +
				"222000333444\n" +
				"   555\n" +
				"   555\n" +
				"   555";
		
		final String init = 
				"   121\n" + 
				"   111\n" +
				"   111\n" +
				"222000333444\n" +
				"522000333444\n" +
				"222000333444\n" +
				"   555\n" +
				"   555\n" +
				"   515";
		
		Cube cube = CubeFactory.createCube(init);
		CubeResolver.correctBackEdgeBlocksPosition(cube);
		assertEquals(result, cube.toString());
		
		final String init_1 = 
				"   121\n" + 
				"   111\n" +
				"   111\n" +
				"222000333444\n" +
				"322000331444\n" +
				"222000333444\n" +
				"   555\n" +
				"   555\n" +
				"   555";
		
		Cube cube_1 = CubeFactory.createCube(init_1);
		CubeResolver.correctBackEdgeBlocksPosition(cube_1);
		assertEquals(result, cube_1.toString());
		
		final String init1 = 
				"   151\n" + 
				"   111\n" +
				"   111\n" +
				"222000333444\n" +
				"122000333444\n" +
				"222000333444\n" +
				"   555\n" +
				"   555\n" +
				"   525";
		
		Cube cube1 = CubeFactory.createCube(init1);
		CubeResolver.correctBackEdgeBlocksPosition(cube1);
		assertEquals(result, cube1.toString());
		
		final String init2 = 
				"   151\n" + 
				"   111\n" +
				"   111\n" +
				"222000333444\n" +
				"322000332444\n" +
				"222000333444\n" +
				"   555\n" +
				"   555\n" +
				"   515";
		
		Cube cube2 = CubeFactory.createCube(init2);
		CubeResolver.correctBackEdgeBlocksPosition(cube2);
		assertEquals(result, cube2.toString());
		
		final String init3 = 
				"   131\n" + 
				"   111\n" +
				"   111\n" +
				"222000333444\n" +
				"522000331444\n" +
				"222000333444\n" +
				"   555\n" +
				"   555\n" +
				"   525";
		
		Cube cube3 = CubeFactory.createCube(init3);
		CubeResolver.correctBackEdgeBlocksPosition(cube3);
		assertEquals(result, cube3.toString());
		
		final String init4 = 
				"   121\n" + 
				"   111\n" +
				"   111\n" +
				"222000333444\n" +
				"122000335444\n" +
				"222000333444\n" +
				"   555\n" +
				"   555\n" +
				"   535";
		
		Cube cube4 = CubeFactory.createCube(init4);
		CubeResolver.correctBackEdgeBlocksPosition(cube4);
		assertEquals(result, cube4.toString());
	}
	
	@Test
	public void testRotateCommandX90()
	{
		Cube cube = CubeFactory.createCube(data);
		
		cube.U();
		_cube.rotateX90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandX90("U"));
		_cube.rotateXNegative90();
		assertEquals(cube.toString(), _cube.toString());
		
		cube.F();
		_cube.rotateX90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandX90("F"));
		_cube.rotateXNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.D();
		_cube.rotateX90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandX90("D"));
		_cube.rotateXNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.B();
		_cube.rotateX90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandX90("B"));
		_cube.rotateXNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.L();
		_cube.rotateX90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandX90("L"));
		_cube.rotateXNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.R();
		_cube.rotateX90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandX90("R"));
		_cube.rotateXNegative90();
		assertEquals(cube.toString(), _cube.toString());
		
		cube.U_CC();
		_cube.rotateX90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandX90("U'"));
		_cube.rotateXNegative90();
		assertEquals(cube.toString(), _cube.toString());
		
		cube.F_CC();
		_cube.rotateX90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandX90("F'"));
		_cube.rotateXNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.D_CC();
		_cube.rotateX90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandX90("D'"));
		_cube.rotateXNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.B_CC();
		_cube.rotateX90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandX90("B'"));
		_cube.rotateXNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.L_CC();
		_cube.rotateX90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandX90("L'"));
		_cube.rotateXNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.R_CC();
		_cube.rotateX90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandX90("R'"));
		_cube.rotateXNegative90();
		assertEquals(cube.toString(), _cube.toString());
	}
	
	@Test
	public void testRotateCommandY90()
	{
		Cube cube = CubeFactory.createCube(data);
		
		cube.U();
		_cube.rotateY90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandY90("U"));
		_cube.rotateYNegative90();
		assertEquals(cube.toString(), _cube.toString());
		
		cube.F();
		_cube.rotateY90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandY90("F"));
		_cube.rotateYNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.D();
		_cube.rotateY90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandY90("D"));
		_cube.rotateYNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.B();
		_cube.rotateY90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandY90("B"));
		_cube.rotateYNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.L();
		_cube.rotateY90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandY90("L"));
		_cube.rotateYNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.R();
		_cube.rotateY90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandY90("R"));
		_cube.rotateYNegative90();
		assertEquals(cube.toString(), _cube.toString());
		
		cube.U_CC();
		_cube.rotateY90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandY90("U'"));
		_cube.rotateYNegative90();
		assertEquals(cube.toString(), _cube.toString());
		
		cube.F_CC();
		_cube.rotateY90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandY90("F'"));
		_cube.rotateYNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.D_CC();
		_cube.rotateY90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandY90("D'"));
		_cube.rotateYNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.B_CC();
		_cube.rotateY90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandY90("B'"));
		_cube.rotateYNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.L_CC();
		_cube.rotateY90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandY90("L'"));
		_cube.rotateYNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.R_CC();
		_cube.rotateY90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandY90("R'"));
		_cube.rotateYNegative90();
		assertEquals(cube.toString(), _cube.toString());
	}
	
	@Test
	public void testRotateCommandZ90()
	{
		Cube cube = CubeFactory.createCube(data);
		
		cube.U();
		_cube.rotateZ90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandZ90("U"));
		_cube.rotateZNegative90();
		assertEquals(cube.toString(), _cube.toString());
		
		cube.F();
		_cube.rotateZ90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandZ90("F"));
		_cube.rotateZNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.D();
		_cube.rotateZ90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandZ90("D"));
		_cube.rotateZNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.B();
		_cube.rotateZ90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandZ90("B"));
		_cube.rotateZNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.L();
		_cube.rotateZ90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandZ90("L"));
		_cube.rotateZNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.R();
		_cube.rotateZ90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandZ90("R"));
		_cube.rotateZNegative90();
		assertEquals(cube.toString(), _cube.toString());
		
		cube.U_CC();
		_cube.rotateZ90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandZ90("U'"));
		_cube.rotateZNegative90();
		assertEquals(cube.toString(), _cube.toString());
		
		cube.F_CC();
		_cube.rotateZ90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandZ90("F'"));
		_cube.rotateZNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.D_CC();
		_cube.rotateZ90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandZ90("D'"));
		_cube.rotateZNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.B_CC();
		_cube.rotateZ90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandZ90("B'"));
		_cube.rotateZNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.L_CC();
		_cube.rotateZ90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandZ90("L'"));
		_cube.rotateZNegative90();
		assertEquals(cube.toString(), _cube.toString());

		cube.R_CC();
		_cube.rotateZ90();
		CubeResolver.executeCommands(_cube, CubeResolver.rotateCommandZ90("R'"));
		_cube.rotateZNegative90();
		assertEquals(cube.toString(), _cube.toString());
	}

	@Test
	public void testExecute()
	{
		fail("Not yet implemented");
	}

}
