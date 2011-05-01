package com.ggshily.game.geom
{
	import flash.errors.IllegalOperationError;
	
	public class Grid extends Parallelogram
	{
		/**
		 * 
		 * cell:
		 * 
		 *       /\
		 *       \/
		 * 
		 * Grid:
		 * 
		 *    colum: 5
		 *    row : 9
		 * 
		 *           xoffset
		 *           |----|
		 *         _  ______________
		 *         | |    /\        |
		 *         | |   /  \       |
		 * yoffset | |  /    \      |
		 *         | | /      \     |
		 *         _ |/        \    |
		 *           |\         \   |
		 *           | \         \  |
		 *           |  \         \ |
		 *           |   \         \| _
		 *           |    \        /| | 
		 *           |     \      / | | 
		 *           |      \    /  | | yoffset
		 *           |       \  /   | | 
		 *           |        \/    | _ 
		 *           ---------------- 
		 *                    |----|
		 *                    xoffset
		 * 
		 * 
		 * */
		// cell offsets based on a common grid coordinates
		public var cellX:int;
		public var cellY:int;
		
		// grid infomation
		public var cell:Parallelogram;
		public var column:int = 1;
		public var row:int = 1;
		public var total:int = 1;
		
		// data for each cell
		public var defaultCellData:Object;
		public var cellData:Array;
		
		// intersectiong data definitions
		public static const GRID_SETINCOPY:int = 1;
		public static const GRID_SETINADD:int = 2;
		public static const GRID_SETINREMOVE:int = 4;
		public static const GRID_SETINVALUE:int = 8;
		public static const GRID_SETINDATA:int = 16;
		public static const GRID_SETOUTVALUE:int = 32;
		public static const GRID_SETTOFORM1:int = 64;
		public static const GRID_SETTOFORM2:int = 128;

		
		public function Grid(cell:Parallelogram=null, column:int=1, row:int=1)
		{
			super();
			setCell(cell);
			setGrid(column, row);
		}
		
		public function setCell(newcell:Parallelogram):void
		{
			if(newcell == null)
				cell = null;
			else if(cell == null)
				cell = newcell.clone() as Parallelogram;
			else
				newcell.cloneTo(cell);
		}
		
		public function setGrid(column:int, row:int):void
		{
			// grid
			this.column = column < 1 ? 1 : column;
			this.row = row < 1 ? 1 : row;
			this.total = column * row;
			
			// shape
			if(cell != null)
			{
				var xo:Number = cell.xoffset * this.column;
				var yo:Number = cell.yoffset * this.column;
				super.setShape(xo + (cell.width-cell.xoffset) * this.row, 
							yo + (cell.height-cell.yoffset) * this.row,
							xo, yo);
			}
			
			// data, only enlarge if necessary
			if(cellData != null)
			{
				xo = total - cellData.length;
				while(xo > 0)
				{
					--xo;
					cellData.push(defaultCellData);
				}
			}
		}
		
		public function setCellData(cx:int, cy:int, d:Object):void
		{
			if(cellData == null)
				cellData = new Array(total);
			cellData[cy*row+cx] = d;
		}
		
		public function getCellData(cx:int, cy:int):Object
		{
			return cellData == null ? null : cellData[cy*column+cx];
		}
		
		public override function cloneTo(newobj:Object):Object
		{
			newobj = super.cloneTo(newobj);
			newobj.cellX = this.cellX;
			newobj.cellY = this.cellY;
			newobj.cell = this.cell != null ? this.cell.clone() : null;
			newobj.setGrid(this.column, this.row);
			newobj.cellData = this.cellData == null ? null : this.cellData.slice();
			return newobj;
		}
		
		public function intersectsGrid(another:Grid, result:Grid=null):Boolean
		{
			if(another.cellX >= this.cellX+this.row
				|| another.cellX+another.row <= this.cellX
				|| another.cellY >= this.cellY+this.column
				|| another.cellY+another.column <= this.cellY)
				return false;
				
			if(result != null)
			{
				var cx:int = Math.max(another.cellX, this.cellX);
				var cy:int = Math.max(another.cellY, this.cellY);
				var ro:int = Math.min(another.cellX+another.row, this.cellX+this.row) - cx;
				var co:int =  Math.min(another.cellY+another.column, this.cellY+this.column) - cy;
			
				result.setGrid(co, ro);
				result.cellX = cx;
				result.cellY = cy;
			}
			return true;
		}
		
		protected static var _intersectResult:Grid = new Grid();
		
		public static function setIntersectData(form1:Grid, form2:Grid, option:int,
												outValue:Number=-1, invalue:Number=0):void
		{
			// auto create
			if(form1.cellData == null)
				form1.cellData = new Array(form1.total);
			if(form2.cellData == null)
				form2.cellData = new Array(form2.total);
				
			// flags	
			var setBehavior:int = (GRID_SETINCOPY|GRID_SETINADD|GRID_SETINREMOVE) & option;
			var setOut:Boolean = (GRID_SETOUTVALUE & option) != 0;
			var inValue:Boolean = (GRID_SETINVALUE & option) != 0;
			var setIn:Boolean = ((GRID_SETINVALUE | GRID_SETINDATA) & option) != 0;
				
			// less loop
			var loopForm:Grid, otherForm:Grid; 
			if(form1.total <= form2.total)
			{
				loopForm = form1;
				otherForm = form2;
			}
			else
			{
				loopForm = form2;
				otherForm = form1;
			}
			var toLoopForm:Boolean = ((GRID_SETTOFORM1 & option) != 0) == (loopForm == form1);
			var total:int = loopForm.total;
				
			// intersection data, local coords for loopForm
			var inStart:int, inEnd:int, inFinalEnd:int, otherIndex:int;
			if(form1.intersectsGrid(form2, _intersectResult))
			{
				// loop index
				inStart = (_intersectResult.cellY-loopForm.cellY) * loopForm.row 
						+ _intersectResult.cellX-loopForm.cellX; 
				inEnd = inStart + _intersectResult.row;
				inFinalEnd = inEnd + (_intersectResult.column - 1) * loopForm.row; 
				
				// other index
				otherIndex = (_intersectResult.cellY-otherForm.cellY) * otherForm.row 
						+ _intersectResult.cellX-otherForm.cellX;
			}
			else
			{
				// all out
				if(!setOut)
					return ;
				inStart = loopForm.total;
				inEnd = inStart;
				inFinalEnd = inStart;
				otherIndex = 0;
			}

			// set
			var src:Number;		
			for(var i:int=0; i<total; i++)
			{
				if(i == inEnd)					// end of current setting window
				{
					if(inEnd == inFinalEnd)		// no more set 
					{
						inStart = total;
						inEnd = total;
					}
					else
					{
						inStart += loopForm.row;
						inEnd += loopForm.row;
						otherIndex += otherForm.row - (inEnd - inStart);
					}
				}
				if(i < inStart)		// out
				{
					if(!setOut)
						continue;
					src = outValue;
				}
				else 				// in
				{
					if(!setIn)
						continue;
					if(inValue)
					{
						src = invalue;
					}
					else
					{
						if(toLoopForm)
						{
							src = otherForm.cellData[otherIndex];
							++otherIndex;
						}
						else
						{
							src = loopForm.cellData[i];
						}
					}
				}
				if(toLoopForm)		// set
				{
					switch(setBehavior)
					{
						case GRID_SETINCOPY:
							loopForm.cellData[i] = src;
							break;
							
						case GRID_SETINADD:
							loopForm.cellData[i] |= src;
							break;
							
						case GRID_SETINREMOVE:
							loopForm.cellData[i] &= ~src;
							break;
					}
				}
				else 
				{
					switch(setBehavior)
					{
						case GRID_SETINCOPY:
							otherForm.cellData[otherIndex] = src;
							break;
							
						case GRID_SETINADD:
							otherForm.cellData[otherIndex] |= src;
							break;
							
						case GRID_SETINREMOVE:
							otherForm.cellData[otherIndex] &= ~src;
							break;
					}
					++otherIndex;
				}
			}
		}
		
		public function containsPointInGrid(px:Number, py:Number, result:Grid):PointIntersectPolygon
		{
			throw new Error("containsPointInGrid() Not implemented in Class com.playfish.cw.geom.Grid");
		}
		
		public function getGridArea(cx:int, cy:int, clen:int, rlen:int, result:Grid=null, needCopyCell:Boolean=false):Grid
		{
			throw new Error("getGridArea() Not implemented in Class com.playfish.cw.geom.Grid");
		}
		
		public function setPosCell(cx:int, cy:int, parent:Grid):void
		{
			throw new Error("setPosCell() Not implemented in Class com.playfish.cw.geom.Grid");
		}

	}
}