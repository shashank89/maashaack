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
	public void testExecute()
	{
		fail("Not yet implemented");
	}

}
