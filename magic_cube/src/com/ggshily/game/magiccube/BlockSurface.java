package com.ggshily.game.magiccube;


public class BlockSurface
{
	public static final int VERTEX_NUMBER = 4;
	
	private int _colorIndex;
	private Vertex[] vertexs;
	public BlockSurface(Vertex[] vertexs)
	{
		assert(vertexs.length == VERTEX_NUMBER);
		
		this.vertexs = vertexs;
	}
	/**
	 * @return the _colorIndex
	 */
	public int get_colorIndex()
	{
		return _colorIndex;
	}
	/**
	 * @param index the _colorIndex to set
	 */
	public void set_colorIndex(int index)
	{
		_colorIndex = index;
	}
	/**
	 * @return the vertexs
	 */
	public Vertex[] getVertexs()
	{
		return vertexs;
	}
	/**
	 * @param vertexs the vertexs to set
	 */
	public void setVertexs(Vertex[] vertexs)
	{
		this.vertexs = vertexs;
	}
	
	public Vertex getBase()
	{
		return new Vertex(
			Math.min(vertexs[0].get_x(), Math.min(vertexs[1].get_x(), Math.min(vertexs[2].get_x(), vertexs[3].get_x()))),
			Math.min(vertexs[0].get_y(), Math.min(vertexs[1].get_y(), Math.min(vertexs[2].get_y(), vertexs[3].get_y()))),
			Math.min(vertexs[0].get_z(), Math.min(vertexs[1].get_z(), Math.min(vertexs[2].get_z(), vertexs[3].get_z())))
		);
	}
	
	public boolean hasSameX()
	{
		return vertexs[0].get_x() == vertexs[1].get_x() &&
			   vertexs[0].get_x() == vertexs[2].get_x() &&
			   vertexs[0].get_x() == vertexs[3].get_x();
	}
	
	public boolean hasSameY()
	{
		return vertexs[0].get_y() == vertexs[1].get_y() &&
			   vertexs[0].get_y() == vertexs[2].get_y() &&
			   vertexs[0].get_y() == vertexs[3].get_y();
	}
	
	public boolean hasSameZ()
	{
		return vertexs[0].get_z() == vertexs[1].get_z() &&
			   vertexs[0].get_z() == vertexs[2].get_z() &&
			   vertexs[0].get_z() == vertexs[3].get_z();
	}
	public void transform(M4 transform)
	{
		for(int i = 0; i < vertexs.length; ++i)
		{
			vertexs[i].transform(transform);
		}
	}
}
