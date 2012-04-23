package com.ggshily.mortalcoil;

import java.util.ArrayList;
import java.util.Arrays;

public class GameMap
{
	public static final String WIDTH_PREFIX = "x=";
	public static final String HEIGHT_PREFIX = "y=";
	public static final String MAPDATA_PREFIX = "board=";
	
	public static final int CELL_EMPTY = 0;
	public static final int CELL_SOLID = 1;
	
	public static final int DIRECTION_UP = 2;
	public static final int DIRECTION_DOWN = 3;
	public static final int DIRECTION_LEFT = 4;
	public static final int DIRECTION_RIGHT = 5;
	
	public static final String[] DIRECTIONS = {"U", "D", "L", "R"};
	
	protected int[] _mapdata;
	protected int _width;
	protected int _height;
	
	private int[] _possiblePoints;
	private ArrayList<Integer> path = new ArrayList<Integer>();
	private ArrayList<Pair> pointsHas2Directions = new ArrayList<Pair>();
	
	public void setMap(String mapData)
	{
		getMapData(mapData);
		
		path = new ArrayList<Integer>();
		pointsHas2Directions = new ArrayList<Pair>();
	}

	private void getMapData(String mapData)
	{
		// x=3&y=3&board=X....X...
		String[] strs = mapData.split("&");
		if(strs.length != 3)
		{
			throw new Error("Wrong data !!!");
		}
		
		_width = Integer.parseInt(strs[0].substring(WIDTH_PREFIX.length()));
		_height = Integer.parseInt(strs[1].substring(HEIGHT_PREFIX.length()));
		
		String data = strs[2].substring(MAPDATA_PREFIX.length());
		_mapdata = new int[data.length()];
		for(int i = 0; i < data.length(); i++)
		{
			_mapdata[i] = data.charAt(i) == 'X' ? CELL_SOLID : CELL_EMPTY;
		}
	}

	public String getFormatMap()
	{
		StringBuilder sb = new StringBuilder();
		for(int i = 0; i < _height; i++)
		{
			for(int j = 0; j < _width; j++)
			{
				sb.append(_mapdata[i * _width + j]);
			}
			sb.append("\n");
		}
		return sb.toString();
	}

	public String getPath()
	{
		_possiblePoints = getPossiblePoints();
		
		int startPoint = 0;
		for(int i = 0; i < _possiblePoints.length; i++)
		{
			int curPointIndex = _possiblePoints[i];
			startPoint = curPointIndex;

			int[] directions = getDirections(curPointIndex);
			for(int j = 0; j < directions.length; j++)
			{
				curPointIndex = startPoint;
				_mapdata[curPointIndex] = CELL_SOLID;
				int direction = directions[j];
				while(true)
				{
					curPointIndex = gotoDirection(curPointIndex, direction);
					
					int[] temp = getDirections(curPointIndex);
					if(temp.length == 2)
					{
						if(isDeathPath(curPointIndex))
						{
							if(hasMoreChoice())
							{
								Pair pair = pointsHas2Directions.get(pointsHas2Directions.size() - 1);
								clearPath(pair.point, pair.pathIndex);
								pointsHas2Directions.remove(pointsHas2Directions.size() - 1);
								curPointIndex = pair.point;
								direction = getDirections(curPointIndex)[1];
							}
							else
							{
								_mapdata[startPoint] = CELL_EMPTY;
								pointsHas2Directions.clear();
								clearPath(startPoint, 0);
								break;
							}
						}
						else
						{
							direction = temp[0];
							pointsHas2Directions.add(new Pair(curPointIndex, path.size()));
						}
					}
					else if(isFound())
					{
						return parsePath(startPoint);
					}
					else
					{
						if(hasMoreChoice())
						{
							Pair pair = pointsHas2Directions.get(pointsHas2Directions.size() - 1);
							clearPath(pair.point, pair.pathIndex);
							pointsHas2Directions.remove(pointsHas2Directions.size() - 1);
							curPointIndex = pair.point;
							direction = getDirections(curPointIndex)[1];
						}
						else
						{
							_mapdata[startPoint] = CELL_EMPTY;
							pointsHas2Directions.clear();
							clearPath(startPoint, 0);
							break;
						}
					}
				}
			}
		}
		
		return null;
	}

