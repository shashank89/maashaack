package com.ggshily.game.geom
{
	public class Rhombus extends Parallelogram
	{
		public function Rhombus(width:Number=0, height:Number=0)
		{
			super(width, height, width>>1, height>>1);
		}
		
		public override function containsPoint(px:Number, py:Number):PointIntersectPolygon
		{
			// must remove offset before containsPointRect()
			px -= x;
			py -= y;
			
			// quick test
			if(!containsPointRect(px, py))
				return PointIntersectPolygon.INST_OUT;

			// compare angle, in an 1/4 area
			var dx:Number = px < xoffset ? px : width - px;
			var dy:Number = py < yoffset ? yoffset - py : py - yoffset;
			var p:Number = dy * xoffset - yoffset * dx;
			
			if(p < 0)
				return PointIntersectPolygon.INST_IN;
			else if(p > 0)
				return PointIntersectPolygon.INST_OUT;
			else //if(p == 0)
			{
				// on border
				if(py <= yoffset)
				{
					if(px > xoffset)
						return px == width ? PointIntersectPolygon.INST_POINT(1) : PointIntersectPolygon.INST_BODER(0);
					else if(px < xoffset)
						return px == 0 ? PointIntersectPolygon.INST_POINT(3) : PointIntersectPolygon.INST_BODER(3);
					else // if(px == xoffset)
						return PointIntersectPolygon.INST_POINT(0);
					
				}
				else // py > yoffset
				{
					if(px > xoffset)
						return PointIntersectPolygon.INST_BODER(1);
					else if(px < xoffset)
						return PointIntersectPolygon.INST_BODER(2);
					else // if(px == xoffset)
						return PointIntersectPolygon.INST_POINT(2);
				}
			}
		}
	}
}