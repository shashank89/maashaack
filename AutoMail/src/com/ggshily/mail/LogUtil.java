package com.ggshily.mail;

import java.io.IOException;
import java.util.zip.DataFormatException;
import java.util.zip.Inflater;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

public class LogUtil
{

	public static String getLogString(byte[] by) throws IOException, DataFormatException
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
	
	public static Log getLog(byte[] by) throws JsonSyntaxException, IOException, DataFormatException
	{
		Gson gson = new Gson();
		Log log = gson.fromJson(getLogString(by), Log.class);
		
		return log;
	}
	
	public static String getMailBody(Log log)
	{
		return ":<div><br>user :<a href=\"http://www.facebook.com/profile.php?id="
		+ log.userId + "\">" + log.userId
		+ "</a><br>Error code:" + log.code
		+ "<br>Error message:<br>"
		+ log.message.replaceAll("\n", "<br>") + "</div>";
	}
}