	private void clearPath(int point, int pathIndex)
	{
		while(path.size() > pathIndex)
		{
			int direction = path.get(pathIndex);
			path.remove(pathIndex);
			
			int x = point % _width;
			int y = point / _width;
			
			switch(direction)
			{
			case DIRECTION_UP:
				while(y > 0 && _mapdata[(y - 1) * _width + x] == DIRECTION_UP)
				{
					_mapdata[--y * _width + x] = CELL_EMPTY;
				}
				break;
			case DIRECTION_DOWN:
				while(y < _height - 1 && _mapdata[(y + 1) * _width + x] == DIRECTION_DOWN)
				{
					_mapdata[++y * _width + x] = CELL_EMPTY;
				}
				break;
			case DIRECTION_LEFT:
				while(x > 0 && _mapdata[y * _width + x - 1] == DIRECTION_LEFT)
				{
					_mapdata[y * _width + --x] = CELL_EMPTY;
				}
				break;
			case DIRECTION_RIGHT:
				while(x < _width - 1 && _mapdata[y * _width + x + 1] == DIRECTION_RIGHT)
				{
					_mapdata[y * _width + ++x] = CELL_EMPTY;
				}
				break;
			}
			
			point = y * _width + x;
		}
	}

	private String parsePath(int startPoint)
	{
		StringBuilder sb = new StringBuilder("x=" + (startPoint % _width) + "&y=" + (int)(startPoint / _width) + "&path=");
		for(int i = 0; i < path.size(); i++)
		{
			sb.append(DIRECTIONS[path.get(i) - DIRECTION_UP]);
		}
		return sb.toString();
	}

	private int gotoDirection(int curPointIndex, int direction)
	{
		path.add(direction);
		
		int x = curPointIndex % _width;
		int y = curPointIndex / _width;
		
		switch(direction)
		{
		case DIRECTION_UP:
			while(y > 0 && _mapdata[(y - 1) * _width + x] == CELL_EMPTY)
			{
				_mapdata[--y * _width + x] = DIRECTION_UP;
			}
			break;
		case DIRECTION_DOWN:
			while(y < _height - 1 && _mapdata[(y + 1) * _width + x] == CELL_EMPTY)
			{
				_mapdata[++y * _width + x] = DIRECTION_DOWN;
			}
			break;
		case DIRECTION_LEFT:
			while(x > 0 && _mapdata[y * _width + x - 1] == CELL_EMPTY)
			{
				_mapdata[y * _width + --x] = DIRECTION_LEFT;
			}
			break;
		case DIRECTION_RIGHT:
			while(x < _width - 1 && _mapdata[y * _width + x + 1] == CELL_EMPTY)
			{
				_mapdata[y * _width + ++x] = DIRECTION_RIGHT;
			}
			break;
		}
		
		int nextPoint = y * _width + x;
		int[] directions = getDirections(nextPoint);
		if(directions.length == 1)
		{
			return gotoDirection(nextPoint, directions[0]);
		}
		return nextPoint;
	}

	private boolean hasMoreChoice()
	{
		return pointsHas2Directions.size() > 0;
	}

	private boolean isDeathPath(int curPointIndex)
	{
		int[] points = getSingleDirectionPoints();
		if(points.length > 2)
		{
			return true;
		}
		if(points.length == 2 && (points[0] == curPointIndex || points[1] == curPointIndex))
		{
			return true;
		}
		return hasDeathArea();
	}

	private boolean hasDeathArea()
	{
		int[] mapdata = _mapdata.clone();
		
		for(int i = 0; i < _mapdata.length; i++)
		{
			if(_mapdata[i] == CELL_EMPTY)
			{
				ArrayList<Integer> points = new ArrayList<Integer>();
				points.add(i);
				while(points.size() > 0)
				{
					int point = points.get(0);
					_mapdata[point] = CELL_SOLID;
					points.remove(0);
					
					int[] directions = getDirections(point);
					for(int j = 0; j < directions.length; j++)
					{
						int nextPoint = getNextPoint(point, directions[j]); 
						if(!points.contains(nextPoint))
						{
							points.add(nextPoint);
						}
					}
				}
				
				break;
			}
		}
		
		boolean isFinish = isFound();
		System.arraycopy(mapdata, 0, _mapdata, 0, mapdata.length);
		
		return !isFinish;
	}

	private int[] getSingleDirectionPoints()
	{
		int[] points = new int[_mapdata.length];
		
		int count = 0;
		for(int i = 0; i < _mapdata.length; i++)
		{
			if(_mapdata[i] == CELL_EMPTY && getDirections(i).length == 1)
			{
				points[count++] = i;
			}
		}
		
		int[] result = new int[count];
		if(count > 0)
		{
			System.arraycopy(points, 0, result, 0, count);
		}
		return result;
	}

	private boolean isFound()
	{
		for(int i = 0; i < _mapdata.length; i++)
		{
			if(_mapdata[i] == CELL_EMPTY)
			{
				return false;
			}
		}
		return true;
	}

