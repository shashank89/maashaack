package com.ggshily.android.ms3d;

import javax.microedition.khronos.opengles.GL;

import android.app.Activity;
import android.content.Intent;
import android.opengl.GLSurfaceView;
import android.os.Bundle;
import android.view.Display;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.GestureDetector.OnDoubleTapListener;
import android.view.GestureDetector.OnGestureListener;
import android.view.View.OnTouchListener;

import com.ggshily.android.opengles.text.MatrixTrackingGL;

public class Graphics3D extends Activity implements OnTouchListener, OnGestureListener, OnDoubleTapListener
{

	public static final float FLING_MIN_DISTANCE = 5;
	public static final float FLING_MIN_VELOCITY = 5;
	
	public static final int DEFAULT_MODEL = R.raw.model;
	public static final int DEFAULT_TEX   = R.raw.wood;
//	public static final int DEFAULT_MODEL = R.raw.skinr;
//	public static final int DEFAULT_TEX   = R.raw.skin;
	
	private MS3DRenderer mRenderer;

	private GestureDetector gestureDetector;

	private float angleX;

	private float angleY;
	private float lastDoubleTapDistance = -1f;
	private float lastTranslationZ;
	
	private static int SCREEN_WIDTH;
	private static int SCREEN_HEIGHT;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
        Intent intent = getIntent();
        int modelRes = intent.getIntExtra("model", -1);
        int texRes = intent.getIntExtra("tex", -1);
        int modelNum = intent.getIntExtra("modelNum", 1);
        if(modelRes == -1)
        	modelRes = DEFAULT_MODEL;
        if(texRes == -1)
        	texRes = DEFAULT_TEX;
		
		// We don't need a title either.
		requestWindowFeature(Window.FEATURE_NO_TITLE);

		GLSurfaceView mView = new GLSurfaceView(getApplication());

		mView.setGLWrapper(new GLSurfaceView.GLWrapper() {
            public GL wrap(GL gl) {
                return new MatrixTrackingGL(gl);
            }});
		// mRenderer = new Renderer();
		mRenderer = new MS3DRenderer(getApplication(), texRes, modelRes, modelNum);
		mView.setRenderer(mRenderer);
		
		System.out.println("start game");

		mView.setClickable(true);
		mView.setLongClickable(true);
		mView.setOnTouchListener(this);

		gestureDetector = new GestureDetector(this);
		gestureDetector.setOnDoubleTapListener(this);

		setContentView(mView);
		
		Display display = getWindowManager().getDefaultDisplay();
		SCREEN_WIDTH = display.getWidth();
		SCREEN_HEIGHT = display.getHeight();
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

		lastDoubleTapDistance = -1;
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
		return true;
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
		
		if(e1.getPointerCount() == 1 && e2.getPointerCount() == 1)
		{
			mRenderer.setAngleY((float) (angleY - (float)distanceX * 180 / SCREEN_WIDTH));
			mRenderer.setAngleX((float) (angleX + (float)distanceY * 180 / SCREEN_HEIGHT));
		}
		else
		{
			MotionEvent e = e1.getPointerCount() > 1 ? e1 : null;
			e = e2.getPointerCount() > 1 ? e2 : null;
			if(e != null && e.getAction() == MotionEvent.ACTION_MOVE)
			{
				float disX = e.getHistoricalX(0, 0) - e.getHistoricalX(1, 0);
				float disY = e.getHistoricalY(0, 0) - e.getHistoricalY(1, 0);
				if(lastDoubleTapDistance < 0)
				{
					lastDoubleTapDistance = (float) Math.sqrt(disX * disX + disY * disY);
					lastTranslationZ = mRenderer.getTranslationZ();
				}
				else
				{
					disX = e.getX(0) - e.getX(1);
					disY = e.getY(0) - e.getY(1);
					mRenderer.setTranslationZ(lastTranslationZ - ((float) Math.sqrt(disX * disX + disY * disY) - lastDoubleTapDistance) / 5);
				}
			}
		}
		return true;
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
		lastDoubleTapDistance = -1;
		return false;
	}

	@Override
	public boolean onDoubleTap(MotionEvent e)
	{
		System.out.println("double tap :" + e.getPointerCount() + e.getAction());
		return true;
	}

	@Override
	public boolean onDoubleTapEvent(MotionEvent e)
	{
		return false;
	}

	@Override
	public boolean onSingleTapConfirmed(MotionEvent arg0)
	{
		lastDoubleTapDistance = -1;
		return false;
	}
}