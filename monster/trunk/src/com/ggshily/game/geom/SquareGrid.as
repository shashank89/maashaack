package com.ggshily.game.geom
{
	
	public class SquareGrid extends Grid
	{
		public function SquareGrid(seed:Square=null, column:int=1, row:int=1)
		{
			super(seed, column, row);
		}

		public override function containsPointInGrid(px:Number, py:Number, result:Grid):PointIntersectPolygon
		{
			if(!this.containsPointRect(px, py))
				return PointIntersectPolygon.INST_OUT;
				
			if(total == 1)
			{
				result.x = 0;
				result.y = 0;
				result.cellX = 0;
				result.cellY = 0;
				return result.containsPoint(px, py);
			}
				
			// remove offset
			px -= x;
			py -= y;
			
			var sy:int = py / cell.height;
			var sx:int = px / cell.width;
			var dx:Number = px - sx * cell.width; 
			var dy:Number = py - sy * cell.height;
			
			result.x = px - dx;
			result.y = py - dy;
			result.cellX = sx;		
			result.cellY = sy;			
			
			return result.containsPoint(px, py);
		}
		
		public override function getGridArea(cx:int, cy:int, clen:int, rlen:int, result:Grid=null, needCopyCell:Boolean=false):Grid
		{
			if(result == null)
			{
				result = new SquareGrid(this.cell as Square, clen, rlen);
			}
			else
			{
				if(needCopyCell)
					result.setCell(this.cell);
				result.setGrid(clen, rlen);
			}
			result.setPosCell(cx, cy, this);
			return result;
		}
		
		public override function setPosCell(cx:int, cy:int, parent:Grid):void
		{
			cellX = cx;
			cellY = cy;
			x = cx * cell.width;
			y = cy * cell.width;
		}
	}
}