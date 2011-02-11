package com.ggshily.android.ms3d.model;

public class MathLib
{
	public static void ClearBounds (float[] mins, float[] maxs)
	{
		mins[0] = mins[1] = mins[2] = 99999;
		maxs[0] = maxs[1] = maxs[2] = -99999;
	}

	public static void AddPointToBounds (float[] v, float[] mins, float[] maxs)
	{
		int		i;
		float	val;

		for (i=0 ; i<3 ; i++)
		{
			val = v[i];
			if (val < mins[i])
				mins[i] = val;
			if (val > maxs[i])
				maxs[i] = val;
		}
	}
	public static void AngleQuaternion( float[] angles, float[] quaternion )
	{
		float		angle;
		float		sr, sp, sy, cr, cp, cy;

		// FIXME: rescale the inputs to 1/2 angle
		angle = angles[2] * 0.5f;
		sy = (float) Math.sin(angle);
		cy = (float) Math.cos(angle);
		angle = angles[1] * 0.5f;
		sp = (float) Math.sin(angle);
		cp = (float) Math.cos(angle);
		angle = angles[0] * 0.5f;
		sr = (float) Math.sin(angle);
		cr = (float) Math.cos(angle);

		quaternion[0] = sr*cp*cy-cr*sp*sy; // X
		quaternion[1] = cr*sp*cy+sr*cp*sy; // Y
		quaternion[2] = cr*cp*sy-sr*sp*cy; // Z
		quaternion[3] = cr*cp*cy+sr*sp*sy; // W
	}
	
	public static void AngleMatrix (float[] angles, float[] matrix )
	{
		float		angle;
		float		sr, sp, sy, cr, cp, cy;
		
		angle = angles[2];
		sy = (float) Math.sin(angle);
		cy = (float) Math.cos(angle);
		angle = angles[1];
		sp = (float) Math.sin(angle);
		cp = (float) Math.cos(angle);
		angle = angles[0];
		sr = (float) Math.sin(angle);
		cr = (float) Math.cos(angle);

		// matrix = (Z * Y) * X
		matrix[0 * 4 + 0] = cp*cy;
		matrix[1 * 4 + 0] = cp*sy;
		matrix[2 * 4 + 0] = -sp;
		matrix[0 * 4 + 1] = sr*sp*cy+cr*-sy;
		matrix[1 * 4 + 1] = sr*sp*sy+cr*cy;
		matrix[2 * 4 + 1] = sr*cp;
		matrix[0 * 4 + 2] = (cr*sp*cy+-sr*-sy);
		matrix[1 * 4 + 2] = (cr*sp*sy+-sr*cy);
		matrix[2 * 4 + 2] = cr*cp;
		matrix[0 * 4 + 3] = 0.0f;
		matrix[1 * 4 + 3] = 0.0f;
		matrix[2 * 4 + 3] = 0.0f;
	}

	public static void R_ConcatTransforms (float[] in1, float[] in2, float[] out)
	{
		out[0 * 4 + 0] = in1[0 * 4 + 0] * in2[0 * 4 + 0] + in1[0 * 4 + 1] * in2[1 * 4 + 0] +
					in1[0 * 4 + 2] * in2[2 * 4 + 0];
		out[0 * 4 + 1] = in1[0 * 4 + 0] * in2[0 * 4 + 1] + in1[0 * 4 + 1] * in2[1 * 4 + 1] +
					in1[0 * 4 + 2] * in2[2 * 4 + 1];
		out[0 * 4 + 2] = in1[0 * 4 + 0] * in2[0 * 4 + 2] + in1[0 * 4 + 1] * in2[1 * 4 + 2] +
					in1[0 * 4 + 2] * in2[2 * 4 + 2];
		out[0 * 4 + 3] = in1[0 * 4 + 0] * in2[0 * 4 + 3] + in1[0 * 4 + 1] * in2[1 * 4 + 3] +
					in1[0 * 4 + 2] * in2[2 * 4 + 3] + in1[0 * 4 + 3];
		out[1 * 4 + 0] = in1[1 * 4 + 0] * in2[0 * 4 + 0] + in1[1 * 4 + 1] * in2[1 * 4 + 0] +
					in1[1 * 4 + 2] * in2[2 * 4 + 0];
		out[1 * 4 + 1] = in1[1 * 4 + 0] * in2[0 * 4 + 1] + in1[1 * 4 + 1] * in2[1 * 4 + 1] +
					in1[1 * 4 + 2] * in2[2 * 4 + 1];
		out[1 * 4 + 2] = in1[1 * 4 + 0] * in2[0 * 4 + 2] + in1[1 * 4 + 1] * in2[1 * 4 + 2] +
					in1[1 * 4 + 2] * in2[2 * 4 + 2];
		out[1 * 4 + 3] = in1[1 * 4 + 0] * in2[0 * 4 + 3] + in1[1 * 4 + 1] * in2[1 * 4 + 3] +
					in1[1 * 4 + 2] * in2[2 * 4 + 3] + in1[1 * 4 + 3];
		out[2 * 4 + 0] = in1[2 * 4 + 0] * in2[0 * 4 + 0] + in1[2 * 4 + 1] * in2[1 * 4 + 0] +
					in1[2 * 4 + 2] * in2[2 * 4 + 0];
		out[2 * 4 + 1] = in1[2 * 4 + 0] * in2[0 * 4 + 1] + in1[2 * 4 + 1] * in2[1 * 4 + 1] +
					in1[2 * 4 + 2] * in2[2 * 4 + 1];
		out[2 * 4 + 2] = in1[2 * 4 + 0] * in2[0 * 4 + 2] + in1[2 * 4 + 1] * in2[1 * 4 + 2] +
					in1[2 * 4 + 2] * in2[2 * 4 + 2];
		out[2 * 4 + 3] = in1[2 * 4 + 0] * in2[0 * 4 + 3] + in1[2 * 4 + 1] * in2[1 * 4 + 3] +
					in1[2 * 4 + 2] * in2[2 * 4 + 3] + in1[2 * 4 + 3];
	}

