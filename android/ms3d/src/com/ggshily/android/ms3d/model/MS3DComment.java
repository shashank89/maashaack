package com.ggshily.android.ms3d.model;

import java.io.IOException;

public class MS3DComment
{

	public static MS3DComment decodeMS3DComment(LittleEndianDataInputStream input) throws IOException 
	{
		if(input.available() > 0)
		{
			int subVersion = input.readInt();
			if(subVersion == 1)
			{
				// group comments
				int numComments = input.readInt();
				for(int i = 0; i < numComments; ++i)
				{
					int index = input.readInt();
					int size = input.readInt();
					String comment = MS3DModel.decodeZeroTerminatedString(input, size);
					
					System.out.println(index + " " + comment);
				}
				// material comments
				numComments = input.readInt();
				for(int i = 0; i < numComments; ++i)
				{
					int index = input.readInt();
					int size = input.readInt();
					String comment = MS3DModel.decodeZeroTerminatedString(input, size);
					
					System.out.println(index + " " + comment);
				}
				// joint comments
				numComments = input.readInt();
				for(int i = 0; i < numComments; ++i)
				{
					int index = input.readInt();
					int size = input.readInt();
					String comment = MS3DModel.decodeZeroTerminatedString(input, size);
					
					System.out.println(index + " " + comment);
				}
				// model comments
				numComments = input.readInt();
				for(int i = 0; i < numComments; ++i)
				{
					int index = input.readInt();
					int size = input.readInt();
					String comment = MS3DModel.decodeZeroTerminatedString(input, size);
					
					System.out.println(index + " " + comment);
				}
			}
		}
		
		MS3DComment comment = new MS3DComment();
		
		return comment;
	}
}
