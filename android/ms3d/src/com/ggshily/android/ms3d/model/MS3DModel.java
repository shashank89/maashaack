package com.ggshily.android.ms3d.model;

import java.io.DataInput;
import java.io.IOException;
import java.io.InputStream;

/**
 * A Milkshape 3D Model.
 *
 * @author Nikolaj Ougaard
 */
public class MS3DModel {
    public MS3DHeader header;
    public MS3DVertex[] vertices;
    public MS3DTriangle[] triangles;
    public MS3DGroup[] groups;
    public MS3DMaterial[] materials;
    public MS3DJoint[] joints;
    
    public float animationFPS;
    public float currentTime;
    public float totalFrames;
    public float jointSize;
    public int transparencyMode;
    public float alphaRef;
    
    public float[] maxs = {0.0f, 0.0f, 0.0f};
    public float[] mins = {0.0f, 0.0f, 0.0f};

    public MS3DModel(MS3DHeader header, MS3DVertex[] vertices, MS3DTriangle[] triangles, MS3DGroup[] groups, MS3DMaterial[] materials, MS3DJoint[] joints) {
        this.header = header;
        this.vertices = vertices;
        this.triangles = triangles;
        this.groups = groups;
        this.materials = materials;
        this.joints = joints;
        
        SetupJoints();
        setFrame(-1.0f);
    }

	public MS3DModel()
	{
		// TODO Auto-generated constructor stub
	}

	public void transformVertex(MS3DVertex vertex/*, float[] out*/)
	{
		float[] out = vertex.realPos;
		
		int[] jointIndices = new int[4];
		int[] jointWeights = new int[4];
		fillJointIndicesAndWeights(vertex, jointIndices, jointWeights);
		
		if(jointIndices[0] < 0 || jointIndices[0] >= joints.length || currentTime < 0.0f)
		{
			out[0] = vertex.location[0];
			out[1] = vertex.location[1];
			out[2] = vertex.location[2];
		}
		else
		{
			// count valid weights
			int numWeights = 0;
			for (int i = 0; i < 4; i++)
			{
				if (jointWeights[i] > 0 && jointIndices[i] >= 0 && jointIndices[i] < joints.length)
					++numWeights;
				else
					break;
			}

			// init
			out[0] = 0.0f;
			out[1] = 0.0f;
			out[2] = 0.0f;

			float[] weights = { (float) jointWeights[0] / 100.0f, (float) jointWeights[1] / 100.0f, (float) jointWeights[2] / 100.0f, (float) jointWeights[3] / 100.0f };
			if (numWeights == 0)
			{
				numWeights = 1;
				weights[0] = 1.0f;
			}
			// add weighted vertices
			for (int i = 0; i < numWeights; i++)
			{
				MS3DJoint joint  = joints[vertex.boneId];
				
				float[] tmp = new float[3];
				float[] vert = new float[3];
				MathLib.VectorITransform(vertex.location, joint.matGlobalSkeleton, tmp);
				MathLib.VectorTransform(tmp, joint.matGlobal, vert);
	
				out[0] += vert[0] * weights[i];
				out[1] += vert[1] * weights[i];
				out[2] += vert[2] * weights[i];
			}
		}
	}

	public void transformNormal(MS3DVertex vertex, float[] normal, float[] out)
	{
		int[] jointIndices = new int[4];
		int[] jointWeights = new int[4];
		fillJointIndicesAndWeights(vertex, jointIndices, jointWeights);

		if (jointIndices[0] < 0 || jointIndices[0] >= (int) joints.length || currentTime < 0.0f)
		{
			out[0] = normal[0];
			out[1] = normal[1];
			out[2] = normal[2];
		}
		else
		{
			// count valid weights
			int numWeights = 0;
			for (int i = 0; i < 4; i++)
			{
				if (jointWeights[i] > 0 && jointIndices[i] >= 0 && jointIndices[i] < (int) joints.length)
					++numWeights;
				else
					break;
			}

			// init
			out[0] = 0.0f;
			out[1] = 0.0f;
			out[2] = 0.0f;

			float[] weights = { (float) jointWeights[0] / 100.0f, (float) jointWeights[1] / 100.0f, (float) jointWeights[2] / 100.0f, (float) jointWeights[3] / 100.0f };
			if (numWeights == 0)
			{
				numWeights = 1;
				weights[0] = 1.0f;
			}
			// add weighted vertices
			for (int i = 0; i < numWeights; i++)
			{
				MS3DJoint joint = joints[jointIndices[i]];
				float[] tmp = new float[3];
				float[] norm = new float[3];
				MathLib.VectorIRotate(normal, joint.matGlobalSkeleton, tmp);
				MathLib.VectorRotate(tmp, joint.matGlobal, norm);

				out[0] += norm[0] * weights[i];
				out[1] += norm[1] * weights[i];
				out[2] += norm[2] * weights[i];
			}
		}
	}
	
