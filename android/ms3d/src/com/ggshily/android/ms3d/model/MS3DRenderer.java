package com.ggshily.android.ms3d.model;

import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.ShortBuffer;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.opengl.GLU;
import android.opengl.GLUtils;
import android.os.SystemClock;

public class MS3DRenderer extends AbstractOpenGLRenderer
{

	private Context mContext;
	private int mTextureID;
	private MS3DModel model;
	private int triangleNum;

	private FloatBuffer mFVertexBuffer;
	private FloatBuffer mTexBuffer;
	private ShortBuffer mIndexBuffer;

	private float[] dim = { 0.0f, 0.0f, 0.0f };
	private float[] center = { 0.0f, 0.0f, 0.0f };
	private float radius;
	private float ratio;
	private int width;
	private int height;
	private float currentFrame;
	private int bitmapRes;
	private int modelRes;

	public MS3DRenderer(Context context, int bitmapRes, int modelRes)
	{
		mContext = context;
		
		this.bitmapRes = bitmapRes;
		this.modelRes = modelRes;
	}

	@Override
	public void onSurfaceCreated(GL10 gl, EGLConfig config)
	{
		/*
		 * By default, OpenGL enables features that improve quality but reduce
		 * performance. One might want to tweak that especially on software
		 * renderer.
		 */
		gl.glDisable(GL10.GL_DITHER);

		/*
		 * Some one-time OpenGL initialization can be made here probably based
		 * on features of this particular context
		 */
		gl.glHint(GL10.GL_PERSPECTIVE_CORRECTION_HINT, GL10.GL_FASTEST);

		gl.glClearColor(.5f, .5f, .5f, 1);
		gl.glShadeModel(GL10.GL_SMOOTH);
		gl.glEnable(GL10.GL_DEPTH_TEST);
		gl.glEnable(GL10.GL_TEXTURE_2D);

		/*
		 * Create our texture. This has to be done each time the surface is
		 * created.
		 */

		int[] textures = new int[1];
		gl.glGenTextures(1, textures, 0);

		mTextureID = textures[0];
		gl.glBindTexture(GL10.GL_TEXTURE_2D, mTextureID);

		gl.glTexParameterf(GL10.GL_TEXTURE_2D, GL10.GL_TEXTURE_MIN_FILTER,
				GL10.GL_NEAREST);
		gl.glTexParameterf(GL10.GL_TEXTURE_2D, GL10.GL_TEXTURE_MAG_FILTER,
				GL10.GL_LINEAR);

		gl.glTexParameterf(GL10.GL_TEXTURE_2D, GL10.GL_TEXTURE_WRAP_S,
				GL10.GL_CLAMP_TO_EDGE);
		gl.glTexParameterf(GL10.GL_TEXTURE_2D, GL10.GL_TEXTURE_WRAP_T,
				GL10.GL_CLAMP_TO_EDGE);

		gl.glTexEnvf(GL10.GL_TEXTURE_ENV, GL10.GL_TEXTURE_ENV_MODE,
				GL10.GL_REPLACE);

		loadRes();

		initModel();
	}

