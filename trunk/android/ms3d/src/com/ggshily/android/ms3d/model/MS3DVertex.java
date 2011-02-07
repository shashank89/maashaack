package com.ggshily.android.ms3d.model;

import java.io.DataInput;
import java.io.IOException;

/**
 * A Milshape 3D Vertex 
 * 
 * @author Nikolaj Ougaard
 */
public class MS3DVertex
{
    /**
     * Byte size of vertex
     */
     public static final int SIZE = 15;

    public int flags;                                   // SELECTED | SELECTED2 | HIDDEN
    public float[] location = new float[3];
    public int referenceCount;
    public int boneId;                                  // -1 = no bone
    public int[] boneIds = {0, 0, 0};

	public int[] weights = {0, 0, 0};
	public int extra;

    /**
     * This method creates a new MS3DVertex.
     */
    public static MS3DVertex decodeMS3DVertex(DataInput input) throws IOException {
        MS3DVertex v = new MS3DVertex();
        v.flags = input.readUnsignedByte();
        v.location[0] = input.readFloat();
        v.location[1] = input.readFloat();
        v.location[2] = input.readFloat();
        v.boneId = input.readByte();
        v.referenceCount = input.readUnsignedByte();
        return v;
    }

    /**
     * @see Object#toString()
     */
    public String toString()
    {
        return "Vertex["+location[0]+","+location[1]+","+location[2]+"]";
    }
}