	public void SetupJoints()
	{
		for (int i = 0; i < joints.length; i++)
		{
			MS3DJoint joint = joints[i];
			joint.parentIndex = FindJointByName(joint.parentName);
		}

		for (int i = 0; i < joints.length; i++)
		{
			MS3DJoint joint = joints[i];
			MathLib.AngleMatrix(joint.rotation, joint.matLocalSkeleton);
			joint.matLocalSkeleton[0][3]= joint.position[0];
			joint.matLocalSkeleton[1][3]= joint.position[1];
			joint.matLocalSkeleton[2][3]= joint.position[2];
			
			if (joint.parentIndex == -1)
			{
				copyArray2D(joint.matLocalSkeleton, joint.matGlobalSkeleton);
			}
			else
			{
				MS3DJoint parentJoint = joints[joint.parentIndex];
				MathLib.R_ConcatTransforms(parentJoint.matGlobalSkeleton, joint.matLocalSkeleton, joint.matGlobalSkeleton);
			}

			SetupTangents();
		}
	}
	
	private void SetupTangents()
	{
		for (int j = 0; j < joints.length; j++)
		{
			MS3DJoint joint = joints[j];
			int numPositionKeys = (int) joint.numPositionKeys;
			joint.tangents = new MS3DTangent[numPositionKeys];

			// clear all tangents (zero derivatives)
			for (int k = 0; k < numPositionKeys; k++)
			{
				joint.tangents[k] = new MS3DTangent();
				joint.tangents[k].tangentIn[0] = 0.0f;
				joint.tangents[k].tangentIn[1] = 0.0f;
				joint.tangents[k].tangentIn[2] = 0.0f;
				joint.tangents[k].tangentOut[0] = 0.0f;
				joint.tangents[k].tangentOut[1] = 0.0f;
				joint.tangents[k].tangentOut[2] = 0.0f;
			}

			// if there are more than 2 keys, we can calculate tangents, otherwise we use zero derivatives
			if (numPositionKeys > 2)
			{
				for (int k = 0; k < numPositionKeys; k++)
				{
					// make the curve tangents looped
					int k0 = k - 1;
					if (k0 < 0)
						k0 = numPositionKeys - 1;
					int k1 = k;
					int k2 = k + 1;
					if (k2 >= numPositionKeys)
						k2 = 0;

					// calculate the tangent, which is the vector from key[k - 1] to key[k + 1]
					float[] tangent = new float[3];
					tangent[0] = (joint.positionKeys[k2].key[0] - joint.positionKeys[k0].key[0]);
					tangent[1] = (joint.positionKeys[k2].key[1] - joint.positionKeys[k0].key[1]);
					tangent[2] = (joint.positionKeys[k2].key[2] - joint.positionKeys[k0].key[2]);

					// weight the incoming and outgoing tangent by their time to avoid changes in speed, if the keys are not within the same interval
					float dt1 = joint.positionKeys[k1].time - joint.positionKeys[k0].time;
					float dt2 = joint.positionKeys[k2].time - joint.positionKeys[k1].time;
					float dt = dt1 + dt2;
					joint.tangents[k1].tangentIn[0] = tangent[0] * dt1 / dt;
					joint.tangents[k1].tangentIn[1] = tangent[1] * dt1 / dt;
					joint.tangents[k1].tangentIn[2] = tangent[2] * dt1 / dt;

					joint.tangents[k1].tangentOut[0] = tangent[0] * dt2 / dt;
					joint.tangents[k1].tangentOut[1] = tangent[1] * dt2 / dt;
					joint.tangents[k1].tangentOut[2] = tangent[2] * dt2 / dt;
				}
			}
		}
	}
	
	private int FindJointByName(String name)
	{
		for (int i = 0; i < joints.length; i++)
		{
			if (joints[i].name.equals(name))
				return i;
		}

		return -1;
	}
	