	@Override
	public void onDrawFrame(GL10 gl)
	{
		/*
		 * By default, OpenGL enables features that improve quality but reduce
		 * performance. One might want to tweak that especially on software
		 * renderer.
		 */
		gl.glDisable(GL10.GL_DITHER);

		gl.glTexEnvx(GL10.GL_TEXTURE_ENV, GL10.GL_TEXTURE_ENV_MODE,
				GL10.GL_MODULATE);

		/*
		 * Usually, the first thing one might want to do is to clear the screen.
		 * The most efficient way of doing this is to use glClear().
		 */

		gl.glClear(GL10.GL_COLOR_BUFFER_BIT | GL10.GL_DEPTH_BUFFER_BIT);

		/*
		 * Now we're ready to draw some 3D objects
		 */

		gl.glMatrixMode(GL10.GL_MODELVIEW);
		gl.glLoadIdentity();

//		 GLU.gluLookAt(gl, eyeX, eyeY, eyeZ, 0f, 0f, 0f, 0f, 1.0f, 0.0f);
//		 GLU.gluLookAt(gl, 75, 75, 0, 0f, 0f, 0f, 0f, 1.0f, 0.0f);

		gl.glEnableClientState(GL10.GL_VERTEX_ARRAY);
		gl.glEnableClientState(GL10.GL_TEXTURE_COORD_ARRAY);

		gl.glActiveTexture(GL10.GL_TEXTURE0);
		gl.glEnable(GL10.GL_TEXTURE_WRAP_S);
		gl.glEnable(GL10.GL_TEXTURE_WRAP_T);
		gl.glBindTexture(GL10.GL_TEXTURE_2D, mTextureID);
		gl.glTexParameterx(GL10.GL_TEXTURE_2D, GL10.GL_TEXTURE_WRAP_S,
				GL10.GL_REPEAT);
		gl.glTexParameterx(GL10.GL_TEXTURE_2D, GL10.GL_TEXTURE_WRAP_T,
				GL10.GL_REPEAT);

		gl.glTranslatef(-translationX, -translationY, -translationZ);
		updateAngle();
		gl.glRotatef(angleX, 1.0f, .0f, .0f);
		gl.glRotatef(angleY, .0f, 1.0f, .0f);
		gl.glRotatef(angleZ, .0f, .0f, 1.0f);
		gl.glTranslatef(-center[0], -center[1], -center[2]);

		zoom += 0.01f;
		if(zoom > 2)
		{
			zoom = 1.0f;
		}
//		gl.glScalef(1.0f, 1.0f, 1.0f);

		draw(gl);
		
	}

	public void draw(GL10 gl)
	{
		// based on frame
		currentFrame += 1f;
		
		if(currentFrame > model.totalFrames)
			currentFrame = 0.0f;
		
		updateFrame(currentFrame);
		
		gl.glFrontFace(GL10.GL_CCW);
		gl.glVertexPointer(3, GL10.GL_FLOAT, 0, mFVertexBuffer);
		gl.glEnable(GL10.GL_TEXTURE_2D);
		gl.glTexCoordPointer(2, GL10.GL_FLOAT, 0, mTexBuffer);
		gl.glDrawElements(GL10.GL_TRIANGLES, triangleNum * 3,
				GL10.GL_UNSIGNED_SHORT, mIndexBuffer);
	}

	@Override
	public void onSurfaceChanged(GL10 gl, int w, int h)
	{
		width = w;
		height = h;
		if(height == 0)
			height = 1;
		
		gl.glViewport(0, 0, width, height);

		/*
		 * Set our projection matrix. This doesn't have to be done each time we
		 * draw, but usually a new projection needs to be set when the viewport
		 * is resized.
		 */

		ratio = (float) width / height;
		gl.glMatrixMode(GL10.GL_PROJECTION);
		gl.glLoadIdentity();

		float near = translationZ - radius;
		if(near < 0.1f)
			near = 0.1f;
		float far = translationZ + radius;
		if(far < near)
			far = 4096.f;
//		GLU.gluPerspective(gl, 45f, ratio, near, far);
		GLU.gluPerspective(gl, 45f, ratio, 5f, 3000f); // for the case some texture is wrong sometimes

		gl.glMatrixMode(GL10.GL_MODELVIEW);
		gl.glLoadIdentity();
		// gl.glFrustumf(-ratio, ratio, -1, 1, 3, 7);

	}

