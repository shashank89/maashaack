package com.ggshily.game.geom
{
	public class Rectangle extends Parallelogram
	{
		public function Rectangle(width:Number=0, height:Number=0)
		{
			super(width, height, 0, height);
		}
		
		public override function containsPoint(px:Number, py:Number):PointIntersectPolygon
		{
			// remove offset				
			px -= this.x;
			py -= this.y;

			if(px < 0 || px > width || py < 0 || py > height)
			{
				return PointIntersectPolygon.INST_OUT;
			}
			else if(py == 0)
			{
				if(px == 0)
					return PointIntersectPolygon.INST_POINT(0);
				else if(px == width)
					return PointIntersectPolygon.INST_POINT(1);
				else
					return PointIntersectPolygon.INST_BODER(0);
			}
			else if(py == height)
			{
				if(px == 0)
					return PointIntersectPolygon.INST_POINT(3);
				else if(px == width)
					return PointIntersectPolygon.INST_POINT(2);
				else
					return PointIntersectPolygon.INST_BODER(2);
			}
			else if(px == 0)
				return PointIntersectPolygon.INST_BODER(3);
			else if(px == width)
				return PointIntersectPolygon.INST_BODER(1);
			else 
				return PointIntersectPolygon.INST_IN;
		}
		
	}
}