package qr2011;

import static org.junit.Assert.*;

import org.junit.Test;

public class BotTrustTest
{

	@Test
	public void testGetMinSeconds()
	{
		assertEquals(6, BotTrust.getMinSeconds("4 O 2 B 1 B 2 O 4"));
		assertEquals(100, BotTrust.getMinSeconds("3 O 5 O 8 B 100"));
		assertEquals(4, BotTrust.getMinSeconds("2 B 2 B 1"));
	}

}