	private void loadRes()
	{
		InputStream is = mContext.getResources().openRawResource(bitmapRes);
		Bitmap bitmap;
		try
		{
			System.out.println("start decode bitmap:" + bitmapRes);
			bitmap = BitmapFactory.decodeStream(is);
			System.out.println("finished decode bitmap");
		}
		finally
		{
			try
			{
				is.close();
			}
			catch (IOException e)
			{
				// Ignore.
			}
		}

		GLUtils.texImage2D(GL10.GL_TEXTURE_2D, 0, bitmap, 0);
		bitmap.recycle();

		model = new MS3DModel();
		is = mContext.getResources().openRawResource(modelRes);

		try
		{
			System.out.println("start decode model:" + modelRes);
			model.decodeMS3DModel(is);

			System.out.println("finished decode model");
		}
		catch (IOException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally
		{
			try
			{
				is.close();
			}
			catch (IOException e)
			{

			}
		}

		dim[0] = model.maxs[0] - model.mins[0];
		dim[1] = model.maxs[1] - model.mins[1];
		dim[2] = model.maxs[2] - model.mins[2];
		center[0] = model.mins[0] + dim[0] / 2.0f;
		center[1] = model.mins[1] + dim[1] / 2.0f;
		center[2] = model.mins[2] + dim[2] / 2.0f;
		radius = dim[0];
		if(dim[1] > radius)
			radius = dim[1];
		if(dim[2] > radius)
			radius = dim[2];
		radius *= 1.41f;
		translationZ = radius;
	}

	/**
	 * 
	 */
	public void initModel()
	{

		// int length = model.vertices.length;
		triangleNum = 0;
		for (int i = 0; i < model.groups.length; i++)
		{
			triangleNum += model.groups[i].numTriangles;
		}

		// ByteBuffer vbb = ByteBuffer.allocateDirect(length * 3 * 4);
		ByteBuffer vbb = ByteBuffer.allocateDirect(triangleNum * 3 * 3 * 4);
		vbb.order(ByteOrder.nativeOrder());
		mFVertexBuffer = vbb.asFloatBuffer();

		ByteBuffer tbb = ByteBuffer.allocateDirect(triangleNum * 3 * 2 * 4);
		tbb.order(ByteOrder.nativeOrder());
		mTexBuffer = tbb.asFloatBuffer();

		ByteBuffer ibb = ByteBuffer.allocateDirect(triangleNum * 3 * 2);
		ibb.order(ByteOrder.nativeOrder());
		mIndexBuffer = ibb.asShortBuffer();

		/*
		 * float[] vertex = new float[3]; for (int i = 0; i < length; i++) {
		 * model.transformVertex(model.vertices[i], vertex); for (int j = 0; j <
		 * 3; j++) { mFVertexBuffer.put(vertex[j]); } }
		 */

		updateFrame(-1.0f);
	}

	private void updateFrame(float frame)
	{
		long start = SystemClock.uptimeMillis();
		model.setFrame(frame);
		
		mFVertexBuffer.position(0);
		mTexBuffer.position(0);
		mIndexBuffer.position(0);
		
		mFVertexBuffer.clear();
		mTexBuffer.clear();
		mIndexBuffer.clear();
		
		MS3DGroup group;
		MS3DTriangle t;
		int vertexIndex = 0;
		for (int i = 0; i < model.groups.length; i++)
		{
			group = model.groups[i];
			for (int l = 0; l < group.numTriangles; l++)
			{
				t = model.triangles[group.triangleIndices[l]];
				for (int j = 0; j < 3; j++)
				{
					mTexBuffer.put(t.s[j]);
					mTexBuffer.put(t.t[j]);
					// mIndexBuffer.put((short) t.vertexIndices[j]);

					mIndexBuffer.put((short) (vertexIndex++));
					int indice = t.vertexIndices[j];
					float[] vertex = new float[3];
					model.transformVertex(model.vertices[indice], vertex);
					for (int k = 0; k < 3; k++)
					{
						mFVertexBuffer.put(vertex[k]);
					}
				}
			}
		}

		mFVertexBuffer.position(0);
		mTexBuffer.position(0);
		mIndexBuffer.position(0);
		System.out.println("update frame time:" + (SystemClock.uptimeMillis() - start));
	}
}