	public void setFrame(float frame)
	{
		int i;
		MS3DJoint joint;
		if(frame < 0.0)
		{
			for(i = 0; i < joints.length; i++)
			{
				joint = joints[i];
				copyArray2D(joint.matLocalSkeleton, joint.matLocal);
				copyArray2D(joint.matGlobalSkeleton, joint.matGlobal);
//				joint.matLocal = joint.matLocalSkeleton;
//				joint.matGloblal = joint.matGlobalSkeleton;
			}
		}
		else
		{
			for(i = 0; i < joints.length; i++)
			{
				evaluateJoint(i, frame);
			}
		}
		currentTime = frame;
	}

	private void evaluateJoint(int index, float frame)
	{
		int i ;
		
		MS3DJoint joint  = joints[index];

		//
		// calculate joint animation matrix, this matrix will animate matLocalSkeleton
		//
		float[] pos = {0.0f, 0.0f, 0.0f};
		int numPosKeys  = joint.numPositionKeys;
		if(numPosKeys > 0)
		{

			int i1  = -1;
			int i2  = -2;
			// find the two keys, where "frame" is in between for the position channel
			for(i = 0; i < numPosKeys - 1; i++)
			{
				if(frame >= joint.positionKeys[i].time && frame < joint.positionKeys[i + 1].time)
				{
					i1 = i;
					i2 = i + 1;
					break;
				}
			}

			// if there are no such keys
			if(i1 == -1 || i2 == -1)
			{
				// either take the first
				if(frame < joint.positionKeys[0].time)
				{
					pos[0] = joint.positionKeys[0].key[0];
					pos[1] = joint.positionKeys[0].key[1];
					pos[2] = joint.positionKeys[0].key[2];
				}
				// or the last key
				else if(frame >= joint.positionKeys[numPosKeys - 1].time)
				{
					pos[0] = joint.positionKeys[numPosKeys - 1].key[0];
					pos[1] = joint.positionKeys[numPosKeys - 1].key[1];
					pos[2] = joint.positionKeys[numPosKeys - 1].key[2];
				}
			}
			// there are such keys, so interpolate using hermite interpolation
			else
			{
				MS3DJoint.KeyFramePosition p0  = joint.positionKeys[i1];
				MS3DJoint.KeyFramePosition p1  = joint.positionKeys[i2];
				
				MS3DTangent m0  = joint.tangents[i1];
				MS3DTangent m1  = joint.tangents[i2];

				// normalize the time between the keys into [0..1]
				float t  = (frame - p0.time) / (p1.time - p0.time);
				float t2 = t  * t;
				float t3 = t2 * t;

				// calculate hermite basis
				float h1 =  2.0f * t3 - 3.0f * t2 + 1.0f;
				float h2 = -2.0f * t3 + 3.0f * t2;
				float h3 =         t3 + 3.0f * t2 + t;
				float h4 =         t3 -        t2;

				// do hermite interpolation
				pos[0] = h1 * p0.key[0] + h3 * m0.tangentOut[0] + h2 * p1.key[0] + h4* m1.tangentIn[0];
				pos[1] = h1 * p0.key[1] + h3 * m0.tangentOut[1] + h2 * p1.key[1] + h4* m1.tangentIn[1];
				pos[2] = h1 * p0.key[2] + h3 * m0.tangentOut[2] + h2 * p1.key[2] + h4* m1.tangentIn[2];
			}
		}
		
		float[] quat = {0.0f, 0.0f, 0.0f, 1.0f};
		int numRotKeys  = joint.numRotationKeys;
		if(numRotKeys > 0)
		{
			int i1  = -1;
			int i2  = -1;

			// find the two keys, where "frame" is in between for the rotation channel
			for(i = 0; i < numRotKeys - 1; i++)
			{
				if(frame >= joint.rotationKeys[i].time && frame < joint.rotationKeys[i + 1].time)
				{
					i1 = i;
					i2 = i + 1;
					break;
				}
			}

			// if there are no such keys
			if(i1 == -1 || i2 == -1)
			{
				// either take the first key
				if(frame < joint.rotationKeys[0].time)
				{
					MathLib.AngleQuaternion(joint.rotationKeys[0].key, quat);
				}
				// or the last key
				else if(frame >= joint.rotationKeys[numRotKeys - 1].time)
				{
					MathLib.AngleQuaternion(joint.rotationKeys[numRotKeys - 1].key, quat);
				}
			}
			// there are such keys, so do the quaternion slerp interpolation
			else
			{
				float t = (frame - joint.rotationKeys[i1].time) / (joint.rotationKeys[i2].time - joint.rotationKeys[i1].time);
				float[] q1 = {0.0f, 0.0f, 0.0f, 0.0f};
				float[] q2 = {0.0f, 0.0f, 0.0f, 0.0f};
				MathLib.AngleQuaternion(joint.rotationKeys[i1].key, q1);
				MathLib.AngleQuaternion(joint.rotationKeys[i2].key, q2);
				MathLib.QuaternionSlerp(q1, q2, t, quat);
			}
		}

		// make a matrix from pos/quat
		float[][] matAnimate = new float[3][4];
		MathLib.QuaternionMatrix(quat, matAnimate);
		matAnimate[0][3] = pos[0];
		matAnimate[1][3] = pos[1];
		matAnimate[2][3] = pos[2];

		// animate the local joint matrix using: matLocal = matLocalSkeleton * matAnimate
		MathLib.R_ConcatTransforms(joint.matLocalSkeleton, matAnimate, joint.matLocal);

		// build up the hierarchy if joints
		// matGlobal = matGlobal(parent) * matLocal
		if(joint.parentIndex == -1)
		{
			copyArray2D(joint.matLocal, joint.matGlobal);
		}
		else
		{
			MS3DJoint parentJoint  = joints[joint.parentIndex];
			MathLib.R_ConcatTransforms(parentJoint.matGlobal, joint.matLocal, joint.matGlobal);
		}
	}
    public void decodeMS3DModel(InputStream is) throws IOException {
        LittleEndianDataInputStream dataInputStream = new LittleEndianDataInputStream(is);
        System.out.println("header");
        header = decodeMS3DHeader(dataInputStream);
        System.out.println("vertices");
        vertices = decodeMS3DVertices(dataInputStream);
        System.out.println("triangles");
        triangles = decodeMS3DTriangles(dataInputStream);
        System.out.println("groups");
        groups = decodeMS3DGroups(dataInputStream);
        System.out.println("materials");
        materials = decodeMaterials(dataInputStream);

        // save some keyframer data
        animationFPS = dataInputStream.readFloat();
        currentTime = dataInputStream.readFloat();
        totalFrames = dataInputStream.readInt();

        joints = decodeJoints(dataInputStream, animationFPS);
        
        MS3DComment.decodeMS3DComment(dataInputStream);
        
        decodeVetexExtra(dataInputStream);
        decodeJointExtra(dataInputStream);
        decodeModelExtra(dataInputStream);

        SetupJoints();
        setFrame(-1.0f);
        
        for(int i = 0; i < vertices.length; i++)
        {
        	MathLib.AddPointToBounds(vertices[i].location, mins, maxs);
        }
    }
    
