package com.ggshily.game.magiccube;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

public class CubeTest
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
	 * 
	 */
	private Cube _cube;
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
	 * 
	 */
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
//		String result = 
//			"   111\n" +
//			"   111\n" +
//			"   111\n" +
//			"222000333444\n" +
//			"222000333444\n" +
//			"222000333444\n" +
//			"   555\n" +
//			"   555\n" +
//			"   555";
		_cube = CubeFactory.createCube(data);
	}

	@After
	public void tearDown() throws Exception
	{
		_cube = null;
	}

	@Test
	public void test_correctCube()
	{
		// front top-left
		assertEquals(0, _cube.getFrontBlocks()[0].getFrontSurface().get_colorIndex());
		assertEquals(2, _cube.getFrontBlocks()[0].getLeftSurface().get_colorIndex());
		assertEquals(1, _cube.getFrontBlocks()[0].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[0].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[0].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[0].getBackSurface().get_colorIndex());

		// front top-center
		assertEquals(0, _cube.getFrontBlocks()[1].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[1].getLeftSurface().get_colorIndex());
		assertEquals(1, _cube.getFrontBlocks()[1].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[1].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[1].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[1].getBackSurface().get_colorIndex());

		// front top-right
		assertEquals(0, _cube.getFrontBlocks()[2].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[2].getLeftSurface().get_colorIndex());
		assertEquals(1, _cube.getFrontBlocks()[2].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[2].getDownSurface().get_colorIndex());
		assertEquals(3, _cube.getFrontBlocks()[2].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[2].getBackSurface().get_colorIndex());

		// front center-left
		assertEquals(0, _cube.getFrontBlocks()[3].getFrontSurface().get_colorIndex());
		assertEquals(2, _cube.getFrontBlocks()[3].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[3].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[3].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[3].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[3].getBackSurface().get_colorIndex());

		// front center-center
		assertEquals(0, _cube.getFrontBlocks()[4].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[4].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[4].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[4].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[4].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[4].getBackSurface().get_colorIndex());

		// front center-right
		assertEquals(0, _cube.getFrontBlocks()[5].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[5].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[5].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[5].getDownSurface().get_colorIndex());
		assertEquals(3, _cube.getFrontBlocks()[5].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[5].getBackSurface().get_colorIndex());

		// front bottom-left
		assertEquals(0, _cube.getFrontBlocks()[6].getFrontSurface().get_colorIndex());
		assertEquals(2, _cube.getFrontBlocks()[6].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[6].getUpperSurface().get_colorIndex());
		assertEquals(5, _cube.getFrontBlocks()[6].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[6].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[6].getBackSurface().get_colorIndex());

		// front bottom-center
		assertEquals(0, _cube.getFrontBlocks()[7].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[7].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[7].getUpperSurface().get_colorIndex());
		assertEquals(5, _cube.getFrontBlocks()[7].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[7].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[7].getBackSurface().get_colorIndex());

		// front bottom-right
		assertEquals(0, _cube.getFrontBlocks()[8].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[8].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[8].getUpperSurface().get_colorIndex());
		assertEquals(5, _cube.getFrontBlocks()[8].getDownSurface().get_colorIndex());
		assertEquals(3, _cube.getFrontBlocks()[8].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getFrontBlocks()[8].getBackSurface().get_colorIndex());

		// left top-left
		assertEquals(2, _cube.getLeftBlocks()[0].getLeftSurface().get_colorIndex());
		assertEquals(4, _cube.getLeftBlocks()[0].getBackSurface().get_colorIndex());
		assertEquals(1, _cube.getLeftBlocks()[0].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[0].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[0].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[0].getRightSurface().get_colorIndex());

		// left top-center
		assertEquals(2, _cube.getLeftBlocks()[1].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[1].getBackSurface().get_colorIndex());
		assertEquals(1, _cube.getLeftBlocks()[1].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[1].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[1].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[1].getRightSurface().get_colorIndex());

		// left top-right
		assertEquals(2, _cube.getLeftBlocks()[2].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[2].getBackSurface().get_colorIndex());
		assertEquals(1, _cube.getLeftBlocks()[2].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[2].getDownSurface().get_colorIndex());
		assertEquals(0, _cube.getLeftBlocks()[2].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[2].getRightSurface().get_colorIndex());

		// left center-left
		assertEquals(2, _cube.getLeftBlocks()[3].getLeftSurface().get_colorIndex());
		assertEquals(4, _cube.getLeftBlocks()[3].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[3].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[3].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[3].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[3].getRightSurface().get_colorIndex());

		// left center-center
		assertEquals(2, _cube.getLeftBlocks()[4].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[4].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[4].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[4].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[4].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[4].getRightSurface().get_colorIndex());

		// left center-right
		assertEquals(2, _cube.getLeftBlocks()[5].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[5].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[5].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[5].getDownSurface().get_colorIndex());
		assertEquals(0, _cube.getLeftBlocks()[5].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[5].getRightSurface().get_colorIndex());

		// left bottom-left
		assertEquals(2, _cube.getLeftBlocks()[6].getLeftSurface().get_colorIndex());
		assertEquals(4, _cube.getLeftBlocks()[6].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[6].getUpperSurface().get_colorIndex());
		assertEquals(5, _cube.getLeftBlocks()[6].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[6].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[6].getRightSurface().get_colorIndex());

		// left bottom-center
		assertEquals(2, _cube.getLeftBlocks()[7].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[7].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[7].getUpperSurface().get_colorIndex());
		assertEquals(5, _cube.getLeftBlocks()[7].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[7].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[7].getRightSurface().get_colorIndex());

		// left bottom-right
		assertEquals(2, _cube.getLeftBlocks()[8].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[8].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[8].getUpperSurface().get_colorIndex());
		assertEquals(5, _cube.getLeftBlocks()[8].getDownSurface().get_colorIndex());
		assertEquals(0, _cube.getLeftBlocks()[8].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getLeftBlocks()[8].getRightSurface().get_colorIndex());

		// right top-left
		assertEquals(3, _cube.getRightBlocks()[0].getRightSurface().get_colorIndex());
		assertEquals(0, _cube.getRightBlocks()[0].getFrontSurface().get_colorIndex());
		assertEquals(1, _cube.getRightBlocks()[0].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[0].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[0].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[0].getLeftSurface().get_colorIndex());

		// right top-center
		assertEquals(3, _cube.getRightBlocks()[1].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[1].getFrontSurface().get_colorIndex());
		assertEquals(1, _cube.getRightBlocks()[1].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[1].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[1].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[1].getLeftSurface().get_colorIndex());

		// right top-right
		assertEquals(3, _cube.getRightBlocks()[2].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[2].getFrontSurface().get_colorIndex());
		assertEquals(1, _cube.getRightBlocks()[2].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[2].getDownSurface().get_colorIndex());
		assertEquals(4, _cube.getRightBlocks()[2].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[2].getLeftSurface().get_colorIndex());

		// right center-left
		assertEquals(3, _cube.getRightBlocks()[3].getRightSurface().get_colorIndex());
		assertEquals(0, _cube.getRightBlocks()[3].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[3].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[3].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[3].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[3].getLeftSurface().get_colorIndex());

		// right center-center
		assertEquals(3, _cube.getRightBlocks()[4].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[4].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[4].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[4].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[4].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[4].getLeftSurface().get_colorIndex());

		// right center-right
		assertEquals(3, _cube.getRightBlocks()[5].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[5].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[5].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[5].getDownSurface().get_colorIndex());
		assertEquals(4, _cube.getRightBlocks()[5].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[5].getLeftSurface().get_colorIndex());

		// right bottom-left
		assertEquals(3, _cube.getRightBlocks()[6].getRightSurface().get_colorIndex());
		assertEquals(0, _cube.getRightBlocks()[6].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[6].getUpperSurface().get_colorIndex());
		assertEquals(5, _cube.getRightBlocks()[6].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[6].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[6].getLeftSurface().get_colorIndex());

		// right bottom-center
		assertEquals(3, _cube.getRightBlocks()[7].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[7].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[7].getUpperSurface().get_colorIndex());
		assertEquals(5, _cube.getRightBlocks()[7].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[7].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[7].getLeftSurface().get_colorIndex());

		// right bottom-right
		assertEquals(3, _cube.getRightBlocks()[8].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[8].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[8].getUpperSurface().get_colorIndex());
		assertEquals(5, _cube.getRightBlocks()[8].getDownSurface().get_colorIndex());
		assertEquals(4, _cube.getRightBlocks()[8].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getRightBlocks()[8].getLeftSurface().get_colorIndex());

		// upper top-left
		assertEquals(1, _cube.getUpperBlocks()[0].getUpperSurface().get_colorIndex());
		assertEquals(2, _cube.getUpperBlocks()[0].getLeftSurface().get_colorIndex());
		assertEquals(4, _cube.getUpperBlocks()[0].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[0].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[0].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[0].getDownSurface().get_colorIndex());

		// upper top-center
		assertEquals(1, _cube.getUpperBlocks()[1].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[1].getLeftSurface().get_colorIndex());
		assertEquals(4, _cube.getUpperBlocks()[1].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[1].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[1].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[1].getDownSurface().get_colorIndex());

		// upper top-right
		assertEquals(1, _cube.getUpperBlocks()[2].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[2].getLeftSurface().get_colorIndex());
		assertEquals(4, _cube.getUpperBlocks()[2].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[2].getFrontSurface().get_colorIndex());
		assertEquals(3, _cube.getUpperBlocks()[2].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[2].getDownSurface().get_colorIndex());

		// upper center-left
		assertEquals(1, _cube.getUpperBlocks()[3].getUpperSurface().get_colorIndex());
		assertEquals(2, _cube.getUpperBlocks()[3].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[3].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[3].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[3].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[3].getDownSurface().get_colorIndex());

		// upper center-center
		assertEquals(1, _cube.getUpperBlocks()[4].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[4].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[4].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[4].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[4].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[4].getDownSurface().get_colorIndex());

		// upper center-right
		assertEquals(1, _cube.getUpperBlocks()[5].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[5].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[5].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[5].getFrontSurface().get_colorIndex());
		assertEquals(3, _cube.getUpperBlocks()[5].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[5].getDownSurface().get_colorIndex());

		// upper bottom-left
		assertEquals(1, _cube.getUpperBlocks()[6].getUpperSurface().get_colorIndex());
		assertEquals(2, _cube.getUpperBlocks()[6].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[6].getBackSurface().get_colorIndex());
		assertEquals(0, _cube.getUpperBlocks()[6].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[6].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[6].getDownSurface().get_colorIndex());

		// upper bottom-center
		assertEquals(1, _cube.getUpperBlocks()[7].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[7].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[7].getBackSurface().get_colorIndex());
		assertEquals(0, _cube.getUpperBlocks()[7].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[7].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[7].getDownSurface().get_colorIndex());

		// upper bottom-right
		assertEquals(1, _cube.getUpperBlocks()[8].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[8].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[8].getBackSurface().get_colorIndex());
		assertEquals(0, _cube.getUpperBlocks()[8].getFrontSurface().get_colorIndex());
		assertEquals(3, _cube.getUpperBlocks()[8].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getUpperBlocks()[8].getDownSurface().get_colorIndex());

		// down top-left
		assertEquals(5, _cube.getDownBlocks()[0].getDownSurface().get_colorIndex());
		assertEquals(2, _cube.getDownBlocks()[0].getLeftSurface().get_colorIndex());
		assertEquals(0, _cube.getDownBlocks()[0].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[0].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[0].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[0].getUpperSurface().get_colorIndex());

		// down top-center
		assertEquals(5, _cube.getDownBlocks()[1].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[1].getLeftSurface().get_colorIndex());
		assertEquals(0, _cube.getDownBlocks()[1].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[1].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[1].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[1].getUpperSurface().get_colorIndex());

		// down top-right
		assertEquals(5, _cube.getDownBlocks()[2].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[2].getLeftSurface().get_colorIndex());
		assertEquals(0, _cube.getDownBlocks()[2].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[2].getBackSurface().get_colorIndex());
		assertEquals(3, _cube.getDownBlocks()[2].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[2].getUpperSurface().get_colorIndex());

		// down center-left
		assertEquals(5, _cube.getDownBlocks()[3].getDownSurface().get_colorIndex());
		assertEquals(2, _cube.getDownBlocks()[3].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[3].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[3].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[3].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[3].getUpperSurface().get_colorIndex());

		// down center-center
		assertEquals(5, _cube.getDownBlocks()[4].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[4].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[4].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[4].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[4].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[4].getUpperSurface().get_colorIndex());

		// down center-right
		assertEquals(5, _cube.getDownBlocks()[5].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[5].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[5].getFrontSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[5].getBackSurface().get_colorIndex());
		assertEquals(3, _cube.getDownBlocks()[5].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[5].getUpperSurface().get_colorIndex());

		// down bottom-left
		assertEquals(5, _cube.getDownBlocks()[6].getDownSurface().get_colorIndex());
		assertEquals(2, _cube.getDownBlocks()[6].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[6].getFrontSurface().get_colorIndex());
		assertEquals(4, _cube.getDownBlocks()[6].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[6].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[6].getUpperSurface().get_colorIndex());

		// down bottom-center
		assertEquals(5, _cube.getDownBlocks()[7].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[7].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[7].getFrontSurface().get_colorIndex());
		assertEquals(4, _cube.getDownBlocks()[7].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[7].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[7].getUpperSurface().get_colorIndex());

		// down bottom-right
		assertEquals(5, _cube.getDownBlocks()[8].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[8].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[8].getFrontSurface().get_colorIndex());
		assertEquals(4, _cube.getDownBlocks()[8].getBackSurface().get_colorIndex());
		assertEquals(3, _cube.getDownBlocks()[8].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getDownBlocks()[8].getUpperSurface().get_colorIndex());

		// back top-left
		assertEquals(4, _cube.getBackBlocks()[0].getBackSurface().get_colorIndex());
		assertEquals(3, _cube.getBackBlocks()[0].getRightSurface().get_colorIndex());
		assertEquals(1, _cube.getBackBlocks()[0].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[0].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[0].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[0].getFrontSurface().get_colorIndex());

		// back top-center
		assertEquals(4, _cube.getBackBlocks()[1].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[1].getRightSurface().get_colorIndex());
		assertEquals(1, _cube.getBackBlocks()[1].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[1].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[1].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[1].getFrontSurface().get_colorIndex());

		// back top-right
		assertEquals(4, _cube.getBackBlocks()[2].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[2].getRightSurface().get_colorIndex());
		assertEquals(1, _cube.getBackBlocks()[2].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[2].getDownSurface().get_colorIndex());
		assertEquals(2, _cube.getBackBlocks()[2].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[2].getFrontSurface().get_colorIndex());

		// back center-left
		assertEquals(4, _cube.getBackBlocks()[3].getBackSurface().get_colorIndex());
		assertEquals(3, _cube.getBackBlocks()[3].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[3].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[3].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[3].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[3].getFrontSurface().get_colorIndex());

		// back center-center
		assertEquals(4, _cube.getBackBlocks()[4].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[4].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[4].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[4].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[4].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[4].getFrontSurface().get_colorIndex());

		// back center-right
		assertEquals(4, _cube.getBackBlocks()[5].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[5].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[5].getUpperSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[5].getDownSurface().get_colorIndex());
		assertEquals(2, _cube.getBackBlocks()[5].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[5].getFrontSurface().get_colorIndex());

		// back bottom-left
		assertEquals(4, _cube.getBackBlocks()[6].getBackSurface().get_colorIndex());
		assertEquals(3, _cube.getBackBlocks()[6].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[6].getUpperSurface().get_colorIndex());
		assertEquals(5, _cube.getBackBlocks()[6].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[6].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[6].getFrontSurface().get_colorIndex());

		// back bottom-center
		assertEquals(4, _cube.getBackBlocks()[7].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[7].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[7].getUpperSurface().get_colorIndex());
		assertEquals(5, _cube.getBackBlocks()[7].getDownSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[7].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[7].getFrontSurface().get_colorIndex());

		// back bottom-right
		assertEquals(4, _cube.getBackBlocks()[8].getBackSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[8].getRightSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[8].getUpperSurface().get_colorIndex());
		assertEquals(5, _cube.getBackBlocks()[8].getDownSurface().get_colorIndex());
		assertEquals(2, _cube.getBackBlocks()[8].getLeftSurface().get_colorIndex());
		assertEquals(-1, _cube.getBackBlocks()[8].getFrontSurface().get_colorIndex());

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
		assertEquals(_cube.toString(), result);
	}
	
	@Test
	public void test_R()
	{
		_cube.R();
		String result =
			"   110\n" +
			"   110\n" +
			"   110\n" +
			"222005333144\n" +
			"222005333144\n" +
			"222005333144\n" +
			"   554\n" +
			"   554\n" +
			"   554";
		
		assertEquals(_cube.toString(), result);
	}
	
	@Test
	public void test_R_CC()
	{
		_cube.R_CC();
		String result =
			"   114\n" +
			"   114\n" +
			"   114\n" +
			"222001333544\n" +
			"222001333544\n" +
			"222001333544\n" +
			"   550\n" +
			"   550\n" +
			"   550";
		
		assertEquals(_cube.toString(), result);
	}
	
	@Test
	public void test_L()
	{
		_cube.L();
		String result =
				"   411\n" +
				"   411\n" +
				"   411\n" +
				"222100333445\n" +
				"222100333445\n" +
				"222100333445\n" +
				"   055\n" +
				"   055\n" +
				"   055";
		
		assertEquals(_cube.toString(), result);
	}
	
	@Test
	public void test_L_CC()
	{
		_cube.L_CC();
		String result =
				"   011\n" +
				"   011\n" +
				"   011\n" +
				"222500333441\n" +
				"222500333441\n" +
				"222500333441\n" +
				"   455\n" +
				"   455\n" +
				"   455";
		
		assertEquals(_cube.toString(), result);
	}

	@Test
	public void test_F()
	{
		_cube.F();
		String result =
			"   111\n" +
			"   111\n" +
			"   222\n" +
			"225000133444\n" +
			"225000133444\n" +
			"225000133444\n" +
			"   333\n" +
			"   555\n" +
			"   555";
		
		assertEquals(_cube.toString(), result);
	}

	@Test
	public void test_F_CC()
	{
		_cube.F_CC();
		String result =
			"   111\n" +
			"   111\n" +
			"   333\n" +
			"221000533444\n" +
			"221000533444\n" +
			"221000533444\n" +
			"   222\n" +
			"   555\n" +
			"   555";
		
		assertEquals(_cube.toString(), result);
	}

	@Test
	public void test_B()
	{
		_cube.B();
		String result =
				"   333\n" +
				"   111\n" +
				"   111\n" +
				"122000335444\n" +
				"122000335444\n" +
				"122000335444\n" +
				"   555\n" +
				"   555\n" +
				"   222";
		
		assertEquals(_cube.toString(), result);
	}

	@Test
	public void test_B_CC()
	{
		_cube.B_CC();
		String result =
				"   222\n" +
				"   111\n" +
				"   111\n" +
				"522000331444\n" +
				"522000331444\n" +
				"522000331444\n" +
				"   555\n" +
				"   555\n" +
				"   333";
		
		assertEquals(_cube.toString(), result);
	}
	
	@Test
	public void test_U()
	{
		_cube.U();
		String result =
			"   111\n" +
			"   111\n" +
			"   111\n" +
			"000333444222\n" +
			"222000333444\n" +
			"222000333444\n" +
			"   555\n" +
			"   555\n" +
			"   555";
		
		assertEquals(_cube.toString(), result);
	}
	@Test
	public void test_U_CC()
	{
		_cube.U_CC();
		String result =
			"   111\n" +
			"   111\n" +
			"   111\n" +
			"444222000333\n" +
			"222000333444\n" +
			"222000333444\n" +
			"   555\n" +
			"   555\n" +
			"   555";
		
		assertEquals(_cube.toString(), result);
	}
	@Test
	public void test_D()
	{
		_cube.D();
		String result =
			"   111\n" +
			"   111\n" +
			"   111\n" +
			"222000333444\n" +
			"222000333444\n" +
			"444222000333\n" +
			"   555\n" +
			"   555\n" +
			"   555";
		
		assertEquals(_cube.toString(), result);
	}
	@Test
	public void test_D_CC()
	{
		_cube.D_CC();
		String result =
			"   111\n" +
			"   111\n" +
			"   111\n" +
			"222000333444\n" +
			"222000333444\n" +
			"000333444222\n" +
			"   555\n" +
			"   555\n" +
			"   555";
		
		assertEquals(_cube.toString(), result);
	}
	
	@Test
	public void test_rotateX90()
	{
		_cube.rotateX90();
		String result = 
			"   000\n" +
			"   000\n" +
			"   000\n" +
			"222555333111\n" +
			"222555333111\n" +
			"222555333111\n" +
			"   444\n" +
			"   444\n" +
			"   444";
		assertEquals(result, _cube.toString());
	}
	
	@Test
	public void test_rotateY90()
	{
		_cube.rotateY90();
		String result = 
		"   333\n" +
		"   333\n" +
		"   333\n" +
		"111000555444\n" +
		"111000555444\n" +
		"111000555444\n" +
		"   222\n" +
		"   222\n" +
		"   222";
		assertEquals(result, _cube.toString());
	}
	
	@Test
	public void test_rotateZ90()
	{
		_cube.rotateZ90();
		String result = 
		"   111\n" +
		"   111\n" +
		"   111\n" +
		"444222000333\n" +
		"444222000333\n" +
		"444222000333\n" +
		"   555\n" +
		"   555\n" +
		"   555";
		assertEquals(result, _cube.toString());
	}
	
	@Test
	public void test_rotateXNegative90()
	{
		_cube.rotateXNegative90();
		String result = 
			"   444\n" +
			"   444\n" +
			"   444\n" +
			"222111333555\n" +
			"222111333555\n" +
			"222111333555\n" +
			"   000\n" +
			"   000\n" +
			"   000";
		assertEquals(result, _cube.toString());
	}
	
	@Test
	public void test_rotateYNegative90()
	{
		_cube.rotateYNegative90();
		String result = 
		"   222\n" +
		"   222\n" +
		"   222\n" +
		"555000111444\n" +
		"555000111444\n" +
		"555000111444\n" +
		"   333\n" +
		"   333\n" +
		"   333";
		assertEquals(result, _cube.toString());
	}
	
	@Test
	public void test_rotateZNegetive90()
	{
		_cube.rotateZNegative90();
		String result = 
		"   111\n" +
		"   111\n" +
		"   111\n" +
		"000333444222\n" +
		"000333444222\n" +
		"000333444222\n" +
		"   555\n" +
		"   555\n" +
		"   555";
		assertEquals(result, _cube.toString());
	}
}
