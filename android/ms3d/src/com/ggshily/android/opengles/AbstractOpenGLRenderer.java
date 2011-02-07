package com.ggshily.android.opengles;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

import android.opengl.GLSurfaceView;

public abstract class AbstractOpenGLRenderer implements GLSurfaceView.Renderer
{

	protected float angleX;

	public abstract void onSurfaceChanged(GL10 gl, int w, int h);

	public abstract void onDrawFrame(GL10 gl);

	public abstract void onSurfaceCreated(GL10 gl, EGLConfig config);

	protected float angleY;
	protected float angleZ;
	protected float rotateSpeedX;
	protected float rotateSpeedY;
	protected float rotateSpeedZ;
	protected float rotateAccX;
	protected float rotateAccY;
	protected float rotateAccZ;
	protected float zoom;
	protected float eyeZ = -20f;
	protected float eyeX;
	protected float eyeY = 10f;
	protected float translationX;
	protected float translationY;
	protected float translationZ;

	public AbstractOpenGLRenderer()
	{
		super();
	}

	public void updateAngle()
	{

		rotateSpeedX += rotateAccX;
		if (Math.abs(rotateSpeedX) <= Math.abs(rotateAccX))
		{
			rotateSpeedX = 0;
			rotateAccX = 0;
		}
		rotateSpeedY += rotateAccY;
		if (Math.abs(rotateSpeedY) <= Math.abs(rotateAccY))
		{
			rotateSpeedY = 0;
			rotateAccY = 0;
		}
		rotateSpeedZ += rotateAccZ;
		if (Math.abs(rotateSpeedZ) <= Math.abs(rotateAccZ))
		{
			rotateSpeedZ = 0;
			rotateAccZ = 0;
		}

		angleX += rotateSpeedX;
		angleY += rotateSpeedY;
		angleZ += rotateSpeedZ;
	}

	public void setAngleX(float angleX)
	{
		this.angleX = angleX;
	}

	public void setAngleY(float angleY)
	{
		this.angleY = angleY;
	}

	public void setAngleZ(float angleZ)
	{
		this.angleZ = angleZ;
	}

	public float getAngleX()
	{
		return angleX;
	}

	public float getAngleY()
	{
		return angleY;
	}

	public float getAngleZ()
	{
		return angleZ;
	}

	public void setRotateSpeedX(float rotateSpeedX)
	{
		this.rotateSpeedX = rotateSpeedX;
	}

	public void setRotateSpeedY(float rotateSpeedY)
	{
		this.rotateSpeedY = rotateSpeedY;
	}

	public void setRotateSpeedZ(float rotateSpeedZ)
	{
		this.rotateSpeedZ = rotateSpeedZ;
	}

	public void setRotateAccX(float rotateAcc)
	{
		this.rotateAccX = rotateAcc;
	}

	public void setRotateAccY(float rotateAccY)
	{
		this.rotateAccY = rotateAccY;
	}

	public void setRotateAccZ(float rotateAccZ)
	{
		this.rotateAccZ = rotateAccZ;
	}

}