	private void decodeVetexExtra(LittleEndianDataInputStream dataInputStream) throws IOException
	{
		if(dataInputStream.available() > 0)
		{
			int subVerstion = dataInputStream.readInt();
			if(subVerstion == 2)
			{
				for(int i = 0; i < vertices.length; i++)
				{
					MS3DVertex vertex = vertices[i];
					vertex.boneIds[0] = dataInputStream.readByte();
					vertex.boneIds[1] = dataInputStream.readByte();
					vertex.boneIds[2] = dataInputStream.readByte();
					vertex.weights[0] = dataInputStream.readUnsignedByte();
					vertex.weights[1] = dataInputStream.readUnsignedByte();
					vertex.weights[2] = dataInputStream.readUnsignedByte();
					vertex.extra = dataInputStream.readInt();
				}
			}
			else if(subVerstion == 1)
			{
				for(int i = 0; i < vertices.length; i++)
				{
					MS3DVertex vertex = vertices[i];
					vertex.boneIds[0] = dataInputStream.readUnsignedByte();
					vertex.boneIds[1] = dataInputStream.readUnsignedByte();
					vertex.boneIds[2] = dataInputStream.readUnsignedByte();
					vertex.weights[0] = dataInputStream.readUnsignedByte();
					vertex.weights[1] = dataInputStream.readUnsignedByte();
					vertex.weights[2] = dataInputStream.readUnsignedByte();
				}
			}
		}
	}
	
	private void decodeJointExtra(LittleEndianDataInputStream dataInputStream) throws IOException
	{
		if(dataInputStream.available() > 0)
		{
			int subVersion = dataInputStream.readInt();
			if(subVersion == 1)
			{
				for(int i = 0; i < joints.length; ++i)
				{
					joints[i].color[0] = dataInputStream.readFloat();
					joints[i].color[1] = dataInputStream.readFloat();
					joints[i].color[2] = dataInputStream.readFloat();
				}
			}
		}
	}
	
