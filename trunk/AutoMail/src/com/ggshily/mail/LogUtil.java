package com.ggshily.mail;

import java.io.IOException;
import java.util.zip.DataFormatException;
import java.util.zip.Inflater;

public class LogUtil
{

	public static String getLog(byte[] by) throws IOException, DataFormatException
	{
		Inflater decompresser = new Inflater();
		decompresser.setInput(by, 0, by.length);
		byte[] result = new byte[10 * 1024 * 1024];
		int resultLength = decompresser.inflate(result);
		decompresser.end();

		// Decode the bytes into a String
		String outputString = new String(result, 0, resultLength, "UTF-8");
		return outputString;

	}
}
