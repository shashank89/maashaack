package y2011.qr;

import static org.junit.Assert.*;

import org.junit.Test;

public class DoubleSquaresTest
{

	@Test
	public void testGetNumber()
	{
		assertEquals(DoubleSquares.getNumber(10), 1);
		assertEquals(DoubleSquares.getNumber(25), 2);
		assertEquals(DoubleSquares.getNumber(3), 0);
		assertEquals(DoubleSquares.getNumber(0), 1);
		assertEquals(DoubleSquares.getNumber(1), 1);
	}

}
