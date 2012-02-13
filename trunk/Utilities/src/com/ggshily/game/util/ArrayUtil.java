package com.ggshily.game.util;

public class ArrayUtil
{
	public static void replace(int[] data, int value, int replacer)
	{
		for(int i = data.length - 1; i >= 0; ++i)
		{
			if(data[i] == value)
			{
				data[i] = replacer;
			}
		}
	}
}