	public static void VectorRotate (float[] in1,  float[] in2, float[] out)
	{
		out[0] = in1[0] * in2[0 * 4 + 0] + in1[1] * in2[0 * 4 + 1] + in1[2] * in2[0 * 4 + 2];
		out[1] = in1[0] * in2[1 * 4 + 0] + in1[1] * in2[1 * 4 + 1] + in1[2] * in2[1 * 4 + 2];
		out[2] = in1[0] * in2[2 * 4 + 0] + in1[1] * in2[2 * 4 + 1] + in1[2] * in2[2 * 4 + 2];
	}

	// rotate by the inverse of the matrix
	public static void VectorIRotate (float[] in1, float[] in2, float[] out)
	{
		out[0] = in1[0]*in2[0 * 4 + 0] + in1[1]*in2[1 * 4 + 0] + in1[2]*in2[2 * 4 + 0];
		out[1] = in1[0]*in2[0 * 4 + 1] + in1[1]*in2[1 * 4 + 1] + in1[2]*in2[2 * 4 + 1];
		out[2] = in1[0]*in2[0 * 4 + 2] + in1[1]*in2[1 * 4 + 2] + in1[2]*in2[2 * 4 + 2];
	}

	public static void VectorTransform (float[] in1, float[] in2, float[] out)
	{
		out[0] = in1[0] * in2[0 * 4 + 0] + in1[1] * in2[0 * 4 + 1] + in1[2] * in2[0 * 4 + 2] + in2[0 * 4 + 3];
		out[1] = in1[0] * in2[1 * 4 + 0] + in1[1] * in2[1 * 4 + 1] + in1[2] * in2[1 * 4 + 2] + in2[1 * 4 + 3];
		out[2] = in1[0] * in2[2 * 4 + 0] + in1[1] * in2[2 * 4 + 1] + in1[2] * in2[2 * 4 + 2] + in2[2 * 4 + 3];
	}

	private static float[] tmp = new float[3];
	
	public static void VectorITransform (float[] in1, float[] in2, float[] out)
	{
		tmp[0] = in1[0] - in2[0 * 4 + 3];
		tmp[1] = in1[1] - in2[1 * 4 + 3];
		tmp[2] = in1[2] - in2[2 * 4 + 3];
		VectorIRotate(tmp, in2, out);
	}
	
	public static void QuaternionMatrix( float[] quaternion, float[] matrix )
	{
		matrix[0 * 4 + 0] = 1.0f - 2.0f * quaternion[1] * quaternion[1] - 2.0f * quaternion[2] * quaternion[2];
		matrix[1 * 4 + 0] = 2.0f * quaternion[0] * quaternion[1] + 2.0f * quaternion[3] * quaternion[2];
		matrix[2 * 4 + 0] = 2.0f * quaternion[0] * quaternion[2] - 2.0f * quaternion[3] * quaternion[1];

		matrix[0 * 4 + 1] = 2.0f * quaternion[0] * quaternion[1] - 2.0f * quaternion[3] * quaternion[2];
		matrix[1 * 4 + 1] = 1.0f - 2.0f * quaternion[0] * quaternion[0] - 2.0f * quaternion[2] * quaternion[2];
		matrix[2 * 4 + 1] = 2.0f * quaternion[1] * quaternion[2] + 2.0f * quaternion[3] * quaternion[0];

		matrix[0 * 4 + 2] = 2.0f * quaternion[0] * quaternion[2] + 2.0f * quaternion[3] * quaternion[1];
		matrix[1 * 4 + 2] = 2.0f * quaternion[1] * quaternion[2] - 2.0f * quaternion[3] * quaternion[0];
		matrix[2 * 4 + 2] = 1.0f - 2.0f * quaternion[0] * quaternion[0] - 2.0f * quaternion[1] * quaternion[1];
	}
	
	public static void QuaternionSlerp( float[] p, float[] q, float t, float[] qt )
	{
		int i;
		float omega, cosom, sinom, sclp, sclq;

		// decide if one of the quaternions is backwards
		float a = 0;
		float b = 0;
		for (i = 0; i < 4; i++) {
			a += (p[i]-q[i])*(p[i]-q[i]);
			b += (p[i]+q[i])*(p[i]+q[i]);
		}
		if (a > b) {
			for (i = 0; i < 4; i++) {
				q[i] = -q[i];
			}
		}

		cosom = p[0]*q[0] + p[1]*q[1] + p[2]*q[2] + p[3]*q[3];

		if ((1.0 + cosom) > 0.00000001) {
			if ((1.0 - cosom) > 0.00000001) {
				omega = (float) Math.acos( cosom );
				sinom = (float) Math.sin( omega );
				sclp = (float) Math.sin( (1.0 - t)*omega) / sinom;
				sclq = (float) Math.sin( t*omega ) / sinom;
			}
			else {
				sclp = 1.0f - t;
				sclq = t;
			}
			for (i = 0; i < 4; i++) {
				qt[i] = sclp * p[i] + sclq * q[i];
			}
		}
		else {
			qt[0] = -p[1];
			qt[1] = p[0];
			qt[2] = -p[3];
			qt[3] = p[2];
			sclp = (float) Math.sin( (1.0 - t) * 0.5 * 3.14159265358979323846);
			sclq = (float) Math.sin( t * 0.5 * 3.14159265358979323846);
			for (i = 0; i < 3; i++) {
				qt[i] = sclp * p[i] + sclq * qt[i];
			}
		}
	}
}
