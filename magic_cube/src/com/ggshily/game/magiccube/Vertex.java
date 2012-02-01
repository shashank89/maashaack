package com.ggshily.game.magiccube;

public class Vertex
{
	private float _x;
	private float _y;
	private float _z;
	public Vertex(float _x, float _y, float _z)
	{
		this._x = _x;
		this._y = _y;
		this._z = _z;
	}
	/**
	 * @return the _x
	 */
	public float get_x()
	{
		return _x;
	}
	/**
	 * @param _x the _x to set
	 */
	public void set_x(float _x)
	{
		this._x = _x;
	}
	/**
	 * @return the _y
	 */
	public float get_y()
	{
		return _y;
	}
	/**
	 * @param _y the _y to set
	 */
	public void set_y(float _y)
	{
		this._y = _y;
	}
	/**
	 * @return the _z
	 */
	public float get_z()
	{
		return _z;
	}
	/**
	 * @param _z the _z to set
	 */
	public void set_z(float _z)
	{
		this._z = _z;
	}
	@Override
	public boolean equals(Object obj)
	{
		return (obj instanceof Vertex) && _x == ((Vertex)obj)._x && _y == ((Vertex)obj)._y && _z == ((Vertex)obj)._z;
	}
	public void transform(M4 transform)
	{
		Vertex temp = new Vertex(0, 0, 0);
		transform.multiply(this, temp);
		_x = temp._x;
		_y = temp._y;
		_z = temp._z;
	}
	
	public void minus(Vertex other)
	{
		_x -= other._x;
		_y -= other._y;
		_z -= other._z;
	}
}
