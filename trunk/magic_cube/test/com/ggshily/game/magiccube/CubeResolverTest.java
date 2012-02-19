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
	public void testCorrectFrontEdgeBlocks()
	{
		_cube = CubeFactory.createCube(
				"   104\n" +
				"   412\n" +
				"   002\n" +
				"015354541332\n" +
				"325301232041\n" +
				"022414540142\n" +
				"   103\n" +
				"   553\n" +
				"   553");
		CubeResolver.correctFrontTopEdgeBlock(_cube);
		CubeResolver.correctFrontLeftEdgeBlock(_cube);
		CubeResolver.correctFrontDownEdgeBlock(_cube);
		CubeResolver.correctFrontRightEdgeBlock(_cube);
		
		assertEquals(0, _cube.getFrontBlocks()[1].getFrontColor());
		assertEquals(0, _cube.getFrontBlocks()[3].getFrontColor());
		assertEquals(0, _cube.getFrontBlocks()[5].getFrontColor());
		assertEquals(0, _cube.getFrontBlocks()[7].getFrontColor());
		assertEquals(1, _cube.getUpperBlocks()[7].getUpperColor());
		assertEquals(2, _cube.getLeftBlocks()[5].getLeftColor());
		assertEquals(3, _cube.getRightBlocks()[3].getRightColor());
		assertEquals(5, _cube.getDownBlocks()[1].getDownColor());
	}
	
	@Test
	public void testCorrectFrontTopLeftBlock()
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

		assertEquals("", CubeResolver.correctFrontTopLeftBlock(_cube));
		assertEquals(result, _cube.toString());
		
		_cube = CubeFactory.createCube(
			"   234\n" +
			"   511\n" +
			"   042\n" +
			"103114501310\n" +
			"122405334342\n" +
			"304550552400\n" +
			"   322\n" +
			"   254\n" +
			"   531");
		CubeResolver.correctFrontTopLeftBlock(_cube);
		assertEquals(0, _cube.getFrontBlocks()[0].getFrontColor());
		assertEquals(1, _cube.getUpperBlocks()[6].getUpperColor());
		assertEquals(2, _cube.getLeftBlocks()[2].getLeftColor());
	}
	
	@Test
	public void testcorrectFrontLeftDownBlock()
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

		assertEquals("", CubeResolver.correctFrontLeftDownBlock(_cube));
		assertEquals(result, _cube.toString());
		
		_cube = CubeFactory.createCube(
			"   345\n" + 
			"   513\n" +
			"   521\n" +
			"420204243015\n" +
			"322105430341\n" +
			"023150202553\n" +
			"   431\n" +
			"   451\n" +
			"   104");
		CubeResolver.correctFrontLeftDownBlock(_cube);
		assertEquals(0, _cube.getFrontBlocks()[6].getFrontColor());
		assertEquals(2, _cube.getLeftBlocks()[8].getLeftColor());
		assertEquals(5, _cube.getDownBlocks()[0].getDownColor());
		
		_cube = CubeFactory.createCube(
			"   311\n" + 
			"   115\n" + 
			"   245\n" + 
			"131414322024\n" + 
			"324201034340\n" + 
			"041354253502\n" + 
			"   005\n" + 
			"   553\n" + 
			"   520");
		CubeResolver.correctFrontLeftDownBlock(_cube);
		assertEquals(0, _cube.getFrontBlocks()[6].getFrontColor());
		assertEquals(2, _cube.getLeftBlocks()[8].getLeftColor());
		assertEquals(5, _cube.getDownBlocks()[0].getDownColor());
	}
	
	@Test
	public void testCorrectFrontRightDownBlock()
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

		assertEquals("", CubeResolver.correctFrontRightDownBlock(_cube));
		assertEquals(result, _cube.toString());

		_cube = CubeFactory.createCube(
			"   513\n" + 
			"   513\n" + 
			"   031\n" + 
			"441210304122\n" + 
			"025304331045\n" + 
			"040524145305\n" + 
			"   252\n" + 
			"   152\n" + 
			"   324");
		CubeResolver.correctFrontRightDownBlock(_cube);
		assertEquals(0, _cube.getFrontBlocks()[8].getFrontColor());
		assertEquals(3, _cube.getRightBlocks()[6].getRightColor());
		assertEquals(5, _cube.getDownBlocks()[2].getDownColor());
	}
	
	@Test
	public void testCorrectMiddleTopLeftBlock()
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

		assertEquals("", CubeResolver.correctMiddleTopLeftBlock(_cube));
		assertEquals(result, _cube.toString());
		

		String init =
				"   111\n" +
				"   911\n" +
				"   111\n" +
				"292000333444\n" +
				"222000333444\n" +
				"222000333444\n" +
				"   555\n" +
				"   155\n" +
				"   555";
		Cube cube = CubeFactory.createCube(init);
		CubeResolver.correctMiddleTopLeftBlock(cube);
		assertEquals(1, cube.getUpperBlocks()[3].getUpperColor());
		assertEquals(2, cube.getLeftBlocks()[1].getLeftColor());
		
		init =
				"   111\n" +
				"   911\n" +
				"   111\n" +
				"292000333444\n" +
				"222000333444\n" +
				"212000333444\n" +
				"   555\n" +
				"   255\n" +
				"   555";
		cube = CubeFactory.createCube(init);
		CubeResolver.correctMiddleTopLeftBlock(cube);
		assertEquals(1, cube.getUpperBlocks()[3].getUpperColor());
		assertEquals(2, cube.getLeftBlocks()[1].getLeftColor());
		
		init =
				"   111\n" +
				"   911\n" +
				"   111\n" +
				"292000333444\n" +
				"222000333444\n" +
				"222000323444\n" +
				"   555\n" +
				"   551\n" +
				"   555";
		cube = CubeFactory.createCube(init);
		CubeResolver.correctMiddleTopLeftBlock(cube);
		assertEquals(1, cube.getUpperBlocks()[3].getUpperColor());
		assertEquals(2, cube.getLeftBlocks()[1].getLeftColor());
		
		init =
				"   111\n" +
				"   911\n" +
				"   111\n" +
				"292000333444\n" +
				"222000333444\n" +
				"222000313444\n" +
				"   555\n" +
				"   552\n" +
				"   555";
		cube = CubeFactory.createCube(init);
		CubeResolver.correctMiddleTopLeftBlock(cube);
		assertEquals(1, cube.getUpperBlocks()[3].getUpperColor());
		assertEquals(2, cube.getLeftBlocks()[1].getLeftColor());
		
		init =
				"   111\n" +
				"   912\n" +
				"   111\n" +
				"292000313444\n" +
				"222000333444\n" +
				"222000333444\n" +
				"   555\n" +
				"   555\n" +
				"   555";
		cube = CubeFactory.createCube(init);
		CubeResolver.correctMiddleTopLeftBlock(cube);
		assertEquals(1, cube.getUpperBlocks()[3].getUpperColor());
		assertEquals(2, cube.getLeftBlocks()[1].getLeftColor());
		
		init =
				"   111\n" +
				"   911\n" +
				"   111\n" +
				"292000323444\n" +
				"222000333444\n" +
				"222000333444\n" +
				"   555\n" +
				"   555\n" +
				"   555";
		cube = CubeFactory.createCube(init);
		CubeResolver.correctMiddleTopLeftBlock(cube);
		assertEquals(1, cube.getUpperBlocks()[3].getUpperColor());
		assertEquals(2, cube.getLeftBlocks()[1].getLeftColor());
		
		init =
				"   111\n" +
				"   911\n" +
				"   111\n" +
				"292000333424\n" +
				"222000333444\n" +
				"222000333444\n" +
				"   555\n" +
				"   555\n" +
				"   555";
		cube = CubeFactory.createCube(init);
		CubeResolver.correctMiddleTopLeftBlock(cube);
		assertEquals(1, cube.getUpperBlocks()[3].getUpperColor());
		assertEquals(2, cube.getLeftBlocks()[1].getLeftColor());
		
		init =
				"   121\n" +
				"   911\n" +
				"   111\n" +
				"292000333414\n" +
				"222000333441\n" +
				"222000333444\n" +
				"   555\n" +
				"   555\n" +
				"   555";
		cube = CubeFactory.createCube(init);
		CubeResolver.correctMiddleTopLeftBlock(cube);
		assertEquals(1, cube.getUpperBlocks()[3].getUpperColor());
		assertEquals(2, cube.getLeftBlocks()[1].getLeftColor());
		
		init =
				"   111\n" +
				"   911\n" +
				"   111\n" +
				"292000333444\n" +
				"122000333442\n" +
				"222000333444\n" +
				"   555\n" +
				"   555\n" +
				"   555";
		cube = CubeFactory.createCube(init);
		CubeResolver.correctMiddleTopLeftBlock(cube);
		assertEquals(1, cube.getUpperBlocks()[3].getUpperColor());
		assertEquals(2, cube.getLeftBlocks()[1].getLeftColor());
		
		init =
				"   111\n" +
				"   911\n" +
				"   111\n" +
				"292000333444\n" +
				"222000333444\n" +
				"222000333414\n" +
				"   555\n" +
				"   555\n" +
				"   525";
		cube = CubeFactory.createCube(init);
		CubeResolver.correctMiddleTopLeftBlock(cube);
		assertEquals(1, cube.getUpperBlocks()[3].getUpperColor());
		assertEquals(2, cube.getLeftBlocks()[1].getLeftColor());
		
		init =
				"   111\n" +
				"   911\n" +
				"   111\n" +
				"292000333444\n" +
				"222000333444\n" +
				"222000333424\n" +
				"   555\n" +
				"   555\n" +
				"   515";
		cube = CubeFactory.createCube(init);
		CubeResolver.correctMiddleTopLeftBlock(cube);
		assertEquals(1, cube.getUpperBlocks()[3].getUpperColor());
		assertEquals(2, cube.getLeftBlocks()[1].getLeftColor());
		
		init =
				"   111\n" +
				"   911\n" +
				"   111\n" +
				"292000333444\n" +
				"222000331244\n" +
				"222000333444\n" +
				"   555\n" +
				"   555\n" +
				"   555";
		cube = CubeFactory.createCube(init);
		CubeResolver.correctMiddleTopLeftBlock(cube);
		assertEquals(1, cube.getUpperBlocks()[3].getUpperColor());
		assertEquals(2, cube.getLeftBlocks()[1].getLeftColor());
		
		init =
				"   111\n" +
				"   911\n" +
				"   111\n" +
				"292000333444\n" +
				"222000332144\n" +
				"222000333444\n" +
				"   555\n" +
				"   555\n" +
				"   555";
		cube = CubeFactory.createCube(init);
		CubeResolver.correctMiddleTopLeftBlock(cube);
		assertEquals(1, cube.getUpperBlocks()[3].getUpperColor());
		assertEquals(2, cube.getLeftBlocks()[1].getLeftColor());
		
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
		assertEquals(4, cube.getBackBlocks()[1].getBackColor());
		assertEquals(4, cube.getBackBlocks()[3].getBackColor());
		assertEquals(4, cube.getBackBlocks()[4].getBackColor());
		assertEquals(4, cube.getBackBlocks()[7].getBackColor());

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
		assertEquals(4, cube2.getBackBlocks()[1].getBackColor());
		assertEquals(4, cube2.getBackBlocks()[3].getBackColor());
		assertEquals(4, cube2.getBackBlocks()[4].getBackColor());
		assertEquals(4, cube2.getBackBlocks()[7].getBackColor());

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
		assertEquals(4, cube3.getBackBlocks()[1].getBackColor());
		assertEquals(4, cube3.getBackBlocks()[3].getBackColor());
		assertEquals(4, cube3.getBackBlocks()[4].getBackColor());
		assertEquals(4, cube3.getBackBlocks()[7].getBackColor());

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
		assertEquals(4, cube4.getBackBlocks()[1].getBackColor());
		assertEquals(4, cube4.getBackBlocks()[3].getBackColor());
		assertEquals(4, cube4.getBackBlocks()[4].getBackColor());
		assertEquals(4, cube4.getBackBlocks()[7].getBackColor());
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
		String commands = CubeResolver.correctBackCornerBlocksBackColor(cube);
		assertEquals(4, cube.getBackBlocks()[0].getBackColor());
		assertEquals(4, cube.getBackBlocks()[2].getBackColor());
		assertEquals(4, cube.getBackBlocks()[6].getBackColor());
		assertEquals(4, cube.getBackBlocks()[8].getBackColor());
		Cube cube_1 = CubeFactory.createCube(init);
		executeCommands(cube_1, commands);
		assertTrue(CubeUtil.isMatch(cube, cube_1));

		final String init1 = 
				"   111\n" +
				"   111\n" +
				"   111\n" +
				"422000333449\n" +
				"222000333444\n" +
				"222000334949\n" +
				"   555\n" +
				"   555\n" +
				"   455";
		Cube cube1 = CubeFactory.createCube(init1);
		commands = CubeResolver.correctBackCornerBlocksBackColor(cube1);
		assertEquals(4, cube1.getBackBlocks()[0].getBackColor());
		assertEquals(4, cube1.getBackBlocks()[2].getBackColor());
		assertEquals(4, cube1.getBackBlocks()[6].getBackColor());
		assertEquals(4, cube1.getBackBlocks()[8].getBackColor());
		Cube cube1_1 = CubeFactory.createCube(init1);
		executeCommands(cube1_1, commands);
		assertTrue(CubeUtil.isMatch(cube1, cube1_1));
		
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
		commands = CubeResolver.correctBackCornerBlocksBackColor(cube2);
		assertEquals(4, cube2.getBackBlocks()[0].getBackColor());
		assertEquals(4, cube2.getBackBlocks()[2].getBackColor());
		assertEquals(4, cube2.getBackBlocks()[6].getBackColor());
		assertEquals(4, cube2.getBackBlocks()[8].getBackColor());
		Cube cube2_1 = CubeFactory.createCube(init2);
		executeCommands(cube2_1, commands);
		assertTrue(CubeUtil.isMatch(cube2, cube2_1));

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
		commands = CubeResolver.correctBackCornerBlocksBackColor(cube3);
		assertEquals(4, cube3.getBackBlocks()[0].getBackColor());
		assertEquals(4, cube3.getBackBlocks()[2].getBackColor());
		assertEquals(4, cube3.getBackBlocks()[6].getBackColor());
		assertEquals(4, cube3.getBackBlocks()[8].getBackColor());
		Cube cube3_1 = CubeFactory.createCube(init3);
		executeCommands(cube3_1, commands);
		assertTrue(CubeUtil.isMatch(cube3, cube3_1));

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
		commands = CubeResolver.correctBackCornerBlocksBackColor(cube4);
		assertEquals(4, cube4.getBackBlocks()[0].getBackColor());
		assertEquals(4, cube4.getBackBlocks()[2].getBackColor());
		assertEquals(4, cube4.getBackBlocks()[6].getBackColor());
		assertEquals(4, cube4.getBackBlocks()[8].getBackColor());
		Cube cube4_1 = CubeFactory.createCube(init4);
		executeCommands(cube4_1, commands);
		assertTrue(CubeUtil.isMatch(cube4, cube4_1));

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
		commands = CubeResolver.correctBackCornerBlocksBackColor(cube5);
		assertEquals(4, cube5.getBackBlocks()[0].getBackColor());
		assertEquals(4, cube5.getBackBlocks()[2].getBackColor());
		assertEquals(4, cube5.getBackBlocks()[6].getBackColor());
		assertEquals(4, cube5.getBackBlocks()[8].getBackColor());
		Cube cube5_1 = CubeFactory.createCube(init5);
		executeCommands(cube5_1, commands);
		assertTrue(CubeUtil.isMatch(cube5, cube5_1));

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
		commands = CubeResolver.correctBackCornerBlocksBackColor(cube6);
		assertEquals(4, cube6.getBackBlocks()[0].getBackColor());
		assertEquals(4, cube6.getBackBlocks()[2].getBackColor());
		assertEquals(4, cube6.getBackBlocks()[6].getBackColor());
		assertEquals(4, cube6.getBackBlocks()[8].getBackColor());
		Cube cube6_1 = CubeFactory.createCube(init6);
		executeCommands(cube6_1, commands);
		assertTrue(CubeUtil.isMatch(cube6, cube6_1));
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
	public void testResolver()
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
		CubeResolver.resolve(_cube);
		assertEquals(result, _cube.toString());
		
		final String init1=
				"   112\n" + 
				"   014\n" + 
				"   353\n" + 
				"011035415032\n" + 
				"420202431245\n" + 
				"404141423535\n" + 
				"   233\n" + 
				"   555\n" + 
				"   200";
		_cube = CubeFactory.createCube(init1);
		String commands = CubeResolver.resolve(_cube);
		assertEquals(result, _cube.toString());
		
		commands = commands.replace("\n", "");
		_cube = CubeFactory.createCube(init1);
		executeCommands(_cube, commands);
		assertEquals(result, _cube.toString());
	}

	@Test
	public void testResolverRandomly()
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
		
		final int[] commands = {'F', 'B', 'L', 'R', 'U', 'D',
				'F' + 1, 'B' + 1, 'L' + 1, 'R' + 1, 'U' + 1, 'D' + 1};
		int i = 0;
		while(i++ < 200)
		{
			executeSingleCommand(_cube, (char) commands[(int) (Math.random() * commands.length)]);
		}
		
		System.out.println(_cube);
		
		resolve(_cube);
		
		assertEquals(result, _cube.toString());
	}

}