	private void decodeModelExtra(LittleEndianDataInputStream dataInputStream) throws IOException
	{
		if(dataInputStream.available() > 0)
		{
			int subVersion = dataInputStream.readInt();
			if(subVersion == 1)
			{
				jointSize = dataInputStream.readFloat();
				transparencyMode = dataInputStream.readInt();
				alphaRef = dataInputStream.readFloat();
			}
		}
	}
	
	public static void fillJointIndicesAndWeights(MS3DVertex vertex, int[] jointIndices, int[] jointWeights)
	{
		jointIndices[0] = vertex.boneId;
		jointIndices[1] = vertex.boneIds[0];
		jointIndices[2] = vertex.boneIds[1];
		jointIndices[3] = vertex.boneIds[2];
		jointWeights[0] = 100;
		jointWeights[1] = 0;
		jointWeights[2] = 0;
		jointWeights[3] = 0;
		if (vertex.weights[0] != 0 || vertex.weights[1] != 0 || vertex.weights[2] != 0)
		{
			jointWeights[0] = vertex.weights[0];
			jointWeights[1] = vertex.weights[1];
			jointWeights[2] = vertex.weights[2];
			jointWeights[3] = 100 - (vertex.weights[0] + vertex.weights[1] + vertex.weights[2]);
		}
	}

	public static void copyArray2D(float[][] from , float[][] toArr)
	{
		toArr[0][0] = from[0][0];
		toArr[0][1] = from[0][1];
		toArr[0][2] = from[0][2];
		toArr[0][3] = from[0][3];
		toArr[1][0] = from[1][0];
		toArr[1][1] = from[1][1];
		toArr[1][2] = from[1][2];
		toArr[1][3] = from[1][3];
		toArr[2][0] = from[2][0];
		toArr[2][1] = from[2][1];
		toArr[2][2] = from[2][2];
		toArr[2][3] = from[2][3];
	}

    private static MS3DJoint[] decodeJoints(DataInput input, float fps) throws IOException {
        int numJoints = input.readUnsignedShort();

        MS3DJoint[] joints = new MS3DJoint[numJoints];

        for (int jc = 0; jc < numJoints; jc++) {
            joints[jc] = MS3DJoint.decodeMS3DJoint(input, fps);
        }
        return joints;
    }

    private static MS3DMaterial[] decodeMaterials(DataInput input) throws IOException {
        int numMaterials = input.readUnsignedShort();

        MS3DMaterial[] materials = new MS3DMaterial[numMaterials];

        for (int mc = 0; mc < numMaterials; mc++) {
            materials[mc] = MS3DMaterial.decodeMS3DMaterial(input);
        }
        return materials;
    }

    private static MS3DGroup[] decodeMS3DGroups(DataInput input) throws IOException {
        int numGroups = input.readUnsignedShort();

        MS3DGroup[] groups = new MS3DGroup[numGroups];

        for (int gc = 0; gc < numGroups; gc++) {
            groups[gc] = MS3DGroup.decodeMS3DGroup(input);
        }
        return groups;
    }

    private static MS3DTriangle[] decodeMS3DTriangles(DataInput input) throws IOException {
        int numTriangles = input.readUnsignedShort();

        MS3DTriangle[] triangles = new MS3DTriangle[numTriangles];

        for (int tc = 0; tc < numTriangles; tc++) {
            triangles[tc] = MS3DTriangle.decodeMS3DTriangle(input);
        }
        return triangles;
    }

    private static MS3DVertex[] decodeMS3DVertices(DataInput input) throws IOException {
        int numVertices = input.readUnsignedShort();

        MS3DVertex[] vertices = new MS3DVertex[numVertices];

        for (int vc = 0; vc < numVertices; vc++) {
            vertices[vc] = MS3DVertex.decodeMS3DVertex(input);
        }
        return vertices;
    }

    private static MS3DHeader decodeMS3DHeader(DataInput input) throws IOException {
        return MS3DHeader.decodeMS3DHeader(input);
    }

    private static StringBuffer stringBuffer = new StringBuffer();
    static String decodeZeroTerminatedString(DataInput input, int maximumLength) throws IOException {
        boolean zeroEncountered = false;
        stringBuffer.delete(0, stringBuffer.length());
        for (int c = 0; c < maximumLength; c++) {
            int readByte = input.readUnsignedByte();
            if (!zeroEncountered && readByte != 0) {
                stringBuffer.append((char)readByte);
            } else {
                zeroEncountered = true;
            }
        }

        return stringBuffer.toString();
    }
}
