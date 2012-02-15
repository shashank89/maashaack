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
