package com.ggshily.game.geom
{
	public class RhombusGrid extends Grid
	{
		public function RhombusGrid(seed:Rhombus=null, column:int=1, row:int=1)
		{
			super(seed, column, row);
		}

		public override function containsPointInGrid(px:Number, py:Number, result:Grid):PointIntersectPolygon
		{
			var pip:PointIntersectPolygon = containsPoint(px, py);
			if(pip.isOut())
			{
				setOutOfGridCell(px, py, result);
				return PointIntersectPolygon.INST_OUT;
			}
				
			// only 1 cell
			if(total == 1)
			{
				result.x = 0;
				result.y = 0;
				result.cellX = 0;
				result.cellY = 0;
				return pip;
			}
				
			// remove offset
			px -= x;
			py -= y;

			// find a rectangle which is exactly 1/4 of a rhombus cell 
			px -= xoffset;
			var sy:int = py / cell.yoffset;
			var sx:int = px / cell.xoffset;
			
			// align to left cell
			if(px < 0)		
				sx -= 1;
				
			var dx:Number = px - sx * cell.xoffset; 
			var dy:Number = py - sy * cell.yoffset;
			
			// no matter the sum is positive or negative
			if(((sx + sy) & 1) == 0)
			{
				// Now in a 1/4 rhombus cell, with a cell border divide the 1/4 cell from LT to RB .
				// try the 2 possible cell result
				result.x = px - dx - cell.xoffset;
				result.y = py - dy;
				result.cellX = sx - 1;		// optimize from result.x / cell.xoffset
				result.cellY = sy;			// optimize from result.y / cell.yoffset
				pip = result.containsPoint(px, py);
				if(pip.isOut())
				{
					// move to up right
					result.x += cell.xoffset;
					result.y -= cell.yoffset;
					result.cellX += 1;
					result.cellY -= 1;
					pip = result.containsPoint(px, py);
				}
			}
			else
			{
				// center point, align to cell
				result.x = px - dx - cell.xoffset;
				result.y = py - dy - cell.yoffset;
				result.cellX = sx - 1;		// optimize from result.x / cell.xoffset
				result.cellY = sy - 1;		// optimize from result.y / cell.yoffset
				pip = result.containsPoint(px, py);
				if(pip.isOut())
				{
					// move to down right
					result.x += cell.xoffset;
					result.y += cell.yoffset;
					result.cellX += 1;
					result.cellY += 1;
					pip = result.containsPoint(px, py);
				}
			}
			
			// Get cell position, use these formular
			// result.x = (cellX - cellY - 1) * cell.xoffset;
			// result.y = (cellX + cellY) * cell.yoffset;
			dx = result.cellX + 1;
			dy = result.cellY;
			result.cellX = (dy + dx) >> 1;
			result.cellY = (dy - dx) >> 1;
			result.x += xoffset;
			
			return pip;//result.containsPoint(px + x + xoffset, py + y);
		}
		
		public function setOutOfGridCell(px : Number, py : Number, result : Grid) : void
		{
			px -= x;
			py -= y;
			
			px -= xoffset;
			var sy:int = py / cell.yoffset;
			var sx:int = px / cell.xoffset;
			
			var dx:Number = px - sx * cell.xoffset; 
			var dy:Number = py - sy * cell.yoffset;
			
			if(((sx + sy) & 1) == 0)
			{
				result.x = px - dx - cell.xoffset;
				result.y = py - dy;
				result.cellX = sx - 1;		// optimize from result.x / cell.xoffset
				result.cellY = sy;			// optimize from result.y / cell.yoffset
			}
			else
			{
				// center point, align to cell
				result.x = px - dx - cell.xoffset;
				result.y = py - dy - cell.yoffset;
				result.cellX = sx - 1;		// optimize from result.x / cell.xoffset
				result.cellY = sy - 1;		// optimize from result.y / cell.yoffset
			}
			dx = result.cellX + 1;
			dy = result.cellY;
			result.cellX = (dy + dx) >> 1;
			result.cellY = (dy - dx) >> 1;
			result.x += xoffset;
			
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
			/*var dx:Number = px < xoffset ? px : width - px;
			var dy:Number = py < yoffset ? yoffset - py : py - yoffset;
			var p:Number = dy * xoffset - yoffset * dx;*/
			var p:Number = 0;
			if(px < xoffset && py < yoffset)
			{
				p = (yoffset - py) * xoffset - px * yoffset;
			}
			else if(px > xoffset && py < height - yoffset)
			{
				p = (height - yoffset - py) * (width - xoffset) - (width - px) * (height - yoffset);
			}
			else if(px < xoffset && py > yoffset)
			{
				p = (width - xoffset) * (py - yoffset) - px * (height - yoffset);
			}
			else if(px > xoffset && py > height - yoffset)
			{
				p = yoffset * (xoffset - (width - px)) - (height - py) * xoffset;
			}
			
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
		
		public override function getGridArea(cx:int, cy:int, clen:int, rlen:int, result:Grid=null, needCopyCell:Boolean=false):Grid
		{
			if(result == null)
			{
				result = new RhombusGrid(this.cell as Rhombus, clen, rlen);
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
			x = parent.xoffset + (cx - cy) * cell.xoffset - this.xoffset;
			y = (cx + cy) * cell.yoffset;
		}
	}
}