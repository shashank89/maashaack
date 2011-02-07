package com.ggshily.android.ms3d;

import javax.microedition.khronos.opengles.GL;

import android.app.Activity;
import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.view.Display;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.GestureDetector.OnGestureListener;
import android.view.View.OnClickListener;
import android.view.View.OnLongClickListener;
import android.view.View.OnTouchListener;

import com.ggshily.android.opengles.text.MatrixTrackingGL;

public class Graphics3D extends Activity implements OnClickListener,
		OnLongClickListener, OnTouchListener, OnGestureListener
{
	private MS3DRenderer mRenderer;

	private GestureDetector gestureDetector;

	private float angleX;

	private float angleY;

	private static final float FLING_MIN_DISTANCE = 5;

	private static final float FLING_MIN_VELOCITY = 5;
	
	private static int SCREEN_WIDTH;
	private static int SCREEN_HEIGHT;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		// We don't need a title either.
		requestWindowFeature(Window.FEATURE_NO_TITLE);

		GLSurfaceView mView = new GLSurfaceView(getApplication());

		mView.setGLWrapper(new GLSurfaceView.GLWrapper() {
            public GL wrap(GL gl) {
                return new MatrixTrackingGL(gl);
            }});
		// mRenderer = new Renderer();
		mRenderer = new MS3DRenderer(getApplication(), R.raw.wood, R.raw.model);
//		mRenderer = new MS3DRenderer(getApplication(), R.raw.skin, R.raw.skinr);
		mView.setRenderer(mRenderer);
		
		System.out.println("start game");

		mView.setClickable(true);
		mView.setLongClickable(true);
		mView.setOnClickListener(this);
		mView.setOnLongClickListener(this);
		mView.setOnTouchListener(this);

		gestureDetector = new GestureDetector(this);

		setContentView(mView);
		
		Display display = getWindowManager().getDefaultDisplay();
		SCREEN_WIDTH = display.getWidth();
		SCREEN_HEIGHT = display.getHeight();
	}

	@Override
	public void onClick(View arg0)
	{
	}

	@Override
	public boolean onLongClick(View arg0)
	{
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean onTouch(View arg0, MotionEvent e)
	{
		// TODO Auto-generated method stub
		return gestureDetector.onTouchEvent(e);
	}

	@Override
	public boolean onDown(MotionEvent arg0)
	{
		System.out.println("onDown");
		mRenderer.setRotateSpeedX(0);
		mRenderer.setRotateSpeedY(0);
		
		angleX = mRenderer.getAngleX();
		angleY = mRenderer.getAngleY();
		
		return false;
	}

	@Override
	public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX,
			float velocityY)
	{
		if (e1.getX() - e2.getX() > FLING_MIN_DISTANCE
				&& Math.abs(velocityX) > FLING_MIN_VELOCITY)
		{
			// Fling left
			mRenderer.setRotateSpeedY(velocityX / 50);
			mRenderer.setRotateAccY(1);
		} 
		else if (e2.getX() - e1.getX() > FLING_MIN_DISTANCE
				&& Math.abs(velocityX) > FLING_MIN_VELOCITY)
		{
			// Fling right
			mRenderer.setRotateSpeedY(velocityX / 50);
			mRenderer.setRotateAccY(-1);
		}
		if(e1.getY() - e2.getY() > FLING_MIN_DISTANCE
				&& Math.abs(velocityY) > FLING_MIN_VELOCITY)
		{
			mRenderer.setRotateSpeedX(-velocityY / 50);
			mRenderer.setRotateAccX(-1);
		}
		else if(e2.getY() - e1.getY() > FLING_MIN_DISTANCE
				&& Math.abs(velocityY) > FLING_MIN_VELOCITY)
		{
			mRenderer.setRotateSpeedX(-velocityY / 50);
			mRenderer.setRotateAccX(1);
		}
		return false;
	}

	@Override
	public void onLongPress(MotionEvent arg0)
	{
		// TODO Auto-generated method stub

	}

	@Override
	public boolean onScroll(MotionEvent e1, MotionEvent e2, float arg2,
			float arg3)
	{
		float distanceX = e1.getX() - e2.getX();
		float distanceY = e1.getY() - e2.getY();
		
		System.out.println("distanceX " + distanceX);
		System.out.println("distanceY " + distanceY);
		
//		if(Math.abs(distanceX) > Math.abs(distanceY))
		{
			mRenderer.setAngleY((float) (angleY - (float)distanceX * 180 / SCREEN_WIDTH));
			System.out.println("angleY " + mRenderer.getAngleY());
		}
//		else
		{
			mRenderer.setAngleX((float) (angleX + (float)distanceY * 180 / SCREEN_HEIGHT));
		}
		return false;
	}

	@Override
	public void onShowPress(MotionEvent arg0)
	{
		// TODO Auto-generated method stub

	}

	@Override
	public boolean onSingleTapUp(MotionEvent arg0)
	{
		mRenderer.setIdle(!mRenderer.isIdle());
		return false;
	}
}