	private int[] getDirections(int pointIndex)
	{
		int[] directions = new int[4];
		
		int count = 0;
		int x = pointIndex % _width;
		int y = pointIndex / _width;
		if(y > 0 && _mapdata[pointIndex - _width] == CELL_EMPTY)
		{
			directions[count++] = DIRECTION_UP;
		}
		if(y < _height - 1 && _mapdata[pointIndex + _width] == CELL_EMPTY)
		{
			directions[count++] = DIRECTION_DOWN;
		}
		if(x > 0 && _mapdata[pointIndex - 1] == CELL_EMPTY)
		{
			directions[count++] = DIRECTION_LEFT;
		}
		if(x < _width - 1 && _mapdata[pointIndex + 1] == CELL_EMPTY)
		{
			directions[count++] = DIRECTION_RIGHT;
		}
		
		int[] result = new int[count];
		if (count > 0)
		{
			System.arraycopy(directions, 0, result, 0, count);
		}
		return result;
	}

	private int[] getPossiblePoints()
	{
		int[] points = new int[_mapdata.length];
		
		int count = 0;
		int[] directions;
		
		// add 3 directions point first
		for(int i = 0; i < _mapdata.length; i++)
		{
			if(_mapdata[i] == CELL_EMPTY && getDirections(i).length == 3)
			{
				points[count++] = i;
			}
		}
		
		// add 2 directions point and remove points in same path
		for(int i = 0; i < _mapdata.length; i++)
		{
			if (_mapdata[i] == CELL_EMPTY)
			{
				directions = getDirections(i);
				if (directions.length == 2)
				{
					if (getDirections(getNextPoint(i, directions[0])).length == 2
							&& getDirections(getNextPoint(i, directions[1])).length == 2)
					{
						continue;
					}
				}
				points[count++] = i;
			}
		}
		
		int[] result = new int[count];
		if (count > 0)
		{
			System.arraycopy(points, 0, result, 0, count);
		}
		return result;
	}

	/**
	 * Be sure there is a point in that direction
	 * 
	 * @param pointIndex
	 * @param direction
	 * @return
	 */
	private int getNextPoint(int pointIndex, int direction)
	{
		int nextPoint = 0;
		switch(direction)
		{
		case DIRECTION_UP:
			nextPoint = pointIndex - _width; 
			break;
		case DIRECTION_DOWN:
			nextPoint = pointIndex + _width;
			break;
		case DIRECTION_LEFT:
			nextPoint = pointIndex - 1;
			break;
		case DIRECTION_RIGHT:
			nextPoint = pointIndex + 1;
			break;
		}
		return nextPoint;
	}

	// for testing
	public static void main(String[] args)
	{
		GameMap gm = new GameMap();
		
		// 100
		// 001
		// 000
//		gm.setMap("x=23&y=23&board=...X.....XXXX...XX......X...X...XXX..X....XXX...X.....XXXX.X...X...X.X.X.X.X..XX..X.X...X.X.X.X.X..X....XX.XX......X......XXXXX......X......XX......X.....X...X....X....XX...X.........X....XX.X...X.......XX.....XXX...X.X.XXXXX........XXXX......X.....XXX.....X...X......X.....X.XXX.......XXX..X.....X.....XX.....X...X..............X.X...X.....X.XX..XX.X...XXXXXX......XX..XX....X..X..........X....X......X.XXX....X.X.......XXX......XXX...X...X........X...X.........X.XX.........X..XXX....X............XX.X...................XX...XX");
		gm.setMap("x=10&y=10&board=..............XXXX...............X.............X......X.......X...X.X...X..............X.X.....X...X");
//		gm.setMap("x=3&y=3&board=X....X...");
		
		System.out.println("width:" + gm._width);
		System.out.println("height:" + gm._height);
		System.out.printf("map data:\n%s", gm.getFormatMap());

//		System.out.println("point 1's directions:" + gm.getDirections(1).length);
//		System.out.println("point 2's directions:" + gm.getDirections(2).length);
//		System.out.println("point 3's directions:" + gm.getDirections(3).length);
//		System.out.println("point 4's directions:" + gm.getDirections(4).length);
//		System.out.println("point 6's directions:" + gm.getDirections(6).length);
//		System.out.println("point 7's directions:" + gm.getDirections(7).length);
//		System.out.println("point 8's directions:" + gm.getDirections(8).length);
		
		System.out.println("possible points:" + Arrays.toString(gm.getPossiblePoints()));
		
		System.out.println("solution url:" + gm.getPath());
	}
}

class Pair
{
	public int point;
	public int pathIndex;
	
	public Pair()
	{
		
	}

	public Pair(int point, int pathIndex)
	{
		this.point = point;
		this.pathIndex = pathIndex;
	}
}