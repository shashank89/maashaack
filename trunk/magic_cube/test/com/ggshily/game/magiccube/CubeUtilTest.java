package com.ggshily.game.magiccube;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

public class CubeUtilTest
{

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
	}

	@After
	public void tearDown() throws Exception
	{
	}

	@Test
	public void testIsMatch()
	{
		fail("Not yet implemented");
	}

	@Test
	public void testString2Array()
	{
		String data = 
			"   111\n" +
			"   111\n" +
			"   111\n" +
			"222000333444\n" +
			"222000333444\n" +
			"222000333444\n" +
			"   555\n" +
			"   555\n" +
			"   555";
		int[] result = {0, 0, 0, 0, 0, 0, 0, 0, 0,
				 1, 1, 1, 1, 1, 1, 1, 1, 1,
				 2, 2, 2, 2, 2, 2, 2, 2, 2,
				 3, 3, 3, 3, 3, 3, 3, 3, 3,
				 4, 4, 4, 4, 4, 4, 4, 4, 4,
				 5, 5, 5, 5, 5, 5, 5, 5, 5};
		assertArrayEquals(result, CubeUtil.string2Array(data));
	}

	@Test
	public void testArray2String()
	{
		int[] data = {0, 0, 0, 0, 0, 0, 0, 0, 0,
				 1, 1, 1, 1, 1, 1, 1, 1, 1,
				 2, 2, 2, 2, 2, 2, 2, 2, 2,
				 3, 3, 3, 3, 3, 3, 3, 3, 3,
				 4, 4, 4, 4, 4, 4, 4, 4, 4,
				 5, 5, 5, 5, 5, 5, 5, 5, 5};
		String result = 
			"   111\n" +
			"   111\n" +
			"   111\n" +
			"222000333444\n" +
			"222000333444\n" +
			"222000333444\n" +
			"   555\n" +
			"   555\n" +
			"   555";
		assertEquals(result, CubeUtil.array2String(data));
	}

}
